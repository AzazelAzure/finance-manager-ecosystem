# Automation Prompt — Monthly Legal Compliance Audit

> **Agent:** Antigravity (agy)
> **Schedule:** First day of each month (or within first 3 days)
> **Run from:** `/home/pproctor/Documents/python/finance_manager/`
> **Output:** `strategy/legal/compliance_reports/YYYY-MM.md`
> **Escalate to HitM if:** Any FAIL or CHANGED item detected

---

## Your task

You are running the monthly legal compliance audit for The Hive Financial Manager. Your job is to verify that the codebase state matches what the published legal policies claim to be true, and to detect any new features or changes that require a policy update.

Work through the checklist at `strategy/legal/compliance_checklist.md` top to bottom. For each check, run the specified verification, compare the result to the stated policy claim, and record one of four verdicts:

- **PASS** — result matches policy claim; no action needed
- **FAIL** — result contradicts policy claim; immediate HitM attention required
- **CHANGED** — a new item exists that is not yet reflected in any policy; HitM must decide if it's within existing scope or needs a policy update
- **PENDING** — known open item; record current status and whether it has moved since last month

---

## Step 1 — Read authoritative context

Before running any checks, read these files in order:

1. `strategy/legal/compliance_checklist.md` — the full check list (you will work through this)
2. `strategy/legal/legal_workflow_coordination.md` — authoritative implementation state
3. `strategy/legal/drafts/privacy_policy_v1.md` — what the privacy policy says
4. `strategy/legal/drafts/cookie_policy_v1.md` — what the cookie policy says
5. Last month's compliance report at `strategy/legal/compliance_reports/` — compare open items

---

## Step 2 — Run each check

For each check in `compliance_checklist.md`, do the following:

1. Run the specified grep or file read command
2. Compare the result to the "Policy claim" stated in the checklist
3. Record the verdict (PASS / FAIL / CHANGED / PENDING) with brief evidence
4. If FAIL or CHANGED: describe exactly what changed and what policy action is needed

**For Category 7 (new feature detection):** Run `git log --since="30 days ago" --oneline -- finance_manager_api/finance/models.py finance_manager_web/src/` to see recent model and web changes. For each commit that touches models or new endpoints, read the diff and assess if any new data collection or processing is disclosed in the existing policies.

---

## Step 3 — Write the report

Save a new file at: `strategy/legal/compliance_reports/YYYY-MM.md` (use the current year and month).

Use this exact structure:

```markdown
# Legal Compliance Report — YYYY-MM

**Generated:** YYYY-MM-DD
**Run by:** Antigravity monthly automation
**Checklist version:** strategy/legal/compliance_checklist.md (last updated YYYY-MM-DD)
**Policies reviewed:** privacy_policy_v1.md, cookie_policy_v1.md, tos_v1.md

---

## Executive Summary

[3-5 sentences: overall health, number of FAILs/CHANGEDs, any immediate actions needed]

---

## FAIL items (immediate HitM attention required)

[List any FAIL items here. If none: "None — all checks passed."]

For each FAIL:
- **Check:** [check ID and name]
- **What was found:** [exact grep output or file state]
- **Policy claim violated:** [quote the claim]
- **Required action:** [what needs to be fixed — code or policy]

---

## CHANGED items (new features not yet reflected in policy)

[List any items where codebase has moved ahead of policy. If none: "None."]

For each CHANGED:
- **What changed:** [specific new model field, endpoint, or service]
- **Policy impact:** [which document and section needs updating]
- **Recommendation:** [is this within existing scope, or does it need a new disclosure?]

---

## PENDING items (open known gaps)

[Track each item from the checklist Category 6 open item tracker]

| Item | Last month status | This month status | Movement |
|---|---|---|---|
| N2 Clickwrap | [status] | [status] | Resolved / Still open / Regressed |
| N4 Dexie opt-out | ... | ... | ... |
| N5 Multi-user Dexie | ... | ... | ... |
| Signals PII scrub | ... | ... | ... |

---

## PASS items (all checks passed — no action needed)

[Brief list by check ID. No detail needed for passing checks.]

C1.1 ✓ | C1.2 ✓ | C1.3 ✓ | C2.1 ✓ | ... [list all that passed]

---

## Policy update actions (if any)

[List any policy documents that need editing this month, based on FAILs and CHANGEDs above]

| Document | Section | What to change | Who owns it |
|---|---|---|---|
| ... | ... | ... | Claude Code / HitM |

---

## Notes for next month

[Anything to watch: upcoming features in the plan registry that will likely trigger policy updates; attorney review items coming due; open N-items expected to close]
```

---

## Step 4 — Escalate if needed

If there are any FAIL or CHANGED items in the report:

1. Note them clearly at the top of the report under "FAIL items"
2. Print a summary to terminal: "⚠️ COMPLIANCE ALERT: [N] items require HitM attention. See strategy/legal/compliance_reports/YYYY-MM.md"

If all checks PASS and all PENDING items are unchanged: print "✓ Compliance check complete. All checks passed. Report saved to strategy/legal/compliance_reports/YYYY-MM.md"

---

## Constraints

- **Read only** — do not edit any source code or policy drafts during this run
- **Do not** attempt to fix FAIL items yourself — flag them for HitM
- **Do not** update legal documents during this run — the report is the output; a separate session handles policy edits
- If a check requires reading a file that does not exist (e.g., published policy files not yet created): record as PENDING with note "file not yet created"
- If you cannot run a grep (permissions error): record as PENDING with note "verification blocked"
