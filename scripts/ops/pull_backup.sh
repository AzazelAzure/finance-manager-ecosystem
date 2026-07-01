#!/usr/bin/env bash
# pull_backup.sh
#
# Pull a compressed pg_dump from the VPS to local disk over SSH.
# Run daily from local machine — does not require VPS-side cron.
#
# Usage:
#   ./scripts/ops/pull_backup.sh
#
# Cron (daily at 6:00 AM — after doc context gather):
#   0 6 * * * ${REPO_ROOT}/scripts/ops/pull_backup.sh >> /tmp/fm_backup.log 2>&1
#
# Requirements:
#   - SSH key auth to VPS (no password prompt)
#   - PostgreSQL client not required locally — dump runs in VPS db container
#   - ~/fm_backups/ created automatically on first run
#
# Environment (repo-root .env allowlist or export):
#   FM_SPRINT_SSH, VPS_ORIGIN_IP, FM_BLUEGREEN_PROJECT (default: fm-beta)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
# shellcheck source=../lib/vps_env.sh
source "$REPO_ROOT/scripts/lib/vps_env.sh"

VPS_COMPOSE_PROJECT="${FM_BLUEGREEN_PROJECT:-fm-beta}"
LOCAL_BACKUP_DIR="$HOME/fm_backups"
RETAIN_DAYS=30
MIN_BACKUP_BYTES="${PULL_BACKUP_MIN_BYTES:-10240}"
DATE=$(date +%Y%m%d)
TIMESTAMP=$(date -Iseconds)
FILENAME="fm_db_${DATE}.sql.gz"
DEST="$LOCAL_BACKUP_DIR/$FILENAME"

mkdir -p "$LOCAL_BACKUP_DIR"

echo "[pull_backup] Starting — $TIMESTAMP"
echo "[pull_backup] Target: $DEST"
echo "[pull_backup] SSH: $VPS_SSH_TARGET"
echo "[pull_backup] Compose project: $VPS_COMPOSE_PROJECT"

# Dump via podman/docker exec inside the VPS db container (pg_dump is not on host PATH).
ssh "$VPS_SSH_TARGET" \
  env FM_BLUEGREEN_PROJECT="$VPS_COMPOSE_PROJECT" \
  bash -s <<'REMOTE_EOF' > "$DEST"
set -euo pipefail
PROJECT="${FM_BLUEGREEN_PROJECT:-fm-beta}"
RUNNER=""
if command -v podman >/dev/null 2>&1; then
  RUNNER=podman
elif command -v docker >/dev/null 2>&1; then
  RUNNER=docker
else
  echo "[pull_backup] ERROR: neither podman nor docker found on VPS" >&2
  exit 1
fi

DB_CONT="$("$RUNNER" ps --format '{{.Names}}' | grep -E "^${PROJECT}_db_" | head -1 || true)"
if [[ -z "$DB_CONT" ]]; then
  DB_CONT="$("$RUNNER" ps --format '{{.Names}}' | grep -E '_db_' | head -1 || true)"
fi
[[ -n "$DB_CONT" ]] || {
  echo "[pull_backup] ERROR: no db container found for project ${PROJECT}" >&2
  exit 1
}

echo "[pull_backup] Remote: ${RUNNER} exec ${DB_CONT}" >&2
"$RUNNER" exec "$DB_CONT" sh -c 'pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB" | gzip'
REMOTE_EOF

BYTES=$(wc -c < "$DEST" | tr -d ' ')
SIZE=$(du -h "$DEST" | cut -f1)
echo "[pull_backup] Written: $DEST ($SIZE, ${BYTES} bytes)"

if [[ "$BYTES" -lt "$MIN_BACKUP_BYTES" ]]; then
  echo "[pull_backup] ERROR: backup too small (${BYTES} bytes < ${MIN_BACKUP_BYTES}) — removing"
  rm -f "$DEST"
  exit 1
fi

if ! gzip -t "$DEST" 2>/dev/null; then
  echo "[pull_backup] ERROR: backup file failed gzip integrity check — removing"
  rm -f "$DEST"
  exit 1
fi

HEADER=$(gzip -dc "$DEST" 2>/dev/null | head -5 || true)
if ! grep -q 'PostgreSQL database dump' <<< "$HEADER"; then
  echo "[pull_backup] ERROR: missing pg_dump header — removing"
  rm -f "$DEST"
  exit 1
fi
echo "[pull_backup] Integrity check: PASS"

PRUNED=$(find "$LOCAL_BACKUP_DIR" -name "fm_db_*.sql.gz" -mtime +"${RETAIN_DAYS}" -print -delete | wc -l)
echo "[pull_backup] Pruned ${PRUNED} backup(s) older than ${RETAIN_DAYS} days"

echo "[pull_backup] Done"
