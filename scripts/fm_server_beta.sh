#!/usr/bin/env bash

# Finance Manager server-beta blue/green runtime helper.
# Script-first operations for status/check/deploy/switch/rollback without forcing destructive actions.

set -euo pipefail

BASE_DIR="${FM_WORKSPACE:-${FM_WORKSPACE_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}}"
# Parallel stack: docker-compose.bluegreen.parallel.yml (shared network, no extra DB/proxy on host).
if [[ -n "${FM_BLUEGREEN_COMPOSE_FILE:-}" ]]; then
  COMPOSE_FILE="$FM_BLUEGREEN_COMPOSE_FILE"
elif [[ "${FM_BG_PARALLEL:-0}" == "1" ]]; then
  COMPOSE_FILE="$BASE_DIR/docker-compose.bluegreen.parallel.yml"
else
  COMPOSE_FILE="$BASE_DIR/docker-compose.bluegreen.yml"
fi

# Same as scripts/fm_docker.sh: pass --env-file so ${SECRET_KEY} and friends interpolate for api services.
COMPOSE_ENV_FILE_ARGS=()
if [[ -n "${FM_ENV_FILE:-}" ]]; then
  COMPOSE_ENV_FILE_ARGS=(--env-file "$FM_ENV_FILE")
elif [[ -f "$BASE_DIR/.secrets/server.env" ]]; then
  COMPOSE_ENV_FILE_ARGS=(--env-file "$BASE_DIR/.secrets/server.env")
elif [[ -f "$BASE_DIR/.env" ]]; then
  COMPOSE_ENV_FILE_ARGS=(--env-file "$BASE_DIR/.env")
fi

ACTIVE_COLOR_FILE="${FM_ACTIVE_COLOR_FILE:-$BASE_DIR/proxy/active_color.conf}"
DEFAULT_PROJECT="${FM_BLUEGREEN_PROJECT:-fm-beta}"
PROJECT_NAME="$DEFAULT_PROJECT"
DRY_RUN=0
ROLLBACK_STATE_FILE="${FM_ROLLBACK_STATE_FILE:-$BASE_DIR/.secrets/last_active_color}"
PUBLIC_APP_HOST="${FM_PUBLIC_APP_HOST:-financemanager.local}"
PUBLIC_API_HOST="${FM_PUBLIC_API_HOST:-api.financemanager.local}"
PUBLIC_BASE_URL="${FM_PUBLIC_BASE_URL:-https://localhost:8443}"

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
  FM_BG_PARALLEL                     If 1, default compose is docker-compose.bluegreen.parallel.yml
                                     (app services + redis on FM_STACK_NETWORK_NAME; uses FM_DB_HOST).
  FM_STACK_NETWORK_NAME              Podman/Docker network of the live stack (default: finance_manager_default).
  FM_DB_HOST                         Postgres hostname for parallel mode (default: finance-manager-db).
  FM_ENV_FILE                        Optional env file for compose var substitution (default: .secrets/server.env or .env).
  FM_ACTIVE_COLOR_FILE               Override active color include path.
  FM_BLUEGREEN_PROJECT               Override compose project name (default: fm-beta).
  FM_PUBLIC_APP_HOST                 Host header for frontend smoke probes.
  FM_PUBLIC_API_HOST                 Host header for API smoke probes.
  FM_PUBLIC_BASE_URL                 Base URL for proxy smoke probes (default: https://localhost:8443).
EOF
}

using_parallel_compose() {
  case "$COMPOSE_FILE" in
    *parallel.y* | *parallel.yaml) return 0 ;;
    *) return 1 ;;
  esac
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
  ${COMPOSE_CMD[@]} -p "$PROJECT_NAME" -f "$COMPOSE_FILE" "${COMPOSE_ENV_FILE_ARGS[@]}" "$@"
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
  local filter='fm-beta|api-blue|api-green|reflex-blue|reflex-green|web-blue|web-green|proxy|db|redis'
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
  local web_service="web-$color"
  local command
  if using_parallel_compose; then
    command=(up -d redis "$api_service" "$reflex_service" "$web_service")
  else
    command=(up -d db "$api_service" "$reflex_service" "$web_service" proxy)
  fi

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
  local web_upstream="web-$color"
  log "Smoke target color: $color"

  compose_cmd exec -T redis redis-cli ping >/dev/null
  compose_cmd exec -T "$api_upstream" curl -fsS "http://localhost:8000/api/health/" >/dev/null
  compose_cmd exec -T "$reflex_upstream" sh -c "curl -fsS http://localhost:3000/ >/dev/null"
  compose_cmd exec -T "$web_upstream" sh -c "wget -qO- http://127.0.0.1/ >/dev/null"

  if using_parallel_compose; then
    log "Parallel stack: public edge still serves legacy single-stack; skipped Host-header curls to $PUBLIC_BASE_URL"
  else
    curl -kfsS -H "Host: $PUBLIC_API_HOST" "$PUBLIC_BASE_URL/api/health/" >/dev/null
    curl -kfsS -H "Host: $PUBLIC_APP_HOST" "$PUBLIC_BASE_URL/" >/dev/null
  fi
  log "Smoke checks passed for $target ($color)."
}

reload_proxy() {
  if using_parallel_compose; then
    die "reload_proxy: parallel compose has no 'proxy' service. Point edge at blue/green or use full docker-compose.bluegreen.yml for switch."
  fi
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
