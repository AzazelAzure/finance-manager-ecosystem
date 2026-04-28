#!/usr/bin/env bash
# Render deploy/server.env.example into a generated path using envsubst when available.

set -euo pipefail

SERVER_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SERVER_SCRIPT_DIR}/lib/common.sh"

TEMPLATE="${FM_ENV_TEMPLATE:-${REPO_ROOT}/deploy/server.env.example}"
OUT="${FM_RENDER_OUT:-${REPO_ROOT}/deploy/generated/server.env}"

usage() {
  cat <<EOF
Usage: render_env_template.sh [--dry-run]

  Reads template: ${TEMPLATE}
  Writes:          ${OUT} (unless --dry-run)

  If envsubst exists, substitutes \${VAR} using current exported environment.
  Otherwise copies the template and prints a warning (fill manually).

  Environment:
    FM_WORKSPACE / FM_WORKSPACE_ROOT  Optional repo root.
    FM_ENV_TEMPLATE    Override template path.
    FM_RENDER_OUT      Override output path.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ "${1:-}" == "--dry-run" ]]; then
  FM_DRY_RUN=1
fi

[[ -f "$TEMPLATE" ]] || fm_die "template not found: $TEMPLATE"

render_with_envsubst() {
  mkdir -p "$(dirname "$OUT")"
  umask 077
  envsubst < "$TEMPLATE" > "$OUT.tmp"
  mv "$OUT.tmp" "$OUT"
  chmod 0600 "$OUT"
}

simple_copy() {
  mkdir -p "$(dirname "$OUT")"
  cp -a "$TEMPLATE" "$OUT"
  chmod 0600 "$OUT"
}

fm_log "repo root: ${REPO_ROOT}"
if fm_is_dry_run; then
  fm_log "dry-run: would render '$TEMPLATE' -> '$OUT'"
  exit 0
fi

if command -v envsubst &>/dev/null; then
  fm_log "using envsubst"
  render_with_envsubst
else
  fm_log "warning: envsubst not found; copying template without substitution."
  simple_copy
fi

fm_log "wrote $OUT"
