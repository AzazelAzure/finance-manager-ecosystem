---
name: code-review-risk-triage
description: Review a diff for correctness, regressions, security, and test gaps before opening a PR — pre-PR self-review, distinct from WS3 merge-gate TBV. Use when reviewing local changes or a branch diff before CPPR.
---

# Code Review Risk Triage

Phase 3 skill — **pre-PR** self-review. Distinct from Phase 5 `pr-review-and-merge` (merge-gate TBV pass).

## Doctrine

- `governance/plans/plan_template.md` §1a — V-tier evidence; findings are V0/V1, not self-certified V3.
- `governance/plans/definition_of_done.md`.
- `.cursor/rules/anomaly-log.mdc` → `strategy/anomalies/anomaly_template.md`.

## Loads

None.

## Tools

- `branch_delta` — scope of changes vs target branch.
- `test_api` / `test_web` / `test_rust` — verify critical paths touched.
- Repo read/search — evidence for findings.

## Procedure

1. Identify changed files and runtime impact surface (`branch_delta` or `git diff`).
2. Review in severity order: correctness/regressions → security/data integrity → contracts → tests → maintainability.
3. List findings with concrete evidence (file:line).
4. Include explicit test coverage gaps.
5. Fix blockers before proceeding to `pr-ops-merge-readiness`; document accepted risks.
6. Return via `shared-subagent-handoff` with `Skill(s) used: code-review-risk-triage`.

## Output requirements

- Lead with findings, highest severity first.
- State "No critical issues found" when applicable.
- Actionable issues only — no style nitpicks.
