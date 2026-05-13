const express = require("express");
const cors = require("cors");
const { v4: uuidv4 } = require("uuid");
const path = require("path");
const fs = require("fs");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json({ limit: "10mb" }));
app.use(express.urlencoded({ extended: true }));

// ── In-memory stores ──────────────────────────────────────────────────
const scriptQueue = [];          // scripts waiting to be pulled by Delta
const executionResults = [];     // results reported back from Delta
const connectedClients = [];     // SSE connections for real-time push
const sessions = new Map();      // sessionId -> { id, createdAt, lastPing }

// ── Serve static dashboard ───────────────────────────────────────────
app.use("/dashboard", express.static(path.join(__dirname, "public")));

// ── Health / info ────────────────────────────────────────────────────
app.get("/", (_req, res) => {
  res.json({
    name: "King AbramUI – Delta Bridge Server",
    version: "1.0.0",
    status: "online",
    endpoints: {
      "POST /api/push":        "Push a Luau script to the queue",
      "GET  /api/pull":        "Pull next pending script (Delta polls this)",
      "POST /api/result":      "Report execution result from Delta",
      "GET  /api/results":     "List all execution results",
      "GET  /api/queue":       "View pending script queue",
      "POST /api/session/ping":"Register / keep-alive a Delta session",
      "GET  /api/sessions":    "List connected Delta sessions",
      "GET  /api/stream":      "SSE stream for real-time script push",
      "GET  /api/docs/api-dump":"Browse Roblox API Dump",
      "GET  /api/docs/unc":    "View UNC standard documentation",
    },
  });
});

// ── Push a script to the queue ───────────────────────────────────────
app.post("/api/push", (req, res) => {
  const { script, name, metadata } = req.body;
  if (!script) {
    return res.status(400).json({ error: "Missing 'script' field" });
  }

  const entry = {
    id: uuidv4(),
    name: name || "unnamed",
    script,
    metadata: metadata || {},
    createdAt: new Date().toISOString(),
    status: "pending",
  };

  scriptQueue.push(entry);

  // Broadcast to SSE clients
  for (const client of connectedClients) {
    client.write(`data: ${JSON.stringify({ type: "new_script", payload: entry })}\n\n`);
  }

  res.json({ ok: true, id: entry.id, position: scriptQueue.length });
});

// ── Pull next pending script (Delta polls this) ─────────────────────
app.get("/api/pull", (_req, res) => {
  const next = scriptQueue.find((s) => s.status === "pending");
  if (!next) {
    return res.json({ ok: true, script: null, message: "No pending scripts" });
  }
  next.status = "dispatched";
  res.json({ ok: true, ...next });
});

// ── Report execution result ──────────────────────────────────────────
app.post("/api/result", (req, res) => {
  const { scriptId, success, output, error } = req.body;
  const result = {
    id: uuidv4(),
    scriptId: scriptId || "unknown",
    success: !!success,
    output: output || "",
    error: error || null,
    reportedAt: new Date().toISOString(),
  };

  executionResults.push(result);

  // Mark script as executed
  const script = scriptQueue.find((s) => s.id === scriptId);
  if (script) {
    script.status = success ? "success" : "failed";
  }

  // Broadcast to SSE
  for (const client of connectedClients) {
    client.write(`data: ${JSON.stringify({ type: "result", payload: result })}\n\n`);
  }

  res.json({ ok: true, resultId: result.id });
});

// ── List results ─────────────────────────────────────────────────────
app.get("/api/results", (_req, res) => {
  res.json({ ok: true, count: executionResults.length, results: executionResults });
});

// ── View queue ───────────────────────────────────────────────────────
app.get("/api/queue", (_req, res) => {
  res.json({ ok: true, count: scriptQueue.length, queue: scriptQueue });
});

// ── Session ping / keep-alive ────────────────────────────────────────
app.post("/api/session/ping", (req, res) => {
  const { sessionId, deviceInfo } = req.body;
  const id = sessionId || uuidv4();
  const now = new Date().toISOString();

  if (!sessions.has(id)) {
    sessions.set(id, { id, createdAt: now, lastPing: now, deviceInfo: deviceInfo || {} });
  } else {
    const session = sessions.get(id);
    session.lastPing = now;
    if (deviceInfo) session.deviceInfo = deviceInfo;
  }

  res.json({ ok: true, sessionId: id });
});

// ── List sessions ────────────────────────────────────────────────────
app.get("/api/sessions", (_req, res) => {
  const all = Array.from(sessions.values());
  res.json({ ok: true, count: all.length, sessions: all });
});

// ── SSE stream for real-time push ────────────────────────────────────
app.get("/api/stream", (req, res) => {
  res.setHeader("Content-Type", "text/event-stream");
  res.setHeader("Cache-Control", "no-cache");
  res.setHeader("Connection", "keep-alive");
  res.flushHeaders();

  res.write(`data: ${JSON.stringify({ type: "connected", message: "Bridge stream active" })}\n\n`);
  connectedClients.push(res);

  req.on("close", () => {
    const idx = connectedClients.indexOf(res);
    if (idx !== -1) connectedClients.splice(idx, 1);
  });
});

// ── Docs endpoints ───────────────────────────────────────────────────
app.get("/api/docs/api-dump", (_req, res) => {
  const dumpPath = path.join(__dirname, "docs", "API-Dump.json");
  if (!fs.existsSync(dumpPath)) {
    return res.status(404).json({ error: "API Dump not found" });
  }
  res.sendFile(dumpPath);
});

app.get("/api/docs/unc", (_req, res) => {
  const uncPath = path.join(__dirname, "docs", "UNC-Standard.md");
  if (!fs.existsSync(uncPath)) {
    return res.status(404).json({ error: "UNC doc not found" });
  }
  res.type("text/markdown").sendFile(uncPath);
});

// ── Batch push (multiple scripts at once) ────────────────────────────
app.post("/api/push/batch", (req, res) => {
  const { scripts } = req.body;
  if (!Array.isArray(scripts) || scripts.length === 0) {
    return res.status(400).json({ error: "Missing or empty 'scripts' array" });
  }

  const entries = scripts.map((s) => {
    const entry = {
      id: uuidv4(),
      name: s.name || "unnamed",
      script: s.script,
      metadata: s.metadata || {},
      createdAt: new Date().toISOString(),
      status: "pending",
    };
    scriptQueue.push(entry);
    return entry;
  });

  // Broadcast
  for (const client of connectedClients) {
    client.write(`data: ${JSON.stringify({ type: "batch_push", payload: entries })}\n\n`);
  }

  res.json({ ok: true, count: entries.length, ids: entries.map((e) => e.id) });
});

// ── Clear queue / results (admin) ────────────────────────────────────
app.delete("/api/queue", (_req, res) => {
  scriptQueue.length = 0;
  res.json({ ok: true, message: "Queue cleared" });
});

app.delete("/api/results", (_req, res) => {
  executionResults.length = 0;
  res.json({ ok: true, message: "Results cleared" });
});

// ── Start ────────────────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`\n🔥 King AbramUI Bridge Server running on port ${PORT}`);
  console.log(`   Dashboard: http://localhost:${PORT}/dashboard`);
  console.log(`   API Root:  http://localhost:${PORT}/\n`);
});

module.exports = app;
