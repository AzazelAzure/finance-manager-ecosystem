# Automation Prompt — Daily Engineering Digest

> **Agent:** Antigravity (agy)
> **Schedule:** Daily — end of workday or as scheduled
> **Run from:** `/home/pproctor/Documents/python/finance_manager/`
> **Output:** `strategy/daily_summaries/daily_summary_YYYY-MM-DD.md`
> **Also updates:** `strategy/current_status.md` (rollup — see Step 5)

---

## Your task

Generate the daily engineering digest for The Hive Financial Manager. This document is read by HitM each morning to understand what moved, what's parked, and what needs attention. It also feeds the weekly `current_status.md` rollup.

Be concise and factual. Avoid repeating prior days' context unless something changed. The audience is a solo founder who already knows the codebase — lead with deltas, not descriptions.

---

## Step 1 — Read context

Before writing anything, gather state from these sources:

1. **Git log (parent repo):** `git log --since="yesterday" --oneline` — what committed since last summary
2. **Submodule commits:** `git log --since="yesterday" --oneline` in `finance_manager_api/` and `finance_manager_web/` separately
3. **Open PRs:** `gh pr list --state open` — current open PRs with titles and numbers
4. **Recently merged PRs:** `gh pr list --state merged --limit 10` — what closed in the last 24h
5. **Plan registry:** `governance/plan_registry.md` — what's In Progress, Draft, or Ready
6. **Yesterday's summary:** most recent file in `strategy/daily_summaries/` — for continuity
7. **VPS state (live, trust-but-verify):** Read the `## Live VPS State (SSH-verified)` block from `strategy/automations/context/daily_context.md` (populated by `gather_doc_context.sh` → `vps_state.sh`). Use its **capture timestamp**. If that block is missing, marked UNAVAILABLE, or older than this run, report VPS state as **UNKNOWN** — do **NOT** infer it from `Runtime_Signup_Sheet.md`, `validation_gates.md`, prior summaries, or git history. If you have SSH capability, prefer running `scripts/vps_state.sh` live over any cached value.

---

## Step 2 — Write the daily summary

Save to: `strategy/daily_summaries/daily_summary_YYYY-MM-DD.md` (today's date).

Use this exact structure:

```markdown
# Daily Engineering Digest — [Month DD, YYYY]

**Date range covered:** YYYY-MM-DD to YYYY-MM-DD

---

## Key Changes

[One subsection per meaningful change. Use ### headers matching the feature/plan name.
Each subsection: 2-4 bullet points. First bullet: what changed. Subsequent bullets: specifics, file paths, test coverage if applicable.
Omit routine dependency bumps, formatting fixes, or doc typos unless they unblock something.]

### [Feature/Plan Name]
* **[Category]:** [What changed, file references where useful]
* [Detail]
* [Detail]

---

## Open PRs

[Table of ALL currently open PRs. Include PRs opened today plus any previously open ones.]

| PR # | Title | Branch | Status | Plan | Age |
|---|---|---|---|---|---|
| #XX | [title] | [branch] | Open / Draft / Review | [PLAN_ID or "—"] | [Xd] |

---

## PRs Merged / Closed Today

[PRs that merged or closed in the last 24h. If none: "None."]

| PR # | Title | Merged/Closed | Notes |
|---|---|---|---|
| #XX | [title] | Merged | [brief impact note] |

---

## VPS State

[From the live `## Live VPS State (SSH-verified)` block only (Step 1 item 7). Always print the
capture timestamp so staleness is visible. If live state is UNAVAILABLE, set every row to
**UNKNOWN** and add the note below — never fill these from the Runtime Signup Sheet or prior context.]

**State captured:** [ISO timestamp from the live block, or "UNAVAILABLE — VPS state UNKNOWN this run"]

| Item | State |
|---|---|
| Active color | Green / Blue / Unknown |
| Inactive color | Blue / Green / Unknown |
| API submodule on VPS | [SHA or "unknown"] |
| Web submodule on VPS | [SHA or "unknown"] |
| Pending VPS actions | [migration needed? rebuild needed? or "None"] |

