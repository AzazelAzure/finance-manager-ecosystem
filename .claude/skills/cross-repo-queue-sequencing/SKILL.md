---
name: cross-repo-queue-sequencing
description: Use when dispatching multi-task plans across repos (API/Web/CLI) to decide sequencing. The queue has no built-in cross-repo dependency awareness — this skill holds dependent tasks until their prerequisite merges rather than queuing everything at once.
---

# Cross-Repo Queue Sequencing

Precedent: F-009/F-006 dispatch (2026-07-02) — queued only the API task (`T01`) for each, and
explicitly held the Web tasks (`T03`/`T04`) until `T01`'s PR merges, since both plans' Web work
depends on API-side model/field changes landing first.

## Doctrine

- `governance/execution/branching_guidelines.md` — task branch naming, per-feature lifecycle, cross-repo
  edge case (§8.2 "feature spans multiple repos").

## Loads

None required for the dispatch decision itself; load `design-first-gate` first if the plan's
design isn't already closed (don't sequence a dispatch for a plan still under design review).

## Tools

- `queue_push` — dispatch a task to a repo's queue (`api.queue` / `web.queue`).
- `queue_status` — check what's already queued/claimed before adding more.

## Procedure

1. Read the plan's task list and identify true dependencies (does Task B require Task A's model
   changes, API contract, or migration to exist first?).
2. Queue only what's currently unblocked.
3. For anything held: note explicitly in the plan's `README.md` Execution Order and/or dispatch
   note *why* it's held and *what* unblocks it (e.g. "T03/T04 (Web) queue only after T01's PR
   merges").
4. Re-check `queue_status` before each subsequent dispatch — don't queue Task B on the assumption
   Task A merged; confirm it.

## Handoff

Delegation packet to the queue includes `Skill(s) to load: <the relevant Phase 3/4 Cursor skill>`
per the phase-to-skill map (`tp-deploy-lifecycle-skills/notes.md`). Decision log entry:
`Skill(s) used: cross-repo-queue-sequencing`.
