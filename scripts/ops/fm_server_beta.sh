#!/usr/bin/env bash

# Finance Manager server-beta blue/green runtime helper.
# Script-first operations for status/check/deploy/switch/rollback without forcing destructive actions.

set -euo pipefail

BASE_DIR="${FM_WORKSPACE:-${FM_WORKSPACE_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}}"
# Parallel stack: docker-compose.bluegreen.parallel.yml (shared network, no extra DB/proxy on host).
if [[ -n "${FM_BLUEGREEN_COMPOSE_FILE:-}" ]]; then
  COMPOSE_FILE="$FM_BLUEGREEN_COMPOSE_FILE"
elif [[ "${FM_BG_PARALLEL:-0}" == "1" ]]; then
  COMPOSE_FILE="$BASE_DIR/docker-compose.bluegreen.parallel.yml"
else
  COMPOSE_FILE="$BASE_DIR/docker-compose.bluegreen.yml"
fi

# Same as scripts/local-stack/fm_docker.sh: pass --env-file so ${SECRET_KEY} and friends interpolate for api services.
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

# Color-agnostic background workers (F-014). Rebuilt/recreated alongside api/web so
# they always run the freshly built image, and kept running across switches.
CELERY_SERVICES=(celery-worker celery-beat)

usage() {
  cat <<'EOF'
Usage: fm_server_beta.sh <command> [args] [--dry-run] [--project <name>]

Commands:
  install                         Run non-destructive prerequisite/install checks.
  status                          Show compose status and active/inactive color.
  check                           Validate compose and nginx blue/green configuration.
  deploy [--dry-run] <color>      Start inactive color services (or explicit color).
  rebuild-color [--no-build] [--no-cache] <blue|green>
                                  Build api/web for one color plus the shared celery
                                  worker/beat, then safely recreate those containers (and
                                  proxy), pruning orphaned containers first. Use this after
                                  image changes on Podman: plain "up --force-recreate" often
                                  fails because proxy lists depends_on on all app containers
                                  (--requires). Use --no-cache to force a clean build
                                  (recommended after code changes to prevent stale layers).
  prune-orphans                   Remove stale containers in this project whose service is
                                  no longer defined in the compose file (scoped to project).
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

# Service names defined in the active compose file (filters podman-compose banner noise).
compose_services() {
  compose_cmd config --services 2>/dev/null | grep -E '^[A-Za-z0-9._-]+$' || true
}

# Actively tear down stale containers in this project whose service is no longer
# defined in the compose file. Repeated blue/green rebuilds + renamed/removed
# services (e.g. an old celery-beat-green) otherwise leave orphans that confuse
# later "up"/switch steps. Scoped strictly to PROJECT_NAME so unrelated stacks
# are never touched.
prune_orphan_containers() {
  local services
  services="$(compose_services)"
  if [[ -z "${services//[$' \t\n']/}" ]]; then
    log "prune: could not resolve compose services; skipping orphan prune."
    return 0
  fi

  declare -A keep=()
  local svc
  while IFS= read -r svc; do
    [[ -n "$svc" ]] && keep["$svc"]=1
  done <<< "$services"

  local ids id csvc cname removed=0
  ids=$("$RUNTIME_BIN" ps -aq \
    --filter "label=com.docker.compose.project=${PROJECT_NAME}" 2>/dev/null || true)
  for id in $ids; do
    csvc=$("$RUNTIME_BIN" inspect -f '{{ index .Config.Labels "com.docker.compose.service" }}' "$id" 2>/dev/null || true)
    if [[ -z "$csvc" || -z "${keep[$csvc]:-}" ]]; then
      cname=$("$RUNTIME_BIN" inspect -f '{{ .Name }}' "$id" 2>/dev/null || echo "$id")
      log "prune: removing orphan container ${cname#/} (service='${csvc:-<none>}')"
      "$RUNTIME_BIN" rm -f "$id" >/dev/null 2>&1 || true
      removed=$((removed + 1))
    fi
  done
  log "prune: removed ${removed} orphan container(s) for project ${PROJECT_NAME}."
}

# After (re)creating an API container, Django may need a few seconds before :8000 listens.
wait_api_service_ready() {
  wait_api_service_ready_soft "$1" || die "$1 did not respond to /api/health/ within ~120s (check logs: $0 logs $1)"
}

wait_api_service_ready_soft() {
  local svc="$1"
  local i
  log "Waiting for $svc /api/health/ ..."
  for i in $(seq 1 60); do
    if compose_cmd exec -T "$svc" curl -fsS "http://localhost:8000/api/health/" >/dev/null 2>&1; then
      log "$svc is healthy (${i}s)."
      return 0
    fi
    sleep 2
  done
  log "ERROR: $svc did not respond to /api/health/ within ~120s"
  return 1
}

service_container_image_id() {
  local svc="$1"
  local cid
  cid=$("$RUNTIME_BIN" ps -q \
    --filter "label=com.docker.compose.project=${PROJECT_NAME}" \
    --filter "label=com.docker.compose.service=${svc}" 2>/dev/null | head -1)
  [[ -n "$cid" ]] || return 1
  "$RUNTIME_BIN" inspect -f '{{.Image}}' "$cid"
}

tag_last_known_good_image() {
  local svc="$1"
  local img tag
  img="$(service_container_image_id "$svc")" || return 0
  tag="${PROJECT_NAME}_${svc}-lastgood"
  if "$RUNTIME_BIN" tag "$img" "$tag" 2>/dev/null; then
    log "Tagged last-known-good image for $svc: $tag"
  fi
}

compose_built_image_ref() {
  local svc="$1"
  printf '%s_%s\n' "$PROJECT_NAME" "$svc"
}

rollback_color_service_to_lastgood() {
  local svc="$1"
  local lkg primary
  lkg="${PROJECT_NAME}_${svc}-lastgood"
  primary="$(compose_built_image_ref "$svc")"
  if ! "$RUNTIME_BIN" image inspect "$lkg" &>/dev/null; then
    log "rollback: no last-known-good tag $lkg for $svc"
    return 1
  fi
  log "rollback: restoring $svc from $lkg"
  compose_cmd_safe stop "$svc" || true
  remove_compose_service_container "$svc"
  "$RUNTIME_BIN" tag "$lkg" "$primary" 2>/dev/null \
    || "$RUNTIME_BIN" tag "$lkg" "localhost/$primary" 2>/dev/null \
    || true
  compose_cmd_quiet_up -d --no-build "$svc"
}

rollback_failed_color_rebuild() {
  local api_service="$1"
  local web_service="$2"
  local svc
  log "Attempting last-known-good rollback for $api_service / $web_service (proxy left running)."
  compose_cmd_safe stop "$api_service" "$web_service" "${CELERY_SERVICES[@]}" || true
  for svc in "$api_service" "$web_service" "${CELERY_SERVICES[@]}"; do
    remove_compose_service_container "$svc"
    rollback_color_service_to_lastgood "$svc" || true
  done
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

# Mask secret values in compose output. podman-compose echoes the fully
# interpolated `podman ... --env KEY=value` invocation (values sourced from
# .secrets/server.env) on most subcommands, and `config` prints the resolved
# YAML with secrets inline. This filter masks any value whose env-var NAME looks
# sensitive (PASSWORD/SECRET/TOKEN/KEY/CREDENTIAL/AUTH...), in KEY=value, KEY:
# value, and --env/-e KEY=value forms, plus inline URL credentials.
#
# Reads from a file path argument when given (back-compat); otherwise streams
# stdin line-by-line so it can be used as a pipe filter, including for `logs -f`.
# The program is passed via `-c` (not `python3 -`) and the optional file path via
# an env var, so stdin stays free for piped data.
redact_compose_output() {
  FM_REDACT_FILE="${1:-}" python3 -c '
import os
import re
import sys
from pathlib import Path

# Mask the value of any env var whose NAME looks sensitive, plus inline URL creds.
_SENSITIVE = r"[A-Za-z0-9_]*(?:PASSWORD|PASSWD|SECRET|TOKEN|APIKEY|API_KEY|ACCESS_KEY|PRIVATE_KEY|CREDENTIAL|CREDENTIALS|AUTH|_KEY)"
_P1 = re.compile(r"(?i)(\b" + _SENSITIVE + r"\b\s*[:=]\s*)(\S+)")
_P2 = re.compile(r"(://[^:/?#@\s]+:)([^@/?#\s]+)(@)")


def _redact(line):
    line = _P1.sub(lambda m: m.group(1) + "<redacted>", line)
    line = _P2.sub(lambda m: m.group(1) + "<redacted>" + m.group(3), line)
    return line


arg = os.environ.get("FM_REDACT_FILE", "")
if arg:
    text = Path(arg).read_text(errors="replace")
    sys.stdout.write("".join(_redact(l) for l in text.splitlines(keepends=True)))
else:
    for line in sys.stdin:
        sys.stdout.write(_redact(line))
        sys.stdout.flush()
'
}

# Run any compose subcommand with combined stdout+stderr streamed through the
# secret redactor, preserving the compose exit code (not the redactor's). Every
# code path that lets compose output reach the terminal MUST go through this so
# interpolated `--env KEY=value` lines can never leak. Parsing-only callers that
# need clean stdout (e.g. `config --services`) use the raw `compose_cmd`.
compose_cmd_safe() {
  # `set -o pipefail` is active globally, so the pipeline's exit status reflects
  # compose's failure (the redactor is effectively pass-through). Using `if`
  # captures that status without toggling the caller's errexit state.
  local rc=0
  if compose_cmd "$@" 2>&1 | redact_compose_output; then
    rc=0
  else
    rc=$?
  fi
  return "$rc"
}

# Keep successful `up` output quiet; on failure, print a redacted copy. (Even on
# success the temp log is discarded, so secrets never reach the terminal.)
compose_cmd_quiet_up() {
  local tmp rc
  tmp="$(mktemp)"
  chmod 600 "$tmp"
  if compose_cmd up "$@" >"$tmp" 2>&1; then
    rm -f "$tmp"
    return 0
  fi
  rc=$?
  log "compose up failed (output redacted):"
  redact_compose_output "$tmp"
  rm -f "$tmp"
  return "$rc"
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
  local filter='fm-beta|api-blue|api-green|web-blue|web-green|celery-worker|celery-beat|proxy|db|redis'
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

# 00-resolver.conf is generated at proxy container start (see
# proxy/docker-entrypoint.d/20-resolver-from-resolv.sh), not committed in-repo.
proxy_container_running() {
  if using_parallel_compose; then
    return 1
  fi
  compose_cmd ps --status running --services proxy 2>/dev/null | grep -qx 'proxy'
}

check_nginx_config_syntax() {
  if proxy_container_running; then
    compose_cmd_safe exec -T proxy nginx -t >/dev/null
    return 0
  fi

  local resolver_stub
  resolver_stub="$(mktemp)"
  # shellcheck disable=SC2064
  trap "rm -f '$resolver_stub'" RETURN
  {
    echo "resolver 127.0.0.11 valid=10s;"
    echo "resolver_timeout 5s;"
  } >"$resolver_stub"

  "$RUNTIME_BIN" run --rm \
    -v "$BASE_DIR/proxy/nginx.bluegreen.conf:/etc/nginx/nginx.conf:ro,z" \
    -v "$BASE_DIR/proxy/active_color.conf:/etc/nginx/conf.d/active_color.conf:ro,z" \
    -v "$resolver_stub:/etc/nginx/conf.d/00-resolver.conf:ro,z" \
    -v "$BASE_DIR/proxy/certs:/etc/nginx/certs:ro,z" \
    nginx:alpine nginx -t >/dev/null
}

check_cmd() {
  log "Checking compose configuration..."
  # `config` prints the resolved compose YAML (with interpolated secrets) to
  # stdout; route through the redactor and discard so nothing leaks even on error.
  compose_cmd_safe config >/dev/null
  log "Compose config: ok"

  log "Checking nginx blue/green config syntax..."
  check_nginx_config_syntax
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
    # No --remove-orphans: it makes podman-compose recreate the whole project.
    command=(up -d db "$api_service" "$web_service" "${CELERY_SERVICES[@]}" proxy)
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "dry-run: would run compose ${command[*]}"
    return 0
  fi

  compose_cmd_quiet_up "${command[@]:1}"
  log "Deployed candidate color: $color"
  log "Note: DB migrations should be run via repo migration workflow before switch if required."
}

rebuild_color_cmd() {
  local color=""
  local do_build=1
  local no_cache=0
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --no-build)
        do_build=0
        ;;
      --no-cache)
        no_cache=1
        ;;
      blue|green)
        color="$1"
        ;;
      *)
        die "rebuild-color: unknown argument '$1' (expected --no-build, --no-cache, and/or blue|green)"
        ;;
    esac
    shift || true
  done
  [[ -n "$color" ]] || die "rebuild-color requires a color: blue|green (after optional --no-build/--no-cache)"

  local active
  active="$(current_active_color)"
  if [[ "$color" == "$active" && "${FM_ALLOW_ACTIVE_REBUILD:-0}" != "1" ]]; then
    die "refusing rebuild of active color '$active' (set FM_ALLOW_ACTIVE_REBUILD=1 to override)"
  fi

  local api_service="api-$color"
  local web_service="web-$color"

  if using_parallel_compose; then
    if [[ "$DRY_RUN" -eq 1 ]]; then
      log "dry-run: would build (if enabled) and force-recreate $api_service $web_service"
      return 0
    fi
    if [[ "$do_build" -eq 1 ]]; then
      local build_args=(build)
      [[ "$no_cache" -eq 1 ]] && build_args+=(--no-cache)
      build_args+=("$api_service" "$web_service")
      log "Building $api_service and $web_service${no_cache:+ (--no-cache)}..."
      compose_cmd_safe "${build_args[@]}"
    fi
    log "Recreating $api_service and $web_service (parallel compose; no proxy in this file)."
    compose_cmd_quiet_up -d --force-recreate "$api_service" "$web_service"
    wait_api_service_ready "$api_service"
    log "Rebuild complete for $color."
    return 0
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "dry-run: would tag last-known-good images, stop/recreate $api_service + $web_service + ${CELERY_SERVICES[*]} only (proxy left running), wait for API health, verify active color unchanged, smoke inactive color, then reload proxy"
    return 0
  fi

  tag_last_known_good_image "$api_service"
  tag_last_known_good_image "$web_service"

  local active_api active_web
  active="$(current_active_color)"
  active_api="api-$active"
  active_web="web-$active"
  local pre_active_api_img pre_active_web_img
  pre_active_api_img="$(service_container_image_id "$active_api" 2>/dev/null || true)"
  pre_active_web_img="$(service_container_image_id "$active_web" 2>/dev/null || true)"

  if [[ "$do_build" -eq 1 ]]; then
    local build_args=(build)
    [[ "$no_cache" -eq 1 ]] && build_args+=(--no-cache)
    build_args+=("$api_service" "$web_service" "${CELERY_SERVICES[@]}")
    log "Building $api_service, $web_service, and ${CELERY_SERVICES[*]}${no_cache:+ (--no-cache)}..."
    compose_cmd_safe "${build_args[@]}"
  fi

  log "Recreating $api_service, $web_service, and ${CELERY_SERVICES[*]} (proxy left running)."
  compose_cmd_safe stop "$api_service" "$web_service" "${CELERY_SERVICES[@]}" || true
  remove_compose_service_container "$api_service"
  remove_compose_service_container "$web_service"
  local svc
  for svc in "${CELERY_SERVICES[@]}"; do
    remove_compose_service_container "$svc"
  done

  prune_orphan_containers

  log "Starting db, redis, $api_service, $web_service, ${CELERY_SERVICES[*]} (proxy unchanged)..."
  if ! compose_cmd_quiet_up -d db redis "$api_service" "$web_service" "${CELERY_SERVICES[@]}"; then
    rollback_failed_color_rebuild "$api_service" "$web_service"
    die "rebuild-color failed during compose up for $color; rolled back app containers (proxy untouched)"
  fi

  if ! wait_api_service_ready_soft "$api_service"; then
    rollback_failed_color_rebuild "$api_service" "$web_service"
    die "$api_service failed health check after rebuild; rolled back to last-known-good (proxy still serving active color)"
  fi

  if [[ -n "$pre_active_api_img" ]]; then
    local post_active_api_img
    post_active_api_img="$(service_container_image_id "$active_api" 2>/dev/null || true)"
    [[ "$post_active_api_img" == "$pre_active_api_img" ]] \
      || die "proxy isolation violation: active $active_api container image changed during inactive rebuild"
  fi
  if [[ -n "$pre_active_web_img" ]]; then
    local post_active_web_img
    post_active_web_img="$(service_container_image_id "$active_web" 2>/dev/null || true)"
    [[ "$post_active_web_img" == "$pre_active_web_img" ]] \
      || die "proxy isolation violation: active $active_web container image changed during inactive rebuild"
  fi

  log "Pre-reload smoke for inactive color $color (active $active untouched)..."
  if ! smoke_cmd "$color"; then
    rollback_failed_color_rebuild "$api_service" "$web_service"
    die "inactive color $color failed smoke — proxy not reloaded; active color $active still serving"
  fi

  if proxy_container_running; then
    log "Inactive color healthy — reloading proxy (no container recreate)."
    reload_proxy
  else
    log "Proxy not running — starting proxy after confirmed $api_service health."
    compose_cmd_quiet_up -d proxy
  fi

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

  # podman-compose prints the interpolated `podman exec --env KEY=value ...`
  # invocation (api/web services carry the secret env) to stderr, so these MUST
  # go through compose_cmd_safe; the redacted stream is then discarded.
  compose_cmd_safe exec -T redis redis-cli ping >/dev/null
  compose_cmd_safe exec -T "$api_upstream" curl -fsS "http://localhost:8000/api/health/" >/dev/null
  compose_cmd_safe exec -T "$web_upstream" sh -c "wget -qO- http://127.0.0.1/ >/dev/null"

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
  compose_cmd_safe exec -T proxy nginx -t >/dev/null
  compose_cmd_safe exec -T proxy nginx -s reload >/dev/null
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

  if ! using_parallel_compose; then
    # Keep background workers running on the promoted stack and clear any stale
    # containers left from the rebuild that preceded this switch.
    log "Ensuring ${CELERY_SERVICES[*]} are running and pruning orphans..."
    compose_cmd_quiet_up -d "${CELERY_SERVICES[@]}" >/dev/null 2>&1 || true
    prune_orphan_containers
  fi

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
    "$BASE_DIR/scripts/ops/install_prereqs.sh" --dry-run
    "$BASE_DIR/scripts/ops/bootstrap_env.sh" --dry-run --from-example
    "$BASE_DIR/scripts/ops/verify_install.sh" --dry-run
    return 0
  fi
  "$BASE_DIR/scripts/ops/install_prereqs.sh"
  "$BASE_DIR/scripts/ops/bootstrap_env.sh" --validate-only
  "$BASE_DIR/scripts/ops/verify_install.sh"
}

logs_cmd() {
  local service="${1:-}"
  if [[ -n "$service" ]]; then
    compose_cmd_safe logs -f --tail=100 "$service"
  else
    compose_cmd_safe logs -f --tail=100
  fi
}

backup_cmd() {
  log "Backup hook not implemented yet."
  log "Use scripts/db/db_export.sh with your agreed backup destination."
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
    prune-orphans)
      prune_orphan_containers
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
