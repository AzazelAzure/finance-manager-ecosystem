---
name: ci-test-triage
description: Triage test and CI failures quickly by classifying failure type, narrowing blast radius, and proposing deterministic fixes. Use when checks are failing locally or in CI pipelines.
---

# CI and Test Triage

Phase 3 slice implementation skill.

## Doctrine

- `governance/plans/plan_template.md` §1a.
- `governance/plans/definition_of_done.md`.
- `.cursor/rules/anomaly-log.mdc` → `strategy/anomalies/anomaly_template.md`.

## Loads

None.

## Tools

- `ci_status` — pipeline state and failure signals.
- `test_api` / `test_web` / `test_rust` — local reproduction.
- `changelog_entry` — when fix changes behavior or test infrastructure.

## Procedure

- [ ] Capture failing command and exact error via `ci_status` or local rerun.
- [ ] Reproduce in narrowest scope (`test_*` targeted to failing area).
- [ ] Classify: environment/setup | test regression | flake | fixture drift | lint/type.
- [ ] Distinguish flake from deterministic failure before code edits.
- [ ] Apply minimal fix; rerun targeted checks before full suite.
- [ ] Return via `shared-subagent-handoff` with `Skill(s) used: ci-test-triage`.

## Cross-plan handoff

Per `execution_protocols.md` §2.2 with `Skill(s) to load` when failure reveals separate plan work.

## Guidance

- Avoid full-suite reruns until targeted failures pass.
- Escalate infra/auth flakes with evidence rather than masking.
