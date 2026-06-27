#!/usr/bin/env bash
# setup_backup_cron.sh
#
# Prints the crontab entries needed for local backup and doc context automation.
# Does NOT edit crontab automatically — review and add manually via: crontab -e
#
# Usage:
#   ./scripts/local/setup_backup_cron.sh

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo ""
echo "===== CRONTAB ENTRIES FOR FINANCE MANAGER ====="
echo "Run: crontab -e  — then paste the lines below"
echo ""
echo "# --- Finance Manager automation ---"
echo ""
echo "# 1. Doc context gather (runs before Antigravity daily sweep at 5:00 AM)"
echo "45 4 * * * GH_TOKEN=\"\$(cat ~/.config/fm_gh_token 2>/dev/null)\" ${REPO_ROOT}/scripts/gather_doc_context.sh >> /tmp/gather_doc_context.log 2>&1"
echo ""
echo "# 2. VPS database backup (daily pull over SSH)"
echo "0 6 * * * ${REPO_ROOT}/scripts/server/pull_backup.sh >> /tmp/fm_backup.log 2>&1"
echo ""
echo "===== ONE-TIME SETUP REQUIRED ====="
echo ""
echo "# GitHub CLI token for cron (run once interactively):"
echo "gh auth token > ~/.config/fm_gh_token && chmod 600 ~/.config/fm_gh_token"
echo ""
echo "# Verify SSH key auth to VPS (no password prompt expected):"
echo "ssh dev@159.198.75.194 'echo VPS_OK'"
echo ""
echo "# After adding cron entries, verify first runs:"
echo "# Doc context:  tail -f /tmp/gather_doc_context.log"
echo "# Backup:       tail -f /tmp/fm_backup.log"
echo "# Backups live: ls -lh ~/fm_backups/"
echo ""
