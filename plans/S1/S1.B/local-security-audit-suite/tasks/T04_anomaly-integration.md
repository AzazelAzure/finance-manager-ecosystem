# T04 — Anomaly Queue Integration

## End State

`run_audit.sh` automatically writes anomaly files for any MEDIUM or HIGH finding without requiring the Antigravity triage pass. The anomaly files are correctly formatted, include the specific finding, and set `status: unreviewed` so the existing nightly sweep picks them up. LOW findings are report-only — no anomaly file.

## Acceptance Criteria

1. [V1] A simulated MEDIUM finding in a test run produces a correctly-formatted anomaly file in `strategy/anomalies/`
2. [V1] Anomaly file name follows convention: `YYYY-MM-DD_security-audit_<tool>_<short-slug>.md`
3. [V1] Anomaly frontmatter contains: `logged`, `agent: run_audit.sh`, `plan_context`, `status: unreviewed`, `severity_guess`
4. [V1] LOW findings do not produce anomaly files (report-only)
5. [V1] Duplicate detection: if an anomaly file for the same finding already exists (same tool + same file path), do not create a duplicate — update the existing file's `logged` date instead
6. [V1] `run_audit.sh` reports count of anomaly files written at the end of its run

## Scope Lock

### Files to modify
- `scripts/security/run_audit.sh` — add anomaly-writing logic after each tool section

### Files to create
- `scripts/security/lib_anomaly_write.sh` — reusable function for writing anomaly files (keeps `run_audit.sh` readable)

### Files NOT to touch
- `strategy/anomalies/README.md` or `anomaly_template.md`
- Existing anomaly files
- Any source code files

## Slices

### T04.SL1 — Anomaly writer library

Create `scripts/security/lib_anomaly_write.sh`:

```bash
#!/usr/bin/env bash

# write_security_anomaly <tool> <severity> <short_slug> <finding_text>
# Writes to strategy/anomalies/ if severity is MEDIUM or HIGH.
# Skips LOW and INFO.
write_security_anomaly() {
  local tool="$1"
  local severity="$2"     # high | medium | low | info
  local short_slug="$3"   # kebab-case, max 40 chars
  local finding_text="$4"
  local repo_root="$5"

  case "${severity,,}" in
    high|medium) ;;
    *) return 0 ;;  # skip LOW and INFO
  esac

  local date_str
  date_str=$(date +%Y-%m-%d)
  local filename="${date_str}_security-audit_${tool}_${short_slug}.md"
  local filepath="$repo_root/strategy/anomalies/$filename"

  # Duplicate check
  if [[ -f "$filepath" ]]; then
    sed -i "s/^logged: .*/logged: $date_str/" "$filepath"
    echo "[anomaly] Updated existing: $filename"
    return 0
  fi

  cat > "$filepath" <<ANOMALY
---
logged: $date_str
agent: run_audit.sh
plan_context: PLAN_LOCAL_SECURITY_AUDIT_SUITE_2026-06-29
status: unreviewed
severity_guess: ${severity,,}
---

## What was found

\`\`\`
$finding_text
\`\`\`

## Where

Detected by \`$tool\` during automated security audit. See full report:
\`strategy/security/audit_${date_str}.md\`

## What agent was doing

Running weekly automated security audit via \`scripts/security/run_audit.sh\`.

## Why outside scope

Security audit is read-only. Remediation belongs to Cursor or HitM.

## Possible owner

Cursor — review finding and determine if fix is needed.

## Notes

Severity reported by $tool: ${severity^^}. Verify before acting — static analysis can produce false positives.
ANOMALY

  echo "[anomaly] Filed: $filename"
}
```

### T04.SL2 — Integration into run_audit.sh

After each tool's output block in `run_audit.sh`, add a parsing pass that extracts MEDIUM/HIGH findings and calls `write_security_anomaly`. Tool-specific parsing:

**bandit:** Lines matching `Severity: Medium` or `Severity: High` — extract the surrounding block (issue title + file + line)

**pip-audit:** Lines matching `GHSA-` or `CVE-` with severity MEDIUM or HIGH in the JSON output

**npm audit:** Parse `npm audit --json` — iterate `advisories` where `severity` is `moderate`, `high`, or `critical`

**gitleaks:** Each finding in the SARIF output under `runs[0].results[]` — all gitleaks findings are treated as HIGH

**semgrep:** Lines matching `severity: WARNING` or `severity: ERROR` in JSON output (`--json` flag)

Source the library at the top of `run_audit.sh`:
```bash
source "$(dirname "${BASH_SOURCE[0]}")/lib_anomaly_write.sh"
```

### T04.SL3 — Summary count

At the end of `run_audit.sh`, add to the summary footer:
```bash
ANOMALY_COUNT=$(find "$REPO_ROOT/strategy/anomalies" -name "*security-audit*" \
  -newer "$REPORT" 2>/dev/null | wc -l | tr -d ' ')
echo "Anomaly files written this run: $ANOMALY_COUNT"
```
And append to the report:
```markdown
| Anomalies filed (MEDIUM+) | {count} |
```

### T04.SL4 — Smoke test

Create a synthetic test: temporarily add a hardcoded test string resembling a secret to a scratch file, run gitleaks against it, confirm an anomaly file is created. Remove the test file. Confirm LOW-only bandit findings do NOT create anomaly files.

## Notes

- gitleaks: ALL findings are treated as HIGH because any committed secret is an immediate concern regardless of context. HitM can add to `.gitleaksignore` after first run if something is a confirmed FP.
- semgrep `WARNING` = MEDIUM, `ERROR` = HIGH in Semgrep's severity model
- npm `moderate` maps to MEDIUM, `high`/`critical` map to HIGH
- The duplicate check uses filename only (date + tool + slug). If the same slug fires in a new run, it updates `logged` date on the existing file rather than creating a second file. This keeps the anomaly queue clean on repeated runs.
