#!/usr/bin/env bash
# Non-destructive checks that workspace layout matches server install assumptions.

set -euo pipefail

SERVER_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SERVER_SCRIPT_DIR}/lib/common.sh"

usage() {
  cat <<'EOF'
Usage: verify_install.sh [--dry-run]

  Verifies repo layout (compose file, submodule directories, scripts).
  Optional HTTP probes (disabled by default; no network unless enabled).

Environment:
  FM_WORKSPACE / FM_WORKSPACE_ROOT   Optional repo root.
  FM_VERIFY_HTTP      Set to 1 to curl FM_API_HEALTH_URL (default http://localhost:8000/api/health/).
  FM_API_HEALTH_URL   Override health URL for HTTP check.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ "${1:-}" == "--dry-run" ]]; then
  FM_DRY_RUN=1
fi

FM_API_HEALTH_URL="${FM_API_HEALTH_URL:-http://localhost:8000/api/health/}"

failures=0
check_file() {
  local p="$1"
  if [[ -f "$p" ]]; then
    fm_log "ok: file $p"
  else
    fm_log "missing file: $p"
    failures=$((failures + 1))
  fi
}

check_dir() {
  local p="$1"
  if [[ -d "$p" ]]; then
    fm_log "ok: directory $p"
  else
    fm_log "missing directory: $p"
    failures=$((failures + 1))
  fi
}

fm_log "repo root: ${REPO_ROOT}"
if fm_is_dry_run; then
  fm_log "dry-run: read-only filesystem checks below; HTTP probes skipped."
fi

check_file "${REPO_ROOT}/docker-compose.yml"
check_dir "${REPO_ROOT}/scripts"
check_dir "${REPO_ROOT}/scripts/server"
check_file "${REPO_ROOT}/scripts/server/create_runtime_bundle.sh"
check_file "${REPO_ROOT}/scripts/server/push_runtime_bundle.sh"
check_file "${REPO_ROOT}/scripts/server/verify_release_manifest.sh"
check_dir "${REPO_ROOT}/finance_manager_api"
check_dir "${REPO_ROOT}/finance_manager_web"
check_dir "${REPO_ROOT}/deploy"
check_file "${REPO_ROOT}/deploy/server.env.example"

if fm_is_dry_run; then
  fm_log "skipped HTTP check (dry-run)"
elif [[ "${FM_VERIFY_HTTP:-0}" == "1" ]]; then
  fm_log "HTTP check enabled: GET $FM_API_HEALTH_URL"
  if command -v curl &>/dev/null; then
    if curl -fsS "$FM_API_HEALTH_URL" >/dev/null; then
      fm_log "ok: HTTP health"
    else
      fm_log "HTTP health failed: $FM_API_HEALTH_URL"
      failures=$((failures + 1))
    fi
  else
    fm_log "curl missing; skipping HTTP check"
    failures=$((failures + 1))
  fi
else
  fm_log "skipped HTTP check (set FM_VERIFY_HTTP=1 to enable)"
fi

if [[ "$failures" -eq 0 ]]; then
  fm_log "verify_install: ok"
  exit 0
fi
fm_log "verify_install: failed ($failures issue(s))"
exit 1
