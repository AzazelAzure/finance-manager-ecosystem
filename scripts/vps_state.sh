#!/usr/bin/env bash
# vps_state.sh
#
# Single concern: SSH the production VPS, capture LIVE runtime facts, and print a
# timestamped markdown block to stdout. No doc reading, no GitHub calls, no side
# effects beyond a single read-only SSH round-trip.
#
# This script is the anti-stale guarantee for downstream automations (daily
# summary, doc sweep, morning meeting): the VPS state they consume must come from
# THIS block — SSH-verified, with a capture timestamp — never from the static
# Runtime Signup Sheet.
#
# Usage:
#   ./scripts/vps_state.sh
#
# Exit codes:
#   0  live state captured (block printed)
#   1  SSH failed/timed out — an UNAVAILABLE block is printed; callers must
#      surface "state unknown" and never fall back to a cached file.
#
# SSH config is reused from the existing VPS scripts (sprint_verify.sh /
# fm_server_beta.sh ecosystem) via the same env vars — no new credentials.
#
# Environment:
#   FM_SPRINT_SSH          SSH target (default: dev@dev@<VPS_HOST>)
#   FM_SPRINT_REMOTE_ROOT  Absolute ecosystem root on the VPS (default: /home/dev/finance_manager)
#   VPS_STATE_SSH_TIMEOUT  Hard timeout in seconds for the SSH bundle (default: 20)
#   VPS_STATE_EXPECTED     Expected running container count for drift check (default: 7)

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

SSH_TARGET="${FM_SPRINT_SSH:-dev@dev@<VPS_HOST>}"
REMOTE_ROOT="${FM_SPRINT_REMOTE_ROOT:-/home/dev/finance_manager}"
SSH_TIMEOUT="${VPS_STATE_SSH_TIMEOUT:-20}"
EXPECTED_CONTAINERS="${VPS_STATE_EXPECTED:-7}"

now_iso() { date -Iseconds; }
now_ms() { date +%s%3N; }

# --- Run the live query (single SSH round-trip) --------------------------------
START_MS="$(now_ms)"
RAW="$(timeout "$SSH_TIMEOUT" ssh -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new \
  "$SSH_TARGET" \
  REMOTE_ROOT="$REMOTE_ROOT" \
  bash -s <<'REMOTE_EOF' 2>/dev/null
set -uo pipefail
cd "$REMOTE_ROOT" 2>/dev/null || { echo "REMOTE_ERROR=cannot cd $REMOTE_ROOT"; exit 3; }

if command -v podman >/dev/null 2>&1; then RT=podman
elif command -v docker >/dev/null 2>&1; then RT=docker
else echo "REMOTE_ERROR=no container runtime"; exit 3; fi

# Active color from the blue/green proxy include.
ACTIVE=""
if [[ -f proxy/active_color.conf ]]; then
  ACTIVE="$(awk '/default[[:space:]]+(blue|green);/ {gsub(";","",$2); print $2}' proxy/active_color.conf | tail -n 1)"
fi
echo "ACTIVE_COLOR=${ACTIVE:-unknown}"

# Deployed SHAs (the VPS deploys from standalone api/web clones).
if [[ -d finance_manager_api/.git ]]; then
  echo "API_SHA=$(git -C finance_manager_api rev-parse --short HEAD 2>/dev/null || echo unknown)"
  echo "API_FULL_SHA=$(git -C finance_manager_api rev-parse HEAD 2>/dev/null || echo unknown)"
else
  echo "API_SHA=unknown"; echo "API_FULL_SHA=unknown"
fi
if [[ -d finance_manager_web/.git ]]; then
  echo "WEB_SHA=$(git -C finance_manager_web rev-parse --short HEAD 2>/dev/null || echo unknown)"
  echo "WEB_FULL_SHA=$(git -C finance_manager_web rev-parse HEAD 2>/dev/null || echo unknown)"
else
  echo "WEB_SHA=unknown"; echo "WEB_FULL_SHA=unknown"
fi

