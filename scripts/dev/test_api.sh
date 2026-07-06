#!/usr/bin/env bash
# test_api.sh — run API pytest with consistent defaults
#
# Usage:
#   ./scripts/dev/test_api.sh
#   ./scripts/dev/test_api.sh finance/tests/test_support.py
#   ./scripts/dev/test_api.sh -k bill_recurrence -q
#
# Exports (when unset): SECRET_KEY, DEBUG, REDIS_URL — same values agents hand-roll per session.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
API_DIR="$REPO_ROOT/finance_manager_api"

[[ -d "$API_DIR" ]] || { echo "Missing: $API_DIR" >&2; exit 1; }

# Local pytest defaults — only applied when unset (matches common agent/session boilerplate).
export SECRET_KEY="${SECRET_KEY:-ci-test-secret-key-not-real}"
export DEBUG="${DEBUG:-True}"
export REDIS_URL="${REDIS_URL:-redis://localhost:6379/0}"

cd "$API_DIR"
echo "=== API tests ($(date '+%H:%M')) ==="
echo "cwd: $API_DIR"
echo ""

if [[ $# -eq 0 ]]; then
  uv run python -m pytest finance/tests -q --tb=line
else
  uv run python -m pytest "$@" --tb=line
fi
