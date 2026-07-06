#!/usr/bin/env bash
# Print the WS3 review queue state.
#
# Usage:
#   review_status.sh

set -euo pipefail

if [[ -z "${FM_PRIMARY_WORKSPACE:-}" ]]; then
  [[ -f "$HOME/.fm_workspace.conf" ]] && source "$HOME/.fm_workspace.conf"
fi
PRIMARY="${FM_PRIMARY_WORKSPACE:-}"
if [[ -z "$PRIMARY" ]]; then
  printf 'Error: FM_PRIMARY_WORKSPACE not set.\n' >&2; exit 1
fi

QFILE="$PRIMARY/strategy/workspace/review.queue"
if [[ ! -f "$QFILE" ]]; then
  printf 'Review queue not found: %s\n' "$QFILE" >&2; exit 1
fi

printf '\n── review.queue ─────────────────────────────────────────────────────────\n'
printf '%-16s  %-8s  %-6s  %-28s  %-14s  %s\n' "REVIEW_KEY" "STATUS" "REPO" "TASK_ID" "AGENT" "ENQUEUED"
printf '%-16s  %-8s  %-6s  %-28s  %-14s  %s\n' "──────────" "──────" "────" "───────" "─────" "────────"

has_entries=0
while IFS='|' read -r key target_repo pr_num task_id agent status enqueued claimed released; do
  [[ "$key" == \#* || -z "$key" ]] && continue
  has_entries=1
  printf '%-16s  %-8s  %-6s  %-28s  %-14s  %s\n' \
    "$key" "${status:--}" "${target_repo:--}" "$task_id" "${agent:--}" "${enqueued:--}"
done < "$QFILE"

[[ "$has_entries" -eq 0 ]] && printf '  (empty)\n'
printf '\n'
