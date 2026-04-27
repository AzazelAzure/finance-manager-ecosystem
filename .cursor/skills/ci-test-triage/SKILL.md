---
name: ci-test-triage
description: Triage test and CI failures quickly by classifying failure type, narrowing blast radius, and proposing deterministic fixes. Use when checks are failing locally or in CI pipelines.
---

# CI and Test Triage

## Failure Classification

- Environment/setup failure
- Test logic regression
- Flaky/non-deterministic behavior
- Contract/data fixture drift
- Tooling/lint/type enforcement

## Workflow Checklist

- [ ] Capture failing command and exact error output.
- [ ] Reproduce in the narrowest scope possible.
- [ ] Classify failure type and likely owner layer.
- [ ] Apply minimal fix and rerun targeted checks.
- [ ] Run broader confidence checks as needed.
- [ ] Report confidence level and remaining uncertainty.

## Guidance

- Avoid full-suite reruns until targeted failures pass.
- Distinguish flaky from deterministic failures before code edits.
- Use `shared-subagent-handoff` for result reporting.
