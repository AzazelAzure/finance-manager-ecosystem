#!/usr/bin/env bash
# sprint_verify.sh — remote color rebuild + smoke + evidence capture (orchestration huddle Phase 2b).
#
# Runs on your machine; uses SSH to the VPS ecosystem root and invokes scripts/fm_server_beta.sh there.
# Does NOT flip active color or run switch.
#
# Required:
#   --color <blue|green>     Color to rebuild (api-* / web-* pair).
#   --branch <name>          Git branch to checkout on each selected submodule (same branch for all).
#   --evidence <dir>         Local directory for timestamped logs (created).
#
# Optional:
#   --repos <api,web|...>    Comma-separated: api, web (default: api,web).
#   --smoke                  After rebuild, run fm_server_beta.sh smoke.
#   --smoke-color <target>   Passed to smoke --color (default: inactive).
#   --no-cache               Forward --no-cache to rebuild-color.
#   --dry-run                Print planned steps only; no SSH.
#
# Environment:
#   FM_SPRINT_SSH            SSH target (default: dev@159.198.75.194).
#   FM_SPRINT_REMOTE_ROOT    Absolute path to ecosystem root on VPS (default: /home/dev/finance_manager).
#   FM_SPRINT_FM_SCRIPT      Path to fm_server_beta.sh relative to remote root (default: scripts/fm_server_beta.sh).
#   FM_SPRINT_PROJECT        If set, exported as FM_BLUEGREEN_PROJECT on the remote for compose -p.
#
set -euo pipefail

log() { printf '%s\n' "$*"; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

FM_SPRINT_SSH="${FM_SPRINT_SSH:-dev@159.198.75.194}"
FM_SPRINT_REMOTE_ROOT="${FM_SPRINT_REMOTE_ROOT:-/home/dev/finance_manager}"
FM_SPRINT_FM_SCRIPT="${FM_SPRINT_FM_SCRIPT:-scripts/fm_server_beta.sh}"
FM_SPRINT_PROJECT="${FM_SPRINT_PROJECT:-}"

COLOR=""
BRANCH=""
EVIDENCE=""
REPOS="api,web"
DO_SMOKE=0
SMOKE_TARGET="inactive"
DRY_RUN=0
NO_CACHE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --color)
      [[ $# -ge 2 ]] || die "--color requires a value"
      COLOR="$2"
      shift 2
      ;;
    --branch)
      [[ $# -ge 2 ]] || die "--branch requires a value"
      BRANCH="$2"
      shift 2
      ;;
    --evidence)
      [[ $# -ge 2 ]] || die "--evidence requires a path"
      EVIDENCE="$2"
      shift 2
      ;;
    --repos)
      [[ $# -ge 2 ]] || die "--repos requires a value"
      REPOS="$2"
      shift 2
      ;;
    --smoke)
      DO_SMOKE=1
      shift
      ;;
    --smoke-color)
      [[ $# -ge 2 ]] || die "--smoke-color requires a value"
      SMOKE_TARGET="$2"
      shift 2
      ;;
    --no-cache)
      NO_CACHE=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      sed -n '1,30p' "$0"
      exit 0
      ;;
    *)
      die "unknown argument: $1"
      ;;
  esac
done

[[ -n "$COLOR" ]] || die "missing --color (blue|green)"
[[ -n "$BRANCH" ]] || die "missing --branch"
[[ -n "$EVIDENCE" ]] || die "missing --evidence"
[[ "$COLOR" == "blue" || "$COLOR" == "green" ]] || die "--color must be blue or green"

if [[ ! "$BRANCH" =~ ^[a-zA-Z0-9_./-]+$ ]]; then
  die "refusing unsafe --branch value (allowed: alnum, _, ., /, -)"
fi

map_repo_dir() {
  case "$1" in
    api) printf '%s\n' "finance_manager_api" ;;
    web) printf '%s\n' "finance_manager_web" ;;
    *) die "unknown repo token '$1' (use api or web)" ;;
  esac
}

