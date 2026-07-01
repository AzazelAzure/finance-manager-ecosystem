#!/usr/bin/env bash
# stash_triage.sh — list git stashes across parent/api/web
#
# Usage:
#   ./scripts/dev/stash_triage.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

REPOS=("." "finance_manager_api" "finance_manager_web")
LABELS=("parent" "api" "web")
FOUND=0

for i in "${!REPOS[@]}"; do
  dir="$REPO_ROOT/${REPOS[$i]}"
  label="${LABELS[$i]}"
  [[ -d "$dir/.git" || -f "$dir/.git" ]] || continue

  count="$(git -C "$dir" stash list 2>/dev/null | wc -l | tr -d ' ')"
  echo "=== $label ($count stash(es)) ==="
  if [[ "$count" -gt 0 ]]; then
    FOUND=1
    git -C "$dir" stash list | sed 's/^/  /'
  else
    echo "  (none)"
  fi
  echo ""
done

if [[ "$FOUND" -eq 0 ]]; then
  echo "No stashes across parent/api/web."
fi
