# OpenClaw Docker Setup Guide (Template)

This guide complements `docker-setup.sh` and explains troubleshooting + remote access.

## Start / stop

```bash
docker compose ps
docker compose logs -f openclaw-gateway

docker compose restart openclaw-gateway

docker compose down
```

## Control UI / token

- UI: `http://127.0.0.1:18789/`

Get a dashboard link:

```bash
docker compose run --rm openclaw-cli dashboard --no-open
```

## Pairing (“pairing required”)

If your gateway bind is not loopback (e.g. `lan` or `tailnet`), OpenClaw may require device pairing.

List + approve devices:

```bash
docker compose run --rm openclaw-cli devices list
docker compose run --rm openclaw-cli devices approve <requestId>
```

## Reliable remote access (Tailscale)

### Recommended pattern

- Keep OpenClaw bound to loopback (`OPENCLAW_GATEWAY_BIND=loopback`).
- Put Tailscale on the **host**.
- Use `tailscale serve` for access.

Install + login:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

Serve:

```bash
sudo tailscale serve --http=443 http://127.0.0.1:18789
```

This avoids opening firewall ports and works great on home networks.

## Updating OpenClaw

Rebuild the image:

```bash
docker build --pull -t openclaw:local -f Dockerfile .
docker compose up -d --force-recreate
```

## Notes for VPS users

Do not publish port 18789 to the internet. Use Tailscale or another private network.
