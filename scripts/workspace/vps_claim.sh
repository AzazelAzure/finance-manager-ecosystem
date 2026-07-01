#!/usr/bin/env bash
# Claim VPS deploy authority in the sign-out sheet.
# HARD BLOCK — always fails if VPS is already held by another workspace.
# No --force override for VPS (per D-WS-05 / D-WS-09).
#
# Usage:
#   vps_claim.sh <workspace> <operation> [api_sha] [web_sha] [color]
#
# Example:
#   vps_claim.sh WS1 promote-green 4a29bde 07f97ca green

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

if [[ $# -lt 2 ]]; then
  printf 'Usage: vps_claim.sh <workspace> <operation> [api_sha] [web_sha] [color]\n' >&2
  exit 1
fi

WS="$1"; OPERATION="$2"
API_SHA="${3:-null}"; WEB_SHA="${4:-null}"; COLOR="${5:-null}"
CLAIMED_AT="$(date -u +%Y-%m-%dT%H:%M)"

vps_line=$(grep "^vps:" "$LOCKFILE" 2>/dev/null || true)
if [[ -z "$vps_line" ]]; then
  printf 'Error: vps entry not found in lockfile.\n' >&2; exit 1
fi

current_status=$(printf '%s' "$vps_line" | cut -d: -f2)
current_holder=$(printf '%s' "$vps_line" | cut -d: -f3)

if [[ "$current_status" == "ACTIVE" && "$current_holder" != "null" && "$current_holder" != "" ]]; then
  printf 'Error: VPS is already held by %s. Run vps_release.sh %s before claiming.\n' \
    "$current_holder" "$current_holder" >&2
  exit 1
fi

tmpfile=$(mktemp)
sed "s|^vps:.*|vps:ACTIVE:${WS}:${OPERATION}:${API_SHA}:${WEB_SHA}:${COLOR}:${CLAIMED_AT}|" \
  "$LOCKFILE" > "$tmpfile"
mv "$tmpfile" "$LOCKFILE"

printf 'VPS claimed: holder=%s operation=%s api=%s web=%s color=%s at=%s\n' \
  "$WS" "$OPERATION" "$API_SHA" "$WEB_SHA" "$COLOR" "$CLAIMED_AT"
