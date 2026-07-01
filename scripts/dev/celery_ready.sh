#!/usr/bin/env bash
# celery_ready.sh — quick Celery worker/beat presence (local Podman stack)
#
# Usage:
#   ./scripts/dev/celery_ready.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

echo "=== Celery readiness ($(date '+%Y-%m-%d %H:%M')) ==="

if ! command -v podman >/dev/null 2>&1; then
  echo "podman: not found"
  exit 1
fi

mapfile -t lines < <(podman ps --format '{{.Names}}	{{.Status}}' 2>/dev/null | grep -i celery || true)

if [[ ${#lines[@]} -eq 0 ]]; then
  echo "celery: no running containers matching 'celery'"
  echo "hint: start stack with scripts/local-stack/fm_docker.sh start"
  exit 1
fi

for line in "${lines[@]}"; do
  echo "  $line"
done
echo "celery: OK (${#lines[@]} container(s))"
