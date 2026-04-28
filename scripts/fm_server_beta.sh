#!/usr/bin/env bash

# Finance Manager server-beta blue/green runtime helper.
# Script-first operations for status/check/deploy/switch/rollback without forcing destructive actions.

set -euo pipefail

BASE_DIR="${FM_WORKSPACE:-${FM_WORKSPACE_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}}"
COMPOSE_FILE="${FM_BLUEGREEN_COMPOSE_FILE:-$BASE_DIR/docker-compose.bluegreen.yml}"
ACTIVE_COLOR_FILE="${FM_ACTIVE_COLOR_FILE:-$BASE_DIR/proxy/active_color.conf}"
DEFAULT_PROJECT="${FM_BLUEGREEN_PROJECT:-fm-beta}"
PROJECT_NAME="$DEFAULT_PROJECT"
DRY_RUN=0
ROLLBACK_STATE_FILE="${FM_ROLLBACK_STATE_FILE:-$BASE_DIR/.secrets/last_active_color}"

usage() {
  cat <<'EOF'
Usage: fm_server_beta.sh <command> [args] [--dry-run] [--project <name>]

Commands:
  install                         Run non-destructive prerequisite/install checks.
  status                          Show compose status and active/inactive color.
  check                           Validate compose and nginx blue/green configuration.
  deploy [--dry-run] <color>      Start inactive color services (or explicit color).
  smoke --color <active|inactive|blue|green>
                                  Run API and Reflex smoke checks for selected color.
  switch --to <blue|green>        Promote color by updating proxy active color and reloading proxy.
  promote --to <blue|green>       Alias for switch.
  rollback                        Switch back to prior active color.
  logs [service]                  Tail compose logs (optional service filter).
  backup                          Placeholder command for DB backup integration.

Environment:
  FM_WORKSPACE / FM_WORKSPACE_ROOT   Optional absolute repo root.
  FM_BLUEGREEN_COMPOSE_FILE          Override compose file path.
  FM_ACTIVE_COLOR_FILE               Override active color include path.
  FM_BLUEGREEN_PROJECT               Override compose project name (default: fm-beta).
EOF
}

log() { printf '%s\n' "$*"; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

have_cmd() { command -v "$1" >/dev/null 2>&1; }

detect_compose() {
  if have_cmd podman-compose; then
    COMPOSE_CMD=(podman-compose)
    return
  fi
  if have_cmd docker-compose; then
    COMPOSE_CMD=(docker-compose)
    return
  fi
  if have_cmd docker && docker compose version >/dev/null 2>&1; then
    COMPOSE_CMD=(docker compose)
    return
  fi
  die "No compose provider found (podman-compose, docker-compose, or docker compose)."
}

detect_runtime_bin() {
  if have_cmd podman; then
    RUNTIME_BIN="podman"
    return
  fi
  if have_cmd docker; then
    RUNTIME_BIN="docker"
    return
  fi
  die "No container runtime found for nginx config validation (podman or docker)."
}

compose_cmd() {
  # shellcheck disable=SC2086
  ${COMPOSE_CMD[@]} -p "$PROJECT_NAME" -f "$COMPOSE_FILE" "$@"
}

require_paths() {
  [[ -d "$BASE_DIR" ]] || die "Base directory missing: $BASE_DIR"
  [[ -f "$COMPOSE_FILE" ]] || die "Compose file missing: $COMPOSE_FILE"
  [[ -f "$ACTIVE_COLOR_FILE" ]] || die "Active color file missing: $ACTIVE_COLOR_FILE"
}

require_color() {
  case "$1" in
    blue|green) ;;
    *) die "invalid color '$1' (expected blue or green)" ;;
  esac
}

current_active_color() {
  local active
  active="$(awk '/default[[:space:]]+(blue|green);/ {gsub(";", "", $2); print $2}' "$ACTIVE_COLOR_FILE" | tail -n 1)"
  if [[ "$active" != "blue" && "$active" != "green" ]]; then
    die "Could not parse active color from $ACTIVE_COLOR_FILE"
  fi
  printf '%s\n' "$active"
}

inactive_color() {
  local active="$1"
  [[ "$active" == "blue" ]] && printf 'green\n' || printf 'blue\n'
}

write_active_color() {
  local color="$1"
  require_color "$color"
  mkdir -p "$(dirname "$ACTIVE_COLOR_FILE")"
  cat > "$ACTIVE_COLOR_FILE" <<EOF
map \$request_uri \$fm_active_color {
    default $color;
}
EOF
}

status_cmd() {
  local active inactive
  active="$(current_active_color)"
  inactive="$(inactive_color "$active")"
  log "Project: $PROJECT_NAME"
  log "Active color: $active"
  log "Inactive color: $inactive"
  log "Runtime containers (filtered):"
  local filter='fm-beta|api-blue|api-green|reflex-blue|reflex-green|proxy|db|redis'
  if [[ "$RUNTIME_BIN" == "podman" ]]; then
    if have_cmd rg; then
      podman ps -a --format '{{.Names}}\t{{.Status}}\t{{.Ports}}' | rg "$filter" || true
    else
      podman ps -a --format '{{.Names}}\t{{.Status}}\t{{.Ports}}' | grep -E "$filter" || true
    fi
  else
    if have_cmd rg; then
      docker ps -a --format '{{.Names}}\t{{.Status}}\t{{.Ports}}' | rg "$filter" || true
    else
      docker ps -a --format '{{.Names}}\t{{.Status}}\t{{.Ports}}' | grep -E "$filter" || true
    fi
  fi
}

