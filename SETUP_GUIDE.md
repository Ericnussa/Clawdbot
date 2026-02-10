# OpenClaw Docker Setup Guide

This guide documents the setup and troubleshooting steps for running OpenClaw in Docker.

## Quick Start

### Access the Control UI

**Local Access:**
```
http://localhost:18789/#token=YOUR_GATEWAY_TOKEN_HERE
```

**Network Access (from other devices):**
```
http://YOUR_RPI_IP:18789/#token=YOUR_GATEWAY_TOKEN_HERE
```

## Common Issues & Solutions

### Issue 1: "unauthorized: gateway token missing"

**Symptom:**
```
disconnected (1008): unauthorized: gateway token missing
```

**Cause:**
The Control UI (browser) needs to authenticate with the gateway using the token.

**Solution:**
Add the token to the URL as a hash fragment:
```
http://localhost:18789/#token=YOUR_GATEWAY_TOKEN_HERE
```

The token is stored in:
- Environment variable: `OPENCLAW_GATEWAY_TOKEN` in `.env`
- Configuration file: `~/.openclaw/openclaw.json` under `gateway.auth.token`
- Info file: `OPENCLAW_INFO.txt` (generated during setup)

### Issue 2: "pairing required"

**Symptom:**
```
disconnected (1008): pairing required
```

**Cause:**
When accessing the gateway from Docker, even `localhost` connections appear to come from the Docker bridge network (172.18.0.x), not from loopback (127.0.0.1). OpenClaw requires device pairing for non-local connections as a security measure.

**Solution:**
Disable device pairing for the Control UI by adding `allowInsecureAuth` to the configuration.

Edit `~/.openclaw/openclaw.json`:

```json
{
  "agents": {
    "defaults": {
      "workspace": "/home/node/.openclaw/workspace"
    }
  },
  "gateway": {
    "mode": "local",
    "bind": "lan",
    "auth": {
      "mode": "token",
      "token": "YOUR_GATEWAY_TOKEN_HERE"
    },
    "controlUi": {
      "allowInsecureAuth": true
    }
  },
  "meta": {
    "lastTouchedVersion": "2026.2.9",
    "lastTouchedAt": "2026-02-10T17:33:54.685Z"
  }
}
```

The key addition is:
```json
"controlUi": {
  "allowInsecureAuth": true
}
```

Then restart the gateway:
```bash
docker compose restart openclaw-gateway
```

## Configuration Files

### Location
- **Config directory:** `/home/ruby/.openclaw`
- **Main config:** `/home/ruby/.openclaw/openclaw.json`
- **Workspace:** `/home/ruby/.openclaw/workspace`
- **Project:** `/home/ruby/clawdbot/openclaw`

### Environment Variables
Located in `/home/ruby/clawdbot/openclaw/.env`:

```bash
OPENCLAW_CONFIG_DIR=/home/ruby/.openclaw
OPENCLAW_WORKSPACE_DIR=/home/ruby/.openclaw/workspace
OPENCLAW_GATEWAY_PORT=18789
OPENCLAW_BRIDGE_PORT=18790
OPENCLAW_GATEWAY_BIND=lan
OPENCLAW_GATEWAY_TOKEN=YOUR_GATEWAY_TOKEN_HERE
OPENCLAW_IMAGE=openclaw:local
```

## Docker Commands

### View Status
```bash
docker compose -f /home/ruby/clawdbot/openclaw/docker-compose.yml ps
```

### View Logs
```bash
docker compose -f /home/ruby/clawdbot/openclaw/docker-compose.yml logs -f openclaw-gateway
```

### Restart Gateway
```bash
docker compose -f /home/ruby/clawdbot/openclaw/docker-compose.yml restart openclaw-gateway
```

### Stop Gateway
```bash
docker compose -f /home/ruby/clawdbot/openclaw/docker-compose.yml stop openclaw-gateway
```

### Start Gateway
```bash
docker compose -f /home/ruby/clawdbot/openclaw/docker-compose.yml start openclaw-gateway
```

### Access Dashboard CLI
```bash
docker compose -f /home/ruby/clawdbot/openclaw/docker-compose.yml run --rm openclaw-cli dashboard --no-open
```

## Security Considerations

### `allowInsecureAuth: true` Setting

**What it does:**
- Skips device pairing requirement for Control UI connections
- Allows token-only authentication without additional device approval

**Security implications:**
- Anyone with the gateway token can access the Control UI
- No per-device approval needed

**Best practices:**
- ✅ Keep your gateway token secret (treat it like a password)
- ✅ Never commit tokens to version control
- ✅ Only use on trusted local networks
- ❌ Don't expose port 18789 to the public internet
- ❌ Don't share your token publicly

**Alternative (more secure but requires manual approval):**
If you want device pairing enabled, remove the `allowInsecureAuth` setting and use:
```bash
# List pending device pairing requests
docker compose exec openclaw-gateway node dist/index.js devices list

# Approve a device
docker compose exec openclaw-gateway node dist/index.js devices approve <requestId>
```

Note: The CLI commands from inside Docker also require pairing, creating a chicken-and-egg problem, which is why `allowInsecureAuth: true` is recommended for Docker deployments.

## Network Information

- **Container:** openclaw-openclaw-gateway-1
- **Ports:** 18789 (gateway), 18790 (bridge)
- **Host IP:** 192.168.0.105
- **Docker Network:** 172.18.0.x (bridge network)

## Troubleshooting

### Gateway won't start
Check logs:
```bash
docker compose logs openclaw-gateway
```

### Can't connect from browser
1. Verify container is running: `docker compose ps`
2. Check the token is in the URL hash: `#token=...`
3. Verify configuration has `allowInsecureAuth: true`
4. Check browser console for errors (F12)

### Configuration changes not applying
Always restart the gateway after config changes:
```bash
docker compose restart openclaw-gateway
```

## Additional Resources

- [OpenClaw Documentation](https://docs.openclaw.ai)
- [Control UI Docs](https://docs.openclaw.ai/web/control-ui)
- [Gateway Configuration](https://docs.openclaw.ai/gateway/configuration)
- [Docker Installation](https://docs.openclaw.ai/install/docker)
- [Remote Access](https://docs.openclaw.ai/gateway/remote)
