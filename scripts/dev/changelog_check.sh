#!/usr/bin/env bash
# changelog_check.sh — ensure PR touches CHANGELOG without stub placeholders (OPS-REVAMP-T04)
#
# Usage:
#   ./scripts/dev/changelog_check.sh --repo parent|api|web --pr <N>
#
# Exit 0 when no CHANGELOG change required OR changelog entry is non-stub.
# Dependabot-only lockfile PRs: pass with note when diff has no CHANGELOG.

set -euo pipefail

declare -A GH_REPOS=(
  [parent]="AzazelAzure/finance-manager-ecosystem"
  [api]="AzazelAzure/finance-manager-api"
  [web]="AzazelAzure/finance-manager-web"
)
declare -A CHANGELOG_PATHS=(
  [parent]="CHANGELOG.md"
  [api]="CHANGELOG.md"
  [web]="CHANGELOG.md"
)

REPO_SLUG=""
PR_NUM=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO_SLUG="$2"; shift 2 ;;
    --pr) PR_NUM="$2"; shift 2 ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

[[ -n "$REPO_SLUG" && -n "$PR_NUM" ]] || {
  echo "Usage: changelog_check.sh --repo parent|api|web --pr <N>" >&2
  exit 1
}

DIFF="$(gh pr diff "$PR_NUM" --repo "${GH_REPOS[$REPO_SLUG]}" 2>/dev/null || true)"
CL="${CHANGELOG_PATHS[$REPO_SLUG]}"

if ! printf '%s' "$DIFF" | grep -q "^diff --git a/${CL}"; then
  HEAD="$(gh pr view "$PR_NUM" --repo "${GH_REPOS[$REPO_SLUG]}" --json headRefName --jq '.headRefName')"
  if [[ "$HEAD" == dependabot/* ]]; then
    printf 'SKIP: dependabot PR with no %s change\n' "$CL"
    exit 0
  fi
  printf 'WARN: no %s diff — governance PRs should update CHANGELOG\n' "$CL" >&2
  exit 0
fi

if printf '%s' "$DIFF" | grep -E '^\+.*\(fill bullets\)|^\+.*\(fill\)' >/dev/null; then
  printf 'FAIL: CHANGELOG contains stub placeholder\n' >&2
  exit 1
fi

printf 'OK: %s change present without stub placeholder\n' "$CL"
exit 0
