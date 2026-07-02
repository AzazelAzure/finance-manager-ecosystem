---
name: quarterly-review-authoring
description: Use to author the quarterly self-review — the mandatory Family/Health gate (kill_commit_gates.md §6), the honest S1.B/phase progress assessment against validation_gates.md, operational audit response, and kill/commit gate status pass. Due quarterly per AGENTS.md §4.
---

# Quarterly Review Authoring

## Category

Strategic-cadence skill — same taxonomy note as `success-projection-authoring`. Single-owner
(Claude scaffolds and computes; HitM is the sole author of Part 1's personal content — see
Procedure step 1, this is not a section Claude answers on HitM's behalf).

## Doctrine

- `strategy/strategic-roadmap-reframe-53be/kill_commit_gates.md` §6 — the mandatory
  Family/Health gate: exact question set, "yes" definition ("meaningful, lasting-impact... not a
  bad day"), and the 0-1/2/3-yes outcome thresholds (continue / 2-week reduced-scope mode /
  master kill gate evaluation, with 2+ yes for a second consecutive quarter also triggering the
  master gate).
- `strategy/strategic-roadmap-reframe-53be/validation_gates.md` — phase entry/exit criteria this
  review's Part 2 assesses honesty against.
- `strategy/audits/` — operational audit reports this review's Part 3 responds to (audits
  themselves are authored elsewhere — Antigravity/external — not by this skill).
- `strategy/projections/quarterly_reviews/2026-Q2.md` — structural precedent (4-part shape: gate,
  progress assessment, audit response, kill/commit gate pass, log-entry copy-block).
- `AGENTS.md` §4 — quarterly cadence trigger.

## Loads

- `status-verification-spotcheck` (imperative) — Part 2's exit-criteria status table must be
  checked against live `governance/plans/plan_registry.md` state, not carried forward from the
  last review or assumed from memory. This review exists specifically to be an "honest read," per
  its own stated purpose — self-certifying without verification defeats the point.
- `success-projection-authoring` (imperative, conditional) — same bidirectional cross-check as
  that skill's own Loads section.

## Tools

None fixed.

## Procedure

1. **Part 1 — Family/Health Gate (§6), mandatory.** This section is HitM's personal, honest
   self-assessment — **Claude's role is to present the exact question set from
   `kill_commit_gates.md` §6 and log HitM's answers, never to draft or infer answers on HitM's
   behalf.** Compute the gate outcome mechanically from the answers given (0-1/2/3 "yes"
   thresholds) — that part is objective once the answers exist.
2. **Part 2 — Progress assessment.** Load `status-verification-spotcheck` first. Pull the
   relevant phase's exit criteria from `validation_gates.md`, check each against live plan
   registry / repo state (not the last review's cached status), compute an honest done/deferred/
   in-progress count, identify timeline drift (original target vs. current realistic projection),
   and root-cause the drift plainly — this document exists to counteract the "produces more
   governance than product" failure mode the project's own audit history already named once.
3. **Part 3 — Audit response.** If an operational audit landed this quarter, respond to each
   scored category with a current-reality assessment (score may have moved since the audit's
   snapshot — say so, with evidence, don't just accept a stale score).
4. **Part 4 — Kill/commit gate quick pass.** Check every gate in `kill_commit_gates.md` against
   current phase state — most will be "not yet eligible," that's fine, the point is a complete
   pass, not selective checking.
5. Write the "Gate Outcomes Log Entry" copy-block (matching the 2026-Q2 precedent's format) for
   HitM to paste into `kill_commit_gates.md`'s own Gate Outcomes Log.
6. Flag cross-impact to `success-projection-authoring` if this review's findings (timeline drift,
   a resolved blocker, a changed assumption) should trigger a projection re-score.

## Handoff

`Skill(s) used: quarterly-review-authoring, status-verification-spotcheck` plus
`success-projection-authoring` if cross-triggered, in the meeting decision log.
