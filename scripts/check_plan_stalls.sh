#!/usr/bin/env bash
# check_plan_stalls.sh
# Reads plan_registry.md, checks in_progress and paused plans for git activity.
# Flags any plan with no commits on its branch in the last STALE_DAYS days.
# Output: strategy/standby/plan_stall_check.md
#
# Usage: ./scripts/check_plan_stalls.sh [--days N]  (default: 7)

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
REGISTRY="$REPO_ROOT/governance/plan_registry.md"
OUTPUT_DIR="$REPO_ROOT/strategy/standby"
OUTPUT="$OUTPUT_DIR/plan_stall_check.md"
STALE_DAYS=7

# Parse optional --days argument
while [[ $# -gt 0 ]]; do
    case "$1" in
        --days) STALE_DAYS="$2"; shift 2 ;;
        *) echo "Unknown arg: $1"; exit 1 ;;
    esac
done

mkdir -p "$OUTPUT_DIR"

# Extract rows from a named section (stops at next ## heading)
extract_section() {
    local section="$1"
    awk "/^## ${section}/{found=1; next} /^## /{if(found) exit} found && /^\|/ && !/plan_id/ && !/^[[:space:]]*\|[-|[:space:]]*\|/" "$REGISTRY"
}

# Pull a pipe-delimited field (1-based, strips backticks and whitespace)
field() {
    echo "$1" | awk -F'|' "{print \$$2}" | tr -d '`' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# Returns: active:N | stale | not-found | no-branch
check_branch_activity() {
    local branch="$1"
    [[ -z "$branch" || "$branch" == "-" || "$branch" == "_" ]] && { echo "no-branch"; return; }

    # Try local then remote ref
    local ref=""
    if git -C "$REPO_ROOT" rev-parse --verify "refs/heads/$branch" &>/dev/null; then
        ref="$branch"
    elif git -C "$REPO_ROOT" rev-parse --verify "refs/remotes/origin/$branch" &>/dev/null; then
        ref="origin/$branch"
    else
        echo "not-found"
        return
    fi

    local count
    count=$(git -C "$REPO_ROOT" log "$ref" --oneline --since="${STALE_DAYS} days ago" 2>/dev/null | wc -l | tr -d ' ')
    [[ "$count" -gt 0 ]] && echo "active:$count" || echo "stale"
}

# ── Build report ────────────────────────────────────────────────────────────
TODAY=$(date +%Y-%m-%d)
stall_count=0

{
echo "# Plan Stall Check"
echo ""
echo "**Generated:** $TODAY  "
echo "**Stale threshold:** no commits in last ${STALE_DAYS} days  "
echo "**Source:** \`governance/plan_registry.md\`"
echo ""
echo "---"
echo ""

# ── In Progress ─────────────────────────────────────────────────────────────
# Table cols: | plan_id(2) | priority(3) | phase(4) | branch(5) | owner(6) | depends_on(7) | blocks(8) | parallel_safe_with(9) | updated(10) | notes(11) |
echo "## In Progress"
echo ""

has_inprogress=false
while IFS= read -r row; do
    [[ -z "$row" ]] && continue
    plan_id=$(field "$row" 2)
    branch=$(field "$row" 5)
    updated=$(field "$row" 10)
    [[ -z "$plan_id" ]] && continue
    has_inprogress=true

    status=$(check_branch_activity "$branch")
    case "$status" in
        active:*)
            commits="${status#active:}"
            echo "- ✅ \`$plan_id\`"
            echo "  Branch: \`$branch\` — **active** ($commits commit(s) last ${STALE_DAYS}d)"
            ;;
        stale)
            echo "- 🔴 \`$plan_id\`"
            echo "  Branch: \`$branch\` — **STALLED** (0 commits last ${STALE_DAYS}d, registry updated $updated)"
            stall_count=$((stall_count + 1))
            ;;
        not-found)
            echo "- ⚠️  \`$plan_id\`"
            echo "  Branch: \`$branch\` — **not found** locally or on origin (fetch needed?)"
            stall_count=$((stall_count + 1))
            ;;
        no-branch)
            echo "- ⚠️  \`$plan_id\` — no branch recorded in registry"
            ;;
    esac
done < <(extract_section "In Progress")

$has_inprogress || echo "_No in-progress plans._"

echo ""

# ── Paused ───────────────────────────────────────────────────────────────────
# Table cols: | plan_id(2) | phase(3) | paused_date(4) | paused_reason(5) | resume_trigger(6) |
echo "## Paused"
echo ""

has_paused=false
while IFS= read -r row; do
    [[ -z "$row" ]] && continue
    plan_id=$(field "$row" 2)
    paused_date=$(field "$row" 4)
    resume=$(field "$row" 6)
    [[ -z "$plan_id" ]] && continue
    has_paused=true
    echo "- ⏸  \`$plan_id\` — paused $paused_date"
    echo "  Resume trigger: $resume"
done < <(extract_section "Paused")

$has_paused || echo "_No paused plans._"

echo ""
echo "---"
echo ""

if [[ "$stall_count" -gt 0 ]]; then
    echo "**Action needed: $stall_count in-progress plan(s) show no recent activity.**"
else
    echo "**All in-progress plans show recent git activity.**"
fi

} > "$OUTPUT"

echo "Written: $OUTPUT"
echo ""
cat "$OUTPUT"
