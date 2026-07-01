#!/usr/bin/env bash
# Register a workspace as active in the sign-out sheet.
# Advisory + non-blocking per D-WS-09: warns and exits 1 if already claimed;
# HitM can override with --force.
#
# Usage:
#   ws_claim.sh <workspace> <agent> <task> <branch>
#   ws_claim.sh --force <workspace> <agent> <task> <branch>

set -euo pipefail

# ── resolve primary workspace ──────────────────────────────────────────────────
if [[ -z "${FM_PRIMARY_WORKSPACE:-}" ]]; then
  [[ -f "$HOME/.fm_workspace.conf" ]] && source "$HOME/.fm_workspace.conf"
fi
PRIMARY="${FM_PRIMARY_WORKSPACE:-}"
if [[ -z "$PRIMARY" ]]; then
  printf 'Error: FM_PRIMARY_WORKSPACE not set.\n' >&2; exit 1
fi

LOCKFILE="$PRIMARY/strategy/workspace/workspace.lock"
[[ ! -f "$LOCKFILE" ]] && { printf 'Error: workspace.lock not found: %s\n' "$LOCKFILE" >&2; exit 1; }

# ── parse args ─────────────────────────────────────────────────────────────────
FORCE=0
if [[ "${1:-}" == "--force" ]]; then FORCE=1; shift; fi

if [[ $# -lt 4 ]]; then
  printf 'Usage: ws_claim.sh [--force] <workspace> <agent> <task> <branch>\n' >&2
  exit 1
fi

WS="$1"; AGENT="$2"; TASK="$3"; BRANCH="$4"

# ── check + write claim under exclusive lock ───────────────────────────────────
WLOCK="${LOCKFILE}.lock"
(
  flock -x 9

  existing=$(grep "^${WS}:" "$LOCKFILE" 2>/dev/null || true)
  if [[ -z "$existing" ]]; then
    printf 'Error: workspace %q not found in lockfile.\n' "$WS" >&2; exit 1
  fi

  current_status=$(printf '%s' "$existing" | cut -d: -f2)
  if [[ "$current_status" == "ACTIVE" && "$FORCE" -eq 0 ]]; then
    current_agent=$(printf '%s' "$existing" | cut -d: -f3)
    current_task=$(printf '%s' "$existing" | cut -d: -f4)
    printf 'Warning: %s is already claimed by %s for task "%s".\n' "$WS" "$current_agent" "$current_task" >&2
    printf 'Use --force to override, or run ws_release.sh %s first.\n' "$WS" >&2
    exit 1
  fi

  tmpfile=$(mktemp)
  sed "s|^${WS}:.*|${WS}:ACTIVE:${AGENT}:${TASK}:${BRANCH}|" "$LOCKFILE" > "$tmpfile"
  mv "$tmpfile" "$LOCKFILE"

  printf 'Claimed: %s → agent=%s task=%s branch=%s\n' "$WS" "$AGENT" "$TASK" "$BRANCH"

) 9>"$WLOCK"
