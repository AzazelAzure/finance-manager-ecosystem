# Automation Prompt — Quarterly Operational Audit

> **Agent:** Antigravity (agy)
> **Schedule:** Quarterly — run alongside the §6 quarterly self-review (kill_commit_gates.md)
> **Run from:** `/home/pproctor/Documents/python/finance_manager/`
> **Output:** `strategy/operational_audit_report_YYYY-QN.md`

---

## Your task

Re-run the full 12-category operational audit established in `strategy/operational_audit_report.md` (baseline: 2026-06-27, score: 5.2/10). Score each category 0–10 using the same rubric. Produce a delta report showing movement from the prior audit. Be as candid as the baseline audit — no softening, no omissions.

This is a business CI/CD check, not a morale document. The goal is to catch operational drift before it compounds.

---

## Step 1 — Load context

Read these before writing anything:

1. `strategy/operational_audit_report.md` — baseline audit (scores, findings, rubric)
2. `strategy/audit_improvement_tracker_2026-06-27.md` — remediation log and prior score estimates
3. Most recent `strategy/automations/reports/ops_pulse_*.md` files — monthly drift signals
4. `strategy/automations/context/daily_context.md` — current git/PR/plan state
5. `governance/plan_registry.md` — plan completion counts
6. `design_docs/30_Releases/Runtime_Signup_Sheet.md` — VPS live state
7. `strategy/quarterly_reviews/` — most recent quarterly self-review
8. `governance/disaster_recovery.md` + `governance/incident_response.md`
9. `strategy/legal/compliance_reports/` — most recent monthly report

---

## Step 2 — Score all 12 categories

Use the same 0–10 rubric as the baseline:
- **0:** Not implemented
- **3:** Minimal / token effort
- **5:** Functional but significant gaps
- **7:** Solid — meets industry standard
- **9:** Excellent — exceeds typical startup standards
- **10:** Exceptional

For each category, write:
- Current score (0–10)
- Delta vs prior audit (↑ / ↓ / =)
- What improved
- What still needs work
- Any new gaps not in the baseline

**Categories (same 12 as baseline):**

1. Governance & Process Framework (weight: 8%)
2. Strategic Planning & Roadmap (weight: 8%)
3. Deployment Infrastructure (weight: 10%)
4. CI/CD & Automated Quality Gates (weight: 12%)
5. Security Posture (weight: 12%)
6. Legal & Compliance (weight: 8%)
7. Automation & Scheduled Operations (weight: 8%)
8. Documentation Quality (weight: 6%)
9. Financial & Cost Discipline (weight: 6%)
10. Agent Orchestration & Multi-Agent Operations (weight: 6%)
11. Risk Management & Business Continuity (weight: 8%)
12. Operational Execution & Delivery Cadence (weight: 8%)

---

## Step 3 — Write the audit report

Write to `strategy/operational_audit_report_YYYY-QN.md` (e.g. `2026-Q3.md`).

Use this structure:

```markdown
# Operational Audit Report — YYYY QN

**Date:** YYYY-MM-DD
**Auditor:** Antigravity
**Baseline:** strategy/operational_audit_report.md (2026-06-27, 5.2/10)
**Prior audit:** [date and score]

---

## Executive Summary

[3–5 sentences. What's the headline? What moved most? What's still the critical gap?
Same candor as the baseline — no platitudes.]

---

## Score Summary

| # | Category | Prior | Now | Delta | Weight | Weighted |
|---|---|---|---|---|---|---|
| 1 | Governance | X | X | ↑/↓/= | 8% | X |
...
| | **Overall** | **X.X** | **X.X** | **↑/↓/=** | | **X.XX** |

---

## Category Details

### 1. [Category Name] — X/10 (↑/↓/= from prior X/10)

**What improved:** [specific, evidence-backed]
**What still needs work:** [specific]
**New gaps:** [anything not in the baseline]

[repeat for all 12]

---

## Open Questions

[Any states you couldn't determine — flag explicitly rather than assuming]

---

## Priority Improvements (next quarter)

### Tier 1 — Critical
### Tier 2 — High Priority
### Tier 3 — Important

---

## Audit Improvement Tracker Update

[List any items from audit_improvement_tracker_2026-06-27.md that can now be marked closed,
and any new items to add. HitM updates the tracker separately — this is a handoff note.]
```

---

## Constraints

- Score with evidence, not vibes. If you can't verify a claim, note "unverified" rather than assuming.
- Don't inflate scores because things are "in progress." In progress is not done.
- Don't deflate scores to seem rigorous. If something genuinely improved, say so.
- The weighted overall score is the headline. Everything else supports it.
- Do not commit — HitM reviews before committing.
- This audit replaces the baseline as the reference for the next cycle. Write it to stand alone.
