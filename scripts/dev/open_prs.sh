#!/usr/bin/env bash
# open_prs.sh — list open PRs across all active repos in one call
# Usage: ./scripts/dev/open_prs.sh

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

REPOS=("." "finance_manager_api" "finance_manager_web")

for repo in "${REPOS[@]}"; do
  dir="$REPO_ROOT/$repo"
  label="${repo//.//parent}"
  [[ -d "$dir/.git" ]] || continue
  echo "=== $label ==="
  (cd "$dir" && gh pr list --state open 2>/dev/null) || echo "(gh not available)"
  echo ""
done
