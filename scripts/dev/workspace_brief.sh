#!/usr/bin/env bash
# workspace_brief.sh — sign-out sheet + FIFO queues + local workspace identity
#
# Usage: ./scripts/dev/workspace_brief.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

if [[ -z "${FM_PRIMARY_WORKSPACE:-}" ]]; then
  [[ -f "$HOME/.fm_workspace.conf" ]] && source "$HOME/.fm_workspace.conf"
fi
[[ -z "${FM_THIS_WORKSPACE:-}" ]] && [[ -f "$REPO_ROOT/.fm_workspace.conf" ]] && source "$REPO_ROOT/.fm_workspace.conf"

echo "================================================================"
echo "  WORKSPACE IDENTITY  ($(date '+%Y-%m-%d %H:%M'))"
echo "================================================================"
echo "  FM_THIS_WORKSPACE     : ${FM_THIS_WORKSPACE:-(unset)}"
echo "  FM_PRIMARY_WORKSPACE  : ${FM_PRIMARY_WORKSPACE:-(unset)}"
echo "  cwd (repo root)       : $REPO_ROOT"
echo ""

echo "================================================================"
echo "  SIGN-OUT SHEET"
echo "================================================================"
bash "$REPO_ROOT/scripts/workspace/ws_status.sh"
echo ""

echo "================================================================"
echo "  FIFO QUEUES"
echo "================================================================"
bash "$REPO_ROOT/scripts/workspace/queue_status.sh"
