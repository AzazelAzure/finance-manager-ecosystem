#!/usr/bin/env bash
# branch_delta.sh — ahead/behind vs upstream for parent/api/web
#
# Usage:
#   ./scripts/dev/branch_delta.sh
#   ./scripts/dev/branch_delta.sh --repo api --base main

set -euo pipefail

TARGET="all"
BASE_BRANCH="main"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) TARGET="$2"; shift 2 ;;
    --base) BASE_BRANCH="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

show_delta() {
  local label="$1"
  local dir="$2"
  [[ -d "$dir/.git" || -f "$dir/.git" ]] || { echo "[$label] NOT FOUND"; return; }

  local branch upstream ahead behind
  branch="$(git -C "$dir" branch --show-current 2>/dev/null || echo "(detached)")"
  git -C "$dir" fetch origin "$BASE_BRANCH" --quiet 2>/dev/null || true
  upstream="origin/${BASE_BRANCH}"
  if ! git -C "$dir" rev-parse --verify "$upstream" >/dev/null 2>&1; then
    echo "=== $label ==="
    echo "  branch   : $branch"
    echo "  upstream : $upstream (not found)"
    echo ""
    return
  fi
  ahead="$(git -C "$dir" rev-list --count "${upstream}..HEAD" 2>/dev/null || echo "?")"
  behind="$(git -C "$dir" rev-list --count "HEAD..${upstream}" 2>/dev/null || echo "?")"
  echo "=== $label ==="
  echo "  branch   : $branch"
  echo "  vs       : $upstream"
  echo "  ahead    : $ahead"
  echo "  behind   : $behind"
  echo ""
}

case "$TARGET" in
  parent) show_delta parent "$REPO_ROOT" ;;
  api) show_delta api "$REPO_ROOT/finance_manager_api" ;;
  web) show_delta web "$REPO_ROOT/finance_manager_web" ;;
  all)
    show_delta parent "$REPO_ROOT"
    show_delta api "$REPO_ROOT/finance_manager_api"
    show_delta web "$REPO_ROOT/finance_manager_web"
    ;;
  *) echo "Unknown --repo: $TARGET (use parent|api|web|all)" >&2; exit 1 ;;
esac
