#!/usr/bin/env bash
# migration_preflight.sh — pre-deploy migration risk summary (OPS-REVAMP-T07)
#
# Usage:
#   ./scripts/dev/migration_preflight.sh --repo api [--pr <N>]
#   ./scripts/dev/migration_preflight.sh --path finance_manager_api/finance/migrations/00XX_*.py
#
# Static analysis of Django migrations for deploy evidence. Does not require DB when
# using --pr or --path; with --live uses `manage.py showmigrations --plan` in API container.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

REPO_SLUG=""
PR_NUM=""
MIG_PATH=""
LIVE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo) REPO_SLUG="$2"; shift 2 ;;
    --pr) PR_NUM="$2"; shift 2 ;;
    --path) MIG_PATH="$2"; shift 2 ;;
    --live) LIVE=1; shift ;;
    -h|--help)
      sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *) echo "Unknown: $1" >&2; exit 1 ;;
  esac
done

RISK=0

note() { printf '%s\n' "$1"; }
warn() { printf 'WARN: %s\n' "$1" >&2; RISK=1; }
hit() { printf 'RISK: %s\n' "$1"; RISK=2; }

collect_diff_text() {
  if [[ -n "$MIG_PATH" && -f "$REPO_ROOT/$MIG_PATH" ]]; then
    cat "$REPO_ROOT/$MIG_PATH"
    return 0
  fi
  if [[ -n "$PR_NUM" && "$REPO_SLUG" == "api" ]]; then
    gh pr diff "$PR_NUM" --repo AzazelAzure/finance-manager-api 2>/dev/null || true
    return 0
  fi
  if [[ -d "$REPO_ROOT/finance_manager_api/finance/migrations" ]]; then
    find "$REPO_ROOT/finance_manager_api/finance/migrations" -name '*.py' ! -name '__init__.py' -print0 \
      | xargs -0 cat 2>/dev/null || true
  fi
}

TEXT="$(collect_diff_text)"

if [[ -z "${TEXT//[$' \t\n']/}" ]]; then
  note 'NONE: no migration content to analyze'
  exit 0
fi

note '=== migration_preflight summary ==='

if printf '%s' "$TEXT" | grep -qE 'migrations\.(AddField|AlterField)'; then
  if printf '%s' "$TEXT" | grep -qE 'null=False' && ! printf '%s' "$TEXT" | grep -qE 'default='; then
    hit 'AddField/AlterField with null=False and no default — data risk on existing rows'
  fi
fi

for op in RemoveField DeleteModel RenameField AlterUniqueTogether RunSQL RunPython; do
  if printf '%s' "$TEXT" | grep -q "migrations.${op}"; then
    warn "Operation ${op} present — verify reversibility and blue-green safety"
  fi
done

if printf '%s' "$TEXT" | grep -qiE 'unique=True|UniqueConstraint|AlterUniqueTogether'; then
  warn 'Uniqueness constraint change — check for duplicate data before deploy'
fi

if printf '%s' "$TEXT" | grep -qE 'RunPython'; then
  if ! printf '%s' "$TEXT" | grep -qE 'reverse_code|migrations\.RunPython\([^)]*reverse'; then
    warn 'RunPython without obvious reverse_code — rollback may be incomplete'
  fi
fi

if [[ "$LIVE" -eq 1 && -x "$REPO_ROOT/scripts/local-stack/fm_docker.sh" ]]; then
  note '--- live showmigrations (container) ---'
  if "$REPO_ROOT/scripts/local-stack/fm_docker.sh" status 2>/dev/null | grep -q 'api'; then
    podman exec fm-beta_api-blue_1 python manage.py showmigrations --plan 2>/dev/null \
      | tail -20 || warn 'showmigrations failed in api-blue container'
  else
    warn '--live requested but API container not detected'
  fi
fi

if [[ "$RISK" -ge 2 ]]; then
  note 'VERDICT: NEEDS_HITM (high migration risk)'
  exit 2
elif [[ "$RISK" -eq 1 ]]; then
  note 'VERDICT: REVIEW (warnings present)'
  exit 1
fi

note 'VERDICT: OK'
exit 0
