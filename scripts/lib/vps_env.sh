#!/usr/bin/env bash
# Shared VPS SSH target resolution for ops/dev scripts.
# Source after REPO_ROOT is set. Exports FM_SPRINT_SSH / VPS_ORIGIN_IP from
# repo-root .env (allowlist only — not full shell source).
#
# Usage:
#   REPO_ROOT="$(cd ... && pwd)"
#   # shellcheck source=../lib/vps_env.sh
#   source "$REPO_ROOT/scripts/lib/vps_env.sh"
#   ssh "$VPS_SSH_TARGET" ...

vps_load_local_env() {
  local env_file="${REPO_ROOT}/.env"
  [[ -f "$env_file" ]] || return 0

  local key value
  while IFS='=' read -r key value || [[ -n "$key" ]]; do
    key="${key#"${key%%[![:space:]]*}"}"
    key="${key%"${key##*[![:space:]]}"}"
    [[ -z "$key" || "$key" == \#* ]] && continue

    case "$key" in
      FM_SPRINT_SSH|VPS_ORIGIN_IP|FM_SPRINT_REMOTE_ROOT)
        [[ -n "${!key+x}" ]] && continue
        value="${value#"${value%%[![:space:]]*}"}"
        value="${value%"${value##*[![:space:]]}"}"
        value="${value%\"}"; value="${value#\"}"
        value="${value%\'}"; value="${value#\'}"
        export "$key=$value"
        ;;
    esac
  done < "$env_file"
}

vps_load_local_env
FM_SPRINT_SSH="${FM_SPRINT_SSH:-${VPS_ORIGIN_IP:+dev@$VPS_ORIGIN_IP}}"
VPS_SSH_TARGET="${FM_SPRINT_SSH:-dev@<VPS_HOST_OR_IP>}"
