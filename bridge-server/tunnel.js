const localtunnel = require("localtunnel");
const PORT = process.env.PORT || 3000;

(async () => {
  console.log("Opening tunnel to localhost:" + PORT + " ...");
  const tunnel = await localtunnel({ port: Number(PORT) });

  console.log("\n════════════════════════════════════════════════════════");
  console.log("  PUBLIC URL:  " + tunnel.url);
  console.log("════════════════════════════════════════════════════════");
  console.log("\nPaste this URL into your Delta Mobile loader script:");
  console.log(`  local BRIDGE = "${tunnel.url}"\n`);

  tunnel.on("close", () => {
    console.log("Tunnel closed");
  });

  tunnel.on("error", (err) => {
    console.error("Tunnel error:", err);
  });

  // Keep process alive
  process.on("SIGINT", () => {
    tunnel.close();
    process.exit(0);
  });
})();