---

## In-Progress Plans

[From plan_registry.md "In Progress" section. Brief status for each — what's moving, what's blocked.]

| Plan | Status | What's moving | Blocker |
|---|---|---|---|
| [PLAN_ID] | in_progress | [brief] | [blocker or "none"] |

---

## Legal / Compliance Flags

[ONLY include this section if any of the following are true:
- A PR merged today has `legal_impact: true` in its plan
- A new model field or API endpoint was added that collects user data
- A known open legal item (N2, N4, N5, signals PII) changed status

If none of the above: omit this section entirely.]

- **[Flag]:** [brief description + what action is needed]

---

## Anomaly Queue

[ONLY include this section if today's doc sweep report contains unresolved anomalies.
Read `strategy/automations/reports/doc_sweep_YYYY-MM-DD.md` (today's) for the triage table.
If the queue is clear, omit this section entirely.]

| Date logged | Severity | Plan context | Summary | Dispatch to |
|---|---|---|---|---|
| YYYY-MM-DD | medium | PLAN_ID / T## | one-line description | Cursor / Claude / HitM |

---

## Watchlist & Regressions

[Items that need attention but aren't blockers yet. 3-5 items max. Mark severity.]

1. **[High/Medium/Low] [Item]:** [What it is and why it matters]

---

## Parked Items

[Decisions or tasks explicitly parked by HitM. Carry forward from yesterday unless resolved.]

| Item | Parked since | Resume trigger |
|---|---|---|
| [item] | YYYY-MM-DD | [condition] |

---

## Next priorities

[What should move tomorrow based on today's state. 3-5 items ordered by priority.]

1. [Highest priority item]
2. [Next]
3. [Next]
```

---

## Step 3 — Update current_status.md (rollup)

After writing the daily summary, update `strategy/current_status.md` to reflect the current state. This is a LIVING DOCUMENT — replace stale sections, don't append.

**What to update in current_status.md:**

- **§ Active sprint / In Progress plans** — match the plan_registry.md "In Progress" section exactly
- **§ Open PRs** — replace with today's open PR table (same as daily summary)
- **§ VPS state** — update if anything changed today
- **§ Last updated** — set to today's date

**What NOT to change in current_status.md:**

- Architecture sections that don't change day-to-day
- Strategic phase / stage notation
- Long-term roadmap content

If `current_status.md` doesn't have a section for something that changed today (e.g., a new plan category), add the section. Don't let it go stale.

---

## Step 4 — Verify output

Before finishing:

- [ ] Daily summary file saved at correct path with today's date
- [ ] current_status.md open PR table matches `gh pr list --state open`
- [ ] Daily summary has at minimum: Key Changes, Open PRs, VPS State, Watchlist sections
- [ ] Legal/Compliance Flags section ONLY present if there's an actual flag

---

## Constraints

- **Concise over comprehensive.** If nothing changed in an area, omit that subsection rather than writing "No changes."
- **Don't repeat yesterday.** The delta is what matters. Reference yesterday's summary with "per 2026-MM-DD summary" if continuity is needed.
- **Trust but verify (AGENTS.md §1).** Before escalating any VPS/ops item to HIGH, verify it against live state — if you have SSH, query it; if not, mark UNKNOWN. Do not raise a HIGH alert from a cached or inferred value. (This rule exists because 2026-06-29 fired two false-alarm HIGHs from a stale cached context file.)
- **Exact file paths in Key Changes** — `finance_manager_api/finance/models.py` not "the models file." Links are welcome if they help navigation.
- **PR table is mandatory** even if no PRs are open (write "None open"). This is the single source of truth for HitM's PR queue.
- **Do not** commit the summary file — HitM reviews before committing, or the commit happens separately.
- **Do not** edit plan files, governance docs, or source code during this run.
