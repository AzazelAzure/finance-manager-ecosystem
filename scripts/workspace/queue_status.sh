#!/usr/bin/env bash
# Print current queue state for one or all repos.
#
# Usage:
#   queue_status.sh           # all queues
#   queue_status.sh api       # api.queue only
#   queue_status.sh api web   # multiple

set -euo pipefail

if [[ -z "${FM_PRIMARY_WORKSPACE:-}" ]]; then
  [[ -f "$HOME/.fm_workspace.conf" ]] && source "$HOME/.fm_workspace.conf"
fi
PRIMARY="${FM_PRIMARY_WORKSPACE:-}"
if [[ -z "$PRIMARY" ]]; then
  printf 'Error: FM_PRIMARY_WORKSPACE not set.\n' >&2; exit 1
fi

WS_DIR="$PRIMARY/strategy/workspace"

print_queue() {
  local repo="$1"
  local qfile="$WS_DIR/${repo}.queue"
  if [[ ! -f "$qfile" ]]; then
    printf 'Queue not found: %s\n' "$qfile" >&2; return 1
  fi

  printf '\n── %s.queue ────────────────────────────────────────────────────────────\n' "$repo"
  printf '%-28s  %-8s  %-14s  %-20s  %s\n' "TASK_ID" "STATUS" "AGENT" "ENQUEUED" "BRANCH"
  printf '%-28s  %-8s  %-14s  %-20s  %s\n' "───────" "──────" "─────" "────────" "──────"

  local has_entries=0
  while IFS='|' read -r task_id plan_id branch agent status enqueued claimed released; do
    [[ "$task_id" == \#* || -z "$task_id" ]] && continue
    has_entries=1
    printf '%-28s  %-8s  %-14s  %-20s  %s\n' "$task_id" "${status:--}" "${agent:--}" "${enqueued:--}" "${branch:--}"
  done < "$qfile"

  [[ "$has_entries" -eq 0 ]] && printf '  (empty)\n'
  return 0
}

if [[ $# -eq 0 ]]; then
  # All queues
  shopt -s nullglob
  queues=("$WS_DIR"/*.queue)
  if [[ ${#queues[@]} -eq 0 ]]; then
    printf 'No queue files found in %s\n' "$WS_DIR" >&2; exit 1
  fi
  for qfile in "${queues[@]}"; do
    repo=$(basename "$qfile" .queue)
    print_queue "$repo"
  done
else
  for repo in "$@"; do
    print_queue "$repo"
  done
fi

printf '\n'
