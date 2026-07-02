#!/usr/bin/env bash
# new_plan.sh — scaffold a governed plan directory
#
# Usage:
#   ./scripts/dev/new_plan.sh <Phase> <Stage> <status> <slug>
# Example:
#   ./scripts/dev/new_plan.sh S1 S1.B planning feat-example-widget

set -euo pipefail

[[ $# -lt 4 ]] && {
  echo "Usage: new_plan.sh <Phase> <Stage> <status> <slug>" >&2
  echo "  status: proposed | planning | active | inactive | complete" >&2
  exit 1
}

PHASE="$1"
STAGE="$2"
STATUS="$3"
SLUG="$4"
DATE="$(date +%Y-%m-%d)"
PLAN_ID="PLAN_CROSS_$(echo "$SLUG" | tr '[:lower:]' '[:upper:]' | tr '-' '_')_${DATE}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
BASE="$REPO_ROOT/plans/${PHASE}/${STAGE}/${STATUS}/${SLUG}"

if [[ -e "$BASE" ]]; then
  echo "Already exists: $BASE" >&2
  exit 1
fi

mkdir -p "$BASE/tasks" "$BASE/evidence"

cat > "$BASE/README.md" <<EOF
---
plan_id: ${PLAN_ID}
status: draft
priority: P2
created: ${DATE}
updated: ${DATE}
owner: pproctor
intended_branch: cur/s1b/feat/${SLUG}
---

# ${SLUG}

## Summary

(TBD)

## Scope

(TBD — see governance/plans/plan_template.md and definition_of_done.md)

## Tasks

| Task | Status | Notes |
|------|--------|-------|
| T01 | pending | |

## Completion criteria

- [ ] All tasks complete per validation_gates.md
- [ ] CHANGELOG / design docs updated (CPPRD)
EOF

cat > "$BASE/DECISION_LOG.md" <<EOF
# Decision log — ${PLAN_ID}

Append-only. Check before design choices.

## ${DATE}

- Plan scaffold created via scripts/dev/new_plan.sh
EOF

cat > "$BASE/runtime_handoff.md" <<EOF
# Runtime handoff — ${PLAN_ID}

**Updated:** ${DATE}

## Current state

- Plan scaffold only — no execution started.

## Next agent

1. Read this file + README.md
2. Run \`./scripts/dev/session_brief.sh\`
EOF

touch "$BASE/validation_gates.md"
cat > "$BASE/tasks/T01_scaffold.md" <<EOF
# T01 — (title)

## Slice checklist

- [ ] [V0] Define scope in README.md
EOF

echo "Created plan scaffold:"
echo "  $BASE"
find "$BASE" -type f | sort
