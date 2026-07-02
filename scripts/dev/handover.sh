#!/usr/bin/env bash
# handover.sh — generate Cursor handover prompt for a plan
#
# Usage:
#   ./scripts/dev/handover.sh <plan_slug_or_id>
#
# Examples:
#   ./scripts/dev/handover.sh fix-production-ux-2026-06-28
#   ./scripts/dev/handover.sh PRODUCTION_UX_FIX_2026-06-28
#   ./scripts/dev/handover.sh F004

set -euo pipefail

[[ $# -lt 1 ]] && { echo "Usage: handover.sh <plan_slug_or_id>"; exit 1; }

QUERY="${1}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
PLANS_DIR="$REPO_ROOT/plans"
REGISTRY="$REPO_ROOT/governance/plans/plan_registry.md"

# Normalize: uppercase for ID match, keep original for dir match
QUERY_UPPER="${QUERY^^}"
SHORT="${QUERY_UPPER#PLAN_}"

# Find plan directory — try exact slug match first, then substring
FOUND_DIR="$(find "$PLANS_DIR" -maxdepth 4 -type d -iname "*${SHORT}*" 2>/dev/null | sort | head -1 || true)"

# If not found by SHORT, try original query (handles feat-f004 slug style)
if [[ -z "$FOUND_DIR" ]]; then
  FOUND_DIR="$(find "$PLANS_DIR" -maxdepth 4 -type d -iname "*${QUERY}*" 2>/dev/null | sort | head -1 || true)"
fi

if [[ -z "$FOUND_DIR" ]] || [[ ! -f "$FOUND_DIR/README.md" ]]; then
  echo "ERROR: No plan README found matching '${QUERY}'"
  echo "       Try: ls plans/S1/S1.B/ | grep -i '${QUERY}'"
  exit 1
fi

README="$FOUND_DIR/README.md"
REL_README="${FOUND_DIR#$REPO_ROOT/}/README.md"

# Extract plan_id from README frontmatter
PLAN_ID="$(grep "^plan_id:" "$README" | head -1 | awk '{print $2}' || echo "unknown")"
STATUS="$(grep "^status:" "$README" | head -1 | awk '{print $2}' || echo "unknown")"
BRANCH="$(grep "^intended_branch:" "$README" | head -1 | awk '{print $2}' || echo "see README")"

# Extract task list from ## Tasks table (T## entries)
TASK_LIST="$(grep -oE "^\| T[0-9]+" "$README" | tr -d '| ' | tr '\n' ' ' || true)"
TASK_COUNT="$(echo "$TASK_LIST" | wc -w | tr -d ' ')"

# Scan README + task files for HitM gates
GATE_FILES=("$README")
while IFS= read -r -d '' tf; do
  GATE_FILES+=("$tf")
done < <(find "$FOUND_DIR/tasks" -name "*.md" -print0 2>/dev/null)

GATES=""
for gf in "${GATE_FILES[@]}"; do
  while IFS= read -r line; do
    GATES+="  $(basename "$gf"): ${line#*Gate}"$'\n'
  done < <(grep -n "HitM Gate\|⚠️.*gate\|HitM gate" "$gf" 2>/dev/null | head -5 || true)
done

# Count task files (tasks/ dir may not exist for draft plans)
TASK_FILES="$(find "$FOUND_DIR/tasks" -name "T*.md" 2>/dev/null | wc -l | tr -d ' \n' || true)"
TASK_FILES="${TASK_FILES:-0}"

# --- Output ---

echo "================================================================"
echo "  CURSOR HANDOVER — ${PLAN_ID}"
echo "================================================================"
echo ""
echo "  Status : $STATUS"
echo "  Branch : $BRANCH"
echo "  Tasks  : ${TASK_COUNT:-?} in README  |  ${TASK_FILES} task files"
echo ""
echo "----------------------------------------------------------------"
echo "  ATTACH THIS FILE IN CURSOR:"
echo "----------------------------------------------------------------"
echo ""
echo "  $README"
echo ""
echo "----------------------------------------------------------------"
echo "  PASTE THIS PROMPT:"
echo "----------------------------------------------------------------"
echo ""
cat <<PROMPT
I need you to begin work on the attached README.md.

Work through all tasks in order. For each task, read the corresponding
task file in the tasks/ directory before writing any code. Follow the
READ FIRST files listed in the README. Run agent review between tasks.
CPPR on completion of each task — do not batch multiple tasks into one PR.
PROMPT
echo ""

if [[ -n "$GATES" ]]; then
  echo "----------------------------------------------------------------"
  echo "  ⚠️  HITM GATES — ANSWER BEFORE CURSOR REACHES THESE TASKS:"
  echo "----------------------------------------------------------------"
  echo ""
  printf '%s' "$GATES"
  echo ""
fi

# List task files for reference
if [[ "${TASK_FILES:-0}" -gt 0 ]]; then
  echo "----------------------------------------------------------------"
  echo "  TASK FILES (Cursor reads these — you don't need to attach):"
  echo "----------------------------------------------------------------"
  echo ""
  find "$FOUND_DIR/tasks" -name "T*.md" 2>/dev/null | sort | while read -r tf; do
    echo "  ${tf#$REPO_ROOT/}"
  done
  echo ""
fi

echo "================================================================"
