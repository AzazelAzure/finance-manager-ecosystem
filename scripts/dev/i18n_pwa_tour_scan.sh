#!/usr/bin/env bash
# i18n_pwa_tour_scan.sh — web PR signals for PWA/tour/i18n coverage (CODEX-REVIEW-T7)
#
# Usage:
#   ./scripts/dev/i18n_pwa_tour_scan.sh --repo web --pr <N>
#
# Signals only — reviewer applies judgment.

set -euo pipefail

declare -A GH_REPOS=([web]="AzazelAzure/finance-manager-web")

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
  echo "Usage: i18n_pwa_tour_scan.sh --repo web --pr <N>" >&2
  exit 1
}

if [[ "$REPO_SLUG" != "web" ]]; then
  printf 'SKIP: i18n_pwa_tour_scan applies to web repo only\n'
  exit 0
fi

DIFF="$(gh pr diff "$PR_NUM" --repo "${GH_REPOS[web]}" 2>/dev/null || true)"
FILES="$(printf '%s' "$DIFF" | sed -n 's/^diff --git a\/\([^ ]*\).*/\1/p')"

emit_if_files() {
  local label="$1" pattern="$2"
  if printf '%s\n' "$FILES" | grep -qiE "$pattern"; then
    printf 'SIGNAL: %s\n' "$label"
  fi
}

emit_if_files "user-facing-components" '(src/.*\.(tsx|jsx)$|components/)'
emit_if_files "routes-touched" '(src/.*routes|App\.tsx|router)'
emit_if_files "i18n-files" '(locales/|i18n|useTranslation|t\()'
emit_if_files "tour-files" '(tour|guide|walkthrough|help-mode|HelpMode)'
emit_if_files "pwa-files" '(service-worker|sw\.|pwa|offline|workbox|manifest)'

if printf '%s' "$DIFF" | grep -qE '^\+.*["'\''`][A-Za-z][^"'\'']{8,}["'\''`]'; then
  printf 'SIGNAL: new-literal-strings (check i18n)\n'
fi

if printf '%s\n' "$FILES" | grep -qiE 'src/.*\.(tsx|jsx)$' \
  && ! printf '%s\n' "$FILES" | grep -qiE '(tour|guide|walkthrough|help-mode)'; then
  printf 'WARN: component changes without tour/guide path in diff\n'
fi

exit 0