# Container snapshot (one ps call, reused below).
PS="$($RT ps --format '{{.Names}}\t{{.Status}}' 2>/dev/null || true)"
RUNNING_COUNT="$(printf '%s\n' "$PS" | grep -c 'fm-beta' 2>/dev/null || true)"
echo "CONTAINERS_RUNNING=${RUNNING_COUNT:-0}"

emit_celery() {
  local svc="$1" key="$2" line status
  line="$(printf '%s\n' "$PS" | grep -E "${svc}" | head -1)"
  if [[ -n "$line" ]]; then
    status="$(printf '%s' "$line" | cut -f2-)"
    echo "${key}=up ${status#Up }"
  else
    echo "${key}=DOWN"
  fi
}
emit_celery 'celery-worker' CELERY_WORKER
emit_celery 'celery-beat' CELERY_BEAT

# Active-color API container: health probe + last applied migration.
API_CONTAINER="$(printf '%s\n' "$PS" | awk -v c="api-${ACTIVE}" '$0 ~ c {print $1; exit}')"
if [[ -n "$API_CONTAINER" ]]; then
  echo "API_CONTAINER=$API_CONTAINER"
  HC="$($RT exec "$API_CONTAINER" curl -s -o /dev/null -w '%{http_code}' http://localhost:8000/api/health/ 2>/dev/null || echo 000)"
  echo "API_HEALTH=${HC:-000}"
  # Django runs under a project venv; pick the first interpreter that can import
  # Django (container path first, then PATH) and exec manage.py with it.
  run_mgmt() {
    $RT exec "$API_CONTAINER" sh -c \
      'for py in /app/.venv/bin/python python3 python; do if "$py" -c "import django" 2>/dev/null; then exec "$py" manage.py "$@"; fi; done' \
      _ "$@" 2>/dev/null
  }
  # Prefer the project app's latest applied migration; fall back to the global plan tail.
  LM_RAW="$(run_mgmt showmigrations finance | grep '\[X\]' | tail -1)"
  [[ -z "$LM_RAW" ]] && LM_RAW="$(run_mgmt showmigrations --plan | grep '\[X\]' | tail -1)"
  LM="$(printf '%s' "$LM_RAW" | sed -E 's/^[[:space:]]*\[X\][[:space:]]*//')"
  echo "LAST_MIGRATION=${LM:-unknown}"
else
  echo "API_CONTAINER=missing"
  echo "API_HEALTH=000"
  echo "LAST_MIGRATION=unknown"
fi

echo "---CONTAINERS---"
printf '%s\n' "$PS" | grep 'fm-beta' || true
echo "---END_CONTAINERS---"
REMOTE_EOF
)"
SSH_RC=$?
END_MS="$(now_ms)"
LATENCY_MS=$(( END_MS - START_MS ))

# --- SSH failure: print a clearly-marked UNAVAILABLE block and exit non-zero ----
if [[ "$SSH_RC" -ne 0 || -z "$RAW" || "$RAW" == *"REMOTE_ERROR="* ]]; then
  TS="$(now_iso)"
  REASON="SSH failed or timed out (rc=$SSH_RC, timeout=${SSH_TIMEOUT}s)"
  if [[ "$RAW" == *"REMOTE_ERROR="* ]]; then
    REASON="$(printf '%s\n' "$RAW" | sed -n 's/^REMOTE_ERROR=/remote error: /p' | head -1)"
  fi
  cat <<EOF
## Live VPS State (UNAVAILABLE — SSH failed at $TS)

**Host:** $SSH_TARGET · **Reason:** $REASON · **Query latency:** ${LATENCY_MS}ms

> Live VPS state could NOT be verified this run. Downstream automations MUST report
> VPS state as UNKNOWN and MUST NOT fall back to the Runtime Signup Sheet or any
> cached/prior value as if it were current.
EOF
  exit 1
fi

# --- Parse remote facts --------------------------------------------------------
get() { printf '%s\n' "$RAW" | sed -n "s/^$1=//p" | head -1; }

