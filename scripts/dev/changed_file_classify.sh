#!/usr/bin/env bash
# changed_file_classify.sh — suggest area labels from PR diff (OPS-REVAMP-T04)
#
# Usage:
#   ./scripts/dev/changed_file_classify.sh --repo parent|api|web --pr <N>
#
# Prints LABEL: <name> lines for GH Action or human triage.

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
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

[[ -n "$REPO_SLUG" && -n "$PR_NUM" ]] || {
  echo "Usage: changed_file_classify.sh --repo parent|api|web --pr <N>" >&2
  exit 1
}

DIFF="$(gh pr diff "$PR_NUM" --repo "${GH_REPOS[$REPO_SLUG]}" 2>/dev/null || true)"
FILES="$(printf '%s' "$DIFF" | sed -n 's/^diff --git a\/\([^ ]*\).*/\1/p')"

emit_if() {
  local label="$1" pattern="$2"
  if printf '%s\n' "$FILES" | grep -qiE "$pattern"; then
    printf 'LABEL: %s\n' "$label"
  fi
}

emit_if "area:auth" '(auth|login|jwt|oauth|allauth|permission)'
emit_if "area:migration" '(migrations/|/migration)'
emit_if "area:payment" '(payment|transaction|source|spend_account)'
emit_if "area:deploy" '(deploy/|docker|compose|fm_server|fm_docker|vps)'
emit_if "requires-semantic-review" '(AGENTS\.md|governance/|\.cursor/rules|codex_review|ws_review|submodule)'

if printf '%s\n' "$FILES" | grep -qiE '(auth|migration|payment|deploy|governance|codex_review)'; then
  printf 'LABEL: requires-semantic-review\n'
fi

exit 0
