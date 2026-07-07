#!/usr/bin/env bash
# pr_body_contract.sh — validate PR body governance fields (OPS-REVAMP-T04)
#
# Usage:
#   ./scripts/dev/pr_body_contract.sh --repo parent|api|web --pr <N>
#
# Exit 0 when Plan ID, anomaly disposition, and validation evidence present.

set -euo pipefail

declare -A GH_REPOS=(
  [parent]="AzazelAzure/finance-manager-ecosystem"
  [api]="AzazelAzure/finance-manager-api"
  [web]="AzazelAzure/finance-manager-web"
)

REPO_SLUG=""
PR_NUM=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO_SLUG="$2"; shift 2 ;;
    --pr) PR_NUM="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

[[ -n "$REPO_SLUG" && -n "$PR_NUM" ]] || {
  echo "Usage: pr_body_contract.sh --repo parent|api|web --pr <N>" >&2
  exit 1
}

BODY="$(gh pr view "$PR_NUM" --repo "${GH_REPOS[$REPO_SLUG]}" --json body --jq '.body // ""')"
FAIL=0

check_field() {
  local name="$1" pattern="$2"
  if printf '%s' "$BODY" | grep -qiE "$pattern"; then
    printf 'OK: %s\n' "$name"
  else
    printf 'FAIL: missing %s\n' "$name" >&2
    FAIL=1
  fi
}

check_field "Plan ID" 'plan[ _-]*id'
check_field "Anomaly disposition" 'anomaly disposition'
check_field "Validation evidence" 'test plan|validation|## test'

exit "$FAIL"
