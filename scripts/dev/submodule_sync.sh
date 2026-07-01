#!/usr/bin/env bash
# submodule_sync.sh — fetch and checkout submodules to parent-pinned SHAs
#
# Usage:
#   ./scripts/dev/submodule_sync.sh              # all submodules
#   ./scripts/dev/submodule_sync.sh design_docs  # one submodule
#   ./scripts/dev/submodule_sync.sh --dry-run

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
DRY=0
TARGET=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY=1; shift ;;
    -h|--help)
      sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) TARGET="$1"; shift ;;
  esac
done

cd "$REPO_ROOT"

run() {
  if [[ "$DRY" -eq 1 ]]; then
    printf '[dry-run] %q\n' "$@"
  else
    "$@"
  fi
}

if [[ -n "$TARGET" ]]; then
  echo "=== submodule sync: $TARGET ==="
  bash "$SCRIPT_DIR/submodule_status.sh" | sed -n "/\\[$TARGET\\]/,/^$/p" || true
  run git submodule update --init "$TARGET"
  run git -C "$TARGET" fetch origin 2>/dev/null || true
  PINNED=$(git ls-tree HEAD "$TARGET" | awk '{print $3}')
  [[ -n "$PINNED" ]] && run git -C "$TARGET" checkout "$PINNED"
else
  echo "=== submodule sync: all ==="
  bash "$SCRIPT_DIR/submodule_status.sh" || true
  run git submodule update --init --recursive
  git submodule foreach --quiet '
    pinned=$(cd "$toplevel" && git ls-tree HEAD "$sm_path" | awk "{print \$3}")
    if [[ -n "$pinned" ]]; then
      git fetch origin 2>/dev/null || true
      git checkout "$pinned"
    fi
  '
fi

echo ""
bash "$SCRIPT_DIR/submodule_status.sh"
