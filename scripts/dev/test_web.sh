#!/usr/bin/env bash
# test_web.sh — run web build, lint, or test with log capture
#
# Usage:
#   ./scripts/dev/test_web.sh build
#   ./scripts/dev/test_web.sh lint
#   ./scripts/dev/test_web.sh test

set -euo pipefail

MODE="${1:-build}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
WEB_DIR="$REPO_ROOT/finance_manager_web"
LOG_DIR="$REPO_ROOT/tmp/dev_logs"
STAMP="$(date +%Y%m%d_%H%M%S)"

[[ -d "$WEB_DIR" ]] || { echo "Missing: $WEB_DIR" >&2; exit 1; }
mkdir -p "$LOG_DIR"

case "$MODE" in
  build|lint|test) ;;
  *)
    echo "Usage: test_web.sh {build|lint|test}" >&2
    exit 1
    ;;
esac

LOG="$LOG_DIR/web_${MODE}_${STAMP}.log"
echo "=== web npm run $MODE ==="
echo "log: $LOG"

cd "$WEB_DIR"
if npm run "$MODE" >"$LOG" 2>&1; then
  echo "PASS — tail:"
  tail -5 "$LOG"
else
  echo "FAIL — last 30 lines:" >&2
  tail -30 "$LOG" >&2
  exit 1
fi
