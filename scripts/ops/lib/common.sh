#!/usr/bin/env bash
# Shared helpers for scripts/ops/*.sh — repo root and dry-run helpers.
# Caller must set SERVER_SCRIPT_DIR to the scripts/ops directory before sourcing.
# shellcheck shell=bash

set -u

: "${SERVER_SCRIPT_DIR:?SERVER_SCRIPT_DIR must be set before sourcing common.sh}"

if [[ -n "${FM_WORKSPACE_ROOT:-}" ]]; then
  REPO_ROOT="$(cd "${FM_WORKSPACE_ROOT}" && pwd)"
elif [[ -n "${FM_WORKSPACE:-}" ]]; then
  REPO_ROOT="$(cd "${FM_WORKSPACE}" && pwd)"
else
  REPO_ROOT="$(cd "${SERVER_SCRIPT_DIR}/../.." && pwd)"
fi

FM_DRY_RUN="${FM_DRY_RUN:-0}"

fm_is_dry_run() {
  [[ "$FM_DRY_RUN" == "1" || "$FM_DRY_RUN" == "true" ]]
}

fm_log() {
  printf '%s\n' "$*"
}

fm_die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}
