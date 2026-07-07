#!/usr/bin/env bash
# codex_review_resolve_mode.sh — pick codex_review --mode for a PR (CODEX-REVIEW-T2)
#
# Usage:
#   ./scripts/lib/codex_review_resolve_mode.sh --repo parent|api|web --pr <N> [--head <branch>]

set -euo pipefail

declare -A GH_REPOS=(
  [parent]="AzazelAzure/finance-manager-ecosystem"
  [api]="AzazelAzure/finance-manager-api"
  [web]="AzazelAzure/finance-manager-web"
)

REPO_SLUG=""
PR_NUM=""
HEAD_REF=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO_SLUG="$2"; shift 2 ;;
    --pr) PR_NUM="$2"; shift 2 ;;
    --head) HEAD_REF="$2"; shift 2 ;;
    -h|--help)
      sed -n '2,6p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

[[ -n "$REPO_SLUG" && -n "$PR_NUM" ]] || {
  echo "Usage: codex_review_resolve_mode.sh --repo parent|api|web --pr <N>" >&2
  exit 1
}

GH="${GH_REPOS[$REPO_SLUG]}"
if [[ -z "$HEAD_REF" ]]; then
  HEAD_REF="$(gh pr view "$PR_NUM" --repo "$GH" --json headRefName --jq '.headRefName' 2>/dev/null || true)"
fi

if [[ "$HEAD_REF" == dependabot/* ]]; then
  printf 'dependabot\n'
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRIMARY="$(cd "$SCRIPT_DIR/../.." && pwd)"
CLASSIFY="$("$PRIMARY/scripts/dev/changed_file_classify.sh" --repo "$REPO_SLUG" --pr "$PR_NUM" 2>/dev/null || true)"
DIFF="$(gh pr diff "$PR_NUM" --repo "$GH" 2>/dev/null || true)"

if [[ "$REPO_SLUG" == "parent" ]]; then
  sub_only=1
  if printf '%s' "$DIFF" | grep -qE '^diff --git a/(finance_manager_|design_docs)'; then
    :
  else
    sub_only=0
  fi
  if [[ "$sub_only" -eq 1 ]] \
    && printf '%s' "$DIFF" | grep -qE 'Subproject commit|^[-+]{3} [a-f0-9]{7,40}'; then
    if ! printf '%s' "$DIFF" | grep -qE '^diff --git a/(CHANGELOG|governance/|scripts/|\.cursor/|\.github/)'; then
      printf 'submodule-bump\n'
      exit 0
    fi
  fi
fi

if printf '%s' "$CLASSIFY" | grep -q 'requires-semantic-review'; then
  printf 'governance\n'
  exit 0
fi

if [[ "$HEAD_REF" == cur/s1b/chore/* || "$HEAD_REF" == cla/s1b/* ]]; then
  printf 'chore\n'
  exit 0
fi

printf 'implementation\n'
