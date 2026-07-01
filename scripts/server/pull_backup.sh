#!/usr/bin/env bash
# Deprecated path retained for existing crontab entries (pre scripts/ops reorg).
# Forwards to scripts/ops/pull_backup.sh.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/../ops/pull_backup.sh" "$@"
