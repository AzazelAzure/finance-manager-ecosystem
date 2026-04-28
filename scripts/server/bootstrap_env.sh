#!/usr/bin/env bash
# Prepare and validate server environment files (no secrets committed).
# Use --validate-only to only check required variables in an env file.

set -euo pipefail

SERVER_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SERVER_SCRIPT_DIR}/lib/common.sh"

DEFAULT_ENV="${REPO_ROOT}/deploy/server.env"
FM_SERVER_ENV_FILE="${FM_SERVER_ENV_FILE:-$DEFAULT_ENV}"
EXAMPLE="${REPO_ROOT}/deploy/server.env.example"

usage() {
  cat <<EOF
Usage:
  bootstrap_env.sh [--dry-run] [--from-example] [--validate-only]

  --from-example     Copy ${EXAMPLE} to FM_SERVER_ENV_FILE if missing.
  --validate-only    Only load FM_SERVER_ENV_FILE and check required keys (no writes).

  Environment:
    FM_WORKSPACE / FM_WORKSPACE_ROOT   Optional absolute path to repo root.
    FM_SERVER_ENV_FILE  Target env file (default: ${DEFAULT_ENV})

  Does not create real secret values; --from-example copies the template only.
EOF
}

FROM_EXAMPLE=0
VALIDATE_ONLY=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) FM_DRY_RUN=1; shift ;;
    --from-example) FROM_EXAMPLE=1; shift ;;
    --validate-only) VALIDATE_ONLY=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) fm_die "unknown argument: $1" ;;
  esac
done

REQUIRED_KEYS=(
  SECRET_KEY
  DB_NAME
  DB_USER
  DB_PASSWORD
  DB_HOST
  ALLOWED_HOSTS
  CSRF_TRUSTED_ORIGINS
  FM_ACTIVE_COLOR
)

load_env_file() {
  local f="$1"
  [[ -f "$f" ]] || fm_die "env file not found: $f"
  set -a
  # shellcheck disable=SC1090
  source "$f"
  set +a
}

validate_loaded_env() {
  local k missing=0
  for k in "${REQUIRED_KEYS[@]}"; do
    local v="${!k:-}"
    if [[ -z "$v" ]]; then
      fm_log "missing or empty: $k"
      missing=1
    elif [[ "$v" == *"CHANGE_ME"* || "$v" == *"replace-me"* || "$v" == *"changeme"* ]]; then
      fm_log "placeholder value (set a real value): $k"
      missing=1
    else
      fm_log "ok: $k is set"
    fi
  done
  return "$missing"
}

if [[ ! -f "$EXAMPLE" ]]; then
  fm_die "template missing: $EXAMPLE"
fi

if [[ "$FROM_EXAMPLE" -eq 1 ]]; then
  if [[ -f "$FM_SERVER_ENV_FILE" ]]; then
    fm_log "env file already exists, not overwriting: $FM_SERVER_ENV_FILE"
  else
    if fm_is_dry_run; then
      fm_log "dry-run: would copy $EXAMPLE -> $FM_SERVER_ENV_FILE"
    else
      mkdir -p "$(dirname "$FM_SERVER_ENV_FILE")"
      cp -a "$EXAMPLE" "$FM_SERVER_ENV_FILE"
      chmod 0600 "$FM_SERVER_ENV_FILE" 2>/dev/null || true
      fm_log "created $FM_SERVER_ENV_FILE from example (edit and fill secrets)."
    fi
  fi
fi

if [[ "$VALIDATE_ONLY" -eq 1 ]]; then
  load_env_file "$FM_SERVER_ENV_FILE"
  if validate_loaded_env; then
    fm_log "validation passed: $FM_SERVER_ENV_FILE"
    exit 0
  fi
  fm_die "validation failed: $FM_SERVER_ENV_FILE"
fi

fm_log "bootstrap_env: noop unless --from-example or --validate-only."
fm_log "Example: FM_SERVER_ENV_FILE=$FM_SERVER_ENV_FILE $0 --validate-only"
exit 0
