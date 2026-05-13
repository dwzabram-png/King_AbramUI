# King AbramUI – Delta Bridge Server

Live bridge between a Node.js workspace and **Delta Mobile Executor** (UNC standard) for Roblox.

## Architecture

```
┌─────────────────┐    HTTPS     ┌──────────────────┐    HTTP Poll    ┌─────────────────┐
│  Dashboard (PC)  │◄──────────►│  Bridge Server    │◄──────────────►│  Delta Mobile    │
│  Push scripts    │             │  Express + SSE    │                │  Luau Client     │
│  View results    │             │  localtunnel      │                │  Touch-only GUI  │
└─────────────────┘             └──────────────────┘                └─────────────────┘
```

## Quick Start

```bash
cd bridge-server
npm install
npm start          # Start server on port 3000
npm run tunnel     # Open public tunnel (run in separate terminal)
```

## Endpoints

| Method   | Endpoint              | Description                           |
|----------|-----------------------|---------------------------------------|
| `GET`    | `/`                   | Server info & endpoint list           |
| `POST`   | `/api/push`           | Push a Luau script to the queue       |
| `POST`   | `/api/push/batch`     | Push multiple scripts at once         |
| `GET`    | `/api/pull`           | Pull next pending script (Delta polls)|
| `POST`   | `/api/result`         | Report execution result from Delta    |
| `GET`    | `/api/results`        | List all execution results            |
| `GET`    | `/api/queue`          | View pending script queue             |
| `DELETE` | `/api/queue`          | Clear the script queue                |
| `DELETE` | `/api/results`        | Clear all results                     |
| `POST`   | `/api/session/ping`   | Register / keep-alive a Delta session |
| `GET`    | `/api/sessions`       | List connected Delta sessions         |
| `GET`    | `/api/stream`         | SSE stream for real-time events       |
| `GET`    | `/api/docs/api-dump`  | Roblox API Dump (JSON)                |
| `GET`    | `/api/docs/unc`       | UNC Standard documentation            |
| `GET`    | `/dashboard`          | Web dashboard UI                      |

## Delta Mobile Client

The Luau client script is in `scripts/DeltaBridgeClient.lua`.

### Setup

1. Start the bridge server and tunnel
2. Copy the public tunnel URL
3. Edit `DeltaBridgeClient.lua` – set `BRIDGE_URL` to your tunnel URL
4. Execute the script in Delta Mobile

### Mobile-First Design

- **NO `UserInputService` KeyCodes** – Delta Mobile has no physical keyboard
- **TouchTap** events for all GUI button interactions
- **Touch-based dragging** for the floating GUI panel
- **ContextActionService** mobile touch button for minimize
- **Polling-based** script fetch (no WebSocket dependency)

## Included Documentation

- `docs/API-Dump.json` – Latest Roblox API Dump from [Roblox-Client-Tracker](https://github.com/MaximumADHD/Roblox-Client-Tracker)
- `docs/UNC-Standard.md` – Unified Naming Convention standard for executors

## Dashboard

Open `http://localhost:3000/dashboard` (or your tunnel URL + `/dashboard`) to:
- Push scripts to Delta from your browser
- Monitor the script queue in real-time
- View execution results
- Track connected Delta sessions
