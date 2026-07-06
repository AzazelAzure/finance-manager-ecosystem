#!/usr/bin/env bash
# Dispatch the next queued task from <repo> to its per-repo worker workspace.
#
# Pops a PENDING task from the queue, claims the corresponding workspace,
# executes the task, then marks it DONE/FAILED and releases the workspace.
#
# Modes:
#   cursor (default) — invoke a headless Cursor agent in the worker directory
#                      via: cursor agent --print --workspace <dir> --trust --force
#   direct           — in-process smoke fallback (pilot only; real tasks use cursor)
#   --dry-run        — show task brief without executing
#
# Usage:
#   ws_dispatch.sh <repo>              # api | web | parent  (cursor mode)
#   ws_dispatch.sh <repo> --direct     # in-process execution (smoketest/fallback)
#   ws_dispatch.sh <repo> --dry-run    # show task brief without executing

set -euo pipefail

# ── resolve primary workspace ──────────────────────────────────────────────────
if [[ -z "${FM_PRIMARY_WORKSPACE:-}" ]]; then
  [[ -f "$HOME/.fm_workspace.conf" ]] && source "$HOME/.fm_workspace.conf"
fi
PRIMARY="${FM_PRIMARY_WORKSPACE:-}"
[[ -z "$PRIMARY" ]] && { printf 'Error: FM_PRIMARY_WORKSPACE not set.\n' >&2; exit 1; }

SCRIPTS_DIR="$PRIMARY/scripts/workspace"
ROOT_DIR="$(dirname "$PRIMARY")"

# ── args ───────────────────────────────────────────────────────────────────────
[[ $# -lt 1 ]] && { printf 'Usage: ws_dispatch.sh <repo> [--direct|--dry-run]\n' >&2; exit 1; }
REPO="$1"; MODE="cursor"; DRY_RUN=0
case "${2:-}" in
  --direct)  MODE="direct" ;;
  --dry-run) DRY_RUN=1 ;;
esac

# ── repo → workspace + worker directory map ────────────────────────────────────
# parent runs in-place on HFM (not an isolated worker clone). Advisory claim only —
# confirm no concurrent Claude Code admin session is mid-edit before dispatching.
case "$REPO" in
  api)    WORKSPACE="WS1"; WORKER_DIR="$ROOT_DIR/WS-API" ;;
  web)    WORKSPACE="WS2"; WORKER_DIR="$ROOT_DIR/WS-WEB" ;;
  parent) WORKSPACE="HFM"; WORKER_DIR="$PRIMARY" ;;
  *) printf 'Error: unknown repo %q. Expected: api | web | parent\n' "$REPO" >&2; exit 1 ;;
esac

[[ ! -d "$WORKER_DIR" ]] && {
  printf 'Error: worker directory not found: %s\n' "$WORKER_DIR" >&2; exit 1
}

# ── task file resolution (plan_lookup mirror + README plan_id fallback) ─────────
resolve_plan_dir() {
  local plan_id="$1"
  local short="${plan_id#PLAN_}"
  local found readme
  found="$(find "$PRIMARY/plans" -maxdepth 4 -type d -iname "*${short}*" 2>/dev/null | head -1)"
  if [[ -n "$found" ]]; then
    printf '%s\n' "$found"
    return 0
  fi
  # Directory slug often differs from PLAN_ID (e.g. security-audit-fixes vs CROSS_SECURITY_AUDIT_FIXES)
  readme="$(grep -ril "plan_id:[[:space:]]*${plan_id}" "$PRIMARY/plans" 2>/dev/null | grep '/README\.md$' | head -1)"
  if [[ -n "$readme" && -f "$readme" ]]; then
    dirname "$readme"
    return 0
  fi
  return 1
}

resolve_task_num() {
  local task_id="$1"
  if [[ "$task_id" =~ (T[0-9]+)$ ]]; then
    printf '%s\n' "${BASH_REMATCH[1]}"
    return 0
  fi
  return 1
}

resolve_task_file() {
  local plan_dir="$1"
  local task_num="$2"
  [[ -d "$plan_dir/tasks" ]] || return 1
  find "$plan_dir/tasks" -maxdepth 1 -iname "${task_num}_*.md" 2>/dev/null | head -1
}

