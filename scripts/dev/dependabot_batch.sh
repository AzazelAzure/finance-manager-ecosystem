#!/usr/bin/env bash
# dependabot_batch.sh — list open Dependabot PRs for api/web
#
# Usage:
#   ./scripts/dev/dependabot_batch.sh
#   ./scripts/dev/dependabot_batch.sh --repo api

set -euo pipefail

TARGET="all"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) TARGET="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,7p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

list_repo() {
  local gh_repo="$1"
  local label="$2"
  echo "=== $label ($gh_repo) ==="
  if ! gh pr list --repo "$gh_repo" --state open --author "app/dependabot" \
    --json number,title,headRefName,createdAt,mergeable \
    --template '{{range .}}#{{.number}}	{{.mergeable}}	{{.headRefName}}	{{.title}}{{"\n"}}{{end}}' 2>/dev/null; then
    gh pr list --repo "$gh_repo" --state open 2>/dev/null \
      | grep -i dependabot || echo "(no dependabot PRs or gh unavailable)"
  fi
  echo ""
}

case "$TARGET" in
  api) list_repo "AzazelAzure/finance-manager-api" "api" ;;
  web) list_repo "AzazelAzure/finance-manager-web" "web" ;;
  all)
    list_repo "AzazelAzure/finance-manager-api" "api"
    list_repo "AzazelAzure/finance-manager-web" "web"
    ;;
  *) echo "Unknown --repo: $TARGET (use api|web|all)" >&2; exit 1 ;;
esac
