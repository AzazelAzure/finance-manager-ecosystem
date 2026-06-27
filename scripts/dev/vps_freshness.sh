#!/usr/bin/env bash
# vps_freshness.sh — compare live VPS submodule SHAs against local main HEAD
# Usage: ./scripts/dev/vps_freshness.sh
# Requires: SSH key auth to VPS (no password prompt)

set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
VPS_HOST="dev@dev@<VPS_HOST>"
VPS_REPO="~/finance_manager"

echo "=== VPS FRESHNESS CHECK — $(date +%Y-%m-%d\ %H:%M) ==="
echo ""

# Local main HEADs
LOCAL_API=$(cd "$REPO_ROOT/finance_manager_api" && git rev-parse HEAD)
LOCAL_WEB=$(cd "$REPO_ROOT/finance_manager_web" && git rev-parse HEAD)

echo "Local main:"
echo "  api: $LOCAL_API"
echo "  web: $LOCAL_WEB"
echo ""

# VPS live SHAs
VPS_SHAS=$(ssh "$VPS_HOST" "
  echo -n 'api: '; cd ${VPS_REPO}/finance_manager_api && git rev-parse HEAD 2>/dev/null || echo 'unknown'
  echo -n 'web: '; cd ${VPS_REPO}/finance_manager_web && git rev-parse HEAD 2>/dev/null || echo 'unknown'
")

echo "VPS live:"
echo "$VPS_SHAS" | sed 's/^/  /'
echo ""

VPS_API=$(echo "$VPS_SHAS" | grep "^api:" | awk '{print $2}')
VPS_WEB=$(echo "$VPS_SHAS" | grep "^web:" | awk '{print $2}')

echo "Drift:"
if [[ "$LOCAL_API" == "$VPS_API" ]]; then
  echo "  api: IN SYNC"
else
  echo "  api: BEHIND — VPS at ${VPS_API:0:7}, local at ${LOCAL_API:0:7}"
fi

if [[ "$LOCAL_WEB" == "$VPS_WEB" ]]; then
  echo "  web: IN SYNC"
else
  echo "  web: BEHIND — VPS at ${VPS_WEB:0:7}, local at ${LOCAL_WEB:0:7}"
fi
