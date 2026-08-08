#!/usr/bin/env bash
# Render ecosystem-hosts deploy artifact from the tracked template (static DNS upstream maps).
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TEMPLATE="${REPO_ROOT}/proxy/conf.d/ecosystem-hosts.conf.template"
CANONICAL="${REPO_ROOT}/proxy/conf.d/ecosystem-hosts.conf"
DEPLOY_ARTIFACT="${REPO_ROOT}/proxy/conf.d/ecosystem-hosts.deploy.conf"
OUT="${1:-$DEPLOY_ARTIFACT}"

usage() {
  cat <<'EOF'
usage: render_ecosystem_hosts.sh [OUTPUT_PATH]

Copies ecosystem-hosts.conf.template to a deployment artifact (default:
proxy/conf.d/ecosystem-hosts.deploy.conf). Does not write the tracked local
canonical proxy/conf.d/ecosystem-hosts.conf (127.0.0.1 loopback dev maps).
EOF
}

if [[ "${1:-}" == -h || "${1:-}" == --help ]]; then
  usage
  exit 0
fi

[[ -f "$TEMPLATE" ]] || { echo "missing template: $TEMPLATE" >&2; exit 1; }

if [[ "$OUT" == "$CANONICAL" ]]; then
  echo "refusing to render over tracked canonical file: $CANONICAL" >&2
  echo "use default deploy artifact or an explicit staging path" >&2
  exit 1
fi

mkdir -p "$(dirname "$OUT")"
cp "$TEMPLATE" "$OUT"
echo "rendered $OUT (per-color Podman DNS upstream maps)"
