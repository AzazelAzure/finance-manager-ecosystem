#!/usr/bin/env bash
# Release a workspace claim in the sign-out sheet.
#
# Usage:
#   ws_release.sh <workspace>

set -euo pipefail

if [[ -z "${FM_PRIMARY_WORKSPACE:-}" ]]; then
  [[ -f "$HOME/.fm_workspace.conf" ]] && source "$HOME/.fm_workspace.conf"
fi
PRIMARY="${FM_PRIMARY_WORKSPACE:-}"
if [[ -z "$PRIMARY" ]]; then
  printf 'Error: FM_PRIMARY_WORKSPACE not set.\n' >&2; exit 1
fi

LOCKFILE="$PRIMARY/strategy/workspace/workspace.lock"
[[ ! -f "$LOCKFILE" ]] && { printf 'Error: workspace.lock not found: %s\n' "$LOCKFILE" >&2; exit 1; }

if [[ $# -lt 1 ]]; then
  printf 'Usage: ws_release.sh <workspace>\n' >&2; exit 1
fi
WS="$1"

WLOCK="${LOCKFILE}.lock"
(
  flock -x 9

  existing=$(grep "^${WS}:" "$LOCKFILE" 2>/dev/null || true)
  if [[ -z "$existing" ]]; then
    printf 'Error: workspace %q not found in lockfile.\n' "$WS" >&2; exit 1
  fi

  tmpfile=$(mktemp)
  sed "s|^${WS}:.*|${WS}:IDLE:::|" "$LOCKFILE" > "$tmpfile"
  mv "$tmpfile" "$LOCKFILE"

  printf 'Released: %s → IDLE\n' "$WS"

) 9>"$WLOCK"
