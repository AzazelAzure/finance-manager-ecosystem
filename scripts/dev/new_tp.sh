#!/usr/bin/env bash
# new_tp.sh — scaffold a talking-point folder under strategy/meetings/
#
# Usage:
#   ./scripts/dev/new_tp.sh <slug> [--week N] [--date YYYY-MM-DD]
# Example:
#   ./scripts/dev/new_tp.sh scripts-org --week 27 --date 2026-07-01

set -euo pipefail

[[ $# -lt 1 ]] && {
  echo "Usage: new_tp.sh <slug> [--week N] [--date YYYY-MM-DD]" >&2
  exit 1
}

SLUG="$1"; shift
WEEK=""
MEETING_DATE="$(date +%Y-%m-%d)"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --week) WEEK="$2"; shift 2 ;;
    --date) MEETING_DATE="$2"; shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

if [[ -z "$WEEK" ]]; then
  WEEK=$(date +%V | sed 's/^0//')
fi

BASE="$REPO_ROOT/strategy/meetings/week${WEEK}/meeting${MEETING_DATE}/tp-${SLUG}"
mkdir -p "$BASE"

if [[ -e "$BASE/README.md" ]]; then
  echo "Already exists: $BASE" >&2
  exit 1
fi

cat > "$BASE/README.md" <<EOF
# TP: ${SLUG}

**Status:** draft

## Files in this folder

| File | Purpose | Status |
|---|---|---|
| [notes.md](notes.md) | Working notes and talking points | draft |
| [decisions.md](decisions.md) | Resolved decisions (if needed) | — |

## Sequence

1. notes.md — scope and open questions
2. decisions.md — lock choices
3. Hand off to execution (Cursor) or close
EOF

cat > "$BASE/notes.md" <<EOF
# TP: ${SLUG} — Notes

**Meeting:** week${WEEK} / ${MEETING_DATE}

## Talking points

1. 
2. 
3. 

## Open questions

- 
EOF

touch "$BASE/decisions.md"

echo "Created talking-point folder:"
echo "  $BASE"
ls -1 "$BASE"
