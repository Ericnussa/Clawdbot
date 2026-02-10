# ClawdBot - OpenClaw Docker Setup

Documentation and configuration for running [OpenClaw](https://openclaw.ai) personal AI assistant in Docker.

## 📚 What's This?

This repository contains setup guides, troubleshooting documentation, and configuration files for deploying OpenClaw (a personal AI assistant) using Docker on Raspberry Pi or other Linux systems.

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Node.js 22+ (for OpenClaw)
- At least one AI provider API key (Anthropic Claude or OpenAI)

### Setup

1. **Clone this repository**
   ```bash
   git clone https://github.com/ericnussa/clawdbot.git
   cd clawdbot
   ```

2. **Follow the setup guide**
   - See [SETUP_GUIDE.md](SETUP_GUIDE.md) for complete installation and troubleshooting

3. **Check container information**
   - See [OPENCLAW_INFO.txt](OPENCLAW_INFO.txt) for Docker commands and access URLs

## 📖 Documentation

- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Complete setup and troubleshooting guide
  - Fixing "unauthorized: gateway token missing" error
  - Fixing "pairing required" error
  - Configuration examples
  - Docker commands reference
  - Security best practices

- **[OPENCLAW_INFO.txt](OPENCLAW_INFO.txt)** - Quick reference
  - Container status and ports
  - Access URLs
  - Docker Compose commands
  - Directory structure

## 🔧 Common Issues

### Issue: "unauthorized: gateway token missing"
**Solution:** Add the token to the URL: `http://localhost:18789/#token=YOUR_TOKEN`

See [SETUP_GUIDE.md](SETUP_GUIDE.md#issue-1-unauthorized-gateway-token-missing) for details.

### Issue: "pairing required"
**Solution:** Add `"controlUi": { "allowInsecureAuth": true }` to your config.

See [SETUP_GUIDE.md](SETUP_GUIDE.md#issue-2-pairing-required) for details.

## 🔐 Security Notes

- **Never commit sensitive files:**
  - `.env` files containing tokens
  - `openclaw.json` with actual configuration
  - `.openclaw/` directory

- **Token management:**
  - Keep your gateway token secret
  - Don't expose ports to the public internet
  - Use on trusted networks only

The included `.gitignore` protects these files automatically.

## 🐳 Docker Quick Commands

```bash
# View status
docker compose ps

# View logs
docker compose logs -f openclaw-gateway

# Restart gateway
docker compose restart openclaw-gateway

# Stop/Start
docker compose stop openclaw-gateway
docker compose start openclaw-gateway
```

## 🌐 About OpenClaw

OpenClaw is a personal AI assistant that runs on your own devices. It supports:
- Multiple messaging channels (WhatsApp, Telegram, Slack, Discord, etc.)
- Voice interaction on macOS/iOS/Android
- Local workspace and file operations
- Privacy-focused, self-hosted deployment

**Official Resources:**
- [Website](https://openclaw.ai)
- [Documentation](https://docs.openclaw.ai)
- [GitHub](https://github.com/openclaw/openclaw)
- [Discord Community](https://discord.gg/clawd)

## 📝 License

MIT License - See [LICENSE](LICENSE) file for details.

## 🤝 Contributing

This is a personal documentation repository, but feel free to:
- Open issues for questions or corrections
- Submit pull requests for improvements
- Share your own setup tips

## 💬 Support

For OpenClaw support:
- [Official Documentation](https://docs.openclaw.ai)
- [Discord Community](https://discord.gg/clawd)
- [GitHub Issues](https://github.com/openclaw/openclaw/issues)

For issues with this documentation:
- Open an issue in this repository

---

**Built with** ❤️ **for the OpenClaw community**
