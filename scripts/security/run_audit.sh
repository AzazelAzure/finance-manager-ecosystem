#!/usr/bin/env bash
# run_audit.sh — run local security tools across API, Web, and parent repos.
#
# Run from parent repo root:
#   ./scripts/security/run_audit.sh
#
# Writes: strategy/security/audit_YYYY-MM-DD.md
# Requires: ./scripts/security/check_tools.sh (T01) passing first.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
API_DIR="$REPO_ROOT/finance_manager_api"
WEB_DIR="$REPO_ROOT/finance_manager_web"
SECURITY_DIR="$REPO_ROOT/strategy/security"
REPORT="$SECURITY_DIR/audit_$(date +%Y-%m-%d).md"
GITLEAKS_IGNORE="$SCRIPT_DIR/.gitleaksignore"
SEMGREP_IGNORE="$SCRIPT_DIR/.semgrepignore"

BANDIT_BIN="$API_DIR/.venv/bin/bandit"
PIPAUDIT_BIN="$API_DIR/.venv/bin/pip-audit"

# Prereq check (T01)
"$SCRIPT_DIR/check_tools.sh" || exit 1

mkdir -p "$SECURITY_DIR"

BANDIT_COUNT=0
PIPAUDIT_COUNT=0
NPM_COUNT=0
SEMGREP_COUNT=0
GITLEAKS_TOTAL=0

{
  echo "# Security Audit Report — $(date +%Y-%m-%d)"
  echo ""
  echo "**Generated:** $(date '+%Y-%m-%d %H:%M %Z')"
  echo "**Repos scanned:** finance_manager_api, finance_manager_web, parent"
  echo ""
  echo "---"
  echo ""
} > "$REPORT"

# --- bandit (Python SAST) ---
BANDIT_OUT=""
if [[ -x "$BANDIT_BIN" ]] && [[ -d "$API_DIR/finance" ]]; then
  BANDIT_OUT=$(cd "$API_DIR" && "$BANDIT_BIN" -r finance/ --format txt -ll 2>&1 || true)
  BANDIT_COUNT=$(echo "$BANDIT_OUT" | grep -c "^>> Issue" 2>/dev/null || true)
fi
BANDIT_COUNT="${BANDIT_COUNT:-0}"

{
  echo "## bandit — Python SAST ($BANDIT_COUNT issues)"
  echo '```'
  echo "$BANDIT_OUT"
  echo '```'
  echo ""
} >> "$REPORT"

# --- pip-audit (Python dependency CVEs) ---
PIPAUDIT_OUT=""
if [[ -x "$PIPAUDIT_BIN" ]]; then
  PIPAUDIT_OUT=$(cd "$API_DIR" && "$PIPAUDIT_BIN" 2>&1 || true)
  PIPAUDIT_COUNT=$(echo "$PIPAUDIT_OUT" | grep -cE 'GHSA-|CVE-' 2>/dev/null || true)
fi
PIPAUDIT_COUNT="${PIPAUDIT_COUNT:-0}"

{
  echo "## pip-audit — Python Dependency CVEs ($PIPAUDIT_COUNT vulnerabilities)"
  echo '```'
  echo "$PIPAUDIT_OUT"
  echo '```'
  echo ""
} >> "$REPORT"

# --- npm audit (Node dependency CVEs) ---
NPM_JSON=""
NPM_HUMAN=""
if [[ -d "$WEB_DIR" ]] && command -v npm &>/dev/null; then
  NPM_JSON=$(cd "$WEB_DIR" && npm audit --json 2>&1 || true)
  NPM_COUNT=$(echo "$NPM_JSON" | python3 -c \
    "import sys,json; d=json.load(sys.stdin); print(d.get('metadata',{}).get('vulnerabilities',{}).get('total',0))" \
    2>/dev/null || echo "parse error")
  NPM_HUMAN=$(cd "$WEB_DIR" && npm audit 2>&1 || true)
fi
NPM_COUNT="${NPM_COUNT:-0}"

{
  echo "## npm audit — Node Dependency CVEs ($NPM_COUNT vulnerabilities)"
  echo '```'
  echo "$NPM_HUMAN"
  echo '```'
  echo ""
} >> "$REPORT"

