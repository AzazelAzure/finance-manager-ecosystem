#!/usr/bin/env bash
# Create, upload, and extract a lean runtime bundle on a remote VPS over SSH.

set -euo pipefail

SERVER_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SERVER_SCRIPT_DIR}/lib/common.sh"

usage() {
  cat <<'EOF'
Usage:
  push_runtime_bundle.sh --host HOST [options]

Required:
  --host HOST              Remote VPS host/IP.

Optional:
  --user USER              SSH user (default: root)
  --port PORT              SSH port (default: 22)
  --identity FILE          SSH private key path
  --remote-dir DIR         Remote install dir (default: /opt/finance_manager)
  --output-dir DIR         Local bundle output dir (default: <repo>/dist/runtime)
  --bundle-name NAME       Bundle name override (without .tar.gz)
  --no-build               Reuse existing local bundle (requires --bundle-name)
  --dry-run                Print actions only (no remote changes)

Behavior:
  1) Builds runtime bundle via scripts/server/create_runtime_bundle.sh (unless --no-build).
  2) Uploads bundle to remote /tmp.
  3) Extracts bundle into --remote-dir and removes uploaded tarball.

Notes:
  - Git auth is NOT required on VPS for this bundle workflow.
  - Ubuntu is supported; this script only needs ssh/scp/tar on remote host.
EOF
}

HOST=""
SSH_USER="root"
SSH_PORT="22"
SSH_IDENTITY=""
REMOTE_DIR="/opt/finance_manager"
OUTPUT_DIR="${REPO_ROOT}/dist/runtime"
BUNDLE_NAME=""
NO_BUILD=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --host) HOST="$2"; shift 2 ;;
    --user) SSH_USER="$2"; shift 2 ;;
    --port) SSH_PORT="$2"; shift 2 ;;
    --identity) SSH_IDENTITY="$2"; shift 2 ;;
    --remote-dir) REMOTE_DIR="$2"; shift 2 ;;
    --output-dir) OUTPUT_DIR="$2"; shift 2 ;;
    --bundle-name) BUNDLE_NAME="$2"; shift 2 ;;
    --no-build) NO_BUILD=1; shift ;;
    --dry-run) FM_DRY_RUN=1; shift ;;
    -h|--help) usage; exit 0 ;;
    *) fm_die "unknown argument: $1" ;;
  esac
done

[[ -n "$HOST" ]] || fm_die "--host is required"

if [[ "$NO_BUILD" -eq 1 && -z "$BUNDLE_NAME" ]]; then
  fm_die "--no-build requires --bundle-name"
fi

if [[ -z "$BUNDLE_NAME" ]]; then
  BUNDLE_NAME="finance_manager_runtime_$(date +%Y%m%d_%H%M%S)"
fi

LOCAL_BUNDLE="${OUTPUT_DIR}/${BUNDLE_NAME}.tar.gz"
REMOTE_BUNDLE="/tmp/${BUNDLE_NAME}.tar.gz"
SSH_TARGET="${SSH_USER}@${HOST}"

SSH_OPTS=(-p "$SSH_PORT" -o StrictHostKeyChecking=accept-new)
if [[ -n "$SSH_IDENTITY" ]]; then
  SSH_OPTS+=(-i "$SSH_IDENTITY")
fi
SCP_OPTS=(-P "$SSH_PORT" -o StrictHostKeyChecking=accept-new)
if [[ -n "$SSH_IDENTITY" ]]; then
  SCP_OPTS+=(-i "$SSH_IDENTITY")
fi

if [[ "$NO_BUILD" -eq 0 ]]; then
  BUILD_CMD=(./scripts/server/create_runtime_bundle.sh --output-dir "$OUTPUT_DIR" --bundle-name "$BUNDLE_NAME")
  if fm_is_dry_run; then
    BUILD_CMD+=(--dry-run)
  fi
  fm_log "building runtime bundle: ${BUNDLE_NAME}"
  "${BUILD_CMD[@]}"
fi

if fm_is_dry_run; then
  fm_log "dry-run: would upload ${LOCAL_BUNDLE} -> ${SSH_TARGET}:${REMOTE_BUNDLE}"
  fm_log "dry-run: would extract to ${REMOTE_DIR} on remote host"
  exit 0
fi

[[ -f "$LOCAL_BUNDLE" ]] || fm_die "bundle not found: $LOCAL_BUNDLE"

fm_log "uploading bundle to ${SSH_TARGET}:${REMOTE_BUNDLE}"
scp "${SCP_OPTS[@]}" "$LOCAL_BUNDLE" "${SSH_TARGET}:${REMOTE_BUNDLE}"

fm_log "extracting bundle on remote host into ${REMOTE_DIR}"
ssh "${SSH_OPTS[@]}" "$SSH_TARGET" "set -euo pipefail; mkdir -p '$REMOTE_DIR'; tar -xzf '$REMOTE_BUNDLE' -C '$REMOTE_DIR'; rm -f '$REMOTE_BUNDLE'; echo 'bundle extracted to $REMOTE_DIR'"

fm_log "verifying release manifest on remote host"
ssh "${SSH_OPTS[@]}" "$SSH_TARGET" "set -euo pipefail; cd '$REMOTE_DIR'; bash ./scripts/server/verify_release_manifest.sh --path '$REMOTE_DIR/RELEASE_MANIFEST.txt'"

fm_log "runtime bundle push complete"
