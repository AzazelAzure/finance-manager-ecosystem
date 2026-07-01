#!/usr/bin/env bash
# Dispatch the next queued task from <repo> to its per-repo worker workspace.
#
# Pops a PENDING task from the queue, claims the corresponding workspace,
# executes the task, then marks it DONE/FAILED and releases the workspace.
#
# Modes:
#   cursor (default) — invoke a headless Cursor agent in the worker directory
#                      via: cursor agent --print --workspace <dir> --trust --force
#   direct           — execute git/PR work in-process (smoketest / no Cursor available)
#
# Usage:
#   ws_dispatch.sh <repo>              # api | web  (cursor mode)
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
case "$REPO" in
  api) WORKSPACE="WS1"; WORKER_DIR="$ROOT_DIR/WS-API" ;;
  web) WORKSPACE="WS2"; WORKER_DIR="$ROOT_DIR/WS-WEB" ;;
  *) printf 'Error: unknown repo %q. Expected: api | web\n' "$REPO" >&2; exit 1 ;;
esac

[[ ! -d "$WORKER_DIR" ]] && {
  printf 'Error: worker directory not found: %s\n' "$WORKER_DIR" >&2; exit 1
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

# ── claim workspace (real mode only) ──────────────────────────────────────────
[[ "$DRY_RUN" -eq 0 ]] && "$SCRIPTS_DIR/ws_claim.sh" "$WORKSPACE" "$AGENT" "$TASK_ID" "$BRANCH" >&2

# ── dry run: exit early ────────────────────────────────────────────────────────
if [[ "$DRY_RUN" -eq 1 ]]; then
  printf '\nTask: %s | Plan: %s | Branch: %s | Agent: %s\n' \
    "$TASK_ID" "$PLAN_ID" "$BRANCH" "$AGENT"
  printf 'Worker dir: %s\n' "$WORKER_DIR"
  printf 'Mode: %s\n' "$MODE"
  printf '[DRY RUN] No queue or workspace state changed.\n'
  exit 0
fi

# ── execute ────────────────────────────────────────────────────────────────────
FINAL_STATUS="FAILED"
PR_URL=""

if [[ "$MODE" == "cursor" ]]; then
  # ── cursor mode: headless Cursor agent executes in the worker directory ───────
  # cursor agent --print gives full tool access (read + write + shell).
  # --trust skips workspace trust prompts in headless mode.
  # --force allows all commands without per-command confirmation.
  command -v cursor &>/dev/null || {
    printf 'Error: cursor CLI not found. Install Cursor or use --direct mode.\n' >&2; exit 1
  }

  BRIEF="$(cat <<ENDBRIEF
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

## Your job

Execute each step and report results. Shell access is enabled.

1. Verify you are in the correct repo: run \`git status\`
2. Sync to latest main:
   git fetch origin
   git checkout main
   git pull --ff-only origin main
3. Create task branch:
   git checkout -b ${BRANCH}
4. Create the task deliverable file \`smoke_test/${TASK_ID}.txt\`:
   smoke_test: ${TASK_ID}
   plan: ${PLAN_ID}
   branch: ${BRANCH}
   agent: ${AGENT}
   dispatched: ${DISPATCHED_AT}
   status: PASS
5. Stage, commit, push:
   git add smoke_test/${TASK_ID}.txt
   git commit -m "smoke: ${TASK_ID} - add smoke test deliverable"
   git push -u origin ${BRANCH}
6. Open a GitHub PR:
   gh pr create --title "[SMOKE] ${TASK_ID}: ${BRANCH}" \
     --body "Smoke test task ${TASK_ID} (plan ${PLAN_ID}, agent ${AGENT})"
7. Print the PR URL.
8. Print exactly: DISPATCH_RESULT: SUCCESS ${TASK_ID}

If any step fails, print: DISPATCH_RESULT: FAILED ${TASK_ID} <reason>
ENDBRIEF
)"

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
  # ── direct mode: git/PR work executed in-process (smoketest / fallback) ───────
  printf '── Executing task directly in %s ──\n' "$WORKER_DIR" >&2
  (
    set -euo pipefail
    cd "$WORKER_DIR"

    git fetch origin >&2
    git checkout main >&2
    git pull --ff-only origin main >&2
    git checkout -b "$BRANCH" >&2

    mkdir -p smoke_test
    printf 'smoke_test: %s\nplan: %s\nbranch: %s\nagent: %s\ndispatched: %s\nstatus: PASS\n' \
      "$TASK_ID" "$PLAN_ID" "$BRANCH" "$AGENT" "$DISPATCHED_AT" > "smoke_test/${TASK_ID}.txt"

    git add "smoke_test/${TASK_ID}.txt" >&2
    git commit -m "smoke: ${TASK_ID} - add smoke test deliverable" >&2
    git push -u origin "$BRANCH" >&2

    PR_BODY="$(printf 'Automated smoke test PR.\n\nTask: %s\nPlan: %s\nAgent: %s\nDispatched: %s\n\nCreated by ws_dispatch.sh (direct mode).' \
      "$TASK_ID" "$PLAN_ID" "$AGENT" "$DISPATCHED_AT")"

    PR_URL_OUT=$(gh pr create \
      --repo "$(git remote get-url origin | sed 's|.*github.com[:/]\(.*\)\.git|\1|')" \
      --title "[SMOKE] ${TASK_ID}: ${BRANCH}" \
      --body "$PR_BODY" \
      --head "$BRANCH" 2>&1)
    printf 'PR: %s\n' "$PR_URL_OUT" >&2
    printf 'DISPATCH_RESULT: SUCCESS %s\nPR_URL: %s\n' "$TASK_ID" "$PR_URL_OUT"
  ) && FINAL_STATUS="DONE" || FINAL_STATUS="FAILED"
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
