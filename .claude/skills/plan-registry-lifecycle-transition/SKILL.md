---
name: plan-registry-lifecycle-transition
description: Use when a plan moves between lifecycle states (draft/ready/in_progress/completed/blocked/paused/abandoned/archived). Updates governance/plans/plan_registry.md's row and cross-checks the transition against plan_lifecycle.md's state machine before making it.
---

# Plan Registry Lifecycle Transition

## Doctrine

- `governance/plans/plan_registry.md` — the registry itself, and its own "update protocol" header.
- `governance/plans/plan_lifecycle.md` — state machine, transition table, forbidden transitions,
  per-transition action lists (§A–§G).

## Loads

- `status-verification-spotcheck` (imperative) — before marking anything `completed` or moving a
  row to "Recently Completed," verify the close pre-conditions actually hold rather than trusting
  the plan's own self-report.

## Tools

- `plan_lookup` — orient to the plan's current registry row and body status.
- `plan_status` — current computed status, if it differs from the registry row.

## Procedure

1. Identify the requested transition (e.g. `ready → in_progress`, `in_progress → completed`).
2. Check `plan_lifecycle.md`'s transition table — is this transition even valid from the current
   state? Forbidden transitions are listed explicitly; don't assume.
3. Confirm the section-specific pre-conditions for that transition (§A birth, §C pre-execution,
   §E close, etc.) are actually met — load `status-verification-spotcheck` for any pre-condition
   that's a status claim rather than something directly observable.
4. Update the registry row: correct section (Draft/Planning, Ready for Execution, In Progress,
   Recently Completed, etc.), status field, `updated:` date.
5. Update the plan's own `README.md` metadata to match — the registry and the plan body must
   never disagree on status.

## Handoff

`Skill(s) used: plan-registry-lifecycle-transition, status-verification-spotcheck` (when loaded)
in the meeting decision log.
