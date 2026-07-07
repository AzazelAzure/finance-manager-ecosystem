#!/usr/bin/env bash
# Append a task to a repo's FIFO queue.
#
# Usage:
#   queue_push.sh <repo> <task_id> <plan_id> <branch> <agent>
#
# Example:
#   queue_push.sh api feat-f009-t01 PLAN_CROSS_RECURRING_AUTO_DEDUCT_F009 \
#     cur/s1b/feat/f009-t01-auto-deduct-field-api cursor
#
# Queue file: $FM_PRIMARY_WORKSPACE/strategy/workspace/<repo>.queue
# Format: TASK_ID|PLAN_ID|BRANCH|AGENT|STATUS|ENQUEUED_AT|CLAIMED_AT|RELEASED_AT|PLAN_EXPORT_PATH

set -euo pipefail

if [[ -z "${FM_PRIMARY_WORKSPACE:-}" ]]; then
  [[ -f "$HOME/.fm_workspace.conf" ]] && source "$HOME/.fm_workspace.conf"
fi
PRIMARY="${FM_PRIMARY_WORKSPACE:-}"
if [[ -z "$PRIMARY" ]]; then
  printf 'Error: FM_PRIMARY_WORKSPACE not set.\n' >&2; exit 1
fi

if [[ $# -lt 5 ]]; then
  printf 'Usage: queue_push.sh <repo> <task_id> <plan_id> <branch> <agent>\n' >&2; exit 1
fi

REPO="$1"; TASK_ID="$2"; PLAN_ID="$3"; BRANCH="$4"; AGENT="$5"
QFILE="$PRIMARY/strategy/workspace/${REPO}.queue"

if [[ ! -f "$QFILE" ]]; then
  printf 'Error: queue file not found: %s\n' "$QFILE" >&2
  printf 'Known queues: %s\n' "$(ls "$PRIMARY/strategy/workspace/"*.queue 2>/dev/null | xargs -n1 basename | sed 's/\.queue//' | tr '\n' ' ')" >&2
  exit 1
fi

# Prevent duplicate task_id
if grep -q "^${TASK_ID}|" "$QFILE" 2>/dev/null; then
  printf 'Error: task_id %q already exists in %s.queue.\n' "$TASK_ID" "$REPO" >&2; exit 1
fi

ENQUEUED_AT="$(date -u +%Y-%m-%dT%H:%M)"
PLAN_EXPORT_PATH=""
if [[ -n "$PLAN_ID" && "$PLAN_ID" != "null" ]]; then
  PLAN_EXPORT_PATH="$("$PRIMARY/scripts/dev/plan_export.sh" --plan "$PLAN_ID" --print-path 2>/dev/null || true)"
fi
printf '%s|%s|%s|%s|PENDING|%s|null|null|%s\n' \
  "$TASK_ID" "$PLAN_ID" "$BRANCH" "$AGENT" "$ENQUEUED_AT" "${PLAN_EXPORT_PATH:-}" >> "$QFILE"

printf 'Queued: [%s] %s → %s.queue (PENDING)\n' "$PLAN_ID" "$TASK_ID" "$REPO"
