#!/usr/bin/env bash
# migration_summary.sh — summarize Django migrations in API PR diff (CODEX-REVIEW-T7)
#
# Usage:
#   ./scripts/dev/migration_summary.sh --repo api --pr <N>
#
# Lists migration files and operation hints from diff. Non-api repos: no-op pass.

set -euo pipefail

declare -A GH_REPOS=([api]="AzazelAzure/finance-manager-api")

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
  echo "Usage: migration_summary.sh --repo api --pr <N>" >&2
  exit 1
}

if [[ "$REPO_SLUG" != "api" ]]; then
  printf 'SKIP: migration_summary applies to api repo only\n'
  exit 0
fi

DIFF="$(gh pr diff "$PR_NUM" --repo "${GH_REPOS[api]}" 2>/dev/null || true)"
MIGS="$(printf '%s' "$DIFF" | sed -n 's|^diff --git a/\([^ ]*migrations/[^ ]*\).*|\1|p' | sort -u)"

if [[ -z "$MIGS" ]]; then
  printf 'NONE: no migration files in diff\n'
  exit 0
fi

printf '%s\n' "$MIGS" | while read -r f; do
  [[ -z "$f" ]] && continue
  printf 'MIGRATION: %s\n' "$f"
done

for op in AddField RemoveField AlterField RunPython DeleteModel RenameField; do
  if printf '%s' "$DIFF" | grep -q "migrations\..*${op}"; then
    printf 'OP: %s\n' "$op"
  fi
done

if printf '%s' "$DIFF" | grep -qE 'RunPython|RunSQL'; then
  printf 'WARN: data migration — verify reversibility\n'
fi

exit 0
