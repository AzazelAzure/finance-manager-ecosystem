#!/usr/bin/env bash
# Verify RELEASE_MANIFEST.txt exists and contains required metadata keys.

set -euo pipefail

SERVER_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SERVER_SCRIPT_DIR}/lib/common.sh"

usage() {
  cat <<'EOF'
Usage:
  verify_release_manifest.sh [--path FILE] [--dry-run]

Defaults:
  --path <repo-root>/RELEASE_MANIFEST.txt

Validates required keys:
  bundle_name
  built_at_utc
  git_branch
  git_commit_short
  git_commit_full
  git_worktree_dirty
  runtime_profile

Prints a concise identity summary suitable for deploy logs.
EOF
}

MANIFEST_PATH="${REPO_ROOT}/RELEASE_MANIFEST.txt"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --path) MANIFEST_PATH="$2"; shift 2 ;;
    --dry-run) FM_DRY_RUN=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) fm_die "unknown argument: $1" ;;
  esac
done

if fm_is_dry_run; then
  fm_log "dry-run: would validate manifest at ${MANIFEST_PATH}"
  exit 0
fi

[[ -f "$MANIFEST_PATH" ]] || fm_die "manifest not found: ${MANIFEST_PATH}"

required_keys=(
  bundle_name
  built_at_utc
  git_branch
  git_commit_short
  git_commit_full
  git_worktree_dirty
  runtime_profile
)

get_value() {
  local key="$1"
  local line
  line="$(awk -F= -v k="$key" '$1==k {print substr($0, index($0, "=")+1); exit}' "$MANIFEST_PATH")"
  printf '%s' "$line"
}

missing=0
for k in "${required_keys[@]}"; do
  v="$(get_value "$k")"
  if [[ -z "$v" ]]; then
    fm_log "missing key: $k"
    missing=1
  fi
done

[[ "$missing" -eq 0 ]] || fm_die "release manifest validation failed"

fm_log "release manifest: ok"
fm_log "  bundle: $(get_value bundle_name)"
fm_log "  built_at_utc: $(get_value built_at_utc)"
fm_log "  git_branch: $(get_value git_branch)"
fm_log "  git_commit_short: $(get_value git_commit_short)"
fm_log "  git_worktree_dirty: $(get_value git_worktree_dirty)"
fm_log "  runtime_profile: $(get_value runtime_profile)"
