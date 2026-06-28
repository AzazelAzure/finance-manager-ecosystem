# T02 — Main Audit Script

## End State

`scripts/security/run_audit.sh` runs all 5 tools across all repos, collects output, and writes a structured Markdown report to `strategy/security/audit_YYYY-MM-DD.md`. Each tool section shows findings count + full output. Script exits 0 even if findings exist — non-zero only on tool crash or missing prerequisite.

## Acceptance Criteria

1. [V1] `./scripts/security/run_audit.sh` completes without crashing on a clean repo
2. [V1] Output file created at `strategy/security/audit_$(date +%Y-%m-%d).md`
3. [V1] Output file contains a section for each of the 5 tools with finding count in the header
4. [V1] Script calls `check_tools.sh` first and aborts if it exits non-zero
5. [V1] gitleaks scans full git history on all 3 repos (`finance_manager_api`, `finance_manager_web`, parent)
6. [V1] semgrep uses `p/owasp-top-ten` ruleset (not auto-selected defaults — explicit ruleset only)
7. [V1] Script is runnable from parent repo root
8. [V1] `strategy/security/` directory created if it doesn't exist

## Scope Lock

### Files to create
- `scripts/security/run_audit.sh`
- `scripts/security/.semgrepignore` (suppress known non-issues in vendor dirs)
- `scripts/security/.gitleaksignore` (suppress known FPs in test fixtures)

### Files NOT to touch
- `check_tools.sh` from T01
- Any submodule source files

## Slices

### T02.SL1 — Script skeleton and report header

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
API_DIR="$REPO_ROOT/finance_manager_api"
WEB_DIR="$REPO_ROOT/finance_manager_web"
SECURITY_DIR="$REPO_ROOT/strategy/security"
REPORT="$SECURITY_DIR/audit_$(date +%Y-%m-%d).md"

# Prereq check
"$REPO_ROOT/scripts/security/check_tools.sh" || exit 1

mkdir -p "$SECURITY_DIR"

{
  echo "# Security Audit Report — $(date +%Y-%m-%d)"
  echo ""
  echo "**Generated:** $(date '+%Y-%m-%d %H:%M %Z')"
  echo "**Repos scanned:** finance_manager_api, finance_manager_web, parent"
  echo ""
  echo "---"
  echo ""
} > "$REPORT"
```

### T02.SL2 — bandit (Python SAST)

```bash
BANDIT_OUT=$(cd "$API_DIR" && .venv/bin/bandit -r finance/ --format txt -ll 2>&1 || true)
BANDIT_COUNT=$(echo "$BANDIT_OUT" | grep -c "^>> Issue" || echo 0)

{
  echo "## bandit — Python SAST ($BANDIT_COUNT issues)"
  echo '```'
  echo "$BANDIT_OUT"
  echo '```'
  echo ""
} >> "$REPORT"
```

Flag `-ll` = LOW and above (includes LOW, MEDIUM, HIGH). Do not suppress LOW — report everything, let triage decide.

### T02.SL3 — pip-audit (Python dependency CVEs)

```bash
PIPAUDIT_OUT=$(cd "$API_DIR" && .venv/bin/pip-audit 2>&1 || true)
PIPAUDIT_COUNT=$(echo "$PIPAUDIT_OUT" | grep -c "^.*GHSA-\|^.*CVE-" || echo 0)

{
  echo "## pip-audit — Python Dependency CVEs ($PIPAUDIT_COUNT vulnerabilities)"
  echo '```'
  echo "$PIPAUDIT_OUT"
  echo '```'
  echo ""
} >> "$REPORT"
```

### T02.SL4 — npm audit (Node dependency CVEs)

```bash
NPM_OUT=$(cd "$WEB_DIR" && npm audit --json 2>&1 || true)
NPM_COUNT=$(echo "$NPM_OUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('metadata',{}).get('vulnerabilities',{}).get('total',0))" 2>/dev/null || echo "parse error")

{
  echo "## npm audit — Node Dependency CVEs ($NPM_COUNT vulnerabilities)"
  echo '```'
  cd "$WEB_DIR" && npm audit 2>&1 || true
  echo '```'
  echo ""
} >> "$REPORT"
```

### T02.SL5 — gitleaks (secrets in git history)

Scan all 3 repos with full history:

```bash
for SCAN_DIR in "$REPO_ROOT" "$API_DIR" "$WEB_DIR"; do
  REPO_NAME=$(basename "$SCAN_DIR")
  GL_OUT=$(gitleaks detect --source="$SCAN_DIR" --log-opts="--full-history" \
    --no-git=false --report-format=sarif --report-path=/tmp/gl_${REPO_NAME}.sarif \
    2>&1 || true)
  GL_COUNT=$(cat /tmp/gl_${REPO_NAME}.sarif 2>/dev/null | python3 -c \
    "import sys,json; d=json.load(sys.stdin); print(len(d.get('runs',[{}])[0].get('results',[])))" \
    2>/dev/null || echo 0)

  {
    echo "## gitleaks — $REPO_NAME ($GL_COUNT findings)"
    echo '```'
    echo "$GL_OUT"
    echo '```'
    echo ""
  } >> "$REPORT"
done
```

### T02.SL6 — semgrep (OWASP Top 10)

```bash
SEMGREP_OUT=$(semgrep scan --config=p/owasp-top-ten \
  "$API_DIR/finance/" "$WEB_DIR/src/" \
  --no-git-ignore \
  --exclude="*.min.js" --exclude="vendor/" --exclude=".venv/" \
  2>&1 || true)
SEMGREP_COUNT=$(echo "$SEMGREP_OUT" | grep -c "^.*findings" || echo 0)

{
  echo "## semgrep — OWASP Top 10 ($SEMGREP_COUNT findings)"
  echo '```'
  echo "$SEMGREP_OUT"
  echo '```'
  echo ""
} >> "$REPORT"
```

### T02.SL7 — Summary footer

```bash
{
  echo "---"
  echo ""
  echo "## Summary"
  echo ""
  echo "| Tool | Findings |"
  echo "|---|---|"
  echo "| bandit | $BANDIT_COUNT |"
  echo "| pip-audit | $PIPAUDIT_COUNT |"
  echo "| npm audit | $NPM_COUNT |"
  echo "| gitleaks (all repos) | see sections above |"
  echo "| semgrep | $SEMGREP_COUNT |"
  echo ""
  echo "**Report written:** \`$REPORT\`"
} >> "$REPORT"

echo "Audit complete. Report: $REPORT"
```

### T02.SL8 — Ignore files

`scripts/security/.semgrepignore`:
```
# Vendor directories
finance_manager_api/.vendor/
finance_manager_api/.venv/
finance_manager_web/node_modules/
```

`scripts/security/.gitleaksignore`:
```
# Test fixture tokens — not real credentials
# Add entries here as: <commit-sha>:<file-path>:<secret-hash>
```
Start empty; add entries after first real run surfaces known FPs.

### T02.SL9 — chmod and smoke test

```bash
chmod +x scripts/security/run_audit.sh
./scripts/security/run_audit.sh
```

Confirm report file created, all 5 sections present, no crash.

## Notes

- Script uses `|| true` on every tool call so one tool failure doesn't abort the whole audit
- `--full-history` on gitleaks is slow on first run (scans all commits). Expected. Subsequent runs are faster if git reflog is available.
- semgrep community `p/owasp-top-ten` ruleset is pulled from the Semgrep registry on first run (requires internet). Cache is local after that.
- Do NOT pipe tool output through `set -e` — tool exits non-zero when it finds issues, which is the normal success case
