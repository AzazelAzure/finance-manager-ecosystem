#!/usr/bin/env bash
# new_meeting_day.sh — scaffold a meeting day folder under strategy/meetings/
#
# Usage:
#   ./scripts/dev/new_meeting_day.sh
#   ./scripts/dev/new_meeting_day.sh --week 27 --date 2026-07-01

set -euo pipefail

WEEK=""
MEETING_DATE="$(date +%Y-%m-%d)"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --week) WEEK="$2"; shift 2 ;;
    --date) MEETING_DATE="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

if [[ -z "$WEEK" ]]; then
  WEEK=$(date +%V | sed 's/^0//')
fi

BASE="$REPO_ROOT/strategy/meetings/week${WEEK}/meeting${MEETING_DATE}"
if [[ -e "$BASE/README.md" ]]; then
  echo "Already exists: $BASE" >&2
  exit 1
fi

mkdir -p "$BASE/agenda" "$BASE/anomalies"

cat > "$BASE/README.md" <<EOF
# Meeting ${MEETING_DATE} — Index

**Week:** ${WEEK} | **Tool:** (fill in) | **Operator cadence:** (fill in)

---

## Status

- [State Snapshot](state_snapshot.md) — VPS, repo health, plans in motion

## Agenda

- (add agenda/*.md links)

## Session Files

- [Exit Criteria](exit_criteria.md) — today's done checklist
- [Decisions](decisions.md) — live decisions log
EOF

cat > "$BASE/exit_criteria.md" <<EOF
# Exit criteria — ${MEETING_DATE}

- [ ] 
EOF

touch "$BASE/decisions.md"
touch "$BASE/state_snapshot.md"

echo "Created meeting day folder:"
echo "  $BASE"
find "$BASE" -type f | sort
