#!/usr/bin/env bash
# test_rust.sh — run finance_manager_rust_tools tests
#
# Usage:
#   ./scripts/dev/test_rust.sh
#   ./scripts/dev/test_rust.sh --locked

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
RUST_DIR="$REPO_ROOT/finance_manager_rust_tools"
LOCKED=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --locked) LOCKED=1; shift ;;
    -h|--help)
      sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown arg: $1" >&2; exit 1 ;;
  esac
done

[[ -d "$RUST_DIR" ]] || { echo "Missing: $RUST_DIR" >&2; exit 1; }
command -v cargo >/dev/null || { echo "cargo not found on PATH" >&2; exit 1; }

cd "$RUST_DIR"
echo "=== rust_tools tests ($(date '+%H:%M')) ==="
echo "cwd: $RUST_DIR"
echo ""

if [[ "$LOCKED" -eq 1 ]]; then
  cargo test --locked
else
  cargo test
fi
