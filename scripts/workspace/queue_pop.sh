#!/usr/bin/env bash
# Claim the next PENDING task in a repo queue.
# Prints task details to stdout for the calling agent; marks it CLAIMED in the queue.
#
# Usage:
#   queue_pop.sh <repo>
#
# Output (on success): TASK_ID|PLAN_ID|BRANCH|AGENT
# Exit 0: task claimed. Exit 1: no pending tasks or error.
#
# Typical CLI one-shot usage (Option B per architecture):
#   TASK=$(queue_pop.sh api) && cursor-agent --workspace ~/Hive_Financial_Manager/WS-API ...

set -euo pipefail

if [[ -z "${FM_PRIMARY_WORKSPACE:-}" ]]; then
  [[ -f "$HOME/.fm_workspace.conf" ]] && source "$HOME/.fm_workspace.conf"
fi
PRIMARY="${FM_PRIMARY_WORKSPACE:-}"
if [[ -z "$PRIMARY" ]]; then
  printf 'Error: FM_PRIMARY_WORKSPACE not set.\n' >&2; exit 1
fi

if [[ $# -lt 1 ]]; then
  printf 'Usage: queue_pop.sh <repo>\n' >&2; exit 1
fi

REPO="$1"
QFILE="$PRIMARY/strategy/workspace/${REPO}.queue"
[[ ! -f "$QFILE" ]] && { printf 'Error: queue file not found: %s\n' "$QFILE" >&2; exit 1; }

QLOCK="${QFILE}.lock"
(
  flock -x 9

  # Find first PENDING entry (not a comment)
  pending_line=""
  while IFS='|' read -r task_id plan_id branch agent status rest; do
    [[ "$task_id" == \#* || -z "$task_id" ]] && continue
    if [[ "$status" == "PENDING" ]]; then
      pending_line="${task_id}|${plan_id}|${branch}|${agent}"
      break
    fi
  done < "$QFILE"

  if [[ -z "$pending_line" ]]; then
    printf 'No PENDING tasks in %s.queue.\n' "$REPO" >&2
    exit 1
  fi

  task_id=$(printf '%s' "$pending_line" | cut -d'|' -f1)
  CLAIMED_AT="$(date -u +%Y-%m-%dT%H:%M)"

  # Mark CLAIMED (atomic via temp file)
  tmpfile=$(mktemp)
  awk -F'|' -v tid="$task_id" -v ts="$CLAIMED_AT" 'BEGIN{OFS="|"}
    /^#/ || /^$/ { print; next }
    $1 == tid && $5 == "PENDING" { $5="CLAIMED"; $7=ts; print; next }
    { print }
  ' "$QFILE" > "$tmpfile"
  mv "$tmpfile" "$QFILE"

  printf '%s\n' "$pending_line"
  printf 'Claimed: %s from %s.queue at %s\n' "$task_id" "$REPO" "$CLAIMED_AT" >&2

) 9>"$QLOCK"
