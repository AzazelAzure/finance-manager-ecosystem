#!/usr/bin/env bash
# Mark a review queue entry DONE or FAILED.
#
# Usage:
#   review_done.sh <review_key>
#   review_done.sh <review_key> --failed
#
# review_key format: <target_repo>-<pr_number> (e.g. parent-99, api-74)

set -euo pipefail

if [[ -z "${FM_PRIMARY_WORKSPACE:-}" ]]; then
  [[ -f "$HOME/.fm_workspace.conf" ]] && source "$HOME/.fm_workspace.conf"
fi
PRIMARY="${FM_PRIMARY_WORKSPACE:-}"
if [[ -z "$PRIMARY" ]]; then
  printf 'Error: FM_PRIMARY_WORKSPACE not set.\n' >&2; exit 1
fi

if [[ $# -lt 1 ]]; then
  printf 'Usage: review_done.sh <review_key> [--failed]\n' >&2; exit 1
fi

REVIEW_KEY="$1"
FINAL_STATUS="DONE"
[[ "${2:-}" == "--failed" ]] && FINAL_STATUS="FAILED"

QFILE="$PRIMARY/strategy/workspace/review.queue"
[[ ! -f "$QFILE" ]] && { printf 'Error: review queue file not found: %s\n' "$QFILE" >&2; exit 1; }

QLOCK="${QFILE}.lock"
(
  flock -x 9

  if ! grep -q "^${REVIEW_KEY}|" "$QFILE" 2>/dev/null; then
    printf 'Error: review_key %q not found in review.queue.\n' "$REVIEW_KEY" >&2; exit 1
  fi

  RELEASED_AT="$(date -u +%Y-%m-%dT%H:%M)"

  tmpfile=$(mktemp)
  awk -F'|' -v key="$REVIEW_KEY" -v status="$FINAL_STATUS" -v ts="$RELEASED_AT" \
    'BEGIN{OFS="|"}
    /^#/ || /^$/ { print; next }
    $1 == key { $6=status; $9=ts; print; next }
    { print }
  ' "$QFILE" > "$tmpfile"
  mv "$tmpfile" "$QFILE"

  printf '%s: %s in review.queue at %s\n' "$FINAL_STATUS" "$REVIEW_KEY" "$RELEASED_AT"

) 9>"$QLOCK"
