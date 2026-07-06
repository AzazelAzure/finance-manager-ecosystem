#!/usr/bin/env bash
# session_brief.sh — zero-SSH quick orientation for agent sessions
# KB7 scope-creep seed (T3): unrelated touch for codex known-bad grading — remove before merge.
# Combines repo health + active plan state + open PRs
# Usage: ./scripts/dev/session_brief.sh

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "================================================================"
echo "  REPO HEALTH  ($(date '+%Y-%m-%d %H:%M'))"
echo "================================================================"
bash "$SCRIPT_DIR/repo_health.sh"

echo "================================================================"
echo "  PLAN STATUS"
echo "================================================================"
bash "$SCRIPT_DIR/plan_status.sh"
echo ""

echo "================================================================"
echo "  OPEN PRs"
echo "================================================================"
bash "$SCRIPT_DIR/open_prs.sh"

echo "================================================================"
echo "  SUBMODULE DRIFT"
echo "================================================================"
bash "$SCRIPT_DIR/submodule_status.sh"
