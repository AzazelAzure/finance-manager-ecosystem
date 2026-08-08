#!/usr/bin/env bash
# Idempotently attach fm-beta edge proxy to Orchestrator per-color presentation networks.
# Fails closed on missing/ambiguous proxy container or presentation networks.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
FM_PROJECT="${FM_BLUEGREEN_PROJECT:-fm-beta}"
PROXY_FILTER="${FM_PROXY_CONTAINER_FILTER:-${FM_PROJECT}_proxy}"
ORCH_NETWORK_BLUE="${ORCH_PRESENTATION_NETWORK_BLUE:-orchestrator-console-blue}"
ORCH_NETWORK_GREEN="${ORCH_PRESENTATION_NETWORK_GREEN:-orchestrator-console-green}"
MODE="${1:-attach}"

log() { printf '[orch-proxy-attach] %s\n' "$*"; }
die() { log "ERROR: $*" >&2; exit 1; }

usage() {
  cat <<'EOF'
usage: attach_orchestrator_proxy_networks.sh [attach|detach|status]

attach  — connect fm-beta proxy to orchestrator-console-blue/green (idempotent)
detach  — disconnect proxy from both presentation networks (rollback)
status  — report proxy container and network attachment state
EOF
}

discover_proxy_cid() {
  local -a cids=()
  mapfile -t cids < <(podman ps -q --filter "name=${PROXY_FILTER}" 2>/dev/null | sed '/^$/d')
  if [[ ${#cids[@]} -eq 0 ]]; then
    die "no running proxy container matching name=${PROXY_FILTER}"
  fi
  if [[ ${#cids[@]} -gt 1 ]]; then
    die "ambiguous proxy container count (${#cids[@]}) for name=${PROXY_FILTER}"
  fi
  printf '%s' "${cids[0]}"
}

require_presentation_network() {
  local network="$1"
  podman network exists "$network" 2>/dev/null || die "missing presentation network: $network (deploy Orchestrator color first)"
}

proxy_attached_to_network() {
  local proxy_cid="$1"
  local network="$2"
  podman inspect --format '{{range $name, $cfg := .NetworkSettings.Networks}}{{println $name}}{{end}}' "$proxy_cid" \
    | grep -Fxq "$network"
}

attach_proxy_to_network() {
  local proxy_cid="$1"
  local network="$2"
  require_presentation_network "$network"
  if proxy_attached_to_network "$proxy_cid" "$network"; then
    log "ok: proxy already attached to $network"
    return 0
  fi
  podman network connect "$network" "$proxy_cid"
  log "attached proxy to $network"
}

detach_proxy_from_network() {
  local proxy_cid="$1"
  local network="$2"
  if ! proxy_attached_to_network "$proxy_cid" "$network"; then
    log "skip: proxy not attached to $network"
    return 0
  fi
  podman network disconnect "$network" "$proxy_cid"
  log "detached proxy from $network"
}

attach_cmd() {
  local proxy_cid
  proxy_cid="$(discover_proxy_cid)"
  attach_proxy_to_network "$proxy_cid" "$ORCH_NETWORK_BLUE"
  attach_proxy_to_network "$proxy_cid" "$ORCH_NETWORK_GREEN"
  log "attach complete (proxy=$proxy_cid)"
}

detach_cmd() {
  local proxy_cid
  proxy_cid="$(discover_proxy_cid)"
  detach_proxy_from_network "$proxy_cid" "$ORCH_NETWORK_BLUE"
  detach_proxy_from_network "$proxy_cid" "$ORCH_NETWORK_GREEN"
  log "detach complete (proxy=$proxy_cid) — Orchestrator public routes will fail until re-attach + nginx reload"
}

status_cmd() {
  local proxy_cid
  proxy_cid="$(discover_proxy_cid)"
  log "proxy cid=$proxy_cid filter=${PROXY_FILTER}"
  for network in "$ORCH_NETWORK_BLUE" "$ORCH_NETWORK_GREEN"; do
    if podman network exists "$network" 2>/dev/null; then
      if proxy_attached_to_network "$proxy_cid" "$network"; then
        log "attached: $network"
      else
        log "not attached: $network"
      fi
    else
      log "missing network: $network"
    fi
  done
}

case "$MODE" in
  attach) attach_cmd ;;
  detach) detach_cmd ;;
  status) status_cmd ;;
  -h|--help) usage; exit 0 ;;
  *) die "unknown mode: $MODE (expected attach|detach|status)" ;;
esac
