#!/usr/bin/env bash
# Check host prerequisites for Finance Manager server install (read-only / non-destructive).
# Does not install OS packages. Set FM_WORKSPACE_ROOT to override repo root.

set -euo pipefail

SERVER_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SERVER_SCRIPT_DIR}/lib/common.sh"

usage() {
  cat <<'EOF'
Usage: install_prereqs.sh [--dry-run]

  Verifies common tools exist (container runtime, compose, curl). Exits non-zero
  if required tools are missing. Does not modify the system.

  FM_WORKSPACE / FM_WORKSPACE_ROOT   Optional absolute path to ecosystem repo root.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ "${1:-}" == "--dry-run" ]]; then
  FM_DRY_RUN=1
fi

missing=()
need_cmd() {
  local name="$1"
  if command -v "$name" &>/dev/null; then
    fm_log "ok: found command '$name'"
  else
    missing+=("$name")
    fm_log "missing: command '$name'"
  fi
}

fm_log "repo root: ${REPO_ROOT}"
if fm_is_dry_run; then
  fm_log "(dry-run: checks only; no system changes)"
fi

need_cmd bash
if ((BASH_VERSINFO[0] < 4)); then
  fm_die "bash 4+ required (found ${BASH_VERSION})"
fi

have_compose=0
if command -v podman-compose &>/dev/null; then
  fm_log "ok: podman-compose available"
  have_compose=1
elif command -v docker-compose &>/dev/null; then
  fm_log "ok: docker-compose available"
  have_compose=1
elif docker compose version &>/dev/null 2>&1; then
  fm_log "ok: docker compose available"
  have_compose=1
fi
if [[ "$have_compose" -eq 0 ]]; then
  missing+=("compose (podman-compose, docker-compose, or docker compose)")
  fm_log "missing: compose provider"
fi

have_runtime=0
if command -v podman &>/dev/null; then
  fm_log "ok: podman $(podman --version 2>/dev/null | head -1)"
  have_runtime=1
fi
if command -v docker &>/dev/null; then
  fm_log "ok: docker $(docker --version 2>/dev/null | head -1)"
  have_runtime=1
fi
if [[ "$have_runtime" -eq 0 ]]; then
  missing+=("podman or docker")
  fm_log "missing: container runtime (podman or docker)"
fi

need_cmd curl

if [[ ${#missing[@]} -gt 0 ]]; then
  fm_log "prerequisite check failed:"
  for m in "${missing[@]}"; do
    fm_log "  - $m"
  done
  exit 1
fi

fm_log "prerequisite check passed."
