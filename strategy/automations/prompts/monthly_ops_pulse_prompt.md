# Automation Prompt — Monthly Ops Pulse

> **Agent:** Antigravity (agy)
> **Schedule:** Monthly — 1st–3rd of each month (run after legal compliance prompt)
> **Run from:** `/home/pproctor/Documents/python/finance_manager/`
> **Output:** `strategy/automations/reports/ops_pulse_YYYY-MM.md`

---

## Your task

Run a lightweight operational health check across the 12 audit categories from the baseline operational audit (`strategy/audits/operational_audit_report.md`, 2026-06-27). This is not a full re-score — it's a drift detector. Flag what moved (better or worse), flag what's still open, and surface anything that's been flagged two months in a row (escalation trigger for the quarterly full audit).

No scoring. No rewrites. One-page output.

---

## Step 1 — Load context

Read `strategy/automations/context/daily_context.md` for current git/PR/plan state.

Also read:
- `strategy/audits/audit_improvement_tracker_2026-06-27.md` — baseline and prior remediation
- `governance/plan_registry.md` — In Progress and Draft counts
- `design_docs/30_Releases/Runtime_Signup_Sheet.md` — VPS live state
- Most recent prior pulse report in `strategy/automations/reports/ops_pulse_*.md` — for two-month escalation check

---

## Step 2 — Check each category (one line each)

For each of the 12 audit categories, write one line: **GREEN** (no regression, open items progressing), **YELLOW** (drift or stall — attention needed), or **RED** (regression or critical new gap).

Check these specifically:

**1. Governance & Process Framework**
- Are plan lifecycle transitions happening? (new plans closing, not just opening)
- Is plan_registry.md Last Updated within the last 7 days?

**2. Strategic Planning & Roadmap**
- Is the quarterly review current? (check `strategy/projections/quarterly_reviews/` for this quarter)
- Are validation gate docs reflecting current S1.B status?

**3. Deployment Infrastructure**
- What is the VPS SHA drift vs `origin/main`? (from Runtime Signup Sheet)
- Was there at least one deploy this month?

**4. CI/CD & Automated Quality Gates**
- Are GitHub Actions workflows present in API and web repos? (check `.github/workflows/`)
- Any CI failures on `main` branch this month?

**5. Security Posture**
- Any new Dependabot PRs opened (unreviewed >14 days)?
- Any new security scan findings from Antigravity vulnerability automation?

**6. Legal & Compliance**
- Did the monthly legal compliance automation run? (check `strategy/legal/compliance_reports/`)
- Any new compliance flags raised?

**7. Automation & Scheduled Operations**
- Did `gather_doc_context.sh` run this month? (check context file timestamp)
- Did the daily doc sweep run? (check `strategy/automations/reports/doc_sweep_*.md`)
- Antigravity automation reliability — any new failures in scheduled tasks?

**8. Documentation Quality**
- Did the doc sweep flag persistent stale references (same file two months running)?
- Is `current_status.md` Last Updated within 48h?

**9. Financial & Cost Discipline**
- Is current tooling spend within ₱100/mo cap? (check known costs: VPS + Cursor + Claude)
- Is Cursor credit usage on track for the billing cycle?

**10. Agent Orchestration**
- Is the three-tool model boundary being respected? (no code in Claude sessions, no governance in Cursor sessions)
- Any new dead references to archived tooling (Slack bridges, orchestrator.py)?

**11. Risk Management & Business Continuity**
- Did `pull_backup.sh` run this month? (check `~/fm_backups/` for recent file)
- Is uptime monitoring (GitHub Actions health check) active and firing?
- Any incidents logged in `governance/disaster_recovery.md §10`?

**12. Operational Execution & Delivery Cadence**
- How many plans moved to Recently Completed this month?
- Are any Q3 commitments (from quarterly review) progressing?
- Is VPS within 7 days of `main`?

---

## Step 3 — Escalation check

Compare findings to the prior month's pulse report (if one exists).

Any category that was **YELLOW** last month and is still **YELLOW** this month → flag as **ESCALATE** and note it explicitly. These items should be named priorities in the next quarterly full audit.

---

## Step 4 — Write pulse report

Write to `strategy/automations/reports/ops_pulse_YYYY-MM.md`:

```markdown
# Ops Pulse — YYYY-MM

**Date:** YYYY-MM-DD
**Prior pulse:** YYYY-MM (or "first pulse")

## Status by Category

| # | Category | Status | Note |
|---|---|---|---|
| 1 | Governance & Process | GREEN/YELLOW/RED | one line |
| 2 | Strategic Planning | | |
| 3 | Deployment | | |
| 4 | CI/CD | | |
| 5 | Security | | |
| 6 | Legal & Compliance | | |
| 7 | Automation | | |
| 8 | Documentation | | |
| 9 | Financial Discipline | | |
| 10 | Agent Orchestration | | |
| 11 | Risk Management | | |
| 12 | Operational Execution | | |

## Escalations (YELLOW → YELLOW from prior month)

(list any; if none: "None — all yellows are new or resolved")

## Top 3 items needing attention

1.
2.
3.

## Context file status

(Was daily_context.md current? Timestamp?)
```

---

## Constraints

- One line per category — no paragraphs.
- Don't re-audit what hasn't changed. Flag deltas, not stable state.
- Don't commit — HitM reviews the pulse report before committing.
- If context file is missing, note it as an automation gap (YELLOW on §7) and proceed with direct reads.