ACTIVE_COLOR="$(get ACTIVE_COLOR)"
API_SHA="$(get API_SHA)"
API_FULL_SHA="$(get API_FULL_SHA)"
WEB_SHA="$(get WEB_SHA)"
WEB_FULL_SHA="$(get WEB_FULL_SHA)"
CONTAINERS_RUNNING="$(get CONTAINERS_RUNNING)"
CELERY_WORKER="$(get CELERY_WORKER)"
CELERY_BEAT="$(get CELERY_BEAT)"
API_CONTAINER="$(get API_CONTAINER)"
API_HEALTH="$(get API_HEALTH)"
LAST_MIGRATION="$(get LAST_MIGRATION)"

CONTAINER_TABLE="$(printf '%s\n' "$RAW" | awk '/^---CONTAINERS---$/{f=1;next} /^---END_CONTAINERS---$/{f=0} f')"

# --- Drift check (local, best-effort) ------------------------------------------
DRIFT=()
[[ "$CELERY_WORKER" == "DOWN" ]] && DRIFT+=("Celery worker is DOWN.")
[[ "$CELERY_BEAT" == "DOWN" ]] && DRIFT+=("Celery beat is DOWN.")
[[ "$API_CONTAINER" == "missing" ]] && DRIFT+=("Active-color API container (api-${ACTIVE_COLOR}) not found.")
if [[ "$API_HEALTH" != "200" ]]; then
  DRIFT+=("API health endpoint returned ${API_HEALTH} (expected 200).")
fi
if [[ "$CONTAINERS_RUNNING" =~ ^[0-9]+$ && "$CONTAINERS_RUNNING" -lt "$EXPECTED_CONTAINERS" ]]; then
  DRIFT+=("Only ${CONTAINERS_RUNNING}/${EXPECTED_CONTAINERS} expected containers running.")
fi

# Compare deployed SHAs against latest origin/main of each repo (network best-effort).
sha_drift() {
  local label="$1" dir="$2" deployed="$3" url remote_sha
  [[ "$deployed" == "unknown" || -z "$deployed" ]] && return 0
  url="$(git -C "$REPO_ROOT/$dir" config --get remote.origin.url 2>/dev/null || true)"
  [[ -n "$url" ]] || return 0
  remote_sha="$(timeout 10 git ls-remote "$url" refs/heads/main 2>/dev/null | awk '{print $1}' | head -1)"
  [[ -n "$remote_sha" ]] || return 0
  if [[ "$remote_sha" != "$deployed" ]]; then
    DRIFT+=("${label} active SHA ${deployed:0:7} != origin/main ${remote_sha:0:7}.")
  fi
}
sha_drift "API" "finance_manager_api" "$API_FULL_SHA"
sha_drift "Web" "finance_manager_web" "$WEB_FULL_SHA"

# --- Emit the live-state markdown block ----------------------------------------
TS="$(now_iso)"
cat <<EOF
## Live VPS State (SSH-verified)

**Captured:** $TS · **Host:** $SSH_TARGET · **Query latency:** ${LATENCY_MS}ms

| Field | Value |
|---|---|
| Active color | ${ACTIVE_COLOR:-unknown} |
| Active API SHA | ${API_SHA:-unknown} |
| Active Web SHA | ${WEB_SHA:-unknown} |
| Containers running | ${CONTAINERS_RUNNING:-0}/${EXPECTED_CONTAINERS} |
| Celery worker | ${CELERY_WORKER:-unknown} |
| Celery beat | ${CELERY_BEAT:-unknown} |
| Last migration applied | ${LAST_MIGRATION:-unknown} |
| API health | ${API_HEALTH:-000} |

### Container detail
EOF

if [[ -n "$CONTAINER_TABLE" ]]; then
  echo '```'
  printf '%s\n' "$CONTAINER_TABLE"
  echo '```'
else
  echo "_(no fm-beta containers reported)_"
fi

echo ""
echo "### Drift check"
if [[ ${#DRIFT[@]} -eq 0 ]]; then
  echo "_No drift detected._"
else
  for d in "${DRIFT[@]}"; do
    echo "- ⚠️ $d"
  done
fi

exit 0
