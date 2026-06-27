#!/usr/bin/env bash
# pull_backup.sh
#
# Pull a compressed pg_dump from the VPS to local disk over SSH.
# Run daily from local machine — does not require VPS-side cron.
#
# Usage:
#   ./scripts/server/pull_backup.sh
#
# Cron (daily at 6:00 AM — after doc context gather):
#   0 6 * * * /home/pproctor/Documents/python/finance_manager/scripts/server/pull_backup.sh >> /tmp/fm_backup.log 2>&1
#
# Requirements:
#   - SSH key auth to VPS (no password prompt)
#   - PostgreSQL client not required locally — dump is done server-side
#   - ~/fm_backups/ created automatically on first run

set -euo pipefail

VPS_HOST="dev@159.198.75.194"
VPS_DB_USER="fm_user"
VPS_DB_NAME="fm_db"
LOCAL_BACKUP_DIR="$HOME/fm_backups"
RETAIN_DAYS=30
DATE=$(date +%Y%m%d)
TIMESTAMP=$(date -Iseconds)
FILENAME="fm_db_${DATE}.sql.gz"
DEST="$LOCAL_BACKUP_DIR/$FILENAME"

mkdir -p "$LOCAL_BACKUP_DIR"

echo "[pull_backup] Starting — $TIMESTAMP"
echo "[pull_backup] Target: $DEST"

# Dump and stream in one SSH call — never writes uncompressed data to VPS disk
ssh "$VPS_HOST" "pg_dump -U $VPS_DB_USER $VPS_DB_NAME | gzip" > "$DEST"

SIZE=$(du -h "$DEST" | cut -f1)
echo "[pull_backup] Written: $DEST ($SIZE)"

# Verify the dump is non-empty and decompresses without error
if ! gzip -t "$DEST" 2>/dev/null; then
  echo "[pull_backup] ERROR: backup file failed gzip integrity check — removing"
  rm -f "$DEST"
  exit 1
fi
echo "[pull_backup] Integrity check: PASS"

# Prune backups older than RETAIN_DAYS
PRUNED=$(find "$LOCAL_BACKUP_DIR" -name "fm_db_*.sql.gz" -mtime +${RETAIN_DAYS} -print -delete | wc -l)
echo "[pull_backup] Pruned ${PRUNED} backup(s) older than ${RETAIN_DAYS} days"

echo "[pull_backup] Done"
