#!/usr/bin/env bash
# Release VPS deploy authority in the sign-out sheet.
#
# Usage:
#   vps_release.sh <workspace>

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
  printf 'Usage: vps_release.sh <workspace>\n' >&2; exit 1
fi
WS="$1"

vps_line=$(grep "^vps:" "$LOCKFILE" 2>/dev/null || true)
if [[ -z "$vps_line" ]]; then
  printf 'Error: vps entry not found in lockfile.\n' >&2; exit 1
fi

current_holder=$(printf '%s' "$vps_line" | cut -d: -f3)
if [[ "$current_holder" != "$WS" && "$current_holder" != "null" && "$current_holder" != "" ]]; then
  printf 'Warning: VPS is held by %s, not %s. Releasing anyway.\n' "$current_holder" "$WS" >&2
fi

tmpfile=$(mktemp)
sed 's|^vps:.*|vps:IDLE:null:null:null:null:null:null|' "$LOCKFILE" > "$tmpfile"
mv "$tmpfile" "$LOCKFILE"

printf 'VPS released by %s → IDLE\n' "$WS"
