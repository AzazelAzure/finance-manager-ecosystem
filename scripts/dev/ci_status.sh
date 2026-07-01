#!/usr/bin/env bash
# ci_status.sh — latest GitHub Actions run for ecosystem repos
#
# Usage:
#   ./scripts/dev/ci_status.sh
#   ./scripts/dev/ci_status.sh --repo api
#   ./scripts/dev/ci_status.sh --branch main

set -euo pipefail

REPO_FILTER=""
BRANCH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO_FILTER="$2"; shift 2 ;;
    --branch) BRANCH="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

declare -A GH_REPOS=(
  [parent]="AzazelAzure/finance-manager-ecosystem"
  [api]="AzazelAzure/finance-manager-api"
  [web]="AzazelAzure/finance-manager-web"
)

show_one() {
  local label="$1"
  local gh_repo="${GH_REPOS[$label]}"
  local args=(run list --repo "$gh_repo" --limit 3)
  [[ -n "$BRANCH" ]] && args+=(--branch "$BRANCH")
  echo "=== $label ($gh_repo) ==="
  gh "${args[@]}" 2>/dev/null || echo "(gh unavailable)"
  echo ""
}

if [[ -n "$REPO_FILTER" ]]; then
  show_one "$REPO_FILTER"
else
  for label in parent api web; do
    show_one "$label"
  done
fi
