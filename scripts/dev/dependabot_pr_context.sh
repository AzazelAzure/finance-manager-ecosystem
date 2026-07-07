#!/usr/bin/env bash
# dependabot_pr_context.sh — Dependabot PR metadata for Codex dependabot mode (CODEX-REVIEW-T7)
#
# Usage:
#   ./scripts/dev/dependabot_pr_context.sh --repo parent|api|web --pr <N>

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
      sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

[[ -n "$REPO_SLUG" && -n "$PR_NUM" ]] || {
  echo "Usage: dependabot_pr_context.sh --repo parent|api|web --pr <N>" >&2
  exit 1
}

GH="${GH_REPOS[$REPO_SLUG]}"
META="$(gh pr view "$PR_NUM" --repo "$GH" --json title,body,headRefName,author --jq '.')"
HEAD="$(printf '%s' "$META" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("headRefName",""))')"
AUTHOR="$(printf '%s' "$META" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("author",{}).get("login",""))')"
TITLE="$(printf '%s' "$META" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("title",""))')"
BODY="$(printf '%s' "$META" | python3 -c 'import json,sys; print(json.load(sys.stdin).get("body") or "")')"

printf 'head_ref: %s\n' "$HEAD"
printf 'author: %s\n' "$AUTHOR"
printf 'title: %s\n' "$TITLE"

if [[ "$HEAD" != dependabot/* && "$AUTHOR" != "dependabot[bot]" ]]; then
  printf 'NOTE: not a dependabot PR\n'
fi

printf '%s' "$BODY" | grep -iE '^(Bumps|Updates|Package|Dependency|CVE|GHSA|critical|high)' || true

DIFF="$(gh pr diff "$PR_NUM" --repo "$GH" 2>/dev/null || true)"
if printf '%s' "$DIFF" | grep -q '^diff --git' \
  && ! printf '%s' "$DIFF" | grep -vqE '^(uv\.lock|package-lock\.json|yarn\.lock|poetry\.lock|Cargo\.lock)'; then
  printf 'LOCKFILE_ONLY: likely yes\n'
else
  FILES="$(printf '%s' "$DIFF" | sed -n 's/^diff --git a\/\([^ ]*\).*/\1/p' | wc -l)"
  printf 'CHANGED_FILES: %s\n' "$FILES"
fi

if printf '%s' "$BODY" | grep -qiE 'critical|high severity'; then
  printf 'ADVISORY: high-or-critical mentioned\n'
fi

exit 0
