#!/usr/bin/env bash
# check_compose_publish.sh — fail if prod compose publishes data/proxy ports on all interfaces.
# Usage: ./scripts/security/check_compose_publish.sh [path-to-compose]
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
COMPOSE="${1:-$REPO_ROOT/docker-compose.bluegreen.yml}"

if [[ ! -f "$COMPOSE" ]]; then
  echo "ERROR: compose not found: $COMPOSE" >&2
  exit 2
fi

echo "Checking host publish posture in: $COMPOSE"
echo "Policy: data-tier and edge proxy must not use 0.0.0.0 / bare HOST:CONTAINER publishes."

# Flag unsafe patterns: "5432:5432", "8080:80", "8443:443" without 127.0.0.1
# Allow 127.0.0.1:PORT:PORT
UNSAFE=0
while IFS= read -r line; do
  # skip comments
  [[ "$line" =~ ^[[:space:]]*# ]] && continue
  if [[ "$line" =~ \"([0-9]+):([0-9]+)\" ]] || [[ "$line" =~ \'([0-9]+):([0-9]+)\' ]]; then
    echo "UNSAFE all-interfaces publish: $line"
    UNSAFE=1
  fi
  if [[ "$line" =~ 0\.0\.0\.0: ]]; then
    echo "UNSAFE 0.0.0.0 publish: $line"
    UNSAFE=1
  fi
done < <(grep -E 'ports:|"[0-9]+:|"0\.0\.0\.0:|'\''[0-9]+:' "$COMPOSE" || true)

# Also specifically require loopback for known prod ports if present
for pair in '5432:5432' '8080:80' '8443:443'; do
  if grep -q "\"$pair\"" "$COMPOSE" || grep -q "'$pair'" "$COMPOSE"; then
    echo "UNSAFE bare publish $pair (require 127.0.0.1:$pair)"
    UNSAFE=1
  fi
done

if [[ "$UNSAFE" -ne 0 ]]; then
  echo "FAIL: compose publish posture"
  exit 1
fi
echo "PASS: no all-interfaces publishes detected for guarded ports"
exit 0
