#!/usr/bin/env bash
# read_parent_doc.sh — read a document from parent HFM repo (OPS-REVAMP-T05)
#
# Usage:
#   ./scripts/dev/read_parent_doc.sh <relative-path>
#   HFM_ROOT=/path/to/HFM ./scripts/dev/read_parent_doc.sh governance/plans/plan_registry.md
#
# stdout only; non-zero exit if missing.

set -euo pipefail

[[ $# -eq 1 ]] || {
  echo "Usage: read_parent_doc.sh <relative-path>" >&2
  exit 1
}

REL="${1#./}"
REL="${REL#/}"

if [[ "$REL" == *".."* ]]; then
  echo "ERROR: path traversal not allowed" >&2
  exit 1
fi

resolve_hfm_root() {
  if [[ -n "${HFM_ROOT:-}" && -f "${HFM_ROOT}/AGENTS.md" ]]; then
    printf '%s' "$HFM_ROOT"
    return 0
  fi
  if [[ -n "${FM_PRIMARY_WORKSPACE:-}" && -f "${FM_PRIMARY_WORKSPACE}/AGENTS.md" ]]; then
    printf '%s' "$FM_PRIMARY_WORKSPACE"
    return 0
  fi
  if [[ -f "$HOME/.fm_workspace.conf" ]]; then
    # shellcheck source=/dev/null
    source "$HOME/.fm_workspace.conf"
    if [[ -n "${FM_PRIMARY_WORKSPACE:-}" && -f "${FM_PRIMARY_WORKSPACE}/AGENTS.md" ]]; then
      printf '%s' "$FM_PRIMARY_WORKSPACE"
      return 0
    fi
  fi
  local script_dir repo_root
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  repo_root="$(cd "$script_dir/../.." && pwd)"
  if [[ -f "$repo_root/AGENTS.md" ]]; then
    printf '%s' "$repo_root"
    return 0
  fi
  return 1
}

HFM="$(resolve_hfm_root)" || {
  echo "ERROR: cannot resolve HFM root (set HFM_ROOT or FM_PRIMARY_WORKSPACE)" >&2
  exit 1
}

TARGET="$HFM/$REL"
[[ -f "$TARGET" ]] || {
  echo "ERROR: not found: $REL (resolved $TARGET)" >&2
  exit 1
}

cat "$TARGET"
