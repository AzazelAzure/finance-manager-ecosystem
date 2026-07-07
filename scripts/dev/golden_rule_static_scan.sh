#!/usr/bin/env bash
# golden_rule_static_scan.sh — static heuristics for Golden Rule blockers (CODEX-REVIEW-T7)
#
# Usage:
#   ./scripts/dev/golden_rule_static_scan.sh --repo parent|api|web --pr <N>
#
# Prints HIT: lines for grepable patterns in PR diff. Signals only — not final verdict.

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
      sed -n '2,8p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

[[ -n "$REPO_SLUG" && -n "$PR_NUM" ]] || {
  echo "Usage: golden_rule_static_scan.sh --repo parent|api|web --pr <N>" >&2
  exit 1
}

DIFF="$(gh pr diff "$PR_NUM" --repo "${GH_REPOS[$REPO_SLUG]}" 2>/dev/null || true)"

scan() {
  local label="$1" pattern="$2"
  if printf '%s' "$DIFF" | grep -qiE "$pattern"; then
    printf 'HIT: %s\n' "$label"
  fi
}

scan "changelog-stub" '\(fill bullets\)'
scan "todo-hack" '^\+.*\b(TODO|FIXME|HACK)\b'
scan "unknown-source" '^\+.*["'\'']Unknown["'\'']'
scan "source-id-fk" '^\+.*\bsource_id\b'
scan "allow-any" '^\+.*AllowAny'
scan "raw-sql" '^\+.*(raw\(|\.raw\(|execute\()'
scan "dangerous-html" '^\+.*dangerouslySetInnerHTML'
scan "hardcoded-secret" '^\+.*(SECRET_KEY|API_KEY|password)\s*=\s*["'\''][^"'\'']+["'\'']'
scan "compat-shim" '^\+.*(backwards?.compat|compat shim|re-export)'

exit 0
