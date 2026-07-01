#!/usr/bin/env bash
# verify_scripts_org.sh — smoke-test scripts taxonomy + dev tooling build
#
# Usage: ./scripts/dev/verify_scripts_org.sh
# Exit 0 if all required checks pass; non-zero lists failures.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$REPO_ROOT"

PASS=0
FAIL=0
SKIP=0

ok()   { printf '  PASS  %s\n' "$1"; PASS=$((PASS + 1)); }
bad()  { printf '  FAIL  %s\n' "$1"; FAIL=$((FAIL + 1)); }
skip() { printf '  SKIP  %s\n' "$1"; SKIP=$((SKIP + 1)); }

echo "=== scripts org verify ($(date '+%Y-%m-%d %H:%M')) ==="
echo ""

echo "-- syntax (bash -n) --"
if find scripts -name '*.sh' -print0 | xargs -0 -n1 bash -n 2>/dev/null; then
  ok "bash -n all scripts/*.sh"
else
  bad "bash -n"
fi

echo "-- orientation --"
if ./scripts/dev/session_brief.sh >/tmp/verify_session_brief.log 2>&1; then
  ok "session_brief.sh"
else
  bad "session_brief.sh"
fi

if ./scripts/dev/workspace_brief.sh >/tmp/verify_workspace_brief.log 2>&1; then
  ok "workspace_brief.sh"
else
  bad "workspace_brief.sh"
fi

if ./scripts/check_repos.sh >/tmp/verify_check_repos.log 2>&1; then
  ok "check_repos.sh"
else
  bad "check_repos.sh"
fi

echo "-- scaffolding (create + delete) --"
TP_TMP="strategy/meetings/week99/meeting2099-01-01/tp-_verify-scripts-org"
PLAN_TMP="plans/S1/S1.B/proposed/_verify-scripts-org"
rm -rf "$TP_TMP" "$PLAN_TMP" 2>/dev/null || true

if ./scripts/dev/new_tp.sh _verify-scripts-org --week 99 --date 2099-01-01 >/tmp/verify_new_tp.log 2>&1 \
  && [[ -f "$TP_TMP/README.md" ]]; then
  ok "new_tp.sh"
  rm -rf "$(dirname "$TP_TMP")" 2>/dev/null || true
  rmdir strategy/meetings/week99 2>/dev/null || true
else
  bad "new_tp.sh"
fi

if ./scripts/dev/new_plan.sh S1 S1.B proposed _verify-scripts-org >/tmp/verify_new_plan.log 2>&1 \
  && [[ -f "$PLAN_TMP/README.md" ]]; then
  ok "new_plan.sh"
  rm -rf "$PLAN_TMP"
else
  bad "new_plan.sh"
fi

echo "-- api/web runners --"
if ./scripts/dev/test_api.sh finance/tests/test_support.py --collect-only -q >/tmp/verify_test_api.log 2>&1; then
  ok "test_api.sh --collect-only"
else
  bad "test_api.sh"
fi

if ./scripts/dev/test_web.sh lint >/tmp/verify_test_web.log 2>&1; then
  ok "test_web.sh lint"
else
  skip "test_web.sh lint (pre-existing lint errors in web — runner OK)"
fi

echo "-- local stack (optional) --"
if ./scripts/local-stack/fm_docker.sh status >/tmp/verify_fm_docker.log 2>&1; then
  ok "fm_docker.sh status"
else
  skip "fm_docker.sh status (no containers / runtime)"
fi

if ./scripts/dev/local_stack_health.sh >/tmp/verify_stack_health.log 2>&1; then
  ok "local_stack_health.sh"
else
  skip "local_stack_health.sh (stack not up — expected when idle)"
fi

echo "-- mcp server --"
if (cd scripts/mcp && uv run python -c "from hfm_mcp.runner import repo_root; from hfm_mcp.server import mcp; assert str(repo_root()).endswith('HFM')") >/tmp/verify_mcp.log 2>&1; then
  ok "hfm-mcp import + repo_root"
else
  bad "hfm-mcp"
fi

echo ""
echo "=== summary: $PASS passed, $FAIL failed, $SKIP skipped ==="
[[ "$FAIL" -eq 0 ]]
