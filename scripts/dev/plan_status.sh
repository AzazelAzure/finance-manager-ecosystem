#!/usr/bin/env bash
# plan_status.sh — print in-progress and blocked plans from plan_registry.md
# Usage: ./scripts/dev/plan_status.sh

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REGISTRY="$SCRIPT_DIR/../../governance/plans/plan_registry.md"

[[ -f "$REGISTRY" ]] || { echo "plan_registry.md not found"; exit 1; }

echo "=== IN PROGRESS ==="
awk '/^## In Progress/,/^## Ready for Execution/' "$REGISTRY" \
  | grep -E "^\| \`PLAN_" || echo "(none)"

echo ""
echo "=== BLOCKED ==="
awk '/^## Blocked/,/^## Recently Completed/' "$REGISTRY" \
  | grep -E "^\| \`PLAN_" || echo "(none)"

echo ""
echo "=== DRAFT / PLANNING (count) ==="
COUNT=$(awk '/^## Draft \/ Planning/,/^## Paused/' "$REGISTRY" \
  | grep -c "^\| \`PLAN_" || true)
echo "$COUNT plans in draft"
