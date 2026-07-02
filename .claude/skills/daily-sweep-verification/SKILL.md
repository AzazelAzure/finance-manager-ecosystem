---
name: daily-sweep-verification
description: Use when reviewing Antigravity's daily sweep reports before trusting them as a complete picture of uncommitted work. Diff files directly rather than trusting the sweep's narrative, especially for files the sweep report doesn't mention at all.
---

# Daily Sweep Verification

Precedent: 2026-07-02 uncommitted-doc sweep — 4 of 7 `design_docs` files with real diffs weren't
even mentioned in either of two sweep reports, but turned out legitimate on direct inspection.
The actionable gap that *was* real (6 stub CHANGELOG entries) was something the sweep never
checks for by design, not something it got wrong — the lesson is "verify scope, not just
narrative accuracy."

## Doctrine

- `strategy/automations/reports/` — Antigravity's own sweep output, read but not owned by Claude.
- Golden Rule #18/#16 — this skill is a specific application of the general spotcheck discipline.

## Loads

- `status-verification-spotcheck` (imperative) — this skill is largely that discipline applied
  specifically to Antigravity's sweep reports.

## Tools

None fixed — direct `git diff` / `git status` against the actual working tree, not the sweep's
summary of it.

## Procedure

1. Read the sweep report's narrative, but treat it as a claim, not a conclusion.
2. Run `git status`/`git diff` directly across the repos the sweep covers.
3. Cross-check every file the sweep *didn't* mention, not just the ones it flagged — an omission
   is not evidence of "nothing there," especially for files with real uncommitted diffs.
4. Distinguish "sweep got something wrong" from "sweep wasn't scoped to check this at all" — the
   fix differs (correct the sweep vs. accept the gap is out of its design and handle it here).
5. For anything the sweep can't or doesn't check by design (e.g. CHANGELOG stub content, not
   just presence), file that as its own finding rather than expecting the sweep to catch it next
   time.

## Handoff

`Skill(s) used: daily-sweep-verification, status-verification-spotcheck` in the meeting decision
log, alongside whatever real findings surfaced.
