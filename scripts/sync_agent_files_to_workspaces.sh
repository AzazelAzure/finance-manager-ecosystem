#!/usr/bin/env bash
# Mirror gitignored agent / governance files from the primary checkout into
# agent workspace clones. These paths are not on GitHub after the scrub, so
# `git clone` + `git pull` will not deliver them.
#
# Source of truth: primary workspace (default ~/Hive_Financial_Manager/HFM).
#
# Environment:
#   FM_PRIMARY_WORKSPACE     — primary repo root (default below)
#   FM_AGENT_WORKSPACES_ROOT — parent of WS1/WS2/WS3 (default ~/Hive_Financial_Manager)
#
# Usage:
#   ./scripts/sync_agent_files_to_workspaces.sh              # all known workspaces
#   ./scripts/sync_agent_files_to_workspaces.sh WS1
#   ./scripts/sync_agent_files_to_workspaces.sh --dry-run
#   ./scripts/sync_agent_files_to_workspaces.sh --list
#   # Legacy names (pre-migration): cursor-executor → WS1, etc.
#
# Bundled paths (from primary → each target):
#   AGENTS.md, GEMINI.md, CLAUDE.md
#   .cursorignore, .antigravityignore
#   .cursor/  (rules, skills, settings, hooks/state)
#   .claude/
#   governance/coordination/HITM_SCHEDULE_SNAPSHOT.md
#   strategy/   (gitignored — full tree, --delete on target)
#   plans/        (gitignored — full tree, --delete on target)
#
# Not copied: .env, .secrets/, certs, logs, Slack bridge runtime, venvs.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HFM_ROOT="${FM_AGENT_WORKSPACES_ROOT:-$HOME/Hive_Financial_Manager}"
SRC="${FM_PRIMARY_WORKSPACE:-$HFM_ROOT/HFM}"

# workspace key -> directory name under HFM_ROOT (ecosystem clone root)
declare -A WORKSPACES=(
  [WS1]="WS1"
  [WS2]="WS2"
  [WS3]="WS3"
)

# Legacy aliases (old agent-workspaces naming)
declare -A WORKSPACE_ALIASES=(
  [cursor-executor]=WS1
  [antigravity-executor]=WS2
  [antigravity-reviewer]=WS3
)

DRY_RUN=0
SELECTED=()

usage() {
  sed -n '2,28p' "$0" | sed 's/^# \{0,1\}//'
  printf '\nKnown workspace keys: %s\n' "${!WORKSPACES[*]}"
}

require_cmd() {
  if ! command -v "$1" &>/dev/null; then
    printf 'Error: required command %q not in PATH.\n' "$1" >&2
    exit 1
  fi
}

run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    printf '[dry-run]'; printf ' %q' "$@"; printf '\n'
  else
    "$@"
  fi
}

resolve_workspace_key() {
  local key="$1"
  if [[ -n "${WORKSPACES[$key]+x}" ]]; then
    printf '%s' "$key"
    return 0
  fi
  if [[ -n "${WORKSPACE_ALIASES[$key]+x}" ]]; then
    printf '%s' "${WORKSPACE_ALIASES[$key]}"
    return 0
  fi
  return 1
}

sync_one() {
  local name="$1"
  local dir="${WORKSPACES[$name]}"
  local dst="${HFM_ROOT}/${dir}"

  if [[ ! -d "$dst" ]]; then
    printf 'Skip %s: target not found: %s\n' "$name" "$dst" >&2
    return 1
  fi

  printf '==> %s (%s)\n' "$name" "$dst"

  run mkdir -p "$dst/governance" "$dst/.cursor/hooks/state" "$dst/.claude"

  run cp -p \
    "$SRC/AGENTS.md" \
    "$SRC/GEMINI.md" \
    "$SRC/CLAUDE.md" \
    "$SRC/.cursorignore" \
    "$SRC/.antigravityignore" \
    "$dst/"

  if [[ -f "$SRC/governance/coordination/HITM_SCHEDULE_SNAPSHOT.md" ]]; then
    run cp -p "$SRC/governance/coordination/HITM_SCHEDULE_SNAPSHOT.md" "$dst/governance/"
  else
    printf '  warn: missing %s/governance/coordination/HITM_SCHEDULE_SNAPSHOT.md (run schedule_agent_sync.sh?)\n' "$SRC" >&2
  fi

  run rsync -a "${DRY_RUN:+--dry-run}" --delete "$SRC/.cursor/" "$dst/.cursor/"
  run rsync -a "${DRY_RUN:+--dry-run}" "$SRC/.claude/" "$dst/.claude/"

  if [[ -d "$SRC/strategy" ]]; then
    run mkdir -p "$dst/strategy"
    run rsync -a "${DRY_RUN:+--dry-run}" --delete "$SRC/strategy/" "$dst/strategy/"
  else
    printf '  warn: missing %s/strategy/\n' "$SRC" >&2
  fi

  if [[ -d "$SRC/plans" ]]; then
    run mkdir -p "$dst/plans"
    run rsync -a "${DRY_RUN:+--dry-run}" --delete "$SRC/plans/" "$dst/plans/"
  else
    printf '  warn: missing %s/plans/\n' "$SRC" >&2
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    -n|--dry-run)
      DRY_RUN=1
      shift
      ;;
    -l|--list)
      for k in "${!WORKSPACES[@]}"; do
        printf '%s\t%s/%s\n' "$k" "$HFM_ROOT" "${WORKSPACES[$k]}"
      done
      exit 0
      ;;
    -*)
      printf 'Unknown option: %s\n' "$1" >&2
      usage >&2
      exit 1
      ;;
    *)
      resolved="$(resolve_workspace_key "$1" || true)"
      if [[ -z "$resolved" ]]; then
        printf 'Unknown workspace %q. Known: %s (aliases: %s)\n' \
          "$1" "${!WORKSPACES[*]}" "${!WORKSPACE_ALIASES[*]}" >&2
        exit 1
      fi
      SELECTED+=("$resolved")
      shift
      ;;
  esac
done

require_cmd rsync
require_cmd cp

if [[ ! -d "$SRC" ]]; then
  printf 'Error: primary workspace not found: %s\n' "$SRC" >&2
  exit 1
fi

if [[ ${#SELECTED[@]} -eq 0 ]]; then
  SELECTED=("${!WORKSPACES[@]}")
fi

fail=0
for name in "${SELECTED[@]}"; do
  sync_one "$name" || fail=1
done

if [[ "$DRY_RUN" -eq 1 ]]; then
  printf '\nDry run complete (no files changed).\n'
elif [[ "$fail" -eq 0 ]]; then
  printf '\nSync complete. Source: %s\n' "$SRC"
else
  printf '\nSync finished with skipped targets.\n' >&2
  exit 1
fi
