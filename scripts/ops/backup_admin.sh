#!/usr/bin/env bash
# backup_admin.sh — daily backup of gitignored admin/strategy content (LOCAL-ADMIN-BACKUP-T01)
#
# Backs up strategy/, governance/plans/, workspace queues, and agent skills — content that
# does not live in git history. Complements scripts/ops/pull_backup.sh (VPS database).
#
# Usage:
#   ./scripts/ops/backup_admin.sh
#
# Destination: ~/fm_admin_backups/fm_admin_YYYY-MM-DD_HHMMSS.tar.gz
# Retention: 30 days (RETAIN_DAYS)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
RETAIN_DAYS="${FM_ADMIN_BACKUP_RETAIN_DAYS:-30}"
BACKUP_ROOT="${FM_ADMIN_BACKUP_DIR:-$HOME/fm_admin_backups}"
TIMESTAMP="$(date +%Y-%m-%d_%H%M%S)"
STAGING="$BACKUP_ROOT/staging_$TIMESTAMP"
ARCHIVE="$BACKUP_ROOT/fm_admin_${TIMESTAMP}.tar.gz"
LOG_FILE="$BACKUP_ROOT/backup.log"

log() {
  printf '[%s] %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$*" | tee -a "$LOG_FILE"
}

mkdir -p "$BACKUP_ROOT" "$STAGING"

copy_tree() {
  local rel="$1"
  local src="$REPO_ROOT/$rel"
  if [[ -e "$src" ]]; then
    mkdir -p "$STAGING/$(dirname "$rel")"
    cp -a "$src" "$STAGING/$rel"
    log "Included: $rel"
  else
    log "Skip (missing): $rel"
  fi
}

log "Starting admin backup — repo=$REPO_ROOT"

copy_tree "strategy"
copy_tree "governance/plans"
copy_tree "scripts/workspace"
copy_tree ".cursor/skills"
copy_tree ".claude/skills"

tar -czf "$ARCHIVE" -C "$STAGING" .
rm -rf "$STAGING"

BYTES="$(wc -c < "$ARCHIVE" | tr -d ' ')"
if [[ "$BYTES" -lt 1024 ]]; then
  log "ERROR: archive too small (${BYTES} bytes) — removing"
  rm -f "$ARCHIVE"
  exit 1
fi

if ! gzip -t "$ARCHIVE" 2>/dev/null; then
  log "ERROR: gzip integrity check failed — removing"
  rm -f "$ARCHIVE"
  exit 1
fi

PRUNED=0
while IFS= read -r old; do
  rm -f "$old"
  PRUNED=$((PRUNED + 1))
done < <(find "$BACKUP_ROOT" -maxdepth 1 -name 'fm_admin_*.tar.gz' -mtime +"$RETAIN_DAYS" 2>/dev/null || true)

log "Written: $ARCHIVE ($BYTES bytes)"
log "Pruned: $PRUNED archive(s) older than ${RETAIN_DAYS} days"
log "Done"