# --- gitleaks (secrets in git history) ---
for SCAN_DIR in "$REPO_ROOT" "$API_DIR" "$WEB_DIR"; do
  if [[ ! -d "$SCAN_DIR/.git" ]] && [[ "$SCAN_DIR" != "$REPO_ROOT" ]]; then
    {
      echo "## gitleaks — $(basename "$SCAN_DIR") (skipped — not a git repo)"
      echo ""
    } >> "$REPORT"
    continue
  fi

  REPO_NAME=$(basename "$SCAN_DIR")
  SARIF_PATH="/tmp/gl_${REPO_NAME}_$$.sarif"
  GL_OUT=""
  GL_COUNT=0

  GL_IGNORE_ARGS=()
  if [[ -f "$GITLEAKS_IGNORE" ]]; then
    GL_IGNORE_ARGS=(--gitleaks-ignore-path "$GITLEAKS_IGNORE")
  fi

  GL_OUT=$(gitleaks detect --source="$SCAN_DIR" --log-opts="--full-history" \
    --no-git=false --no-banner \
    "${GL_IGNORE_ARGS[@]}" \
    --report-format=sarif --report-path="$SARIF_PATH" \
    2>&1 || true)

  if [[ -f "$SARIF_PATH" ]]; then
    GL_COUNT=$(python3 -c \
      "import json,sys; d=json.load(open(sys.argv[1])); print(len(d.get('runs',[{}])[0].get('results',[])))" \
      "$SARIF_PATH" 2>/dev/null || echo 0)
    rm -f "$SARIF_PATH"
  fi
  GITLEAKS_TOTAL=$((GITLEAKS_TOTAL + GL_COUNT))

  {
    echo "## gitleaks — $REPO_NAME ($GL_COUNT findings)"
    echo '```'
    echo "$GL_OUT"
    echo '```'
    echo ""
  } >> "$REPORT"
done

# --- semgrep (OWASP Top 10) ---
SEMGREP_OUT=""
SEMGREP_ARGS=(
  scan
  --config=p/owasp-top-ten
  --no-git-ignore
  --exclude="*.min.js"
  --exclude="vendor/"
  --exclude=".venv/"
)
if [[ -f "$SEMGREP_IGNORE" ]]; then
  SEMGREP_ARGS+=(--semgrepignore-file "$SEMGREP_IGNORE")
fi

SCAN_PATHS=()
[[ -d "$API_DIR/finance" ]] && SCAN_PATHS+=("$API_DIR/finance/")
[[ -d "$WEB_DIR/src" ]] && SCAN_PATHS+=("$WEB_DIR/src/")

SEMGREP_BIN=""
if [[ -x "$API_DIR/.venv/bin/semgrep" ]]; then
  SEMGREP_BIN="$API_DIR/.venv/bin/semgrep"
elif command -v semgrep &>/dev/null; then
  SEMGREP_BIN="semgrep"
fi
if [[ -n "$SEMGREP_BIN" ]] && [[ ${#SCAN_PATHS[@]} -gt 0 ]]; then
  SEMGREP_OUT=$("$SEMGREP_BIN" "${SEMGREP_ARGS[@]}" "${SCAN_PATHS[@]}" 2>&1 || true)
  SEMGREP_COUNT=$(echo "$SEMGREP_OUT" | grep -cE 'findings|Finding' 2>/dev/null || true)
fi
SEMGREP_COUNT="${SEMGREP_COUNT:-0}"

{
  echo "## semgrep — OWASP Top 10 ($SEMGREP_COUNT findings)"
  echo '```'
  echo "$SEMGREP_OUT"
  echo '```'
  echo ""
} >> "$REPORT"

# --- Summary footer ---
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
  echo "| gitleaks (all repos) | $GITLEAKS_TOTAL |"
  echo "| semgrep | $SEMGREP_COUNT |"
  echo ""
  echo "**Report written:** \`$REPORT\`"
} >> "$REPORT"

echo "Audit complete. Report: $REPORT"
