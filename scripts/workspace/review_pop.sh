#!/usr/bin/env bash
# Claim the next PENDING PR in the review queue.
#
# Usage:
#   review_pop.sh
#
# Output (on success): TARGET_REPO|PR_NUMBER|TASK_ID|AGENT
# Exit 0: entry claimed. Exit 1: no pending reviews or error.

set -euo pipefail

if [[ -z "${FM_PRIMARY_WORKSPACE:-}" ]]; then
  [[ -f "$HOME/.fm_workspace.conf" ]] && source "$HOME/.fm_workspace.conf"
fi
PRIMARY="${FM_PRIMARY_WORKSPACE:-}"
if [[ -z "$PRIMARY" ]]; then
  printf 'Error: FM_PRIMARY_WORKSPACE not set.\n' >&2; exit 1
fi

QFILE="$PRIMARY/strategy/workspace/review.queue"
[[ ! -f "$QFILE" ]] && { printf 'Error: review queue file not found: %s\n' "$QFILE" >&2; exit 1; }

QLOCK="${QFILE}.lock"
(
  flock -x 9

  pending_line=""
  review_key=""
  while IFS='|' read -r key target_repo pr_num task_id agent status rest; do
    [[ "$key" == \#* || -z "$key" ]] && continue
    if [[ "$status" == "PENDING" ]]; then
      review_key="$key"
      pending_line="${target_repo}|${pr_num}|${task_id}|${agent}"
      break
    fi
  done < "$QFILE"

  if [[ -z "$pending_line" ]]; then
    printf 'No PENDING reviews in review.queue.\n' >&2
    exit 1
  fi

  CLAIMED_AT="$(date -u +%Y-%m-%dT%H:%M)"

  tmpfile=$(mktemp)
  awk -F'|' -v key="$review_key" -v ts="$CLAIMED_AT" 'BEGIN{OFS="|"}
    /^#/ || /^$/ { print; next }
    $1 == key && $6 == "PENDING" { $6="CLAIMED"; $8=ts; print; next }
    { print }
  ' "$QFILE" > "$tmpfile"
  mv "$tmpfile" "$QFILE"

  printf '%s\n' "$pending_line"
  printf 'Claimed review: %s at %s\n' "$review_key" "$CLAIMED_AT" >&2

) 9>"$QLOCK"
