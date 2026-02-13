# ClawdBot — OpenClaw Docker Template (Reliable + Simple)

A public template repo for running [OpenClaw](https://openclaw.ai) in **Docker Compose**.

Goals:

- **Simple install**: one script
- **Reliable**: restart policies + healthcheck
- **Safe defaults**: loopback bind by default; token auth
- **Documented**: common problems, plus **Tailscale** remote access

---

## Quick start

### 1) Clone

```bash
git clone https://github.com/Ericnussa/Clawdbot.git
cd Clawdbot
```

### 2) Run setup

```bash
./docker-setup.sh
```

That script will:

- create `~/.openclaw/` + `~/.openclaw/workspace/`
- generate a gateway token into `.env` (if missing)
- build an `openclaw:local` image
- start the gateway via Docker Compose
- run `openclaw onboard` (interactive)

### 3) Open the Control UI

- Local: `http://127.0.0.1:18789/`
- Paste your token in the UI settings (or use the dashboard helper below)

Dashboard helper:

```bash
docker compose run --rm openclaw-cli dashboard --no-open
```

---

## Files

- `docker-compose.yml` — gateway + helper CLI container
- `Dockerfile` — minimal OpenClaw image
- `.env.example` — config template (copy to `.env`)
- `docker-setup.sh` — easiest “do everything” installer

---

## Common issues

### “unauthorized: gateway token missing”

You need the token set in the Control UI.

- Use: `docker compose run --rm openclaw-cli dashboard --no-open`
- Or paste the token in Control UI Settings.

### “pairing required” (Docker / non-loopback)

If you bind the gateway to `lan` / `tailnet`, your browser is not “loopback” anymore.
Approve the device:

```bash
docker compose run --rm openclaw-cli devices list
docker compose run --rm openclaw-cli devices approve <requestId>
```

---

## Tailscale (recommended remote access)

**Best practice:** install Tailscale on the **host**, not inside the OpenClaw container.

### Option A — Keep OpenClaw local-only, access host via Tailscale

1) Install Tailscale on the host:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

2) Keep OpenClaw on loopback (default):

```bash
# in .env
OPENCLAW_GATEWAY_BIND=loopback
```

3) Use `tailscale serve` to expose the Control UI safely:

```bash
# Serve the HTTP UI over your tailnet
sudo tailscale serve --http=443 http://127.0.0.1:18789
```

Now you can reach it from other tailnet devices without opening ports.

### Option B — Bind OpenClaw to tailnet

If you *really* want the gateway to listen on non-loopback, set:

```bash
OPENCLAW_GATEWAY_BIND=tailnet
```

Then restart:

```bash
docker compose up -d
```

Note: you’ll likely need to approve the browser device (pairing).

---

## Security notes

- Treat your gateway token like a password.
- Don’t expose `18789` to the public internet.
- Don’t commit `.env` or `~/.openclaw/`.

---

## License

MIT
