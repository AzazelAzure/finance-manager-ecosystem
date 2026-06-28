# T03 — Weekly Cron + Antigravity Prompt

## End State

The audit runs automatically once a week via cron (local machine). Antigravity reads the latest report and writes a brief triage summary to the daily doc sweep output. HitM sets up the crontab entry after T02 is verified working.

## Acceptance Criteria

1. [V1] Crontab entry exists and `crontab -l` shows the weekly run
2. [V1] Antigravity prompt file exists at `strategy/automations/prompts/security_triage_prompt.md`
3. [V1] Prompt correctly reads latest report from `strategy/security/` and routes MEDIUM/HIGH findings to anomaly queue
4. [V3] First automated run produces a report file with the correct date stamp

## Scope Lock

### Files to create
- `strategy/automations/prompts/security_triage_prompt.md`

### HitM manual action
- Add crontab entry (see §Slices below)

### Files NOT to touch
- `run_audit.sh` from T02
- Existing Antigravity prompt files

## Slices

### T03.SL1 — Antigravity security triage prompt

Create `strategy/automations/prompts/security_triage_prompt.md`:

```markdown
# Security Triage Prompt — Weekly

## Context
This prompt runs after `scripts/security/run_audit.sh` completes. Read the most recent
audit report from `strategy/security/` (sort by filename descending, take the first).

## Step 1 — Read latest report
Find and read `strategy/security/audit_YYYY-MM-DD.md` (most recent date).

## Step 2 — Triage findings
For each tool section in the report:
- Count findings by severity (HIGH / MEDIUM / LOW / INFO)
- For any MEDIUM or HIGH finding: create an anomaly log entry in `strategy/anomalies/`
  using the anomaly template at `strategy/anomalies/anomaly_template.md`
  - File name: `YYYY-MM-DD_security-audit_<tool>-<short-desc>.md`
  - Set `severity_guess` to match the tool's reported severity
  - Set `status: unreviewed`
  - Set `agent: antigravity`
  - Set `plan_context: PLAN_LOCAL_SECURITY_AUDIT_SUITE_2026-06-29`
  - "What was found" = paste the specific finding from the report
  - "Possible owner" = Cursor

## Step 3 — Write triage summary
Append a `## Security Audit Triage` section to the current doc sweep report
(today's file in `strategy/automations/reports/doc_sweep_YYYY-MM-DD.md` if it exists,
or write a standalone `strategy/security/triage_YYYY-MM-DD.md`).

Format:
| Tool | HIGH | MEDIUM | LOW | Anomalies filed |
|---|---|---|---|---|
| bandit | 0 | 0 | 0 | 0 |
| pip-audit | 0 | 0 | 0 | 0 |
| npm audit | 0 | 0 | 0 | 0 |
| gitleaks | 0 | 0 | 0 | 0 |
| semgrep | 0 | 0 | 0 | 0 |

## Step 4 — If zero findings across all tools
Write: "Security audit clean — no findings." No anomaly files needed.

## Scope constraints
- Do NOT attempt to fix any finding. Report and route only.
- Do NOT run the audit script yourself. Read the report file only.
- Do NOT modify source code files.
- Write permission: `strategy/anomalies/*.md`, `strategy/security/triage_*.md`,
  append to `strategy/automations/reports/doc_sweep_*.md`
```

### T03.SL2 — Crontab entry (HitM action)

Run `crontab -e` and add:

```cron
# Weekly security audit — Sunday 02:00 local time
0 2 * * 0 cd /home/pproctor/Documents/python/finance_manager && ./scripts/security/run_audit.sh >> /tmp/security_audit_cron.log 2>&1
```

After adding, verify with `crontab -l`.

The Antigravity triage prompt runs separately as part of the existing `daily_doc_sweep` cadence — it reads whatever report file is newest in `strategy/security/`. No separate cron needed for triage.

### T03.SL3 — Verify cron fires

After setting up crontab, confirm the log file exists at the expected time (`/tmp/security_audit_cron.log`). On first automated run, review the report file date stamp matches the cron execution date.

## Notes

- Cron runs Sunday 02:00 so the weekly report is ready Monday morning before the admin session
- The `>> /tmp/security_audit_cron.log 2>&1` redirect captures any script errors for debugging; check this file if a report doesn't appear
- Antigravity triage reads the report passively — it does not trigger the audit run. The audit run is cron-only (or manual)
- Manual trigger anytime: `./scripts/security/run_audit.sh` from the parent repo root
