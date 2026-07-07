#!/usr/bin/env bash
# review_queue_pr_guard.sh — cross-check review.queue vs GitHub label vs merge state (D1)
#
# Usage:
#   ./scripts/workspace/review_queue_pr_guard.sh --repo parent|api|web --pr <N>
#
# Prints: STATUS: SYNCED|DESYNC|LABEL_MISSING|ALREADY_MERGED|NOT_IN_QUEUE|NOT_OPEN

set -euo pipefail

if [[ -z "${FM_PRIMARY_WORKSPACE:-}" ]]; then
  [[ -f "$HOME/.fm_workspace.conf" ]] && source "$HOME/.fm_workspace.conf"
fi
PRIMARY="${FM_PRIMARY_WORKSPACE:-}"
[[ -n "$PRIMARY" ]] || { printf 'Error: FM_PRIMARY_WORKSPACE not set.\n' >&2; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/codex_review_label.sh
source "$SCRIPT_DIR/../lib/codex_review_label.sh"

REPO_SLUG=""
PR_NUM=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO_SLUG="$2"; shift 2 ;;
    --pr) PR_NUM="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) printf 'Unknown arg: %s\n' "$1" >&2; exit 1 ;;
  esac
done

[[ -n "$REPO_SLUG" && -n "$PR_NUM" ]] || {
  printf 'Usage: review_queue_pr_guard.sh --repo parent|api|web --pr <N>\n' >&2
  exit 1
}

GH_REPO="$(codex_review_resolve_gh_repo "$REPO_SLUG")" || {
  printf 'Error: invalid repo %s\n' "$REPO_SLUG" >&2
  exit 1
}

QFILE="$PRIMARY/strategy/workspace/review.queue"
REVIEW_KEY="${REPO_SLUG}-${PR_NUM}"

QUEUE_STATE="ABSENT"
if [[ -f "$QFILE" ]] && grep -q "^${REVIEW_KEY}|" "$QFILE" 2>/dev/null; then
  QUEUE_STATE="$(grep "^${REVIEW_KEY}|" "$QFILE" | tail -1 | cut -d'|' -f6)"
fi

PR_JSON="$(gh pr view "$PR_NUM" --repo "$GH_REPO" --json state,mergedAt,labels 2>/dev/null || echo '{}')"
PR_STATE="$(printf '%s' "$PR_JSON" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("state","UNKNOWN"))' 2>/dev/null || echo UNKNOWN)"
MERGED_AT="$(printf '%s' "$PR_JSON" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("mergedAt") or "")' 2>/dev/null || true)"

HAS_LABEL=0
if codex_review_has_pending_label "$REPO_SLUG" "$PR_NUM"; then
  HAS_LABEL=1
fi

STATUS="SYNCED"
DETAIL="queue=${QUEUE_STATE} pr_state=${PR_STATE} label=${HAS_LABEL}"

if [[ "$PR_STATE" == "MERGED" ]]; then
  if [[ "$QUEUE_STATE" == "PENDING" || "$QUEUE_STATE" == "CLAIMED" ]]; then
    STATUS="DESYNC"
    DETAIL="P7-class: merged while review.queue still ${QUEUE_STATE}"
  else
    STATUS="ALREADY_MERGED"
    DETAIL="merged; queue=${QUEUE_STATE}"
  fi
elif [[ "$QUEUE_STATE" == "PENDING" || "$QUEUE_STATE" == "CLAIMED" ]]; then
  if [[ "$HAS_LABEL" -eq 0 ]]; then
    STATUS="LABEL_MISSING"
    DETAIL="review.queue ${QUEUE_STATE} but GitHub label absent"
  else
    STATUS="SYNCED"
    DETAIL="review.queue ${QUEUE_STATE} and label present"
  fi
elif [[ "$QUEUE_STATE" == "ABSENT" && "$HAS_LABEL" -eq 1 ]]; then
  STATUS="DESYNC"
  DETAIL="label present but no review.queue entry"
elif [[ "$QUEUE_STATE" == "ABSENT" ]]; then
  STATUS="NOT_IN_QUEUE"
  DETAIL="no review.queue entry"
fi

printf 'STATUS: %s\n' "$STATUS"
printf 'DETAIL: %s\n' "$DETAIL"
printf 'REVIEW_KEY: %s\n' "$REVIEW_KEY"

case "$STATUS" in
  SYNCED|ALREADY_MERGED|NOT_IN_QUEUE) exit 0 ;;
  *) exit 1 ;;
esac
