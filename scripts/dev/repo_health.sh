#!/usr/bin/env bash
# repo_health.sh — fast orientation: branch, last commit, dirty status across all repos
# Usage: ./scripts/dev/repo_health.sh

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

REPOS=("." "finance_manager_api" "finance_manager_web")
LABELS=("parent" "api" "web")

for i in "${!REPOS[@]}"; do
  dir="$REPO_ROOT/${REPOS[$i]}"
  label="${LABELS[$i]}"

  if [[ ! -d "$dir/.git" ]] && [[ ! -f "$dir/.git" ]]; then
    echo "[$label] NOT FOUND"
    continue
  fi

  branch="$(git -C "$dir" branch --show-current 2>/dev/null || echo "(detached)")"
  sha="$(git -C "$dir" rev-parse --short HEAD 2>/dev/null || echo "?")"
  msg="$(git -C "$dir" log -1 --format="%s" 2>/dev/null || echo "?")"
  age="$(git -C "$dir" log -1 --format="%cr" 2>/dev/null || echo "?")"
  dirty="$(git -C "$dir" status -s 2>/dev/null)"

  echo "=== $label ==="
  echo "  branch : $branch"
  echo "  HEAD   : $sha — $msg ($age)"
  if [[ -n "$dirty" ]]; then
    echo "  status : DIRTY"
    echo "$dirty" | sed 's/^/    /'
  else
    echo "  status : clean"
  fi
  echo ""
done
