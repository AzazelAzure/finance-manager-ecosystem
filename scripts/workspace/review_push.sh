#!/usr/bin/env bash
# Append a PR to the WS3 review FIFO queue.
#
# Usage:
#   review_push.sh <target_repo> <pr_number> <task_id> <agent>
#
# target_repo ∈ {api, web, parent}
#
# Queue file: $FM_PRIMARY_WORKSPACE/strategy/workspace/review.queue
# Format: REVIEW_KEY|TARGET_REPO|PR_NUMBER|TASK_ID|AGENT|STATUS|ENQUEUED_AT|CLAIMED_AT|RELEASED_AT

set -euo pipefail

if [[ -z "${FM_PRIMARY_WORKSPACE:-}" ]]; then
  [[ -f "$HOME/.fm_workspace.conf" ]] && source "$HOME/.fm_workspace.conf"
fi
PRIMARY="${FM_PRIMARY_WORKSPACE:-}"
if [[ -z "$PRIMARY" ]]; then
  printf 'Error: FM_PRIMARY_WORKSPACE not set.\n' >&2; exit 1
fi

if [[ $# -lt 4 ]]; then
  printf 'Usage: review_push.sh <target_repo> <pr_number> <task_id> <agent>\n' >&2
  printf 'target_repo: api | web | parent\n' >&2
  exit 1
fi

TARGET_REPO="$1"; PR_NUMBER="$2"; TASK_ID="$3"; AGENT="$4"
case "$TARGET_REPO" in
  api|web|parent) ;;
  *) printf 'Error: unknown target_repo %q. Expected: api | web | parent\n' "$TARGET_REPO" >&2; exit 1 ;;
esac

if ! [[ "$PR_NUMBER" =~ ^[0-9]+$ ]]; then
  printf 'Error: pr_number must be numeric, got %q\n' "$PR_NUMBER" >&2; exit 1
fi

QFILE="$PRIMARY/strategy/workspace/review.queue"
if [[ ! -f "$QFILE" ]]; then
  printf 'Error: review queue file not found: %s\n' "$QFILE" >&2
  printf 'Create it from the header template in workspace_protocol.md §6.\n' >&2
  exit 1
fi

REVIEW_KEY="${TARGET_REPO}-${PR_NUMBER}"

if grep -q "^${REVIEW_KEY}|" "$QFILE" 2>/dev/null; then
  printf 'Error: review_key %q already exists in review.queue.\n' "$REVIEW_KEY" >&2; exit 1
fi

ENQUEUED_AT="$(date -u +%Y-%m-%dT%H:%M)"
printf '%s|%s|%s|%s|%s|PENDING|%s|null|null\n' \
  "$REVIEW_KEY" "$TARGET_REPO" "$PR_NUMBER" "$TASK_ID" "$AGENT" "$ENQUEUED_AT" >> "$QFILE"

printf 'Queued for review: [%s] PR #%s (%s) → review.queue (PENDING)\n' "$TASK_ID" "$PR_NUMBER" "$TARGET_REPO"
