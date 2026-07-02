---
name: bugfix-investigation-loop
description: Run a reproduce-isolate-fix-verify loop focused on root cause and minimal-risk patches. Use when investigating bugs, regressions, runtime failures, or unexpected behavior.
---

# Bugfix Investigation Loop

Phase 3 slice implementation skill.

## Doctrine

- `governance/plans/plan_template.md` §1a — slice granularity, V-tier evidence.
- `.cursor/rules/sprint-task-specification.mdc`.
- `governance/plans/definition_of_done.md`.
- `governance/execution/branching_guidelines.md` §4 — bug-severity path (hotfix vs feature branch).
- `.cursor/rules/anomaly-log.mdc` → `strategy/anomalies/anomaly_template.md`.
- `.cursor/rules/api-architecture.mdc` — when working in API paths.

## Loads

None at skill entry.

## Tools

- `test_api` / `test_web` / `test_rust` — reproduction and regression checks.
- `local_stack_health`, `fm_docker_status`, `env_check`.
- `changelog_entry` — when behavior changes.

## Procedure

- [ ] Confirm sub-repo scope and branch (hotfix path per §4 if production-impacting).
- [ ] Confirm task/slice ID; ask clarifying questions if reproduction scope is ambiguous.
- [ ] Reproduce with a concrete command or scenario.
- [ ] Isolate root cause — not symptom-only patches.
- [ ] Apply minimal coherent fix.
- [ ] Verify with targeted tests; confirm regression closed.
- [ ] Log anomalies if out-of-scope issues found.
- [ ] Return via `shared-subagent-handoff` with `Skill(s) used: bugfix-investigation-loop`.

## Cross-plan handoff

Per `execution_protocols.md` §2.2 with `Skill(s) to load` for discovered cross-plan work.

## Guidance

- Prefer deterministic reproductions over speculative fixes.
- Cross-repo fixes require explicit handoff — do not expand scope silently.
