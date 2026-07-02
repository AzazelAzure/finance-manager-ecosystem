---
name: design-first-gate
description: Use when a plan's registry status says ready or in_progress but design completeness hasn't actually been verified. Walks open design questions with HitM and closes DESIGN.md/task files before anything gets dispatched to Cursor. Absorbs the territory Cursor's dropped roadmap-rollout-planning skill used to cover.
---

# Design-First Gate

Directly prevents the F-009/F-006 class of bug: the registry said "ready" with "task files
authored," but the actual design was incomplete or rested on a wrong premise (F-009 assumed a
field that didn't exist; F-006 had unanswered v1-scope questions). This skill exists to catch
that gap before dispatch, not after.

## Doctrine

- `governance/plans/plan_template.md` — plan schema, required body sections, V-tier evidence.
- `governance/plans/plan_lifecycle.md` — `draft → ready` validation actions (§B), what "ready" is
  actually supposed to mean.
- The `DESIGN.md` pattern (plan-local, no single template — precedented twice: F-009, F-006).

## Loads

- `status-verification-spotcheck` (imperative) — do not trust the registry's `ready` status at
  face value; verify design completeness directly before proceeding.

## Tools

- `plan_lookup` — orient to the plan in question.
- `new_plan` — scaffold a plan directory if this is net-new work, not an existing plan's gap.

## Procedure

1. Load `status-verification-spotcheck` first — confirm the plan's stated design status against
   its actual `DESIGN.md` (or absence of one), not the registry row alone.
2. If design is incomplete: identify every open question (premise checks, scope calls,
   architecture decisions) and walk them with HitM one at a time — don't batch-guess.
3. Author or update `DESIGN.md` with the resolved decisions and their rationale.
4. Rewrite the plan's task files (`tasks/T##_<slug>.md`) to match the closed design — retire
   tasks superseded by a design change, don't leave stale content in the tree unexplained.
5. Only after this: update `governance/plans/plan_registry.md` and hand off to
   `cross-repo-queue-sequencing` for dispatch — this skill does not dispatch directly.

## Handoff

- Delegation packet to `cross-repo-queue-sequencing` includes `Skill(s) to load:
  cross-repo-queue-sequencing`.
- Return/decision-log entry includes `Skill(s) used: design-first-gate,
  status-verification-spotcheck`.
