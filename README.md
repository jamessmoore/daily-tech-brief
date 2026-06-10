# 🤖 Daily Tech Brief Agent

A Claude Code headless agent that runs nightly at 1 AM, researches the latest
news in DevOps, AI agents, MCP, and cloud infrastructure, and posts a
structured summary to Slack.

Built by [James Moore](https://webtechhq.com) — WebTech HQ / AI Jedi.

---

## What It Does

- Runs autonomously via **cron** using Claude Code headless mode (`claude -p`)
- Uses a **subagent** (`researcher`) scoped to web search and file write
- Exposes a custom **MCP server** (`slack-poster`) with two tools:
  - `post_to_slack` — post a plain text message
  - `post_file_to_slack` — read a markdown file and post its contents
- Archives every brief as a dated markdown file in `output/briefs/`
- Logs run status to `logs/runner.log`

---

## Architecture

```
cron (1 AM)
  └── daily-brief-runner.sh
        └── claude -p (headless)
              ├── researcher subagent (web_search → write_file)
              └── slack-poster MCP (post_file_to_slack)
```

---

## Setup

### 1. Clone and install dependencies

```bash
git clone https://github.com/jamessmoore/daily-tech-brief
cd daily-tech-brief
cd mcp-servers/slack-poster && npm install && cd ../..
```

### 2. Configure environment

```bash
cp .env.example .env
# Edit .env with your ANTHROPIC_API_KEY and SLACK_BOT_TOKEN
```

**Slack Bot Token setup:**
1. Go to [api.slack.com/apps](https://api.slack.com/apps) → Create New App
2. OAuth & Permissions → Add scopes: `chat:write`, `chat:write.public`
3. Install to workspace → copy Bot User OAuth Token

### 3. Make the runner executable

```bash
chmod +x scripts/daily-brief-runner.sh
```

### 4. Test a manual run

```bash
./scripts/daily-brief-runner.sh
```

Check `logs/runner.log` and your Slack channel.

### 5. Add the cron job

```bash
crontab -e
```

Add this line (runs at 1 AM daily in your local timezone):

```
0 1 * * * /absolute/path/to/daily-tech-brief/scripts/daily-brief-runner.sh
```

> **Note:** Use the absolute path. Cron does not know your shell aliases or `$HOME` shortcuts.

---

## Project Structure

```
daily-tech-brief/
├── .claude/
│   ├── agents/
│   │   └── researcher.yml       # Subagent: web search + summarize
│   └── settings.json            # MCP server registration
├── mcp-servers/
│   └── slack-poster/
│       ├── index.js             # MCP server (2 tools)
│       └── package.json
├── prompts/
│   └── brief-prompt.md          # Headless agent task prompt
├── output/
│   └── briefs/                  # Archived daily briefs (markdown)
├── scripts/
│   └── daily-brief-runner.sh    # Cron wrapper script
├── logs/                        # Runtime logs (gitignored)
├── .env.example                 # Environment variable template
└── .gitignore
```

---

## Key Patterns Demonstrated

- **Claude Code headless mode** (`claude -p`) for unattended automation
- **Subagent configuration** (YAML, scoped model + tools)
- **Custom MCP server** built with `@modelcontextprotocol/sdk`
- **Defensive prompt design** — agent handles errors autonomously, no user input required
- **Cron integration** on Linux (Arch Linux compatible)

---

## Part of the WebTech HQ Agent Suite

This is the first agent in a portfolio series:

| Agent | Status |
|---|---|
| Daily Tech Brief | ✅ Built |
| Real Estate Offering Generator | 🔜 Next |
| Content Pipeline | 🔜 Planned |
| Client Onboarding | 🔜 Planned |

---

## License

MIT
