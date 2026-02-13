#!/usr/bin/env bash
set -euo pipefail

# Simple, reliable Docker setup for OpenClaw.
# - Builds a local image
# - Creates ~/.openclaw + workspace dirs
# - Generates a gateway token into .env (if missing)
# - Runs onboarding wizard
# - Starts the gateway

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if ! command -v docker >/dev/null 2>&1; then
  echo "docker not found. Install Docker Engine / Docker Desktop first." >&2
  exit 1
fi

if ! docker compose version >/dev/null 2>&1; then
  echo "docker compose not found. Install Docker Compose v2." >&2
  exit 1
fi

# Create .env from template if needed
if [[ ! -f .env ]]; then
  cp .env.example .env
fi

# Load env (no export of everything by default)
set -a
source .env
set +a

OPENCLAW_CONFIG_DIR=${OPENCLAW_CONFIG_DIR:-"$HOME/.openclaw"}
OPENCLAW_WORKSPACE_DIR=${OPENCLAW_WORKSPACE_DIR:-"$HOME/.openclaw/workspace"}
OPENCLAW_IMAGE=${OPENCLAW_IMAGE:-openclaw:local}
OPENCLAW_GATEWAY_PORT=${OPENCLAW_GATEWAY_PORT:-18789}
OPENCLAW_GATEWAY_BIND=${OPENCLAW_GATEWAY_BIND:-loopback}

mkdir -p "$OPENCLAW_CONFIG_DIR" "$OPENCLAW_WORKSPACE_DIR"

# Generate token if unset/placeholder
if [[ -z "${OPENCLAW_GATEWAY_TOKEN:-}" || "${OPENCLAW_GATEWAY_TOKEN}" == "change-me" ]]; then
  if command -v openssl >/dev/null 2>&1; then
    OPENCLAW_GATEWAY_TOKEN="$(openssl rand -hex 32)"
  else
    OPENCLAW_GATEWAY_TOKEN="$(python3 - <<'PY'
import secrets
print(secrets.token_hex(32))
PY
)"
  fi

  # Update .env in-place (portable)
  tmpfile="$(mktemp)"
  awk -v tok="$OPENCLAW_GATEWAY_TOKEN" 'BEGIN{done=0}
    /^OPENCLAW_GATEWAY_TOKEN=/{print "OPENCLAW_GATEWAY_TOKEN="tok; done=1; next}
    {print}
    END{if(!done) print "OPENCLAW_GATEWAY_TOKEN="tok}
  ' .env > "$tmpfile"
  mv "$tmpfile" .env

  echo "Generated OPENCLAW_GATEWAY_TOKEN and saved to .env" >&2
fi

echo "Building image: $OPENCLAW_IMAGE" >&2
docker build -t "$OPENCLAW_IMAGE" -f Dockerfile .

echo "Starting gateway..." >&2
docker compose up -d openclaw-gateway

echo "Running onboarding wizard (interactive)..." >&2
echo "(If you already onboarded, you can skip this step.)" >&2
docker compose run --rm openclaw-cli onboard

echo "\nDone." >&2
echo "Control UI: http://127.0.0.1:${OPENCLAW_GATEWAY_PORT}/" >&2
echo "Token: (stored in .env as OPENCLAW_GATEWAY_TOKEN)" >&2
echo "Dashboard helper: docker compose run --rm openclaw-cli dashboard --no-open" >&2
