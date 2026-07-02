---
name: feature-implementation-loop
description: Deliver scoped features and refactors through incremental changes with verification and rollback awareness. Use when building new behavior, extending flows, or refactoring existing code.
---

# Feature Implementation Loop

Phase 3 slice implementation skill.

## Doctrine

- `governance/plans/plan_template.md` §1a — slice granularity (`T##.SL#`), V-tier evidence, role separation.
- `.cursor/rules/sprint-task-specification.mdc` — end-state task format.
- `governance/plans/definition_of_done.md`.
- `.cursor/rules/anomaly-log.mdc` → `strategy/anomalies/anomaly_template.md`.
- `.cursor/rules/api-architecture.mdc` — when working in API paths.

## Loads

None at skill entry — load `api-architecture.mdc` context when touching `finance_manager_api/`.

## Tools

- `test_api` / `test_web` / `test_rust` — focused verification.
- `local_stack_health`, `fm_docker_status`, `env_check` — runtime context.
- `changelog_entry` — CPPRD documentation step before commit.

## Procedure

- [ ] Confirm repository scope and active branch (`cur/s1b/*`).
- [ ] Confirm assigned task or slice (`T##` / `T##.SL#`); ask clarifying questions if underspecified.
- [ ] Define acceptance criteria; stay inside slice surface (one page or one API seam).
- [ ] Implement incrementally in reviewable steps.
- [ ] Run focused tests/checks (`test_*`, `local_stack_health` as needed).
- [ ] Log anomalies per `anomaly-log.mdc` if out-of-scope issues found — do not fix inline.
- [ ] Run `changelog_entry` when behavior changes.
- [ ] Return via `shared-subagent-handoff` with `Skill(s) used: feature-implementation-loop`.

## Cross-plan handoff

If task reveals out-of-scope work, hand off per `execution_protocols.md` §2.2 `[HANDOFF: cross_plan]`
with `Skill(s) to load` naming the correct destination skill.

## Guidance

- One coherent intent per change set; reuse existing patterns before new abstractions.
- Preserve contracts unless explicitly changing them.
