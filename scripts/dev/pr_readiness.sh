#!/usr/bin/env bash
# pr_readiness.sh — merge-gate snapshot for one or all active repos
#
# Usage:
#   ./scripts/dev/pr_readiness.sh
#   ./scripts/dev/pr_readiness.sh --repo api
#   ./scripts/dev/pr_readiness.sh --repo web --branch cur/s1b/feat/foo
#   ./scripts/dev/pr_readiness.sh --pr 42 --repo api

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

REPO_FILTER=""
BRANCH=""
PR_NUM=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO_FILTER="$2"; shift 2 ;;
    --branch) BRANCH="$2"; shift 2 ;;
    --pr) PR_NUM="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'
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

declare -A DIRS=(
  [parent]="."
  [api]="finance_manager_api"
  [web]="finance_manager_web"
)

check_one() {
  local label="$1"
  local gh_repo="${GH_REPOS[$label]}"
  local dir="${DIRS[$label]}"
  local pr_arg=()

  echo "=== $label ($gh_repo) ==="

  if [[ -n "$PR_NUM" ]]; then
    pr_arg=(--pr "$PR_NUM")
  elif [[ -n "$BRANCH" ]]; then
    pr_arg=(--branch "$BRANCH")
  else
    local head
    head="$(git -C "$REPO_ROOT/$dir" branch --show-current 2>/dev/null || echo "")"
    [[ -n "$head" && "$head" != "main" && "$head" != "master" ]] && pr_arg=(--branch "$head")
  fi

  if [[ ${#pr_arg[@]} -eq 0 ]]; then
    gh pr list --repo "$gh_repo" --state open --limit 5 2>/dev/null || echo "(gh unavailable)"
    echo ""
    return
  fi

  if [[ -n "$PR_NUM" ]]; then
    gh pr view "$PR_NUM" --repo "$gh_repo" \
      --json number,url,title,state,mergeable,mergeStateStatus,reviewDecision,statusCheckRollup,headRefName,baseRefName \
      2>/dev/null | python3 -c "
import json,sys
d=json.load(sys.stdin)
print(f\"  PR     : #{d.get('number')} {d.get('title','')}\")
print(f\"  URL    : {d.get('url')}\")
print(f\"  State  : {d.get('state')} | mergeable={d.get('mergeable')} | mergeState={d.get('mergeStateStatus')}\")
print(f\"  Review : {d.get('reviewDecision')}\")
print(f\"  Branch : {d.get('headRefName')} -> {d.get('baseRefName')}\")
scr=d.get('statusCheckRollup') or []
if scr:
  for c in scr:
    print(f\"  Check  : {c.get('name')} = {c.get('conclusion') or c.get('status')}\")
" || echo "  (could not load PR)"
  else
    gh pr view "${pr_arg[@]}" --repo "$gh_repo" \
      --json number,url,title,state,mergeable,mergeStateStatus,reviewDecision,statusCheckRollup,headRefName,baseRefName \
      2>/dev/null | python3 -c "
import json,sys
d=json.load(sys.stdin)
print(f\"  PR     : #{d.get('number')} {d.get('title','')}\")
print(f\"  URL    : {d.get('url')}\")
print(f\"  State  : {d.get('state')} | mergeable={d.get('mergeable')} | mergeState={d.get('mergeStateStatus')}\")
print(f\"  Review : {d.get('reviewDecision')}\")
print(f\"  Branch : {d.get('headRefName')} -> {d.get('baseRefName')}\")
scr=d.get('statusCheckRollup') or []
if scr:
  for c in scr:
    print(f\"  Check  : {c.get('name')} = {c.get('conclusion') or c.get('status')}\")
" || echo "  (no open PR for branch)"
  fi
  echo ""
}

if [[ -n "$REPO_FILTER" ]]; then
  check_one "$REPO_FILTER"
else
  for label in parent api web; do
    check_one "$label"
  done
fi
