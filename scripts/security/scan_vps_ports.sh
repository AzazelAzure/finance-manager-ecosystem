#!/usr/bin/env bash
# scan_vps_ports.sh — off-host TCP scan vs committed allowlist.
# Usage: VPS_HOST=159.198.75.194 ./scripts/security/scan_vps_ports.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALLOWLIST="${ALLOWLIST_FILE:-$SCRIPT_DIR/vps_port_allowlist.txt}"
HOST="${VPS_HOST:-159.198.75.194}"
# Common exposure candidates
CANDIDATES=(22 80 443 3000 5432 6379 8000 8010 8080 8081 8091 8443 9001)

declare -A ALLOW
while read -r port _rest; do
  [[ -z "${port:-}" || "$port" =~ ^# ]] && continue
  ALLOW["$port"]=1
done < "$ALLOWLIST"

echo "Scanning $HOST against allowlist $ALLOWLIST"
echo "Candidates: ${CANDIDATES[*]}"
FAIL=0
for p in "${CANDIDATES[@]}"; do
  if timeout 2 bash -c "echo >/dev/tcp/${HOST}/${p}" 2>/dev/null; then
    if [[ -n "${ALLOW[$p]:-}" ]]; then
      echo "OPEN  $p (allowlisted)"
    else
      echo "FINDING OPEN $p (NOT allowlisted)"
      FAIL=1
    fi
  else
    echo "closed $p"
  fi
done

if [[ "$FAIL" -ne 0 ]]; then
  echo "FAIL: unexpected open ports on $HOST"
  exit 1
fi
echo "PASS: no unexpected open ports among candidates"
exit 0
