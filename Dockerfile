# Minimal OpenClaw gateway image.
# Builds a container that can run `openclaw gateway` and `openclaw onboard`.

FROM node:22-bookworm-slim

# Basic tools (curl for health checks / debugging)
RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates curl \
  && rm -rf /var/lib/apt/lists/*

# Install OpenClaw CLI (includes gateway)
RUN npm install -g openclaw@latest \
  && openclaw --version

# Use the default node user
USER node
WORKDIR /home/node

# Default command is overridden by docker-compose.yml
ENTRYPOINT ["openclaw"]
