#!/usr/bin/env bash
# submodule_status.sh — show each submodule's HEAD vs parent-pinned SHA
# Usage: ./scripts/dev/submodule_status.sh

set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT"

echo "=== SUBMODULE DRIFT CHECK ==="
echo "Parent HEAD: $(git log --oneline -1)"
echo ""

git submodule foreach --quiet '
  pinned=$(cd "$toplevel" && git ls-tree HEAD "$sm_path" | awk "{print \$3}")
  actual=$(git log --oneline -1)
  branch=$(git branch --show-current 2>/dev/null || echo "detached")
  echo "[$sm_path]"
  echo "  pinned in parent : $pinned"
  echo "  actual HEAD      : $actual"
  echo "  branch           : $branch"
  if [[ "$pinned" == "$(git rev-parse HEAD)" ]]; then
    echo "  status           : IN SYNC"
  else
    echo "  status           : DRIFT — $(git log --oneline ${pinned}..HEAD 2>/dev/null | wc -l | tr -d " ") commits ahead of pin"
  fi
  echo ""
'
