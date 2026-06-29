#!/usr/bin/env bash
# Unit tests for lib_anomaly_write.sh (T04) — no full audit scan required.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_ROOT=$(mktemp -d)
trap 'rm -rf "$TEST_ROOT"' EXIT

export REPO_ROOT="$TEST_ROOT"
mkdir -p "$REPO_ROOT/strategy/anomalies"

# shellcheck source=lib_anomaly_write.sh
source "$SCRIPT_DIR/lib_anomaly_write.sh"

fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; }

# LOW severity should not create a file
before=$(find "$REPO_ROOT/strategy/anomalies" -name '*security-audit*' | wc -l)
write_security_anomaly "bandit" "low" "test-low" "low finding" "$REPO_ROOT"
after=$(find "$REPO_ROOT/strategy/anomalies" -name '*security-audit*' | wc -l)
[[ "$before" -eq "$after" ]] || fail "LOW finding created anomaly file"
pass "LOW findings skipped"

# HIGH creates file with correct naming
write_security_anomaly "bandit" "high" "hardcoded-password" "test high finding" "$REPO_ROOT"
f=$(find "$REPO_ROOT/strategy/anomalies" -name '*security-audit_bandit_hardcoded-password.md' | head -1)
[[ -n "$f" ]] || fail "HIGH finding did not create anomaly file"
grep -q 'agent: run_audit.sh' "$f" || fail "missing agent frontmatter"
grep -q 'status: unreviewed' "$f" || fail "missing status frontmatter"
grep -q 'severity_guess: high' "$f" || fail "missing severity"
pass "HIGH finding creates formatted anomaly"

# Duplicate slug updates logged date instead of new file
count_before=$(find "$REPO_ROOT/strategy/anomalies" -name '*security-audit_bandit_hardcoded-password.md' | wc -l)
write_security_anomaly "bandit" "high" "hardcoded-password" "updated finding" "$REPO_ROOT"
count_after=$(find "$REPO_ROOT/strategy/anomalies" -name '*security-audit_bandit_hardcoded-password.md' | wc -l)
[[ "$count_before" -eq "$count_after" ]] || fail "duplicate slug created second file"
pass "duplicate slug updates existing file"

# bandit parser: LOW-only output produces no anomalies
LOW_BANDIT='>> Issue: Try except pass
   Severity: Low   Confidence: High
   Location: finance/foo.py:10'
parse_bandit_anomalies "$LOW_BANDIT"
low_count=$(find "$REPO_ROOT/strategy/anomalies" -name '*security-audit_bandit_*' | wc -l)
[[ "$low_count" -eq 1 ]] || fail "LOW bandit block created extra anomaly (expected only prior HIGH)"
pass "bandit LOW-only parser skips"

# bandit parser: MEDIUM creates anomaly
MED_BANDIT='>> Issue: Use of insecure function
   Severity: Medium   Confidence: Medium
   Location: finance/bar.py:42'
parse_bandit_anomalies "$MED_BANDIT"
med_file=$(find "$REPO_ROOT/strategy/anomalies" -name '*security-audit_bandit_finance-bar-py-42*' | head -1)
[[ -n "$med_file" ]] || fail "MEDIUM bandit finding not filed"
pass "bandit MEDIUM parser files anomaly"

echo ""
echo "All anomaly integration unit tests passed."
