#!/usr/bin/env bash
# Build a lean server runtime bundle for VPS migration/deploy.
# Includes only production service pipeline assets (api/reflex/proxy/compose/scripts/deploy template).

set -euo pipefail

SERVER_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SERVER_SCRIPT_DIR}/lib/common.sh"

usage() {
  cat <<'EOF'
Usage:
  create_runtime_bundle.sh [--dry-run] [--output-dir DIR] [--bundle-name NAME]

Creates:
  <output-dir>/<bundle-name>.tar.gz

Default output:
  <repo-root>/dist/runtime

Bundle content (lean runtime only):
  - docker-compose.yml
  - docker-compose.bluegreen.yml
  - proxy/
  - deploy/server.env.example
  - scripts/fm_docker.sh
  - scripts/fm_server_beta.sh
  - scripts/server/
  - finance_manager_api/
  - finance_manager_reflex/

Notes:
  - Excludes docs, git metadata, local caches, SQLite/db dumps, node/venv artifacts.
  - Designed for VPS service runtime migration, not developer workspace parity.
EOF
}

OUTPUT_DIR="${REPO_ROOT}/dist/runtime"
BUNDLE_NAME="finance_manager_runtime_$(date +%Y%m%d_%H%M%S)"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) FM_DRY_RUN=1; shift ;;
    --output-dir) OUTPUT_DIR="$2"; shift 2 ;;
    --bundle-name) BUNDLE_NAME="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) fm_die "unknown argument: $1" ;;
  esac
done

STAGE_DIR="${OUTPUT_DIR}/.stage_${BUNDLE_NAME}"
TARBALL_PATH="${OUTPUT_DIR}/${BUNDLE_NAME}.tar.gz"

RSYNC_EXCLUDES=(
  "--exclude=.git/"
  "--exclude=.cursor/"
  "--exclude=__pycache__/"
  "--exclude=*.pyc"
  "--exclude=.pytest_cache/"
  "--exclude=.mypy_cache/"
  "--exclude=.ruff_cache/"
  "--exclude=.venv/"
  "--exclude=node_modules/"
  "--exclude=.reflex/"
  "--exclude=.secrets/"
  "--exclude=.env"
  "--exclude=.env.*"
  "--exclude=db.sqlite3"
  "--exclude=*.sqlite3"
  "--exclude=*.log"
  "--exclude=dist/"
  "--exclude=build/"
)

copy_path() {
  local src_rel="$1"
  local dst_rel="$2"
  local src_abs="${REPO_ROOT}/${src_rel}"
  local dst_abs="${STAGE_DIR}/${dst_rel}"

  [[ -e "$src_abs" ]] || fm_die "missing required path: ${src_rel}"

  if fm_is_dry_run; then
    fm_log "dry-run: would copy ${src_rel} -> ${dst_rel}"
    return
  fi

  mkdir -p "$(dirname "$dst_abs")"
  rsync -a "${RSYNC_EXCLUDES[@]}" "$src_abs" "$dst_abs"
}

git_value_or_unknown() {
  local cmd="$1"
  local val
  if val="$(bash -lc "$cmd" 2>/dev/null)"; then
    printf '%s' "$val"
  else
    printf 'unknown'
  fi
}

write_release_manifest() {
  local manifest_path="$1"
  local built_at branch commit_short commit_full dirty submodule_summary

  built_at="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  branch="$(git_value_or_unknown "git -C \"$REPO_ROOT\" rev-parse --abbrev-ref HEAD")"
  commit_short="$(git_value_or_unknown "git -C \"$REPO_ROOT\" rev-parse --short HEAD")"
  commit_full="$(git_value_or_unknown "git -C \"$REPO_ROOT\" rev-parse HEAD")"

  if git -C "$REPO_ROOT" diff --quiet --ignore-submodules=dirty && git -C "$REPO_ROOT" diff --cached --quiet --ignore-submodules=dirty; then
    dirty="false"
  else
    dirty="true"
  fi

  submodule_summary="$(git_value_or_unknown "git -C \"$REPO_ROOT\" submodule status --recursive")"

  cat > "$manifest_path" <<EOF
bundle_name=${BUNDLE_NAME}
built_at_utc=${built_at}
repo_root=${REPO_ROOT}
git_branch=${branch}
git_commit_short=${commit_short}
git_commit_full=${commit_full}
git_worktree_dirty=${dirty}
runtime_profile=service-only

[included_paths]
docker-compose.yml
docker-compose.bluegreen.yml
proxy/
deploy/server.env.example
scripts/fm_docker.sh
scripts/fm_server_beta.sh
scripts/server/
finance_manager_api/
finance_manager_reflex/

[submodule_status]
${submodule_summary}
EOF
}

fm_log "repo root: ${REPO_ROOT}"
fm_log "output dir: ${OUTPUT_DIR}"
fm_log "bundle name: ${BUNDLE_NAME}"

if fm_is_dry_run; then
  fm_log "dry-run: no files will be written"
else
  mkdir -p "$OUTPUT_DIR"
  rm -rf "$STAGE_DIR"
  mkdir -p "$STAGE_DIR"
fi

copy_path "docker-compose.yml" "docker-compose.yml"
copy_path "docker-compose.bluegreen.yml" "docker-compose.bluegreen.yml"
copy_path "proxy/" "proxy/"
copy_path "deploy/server.env.example" "deploy/server.env.example"
copy_path "scripts/fm_docker.sh" "scripts/fm_docker.sh"
copy_path "scripts/fm_server_beta.sh" "scripts/fm_server_beta.sh"
copy_path "scripts/server/" "scripts/server/"
copy_path "finance_manager_api/" "finance_manager_api/"
copy_path "finance_manager_reflex/" "finance_manager_reflex/"

if fm_is_dry_run; then
  fm_log "dry-run: would write RELEASE_MANIFEST.txt in bundle root"
else
  write_release_manifest "${STAGE_DIR}/RELEASE_MANIFEST.txt"
fi

if fm_is_dry_run; then
  fm_log "dry-run: would create tarball ${TARBALL_PATH}"
  exit 0
fi

tar -C "$STAGE_DIR" -czf "$TARBALL_PATH" .
rm -rf "$STAGE_DIR"

fm_log "runtime bundle created: ${TARBALL_PATH}"