fail_task_resolution() {
  local reason="$1"
  printf 'Error: %s\n' "$reason" >&2
  if [[ "$DRY_RUN" -eq 0 && -n "${TASK_ID:-}" ]]; then
    "$SCRIPTS_DIR/queue_done.sh" "$REPO" "$TASK_ID" --failed >&2
  fi
  exit 1
}

resolve_task_context() {
  PLAN_DIR=""
  TASK_NUM=""
  TASK_FILE=""
  PLAN_DIR="$(resolve_plan_dir "$PLAN_ID")"
  [[ -n "$PLAN_DIR" ]] || fail_task_resolution "plan directory not found for PLAN_ID=${PLAN_ID} (task ${TASK_ID})"
  TASK_NUM="$(resolve_task_num "$TASK_ID")" || fail_task_resolution "could not extract task number from TASK_ID=${TASK_ID}"
  TASK_FILE="$(resolve_task_file "$PLAN_DIR" "$TASK_NUM")"
  [[ -n "$TASK_FILE" && -f "$TASK_FILE" ]] || fail_task_resolution "task file not found for ${TASK_ID} under ${PLAN_DIR}/tasks (not dispatching)"
}

worker_governance_excerpt() {
  local agents_md="$PRIMARY/AGENTS.md"
  if [[ ! -f "$agents_md" ]]; then
    printf '## Governance (live excerpt)\nAGENTS.md not found at primary workspace.\n'
    return
  fi
  printf '## Governance (live excerpt from AGENTS.md)\n\n'
  sed -n '/^## §0 Three-tool model/,/^## §2 /p' "$agents_md" | head -35
  if [[ "$REPO" == "parent" ]]; then
    printf '\n**Worker scope:** Parent-repo execution in HFM primary checkout — branch prefix `cur/s1b/`, one PR per task, parent CHANGELOG when behavior changes. Same directory Claude Code may use for admin; confirm no concurrent admin edit before dispatch.\n'
  else
    printf '\n**Worker scope:** Per-repo execution clone — branch prefix `cur/s1b/`, one PR per task, subrepo CHANGELOG when behavior changes. Do not edit parent governance/plans unless the task requires it.\n'
  fi
}