IFS=',' read -r -a repo_arr <<< "$REPOS"
[[ ${#repo_arr[@]} -gt 0 ]] || die "--repos empty"

REPO_DIRS=()
for r in "${repo_arr[@]}"; do
  r="${r//[$' \t\r\n']/}"
  [[ -n "$r" ]] || continue
  REPO_DIRS+=("$(map_repo_dir "$r")")
done

mkdir -p "$EVIDENCE"
TS="$(date -u +%Y%m%dT%H%M%SZ)"
RUN_LOG="$EVIDENCE/sprint_verify_${TS}.log"

if [[ "$DRY_RUN" -eq 1 ]]; then
  {
    log "=== sprint_verify.sh DRY-RUN $TS ==="
    log "SSH=$FM_SPRINT_SSH REMOTE_ROOT=$FM_SPRINT_REMOTE_ROOT COLOR=$COLOR BRANCH=$BRANCH REPOS=$REPOS"
    log "[dry-run] git fetch/checkout in: ${REPO_DIRS[*]}"
    if [[ "$NO_CACHE" -eq 1 ]]; then
      log "[dry-run] $FM_SPRINT_REMOTE_ROOT/$FM_SPRINT_FM_SCRIPT rebuild-color --no-cache $COLOR"
    else
      log "[dry-run] $FM_SPRINT_REMOTE_ROOT/$FM_SPRINT_FM_SCRIPT rebuild-color $COLOR"
    fi
    if [[ "$DO_SMOKE" -eq 1 ]]; then
      log "[dry-run] $FM_SPRINT_FM_SCRIPT smoke --color $SMOKE_TARGET"
    fi
    log "Dry run complete."
  } | tee -a "$RUN_LOG"
  exit 0
fi

exec > >(tee -a "$RUN_LOG") 2>&1

log "=== sprint_verify.sh $TS ==="
log "SSH=$FM_SPRINT_SSH REMOTE_ROOT=$FM_SPRINT_REMOTE_ROOT COLOR=$COLOR BRANCH=$BRANCH REPOS=$REPOS"

ssh -o BatchMode=yes "$FM_SPRINT_SSH" \
  REMOTE_ROOT="$FM_SPRINT_REMOTE_ROOT" \
  FM_REL="$FM_SPRINT_FM_SCRIPT" \
  BRANCH="$BRANCH" \
  COLOR="$COLOR" \
  NO_CACHE="$NO_CACHE" \
  DO_SMOKE="$DO_SMOKE" \
  SMOKE_TARGET="$SMOKE_TARGET" \
  FM_BLUEGREEN_PROJECT="${FM_SPRINT_PROJECT}" \
  bash -s "${REPO_DIRS[@]}" <<'REMOTE_EOF'
set -euo pipefail
cd "$REMOTE_ROOT"
[[ -f "$FM_REL" ]] || { echo "missing $FM_REL"; exit 1; }
export FM_WORKSPACE="$REMOTE_ROOT"
if [[ -n "${FM_BLUEGREEN_PROJECT:-}" ]]; then
  export FM_BLUEGREEN_PROJECT
fi
for d in "$@"; do
  [[ -d "$d" ]] || { echo "missing directory $d"; exit 1; }
  (
    cd "$d"
    git fetch origin
    git checkout "$BRANCH"
    git pull --ff-only origin "$BRANCH"
  )
  echo "HEAD $(basename "$d")=$(cd "$d" && git rev-parse HEAD)"
done
if [[ "$NO_CACHE" == "1" ]]; then
  "./$FM_REL" rebuild-color --no-cache "$COLOR"
else
  "./$FM_REL" rebuild-color "$COLOR"
fi
if [[ "$DO_SMOKE" == "1" ]]; then
  "./$FM_REL" smoke --color "$SMOKE_TARGET"
fi
REMOTE_EOF

log "=== sprint_verify complete ==="
log "Evidence log: $RUN_LOG"
