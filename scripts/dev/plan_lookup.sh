#!/usr/bin/env bash
# plan_lookup.sh — find a plan by ID and print its path, status, and branch
# Usage: ./scripts/dev/plan_lookup.sh <plan_id>
# Example: ./scripts/dev/plan_lookup.sh F014
#          ./scripts/dev/plan_lookup.sh PLAN_CROSS_CI_CD_2026-06-27

set -euo pipefail

[[ $# -lt 1 ]] && { echo "Usage: plan_lookup.sh <plan_id>"; exit 1; }

QUERY="${1^^}"  # uppercase
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PLANS_DIR="$REPO_ROOT/plans"
REGISTRY="$REPO_ROOT/governance/plans/plan_registry.md"

# Strip PLAN_ prefix if user typed the full ID for matching
SHORT="${QUERY#PLAN_}"

# Search plan directories for a match
FOUND_DIR="$(find "$PLANS_DIR" -maxdepth 4 -type d -iname "*${SHORT}*" 2>/dev/null | head -1 || true)"

if [[ -n "$FOUND_DIR" ]] && [[ -f "$FOUND_DIR/README.md" ]]; then
  echo "=== Plan directory ==="
  echo "  path: ${FOUND_DIR#$REPO_ROOT/}"
  echo ""
  echo "=== README summary ==="
  # Print first 40 lines of README (covers status/branch/description block)
  head -40 "$FOUND_DIR/README.md"
  echo ""
fi

# Also check plan_registry.md for the row
echo "=== Registry entry ==="
grep -i "$SHORT" "$REGISTRY" || echo "(not found in registry)"
