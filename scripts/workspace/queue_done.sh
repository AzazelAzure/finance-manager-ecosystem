#!/usr/bin/env bash
# Mark a task as DONE in a repo queue.
#
# Usage:
#   queue_done.sh <repo> <task_id>
#
# Optionally mark as FAILED:
#   queue_done.sh <repo> <task_id> --failed

set -euo pipefail

if [[ -z "${FM_PRIMARY_WORKSPACE:-}" ]]; then
  [[ -f "$HOME/.fm_workspace.conf" ]] && source "$HOME/.fm_workspace.conf"
fi
PRIMARY="${FM_PRIMARY_WORKSPACE:-}"
if [[ -z "$PRIMARY" ]]; then
  printf 'Error: FM_PRIMARY_WORKSPACE not set.\n' >&2; exit 1
fi

if [[ $# -lt 2 ]]; then
  printf 'Usage: queue_done.sh <repo> <task_id> [--failed]\n' >&2; exit 1
fi

REPO="$1"; TASK_ID="$2"
FINAL_STATUS="DONE"
[[ "${3:-}" == "--failed" ]] && FINAL_STATUS="FAILED"

QFILE="$PRIMARY/strategy/workspace/${REPO}.queue"
[[ ! -f "$QFILE" ]] && { printf 'Error: queue file not found: %s\n' "$QFILE" >&2; exit 1; }

QLOCK="${QFILE}.lock"
(
  flock -x 9

  if ! grep -q "^${TASK_ID}|" "$QFILE" 2>/dev/null; then
    printf 'Error: task_id %q not found in %s.queue.\n' "$TASK_ID" "$REPO" >&2; exit 1
  fi

  RELEASED_AT="$(date -u +%Y-%m-%dT%H:%M)"

  tmpfile=$(mktemp)
  awk -F'|' -v tid="$TASK_ID" -v status="$FINAL_STATUS" -v ts="$RELEASED_AT" \
    'BEGIN{OFS="|"}
    /^#/ || /^$/ { print; next }
    $1 == tid { $5=status; $8=ts; print; next }
    { print }
  ' "$QFILE" > "$tmpfile"
  mv "$tmpfile" "$QFILE"

  printf '%s: %s in %s.queue at %s\n' "$FINAL_STATUS" "$TASK_ID" "$REPO" "$RELEASED_AT"

) 9>"$QLOCK"