build_cursor_brief() {
  local changelog_note
  if [[ "$REPO" == "parent" ]]; then
    changelog_note="update parent \`CHANGELOG.md\` \`[Unreleased]\` if behavior changed"
  else
    changelog_note="update the subrepo \`CHANGELOG.md\` \`[Unreleased]\` if behavior changed"
  fi

  cat <<ENDBRIEF
# HFM Worker Task

You are a Cursor agent worker for the Hive Financial Manager project executing
a queued task in your workspace (${WORKER_DIR}).

## Task metadata
- Task ID   : ${TASK_ID}
- Plan ID   : ${PLAN_ID}
- Branch    : ${BRANCH}
- Agent     : ${AGENT}
- Repo      : ${REPO}
- Dispatched: ${DISPATCHED_AT}
- Task file : ${TASK_FILE}

$(worker_governance_excerpt)

## Your actual task

$(cat "$TASK_FILE")

## Execution requirements

1. Sync to latest main, create the task branch (\`${BRANCH}\`).
2. Do the work described above — the task file is the authoritative spec, not this brief.
3. Follow standard CPPR discipline (\`deploy/CPPR_AND_CPPRD.md\`,
   \`governance/execution/execution_protocols.md\` §1.2): commit, push, ${changelog_note}, open a PR via \`gh pr create\`.
4. Print the PR URL.
5. Print exactly: DISPATCH_RESULT: SUCCESS ${TASK_ID}

If any step fails, print: DISPATCH_RESULT: FAILED ${TASK_ID} <reason>
ENDBRIEF
}

# ── pop (or peek) next PENDING task ───────────────────────────────────────────
QFILE="$PRIMARY/strategy/workspace/${REPO}.queue"
if [[ "$DRY_RUN" -eq 1 ]]; then
  TASK_LINE=""
  while IFS='|' read -r t p b a s rest; do
    [[ "$t" == \#* || -z "$t" ]] && continue
    if [[ "$s" == "PENDING" ]]; then TASK_LINE="${t}|${p}|${b}|${a}"; break; fi
  done < "$QFILE"
  [[ -z "$TASK_LINE" ]] && { printf 'No PENDING tasks in %s.queue.\n' "$REPO" >&2; exit 1; }
  printf '── Dispatch [DRY RUN]: next task from %s.queue ──\n' "$REPO" >&2
else
  printf '── Dispatch [%s mode]: popping from %s.queue ──\n' "$MODE" "$REPO" >&2
  TASK_LINE=$("$SCRIPTS_DIR/queue_pop.sh" "$REPO")
fi

TASK_ID=$(printf '%s' "$TASK_LINE" | cut -d'|' -f1)
PLAN_ID=$(printf '%s' "$TASK_LINE"  | cut -d'|' -f2)
BRANCH=$(printf '%s'  "$TASK_LINE"  | cut -d'|' -f3)
AGENT=$(printf '%s'   "$TASK_LINE"  | cut -d'|' -f4)
DISPATCHED_AT="$(date -u +%Y-%m-%dT%H:%M)"

printf '   task=%s  plan=%s  branch=%s  agent=%s\n' \
  "$TASK_ID" "$PLAN_ID" "$BRANCH" "$AGENT" >&2

resolve_task_context
printf '   plan_dir=%s  task_file=%s\n' "$PLAN_DIR" "$TASK_FILE" >&2

# ── dry run: show brief preview, exit early ────────────────────────────────────
if [[ "$DRY_RUN" -eq 1 ]]; then
  printf '\nTask: %s | Plan: %s | Branch: %s | Agent: %s\n' \
    "$TASK_ID" "$PLAN_ID" "$BRANCH" "$AGENT"
  printf 'Worker dir: %s\n' "$WORKER_DIR"
  printf 'Workspace claim: %s\n' "$WORKSPACE"
  printf 'Mode: %s\n' "$MODE"
  printf 'Resolved task file: %s\n' "$TASK_FILE"
  printf '\n── Brief preview (first 40 lines) ──\n'
  build_cursor_brief | head -40
  printf '\n[DRY RUN] No queue or workspace state changed.\n'
  exit 0
fi

# ── claim workspace (real mode only) ──────────────────────────────────────────
"$SCRIPTS_DIR/ws_claim.sh" "$WORKSPACE" "$AGENT" "$TASK_ID" "$BRANCH" >&2

# ── execute ────────────────────────────────────────────────────────────────────
FINAL_STATUS="FAILED"
PR_URL=""

if [[ "$MODE" == "cursor" ]]; then
  command -v cursor &>/dev/null || {
    printf 'Error: cursor CLI not found. Install Cursor or use --direct mode.\n' >&2
    "$SCRIPTS_DIR/queue_done.sh" "$REPO" "$TASK_ID" --failed >&2
    "$SCRIPTS_DIR/ws_release.sh" "$WORKSPACE" >&2
    exit 1
  }

  BRIEF="$(build_cursor_brief)"

  printf '── Invoking Cursor agent in %s ──\n' "$WORKER_DIR" >&2
  AGENT_OUTPUT=""
  AGENT_OUTPUT=$(cursor agent --print \
    --workspace "$WORKER_DIR" \
    --trust \
    --force \
    "$BRIEF") || true

  printf '%s\n' "$AGENT_OUTPUT"

  if printf '%s' "$AGENT_OUTPUT" | grep -q "DISPATCH_RESULT: SUCCESS"; then
    FINAL_STATUS="DONE"
  fi

else
  # direct mode retained for smoke pilot only — real queued tasks require cursor mode
  printf 'Error: --direct mode cannot execute real task files. Use cursor mode (default).\n' >&2
  FINAL_STATUS="FAILED"
fi

# ── mark task done/failed ──────────────────────────────────────────────────────
if [[ "$FINAL_STATUS" == "DONE" ]]; then
  "$SCRIPTS_DIR/queue_done.sh" "$REPO" "$TASK_ID" >&2
else
  "$SCRIPTS_DIR/queue_done.sh" "$REPO" "$TASK_ID" --failed >&2
fi

# ── release workspace ──────────────────────────────────────────────────────────
"$SCRIPTS_DIR/ws_release.sh" "$WORKSPACE" >&2

printf '── Dispatch complete: %s → %s (%s mode, %s) ──\n' \
  "$TASK_ID" "$FINAL_STATUS" "$MODE" "$WORKSPACE" >&2

[[ "$FINAL_STATUS" == "DONE" ]]
