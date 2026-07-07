#!/usr/bin/env bash
# setup_admin_backup_cron.sh — print crontab line for daily admin backup (2am)
#
# Usage:
#   ./scripts/local/setup_admin_backup_cron.sh
#
# Does NOT edit crontab automatically — paste into: crontab -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

cat <<EOF

===== ADMIN BACKUP CRONTAB (LOCAL-ADMIN-BACKUP-T01) =====
Run: crontab -e  — paste the line below

# Admin/strategy backup (gitignored content) — distinct from 6am VPS DB pull
0 2 * * * ${REPO_ROOT}/scripts/ops/backup_admin.sh >> ${HOME}/fm_admin_backups/backup.log 2>&1

Verify:
  ${REPO_ROOT}/scripts/ops/backup_admin.sh
  ls -lh ~/fm_admin_backups/

Complements: scripts/local/setup_backup_cron.sh (6am pull_backup.sh)

EOF
