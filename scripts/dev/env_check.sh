#!/usr/bin/env bash
# env_check.sh — verify repo-root .env against .env.example keys
#
# Usage:
#   ./scripts/dev/env_check.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
EXAMPLE="$REPO_ROOT/.env.example"
ENV_FILE="$REPO_ROOT/.env"

echo "=== env_check ($(date '+%Y-%m-%d %H:%M')) ==="

[[ -f "$EXAMPLE" ]] || { echo "Missing: $EXAMPLE" >&2; exit 1; }

if [[ ! -f "$ENV_FILE" ]]; then
  echo "FAIL: .env not found (copy from .env.example)"
  exit 1
fi

MISSING=0
while IFS= read -r line; do
  [[ "$line" =~ ^[[:space:]]*# ]] && continue
  [[ -z "${line// }" ]] && continue
  key="${line%%=*}"
  key="${key// /}"
  [[ -z "$key" ]] && continue
  if ! grep -q "^${key}=" "$ENV_FILE" 2>/dev/null; then
    echo "  MISSING: $key"
    MISSING=$((MISSING + 1))
  fi
done < <(grep -E '^[A-Z_][A-Z0-9_]*=' "$EXAMPLE" || true)

OPTIONAL_KEYS=(VPS_ORIGIN_IP FM_SPRINT_SSH FM_SPRINT_REMOTE_ROOT VPS_STATE_SSH_TIMEOUT VPS_STATE_EXPECTED)
for key in "${OPTIONAL_KEYS[@]}"; do
  if grep -q "^${key}=" "$EXAMPLE" && ! grep -q "^${key}=" "$ENV_FILE" 2>/dev/null; then
    echo "  OPTIONAL (unset): $key"
  fi
done

if [[ "$MISSING" -gt 0 ]]; then
  echo "FAIL: $MISSING required key(s) missing from .env"
  exit 1
fi

echo "PASS: .env contains keys declared in .env.example"
