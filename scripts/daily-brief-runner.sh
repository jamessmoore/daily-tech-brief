#!/usr/bin/env bash
# =============================================================================
# daily-brief-runner.sh
# Cron wrapper for the Daily Tech Brief agent.
# Runs Claude Code in headless mode with the brief prompt.
#
# Crontab entry (runs at 1 AM MST daily):
#   0 1 * * * /path/to/daily-tech-brief/scripts/daily-brief-runner.sh
# =============================================================================

set -euo pipefail

# --- Configuration -----------------------------------------------------------
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROMPT_FILE="$PROJECT_DIR/prompts/brief-prompt.md"
LOG_FILE="$PROJECT_DIR/logs/runner.log"
ENV_FILE="$PROJECT_DIR/.env"

# --- Load environment variables ----------------------------------------------
# Cron does not source your shell profile, so we load them explicitly.
if [[ -f "$ENV_FILE" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
else
  echo "[$(date '+%Y-%m-%d %H:%M')] ERROR: .env file not found at $ENV_FILE" >> "$LOG_FILE"
  exit 1
fi

# --- Validate required env vars ----------------------------------------------
required_vars=("ANTHROPIC_API_KEY" "SLACK_BOT_TOKEN")
for var in "${required_vars[@]}"; do
  if [[ -z "${!var:-}" ]]; then
    echo "[$(date '+%Y-%m-%d %H:%M')] ERROR: Required env var $var is not set" >> "$LOG_FILE"
    exit 1
  fi
done

# --- Ensure log and output dirs exist ----------------------------------------
mkdir -p "$PROJECT_DIR/logs"
mkdir -p "$PROJECT_DIR/output/briefs"

# --- Run Claude Code in headless mode ----------------------------------------
echo "[$(date '+%Y-%m-%d %H:%M')] INFO: Starting daily brief agent run" >> "$LOG_FILE"

# Replace placeholder paths in prompt with actual project dir
RESOLVED_PROMPT=$(sed "s|/path/to/daily-tech-brief|$PROJECT_DIR|g" "$PROMPT_FILE")

# Run headless — claude -p reads prompt from stdin or as argument
# --allowedTools grants the tools the agent needs
# --dangerously-skip-permissions is needed for unattended runs (no TTY)
if claude \
  --dangerously-skip-permissions \
  --allowedTools "web_search,write_file,read_file,mcp__slack-poster__post_to_slack,mcp__slack-poster__post_file_to_slack" \
  -p "$RESOLVED_PROMPT" \
  >> "$LOG_FILE" 2>&1; then
  echo "[$(date '+%Y-%m-%d %H:%M')] SUCCESS: Agent run completed" >> "$LOG_FILE"
else
  echo "[$(date '+%Y-%m-%d %H:%M')] ERROR: Agent run exited with code $?" >> "$LOG_FILE"
  exit 1
fi
