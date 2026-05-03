#!/usr/bin/env bash

# Finance Manager server-beta blue/green runtime helper.
# Script-first operations for status/check/deploy/switch/rollback without forcing destructive actions.
#
# Log hygiene: smoke / wait / proxy reload use direct "podman exec" (see compose_exec_tty) so
# podman-compose does not print compose-interpolated secrets for those steps. "compose up" /
# "build" may still print full "podman run -e ..." lines from podman-compose; avoid teeing that
# output to public logs, or run compose from tooling that masks secrets.

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
  rebuild-color [--no-build] <blue|green>
                                  Build api/web for one color, then safely recreate those
                                  containers (and proxy). Use this after image changes on
                                  Podman: plain "up --force-recreate" often fails because
                                  proxy lists depends_on on all app containers (--requires).
  smoke --color <active|inactive|blue|green>
                                  Run API and web (React) smoke checks for selected color.
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

Note: smoke/wait/reload use direct container exec (not compose exec) so compose-interpolated
secrets are not echoed into terminal logs by podman-compose.
EOF
}

# Remove a compose-managed container by project + service labels (works for Podman and Docker).
remove_compose_service_container() {
  local svc="$1"
  local ids
  ids=$("$RUNTIME_BIN" ps -aq \
    --filter "label=com.docker.compose.project=${PROJECT_NAME}" \
    --filter "label=com.docker.compose.service=${svc}" 2>/dev/null || true)
  if [[ -n "${ids//[$' \t\n']/}" ]]; then
    # shellcheck disable=SC2086
    "$RUNTIME_BIN" rm -f $ids || true
  fi
}

# After (re)creating an API container, Django may need a few seconds before :8000 listens.
wait_api_service_ready() {
  local svc="$1"
  local i cid
  log "Waiting for $svc /api/health/ ..."
  for i in $(seq 1 90); do
    cid="$(container_id_for_service "$svc")"
    if [[ -n "$cid" ]] && "$RUNTIME_BIN" exec "$cid" curl -fsS "http://localhost:8000/api/health/" >/dev/null 2>&1; then
      log "$svc is healthy (${i}s)."
      return 0
    fi
    sleep 2
  done
  die "$svc did not respond to /api/health/ within ~180s (check logs: $0 logs $svc)"
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

# podman-compose (and some docker-compose wrappers) print the full translated
# `podman exec ... --env KEY=...` line before running, which leaks compose-interpolated
# secrets from .env into operator logs. Prefer direct runtime exec for probes.
container_id_for_service() {
  local svc="$1"
  "$RUNTIME_BIN" ps -q \
    --filter "label=com.docker.compose.project=${PROJECT_NAME}" \
    --filter "label=com.docker.compose.service=${svc}" 2>/dev/null | head -n1 | tr -d '[:space:]'
}

compose_exec_tty() {
  local svc="$1"
  shift
  local cid
  cid="$(container_id_for_service "$svc")"
  [[ -n "$cid" ]] || die "compose service not running (no container id): $svc (project=$PROJECT_NAME)"
  # No `-T`: Podman does not support Docker's "disable TTY" shorthand; default is non-TTY.
  "$RUNTIME_BIN" exec "$cid" "$@"
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
  local filter='fm-beta|api-blue|api-green|web-blue|web-green|proxy|db|redis'
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
  local web_service="web-$color"
  local command
  if using_parallel_compose; then
    command=(up -d redis "$api_service" "$web_service")
  else
    command=(up -d db "$api_service" "$web_service" proxy)
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "dry-run: would run compose ${command[*]}"
    return 0
  fi

  compose_cmd "${command[@]}"
  log "Deployed candidate color: $color"
  log "Note: DB migrations should be run via repo migration workflow before switch if required."
}

rebuild_color_cmd() {
  local color=""
  local do_build=1
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --no-build)
        do_build=0
        ;;
      blue|green)
        color="$1"
        ;;
      *)
        die "rebuild-color: unknown argument '$1' (expected --no-build and/or blue|green)"
        ;;
    esac
    shift || true
  done
  [[ -n "$color" ]] || die "rebuild-color requires a color: blue|green (after optional --no-build)"

  local api_service="api-$color"
  local web_service="web-$color"

  if using_parallel_compose; then
    if [[ "$DRY_RUN" -eq 1 ]]; then
      log "dry-run: would build (if enabled) and force-recreate $api_service $web_service"
      return 0
    fi
    if [[ "$do_build" -eq 1 ]]; then
      log "Building $api_service and $web_service..."
      compose_cmd build "$api_service" "$web_service"
    fi
    log "Recreating $api_service and $web_service (parallel compose; no proxy in this file)."
    compose_cmd up -d --force-recreate "$api_service" "$web_service"
    wait_api_service_ready "$api_service"
    log "Rebuild complete for $color."
    return 0
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "dry-run: would stop proxy + $api_service + $web_service, rm those containers, build (if enabled), up db/redis/$api_service/$web_service/proxy"
    return 0
  fi

  if [[ "$do_build" -eq 1 ]]; then
    log "Building $api_service and $web_service..."
    compose_cmd build "$api_service" "$web_service"
  fi

  log "Recreating $api_service and $web_service with fresh containers."
  log "Note: proxy shares :8443/:8080 for both colors — it will restart briefly (typically a few seconds)."
  compose_cmd stop proxy "$api_service" "$web_service" || true
  remove_compose_service_container "proxy"
  remove_compose_service_container "$api_service"
  remove_compose_service_container "$web_service"

  log "Starting db, redis, $api_service, $web_service, proxy..."
  compose_cmd up -d db redis "$api_service" "$web_service" proxy
  wait_api_service_ready "$api_service"
  log "Rebuild complete for $color. Run: $0 smoke --color $color"
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
  local web_upstream="web-$color"
  log "Smoke target color: $color"

  compose_exec_tty redis redis-cli ping >/dev/null
  compose_exec_tty "$api_upstream" curl -fsS "http://localhost:8000/api/health/" >/dev/null
  compose_exec_tty "$web_upstream" sh -c "wget -qO- http://127.0.0.1/ >/dev/null"

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
  compose_exec_tty proxy nginx -t >/dev/null
  compose_exec_tty proxy nginx -s reload >/dev/null
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
    rebuild-color)
      rebuild_color_cmd "$@"
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
