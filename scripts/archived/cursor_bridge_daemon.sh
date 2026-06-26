#!/usr/bin/env bash
# Launch the headless Cursor Slack bridge with secrets from .secrets/cli_bridge.env
# (used by systemd user unit; do not print secrets).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ROOT}/.secrets/cli_bridge.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing ${ENV_FILE}; create it (see design_docs bridge manifest)." >&2
  exit 1
fi

set -a
# shellcheck source=/dev/null
source "$ENV_FILE"
set +a

WORKSPACE="${CURSOR_AGENT_WORKSPACE:-$ROOT}"
exec python3 "${ROOT}/scripts/cursor_headless_slack_agent.py" --workspace "$WORKSPACE"
