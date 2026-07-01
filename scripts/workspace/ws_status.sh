#!/usr/bin/env bash
# Print current workspace and VPS state from the sign-out sheet.
# Read-only. Safe to call from any workspace.
#
# Usage:
#   ws_status.sh             # full table
#   ws_status.sh --vps       # VPS line only
#   ws_status.sh --ws <id>   # single workspace line

set -euo pipefail

# ── resolve primary workspace ──────────────────────────────────────────────────
if [[ -z "${FM_PRIMARY_WORKSPACE:-}" ]]; then
  [[ -f "$HOME/.fm_workspace.conf" ]] && source "$HOME/.fm_workspace.conf"
fi
PRIMARY="${FM_PRIMARY_WORKSPACE:-}"
if [[ -z "$PRIMARY" ]]; then
  printf 'Error: FM_PRIMARY_WORKSPACE not set. Source ~/.fm_workspace.conf or set it in the environment.\n' >&2
  exit 1
fi

LOCKFILE="$PRIMARY/strategy/workspace/workspace.lock"

if [[ ! -f "$LOCKFILE" ]]; then
  printf 'Error: workspace.lock not found: %s\n' "$LOCKFILE" >&2
  exit 1
fi

# ── helpers ────────────────────────────────────────────────────────────────────
print_ws_table() {
  printf '%-12s  %-7s  %-14s  %-28s  %s\n' "WORKSPACE" "STATUS" "AGENT" "TASK" "BRANCH"
  printf '%-12s  %-7s  %-14s  %-28s  %s\n' "─────────" "──────" "─────" "────" "──────"
  while IFS=: read -r id status agent task branch; do
    [[ "$id" == \#* || -z "$id" ]] && continue
    [[ "$id" == "vps" ]] && continue
    printf '%-12s  %-7s  %-14s  %-28s  %s\n' "$id" "${status:--}" "${agent:--}" "${task:--}" "${branch:--}"
  done < "$LOCKFILE"
}

print_vps_line() {
  while IFS=: read -r id status holder operation api_sha web_sha color claimed_at; do
    [[ "$id" != "vps" ]] && continue
    printf '%-12s  %-7s  %-14s  %-18s  api:%-10s  web:%-10s  color:%-6s  claimed:%s\n' \
      "vps" "${status:--}" "${holder:--}" "${operation:--}" \
      "${api_sha:--}" "${web_sha:--}" "${color:--}" "${claimed_at:--}"
  done < "$LOCKFILE"
}

# ── parse args ─────────────────────────────────────────────────────────────────
VPS_ONLY=0
WS_FILTER=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --vps) VPS_ONLY=1; shift ;;
    --ws) WS_FILTER="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'
      exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; exit 1 ;;
  esac
done

# ── output ─────────────────────────────────────────────────────────────────────
if [[ "$VPS_ONLY" -eq 1 ]]; then
  print_vps_line
elif [[ -n "$WS_FILTER" ]]; then
  grep "^${WS_FILTER}:" "$LOCKFILE" || printf 'Workspace %s not found in lockfile.\n' "$WS_FILTER" >&2
else
  print_ws_table
  printf '\n'
  print_vps_line
fi
