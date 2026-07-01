#!/usr/bin/env bash
# local_stack_health.sh — container status + local HTTPS probes with correct Host headers
#
# Usage: ./scripts/dev/local_stack_health.sh [--logs]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SHOW_LOGS=0
[[ "${1:-}" == "--logs" ]] && SHOW_LOGS=1

echo "================================================================"
echo "  CONTAINERS  ($(date '+%Y-%m-%d %H:%M'))"
echo "================================================================"
bash "$REPO_ROOT/scripts/local-stack/fm_docker.sh" status 2>&1 || true
echo ""

probe() {
  local label="$1" url="$2" host="${3:-}"
  local args=(-sS -o /dev/null -w '%{http_code}' -k --max-time 10 "$url")
  [[ -n "$host" ]] && args=(-sS -o /dev/null -w '%{http_code}' -k --max-time 10 -H "Host: $host" "$url")
  local code
  code=$(curl "${args[@]}" 2>/dev/null || echo "000")
  printf '  %-8s %s -> HTTP %s\n' "$label" "$url" "$code"
  [[ "$code" =~ ^2 ]] && return 0
  return 1
}

echo "================================================================"
echo "  HTTP PROBES (local :8443)"
echo "================================================================"
FAIL=0
probe "web" "https://127.0.0.1:8443/" "financemanager.local" || FAIL=1
probe "api" "https://127.0.0.1:8443/api/health/" "api.financemanager.local" || FAIL=1
echo ""

if [[ "$SHOW_LOGS" -eq 1 && "$FAIL" -ne 0 ]]; then
  echo "================================================================"
  echo "  RECENT LOGS (on failure)"
  echo "================================================================"
  for c in finance-manager-api finance-manager-proxy finance-manager-web; do
    if podman container exists "$c" 2>/dev/null; then
      echo "--- $c ---"
      podman logs --tail 15 "$c" 2>&1 || true
    fi
  done
fi

[[ "$FAIL" -eq 0 ]] && echo "local_stack_health: OK" || { echo "local_stack_health: FAIL" >&2; exit 1; }
