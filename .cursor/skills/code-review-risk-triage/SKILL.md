---
name: code-review-risk-triage
description: Review changes for correctness, regressions, security issues, and test gaps in severity order. Use when the user asks for a review, PR feedback, or merge risk assessment.
---

# Code Review Risk Triage

## Focus Order

1. Correctness and regressions
2. Security and data integrity risks
3. Contract/API behavior changes
4. Missing or weak tests
5. Maintainability concerns

## Workflow

- Identify changed files and runtime impact surface.
- Validate behavior against existing scoped rules.
- List findings by severity with concrete evidence.
- Include explicit test coverage gaps.
- Use `shared-subagent-handoff` for final report shape.

## Output Requirements

- Lead with findings, highest severity first.
- Include "No critical issues found" when applicable.
- Keep summaries short; prioritize actionable issues.