check_cmd() {
  log "Checking compose configuration..."
  compose_cmd config >/dev/null
  log "Compose config: ok"

  log "Checking nginx blue/green config syntax..."
  "$RUNTIME_BIN" run --rm \
    -v "$BASE_DIR/proxy/nginx.bluegreen.conf:/etc/nginx/nginx.conf:ro,z" \
    -v "$BASE_DIR/proxy/active_color.conf:/etc/nginx/conf.d/active_color.conf:ro,z" \
    -v "$BASE_DIR/proxy/certs:/etc/nginx/certs:ro,z" \
    nginx:alpine nginx -t >/dev/null
  log "Nginx config: ok"
}

deploy_cmd() {
  local color="$1"
  require_color "$color"
  local api_service="api-$color"
  local reflex_service="reflex-$color"
  local command=(up -d db "$api_service" "$reflex_service" proxy)

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "dry-run: would run compose ${command[*]}"
    return 0
  fi

  compose_cmd "${command[@]}"
  log "Deployed candidate color: $color"
  log "Note: DB migrations should be run via repo migration workflow before switch if required."
}

smoke_cmd() {
  local target="$1"
  local color active
  active="$(current_active_color)"

  case "$target" in
    active) color="$active" ;;
    inactive) color="$(inactive_color "$active")" ;;
    blue|green) color="$target" ;;
    *) die "invalid smoke target '$target' (active|inactive|blue|green)" ;;
  esac

  local api_upstream="api-$color"
  local reflex_upstream="reflex-$color"
  log "Smoke target color: $color"

  compose_cmd exec -T redis redis-cli ping >/dev/null
  compose_cmd exec -T "$api_upstream" curl -fsS "http://localhost:8000/api/health/" >/dev/null
  compose_cmd exec -T "$reflex_upstream" sh -c "wget -qO- http://localhost:3000 >/dev/null"

  curl -kfsS -H "Host: api.financemanager.local" "https://localhost:8443/api/health/" >/dev/null
  curl -kfsS -H "Host: financemanager.local" "https://localhost:8443/" >/dev/null
  log "Smoke checks passed for $target ($color)."
}

reload_proxy() {
  compose_cmd exec -T proxy nginx -t >/dev/null
  compose_cmd exec -T proxy nginx -s reload >/dev/null
}

switch_cmd() {
  local to_color="$1"
  require_color "$to_color"
  local from_color
  from_color="$(current_active_color)"

  if [[ "$from_color" == "$to_color" ]]; then
    log "Active color already '$to_color'; no change."
    return 0
  fi

  if [[ "$DRY_RUN" -eq 0 ]]; then
    log "Pre-cutover smoke check for target color '$to_color'..."
    smoke_cmd "$to_color"
  fi

  mkdir -p "$(dirname "$ROLLBACK_STATE_FILE")"
  printf '%s\n' "$from_color" > "$ROLLBACK_STATE_FILE"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "dry-run: would set active color $from_color -> $to_color and reload proxy"
    return 0
  fi

  write_active_color "$to_color"
  reload_proxy
  log "Switched active color: $from_color -> $to_color"
}

rollback_cmd() {
  local current target
  current="$(current_active_color)"
  if [[ -f "$ROLLBACK_STATE_FILE" ]]; then
    target="$(tr -d '[:space:]' < "$ROLLBACK_STATE_FILE")"
  else
    target="$(inactive_color "$current")"
  fi
  require_color "$target"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "dry-run: would rollback active color $current -> $target"
    return 0
  fi

  write_active_color "$target"
  reload_proxy
  log "Rollback complete: $current -> $target"
}

install_cmd() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    "$BASE_DIR/scripts/server/install_prereqs.sh" --dry-run
    "$BASE_DIR/scripts/server/bootstrap_env.sh" --dry-run --from-example
    "$BASE_DIR/scripts/server/verify_install.sh" --dry-run
    return 0
  fi
  "$BASE_DIR/scripts/server/install_prereqs.sh"
  "$BASE_DIR/scripts/server/bootstrap_env.sh" --validate-only
  "$BASE_DIR/scripts/server/verify_install.sh"
}

logs_cmd() {
  local service="${1:-}"
  if [[ -n "$service" ]]; then
    compose_cmd logs -f --tail=100 "$service"
  else
    compose_cmd logs -f --tail=100
  fi
}

backup_cmd() {
  log "Backup hook not implemented yet."
  log "Use scripts/db_export.sh with your agreed backup destination."
}

main() {
  [[ $# -gt 0 ]] || { usage; exit 1; }
  local cmd="$1"
  shift

  local parsed_args=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --project)
        shift
        [[ $# -gt 0 ]] || die "--project requires a value"
        PROJECT_NAME="$1"
        ;;
      --dry-run)
        DRY_RUN=1
        ;;
      *)
        parsed_args+=("$1")
        ;;
    esac
    shift || true
  done
  set -- "${parsed_args[@]}"

  detect_compose
  detect_runtime_bin
  require_paths

  case "$cmd" in
    install)
      install_cmd
      ;;
    status)
      status_cmd
      ;;
    check)
      check_cmd
      ;;
    deploy)
      [[ $# -gt 0 ]] || die "deploy requires target color (blue|green)"
      deploy_cmd "$1"
      ;;
    smoke)
      [[ "${1:-}" == "--color" && -n "${2:-}" ]] || die "usage: smoke --color <active|inactive|blue|green>"
      smoke_cmd "$2"
      ;;
    switch|promote)
      [[ "${1:-}" == "--to" && -n "${2:-}" ]] || die "usage: $cmd --to <blue|green>"
      switch_cmd "$2"
      ;;
    rollback)
      rollback_cmd
      ;;
    logs)
      logs_cmd "${1:-}"
      ;;
    backup)
      backup_cmd
      ;;
    -h|--help|help)
      usage
      ;;
    *)
      usage
      die "unknown command: $cmd"
      ;;
  esac
}

main "$@"
