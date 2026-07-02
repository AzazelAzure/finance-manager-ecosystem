---
name: functional-investigation-report
description: Produce scoped codebase investigation reports (T00-style) answering specific factual questions for design gates — field existence, current behavior, call paths — without proposing design decisions. Use when Claude's design-first-gate needs evidence Claude should not deep-trace itself.
---

# Functional Investigation Report

Phase 1 feeder skill. Produces V0/V1-grade investigation evidence, not design decisions.
Precedent: F-009 T00 report (`plans/S1/S1.B/active/feat-f009-recurring-auto-deduct/reports/T00_functional_investigation_2026-07-01.md`).

## Doctrine

- `governance/plans/plan_template.md` §1a — evidence tiers (V0/V1 investigation, not V2/V3 design).

## Loads

None.

## Tools

Repo search and read only — no MCP tools required.

## Procedure

1. Receive a scoped question set (does field X exist, what does behavior Y do, where is Z wired).
2. Trace code paths with focused search/read — report facts only.
3. Flag open questions that require HitM or design-first-gate input; do not answer them with design proposals.
4. Stop at facts — no "we should refactor" or "recommended approach" sections unless explicitly asked for options (and even then, label as out-of-scope for this skill).
5. Structure output for consumption by `design-first-gate` or plan task authors.

## Output shape

```markdown
## Investigation scope
<question set and repos/paths>

## Findings
- <fact with file:line evidence>

## Open questions
- <unresolved, needs design decision>

## Evidence commands
- <searches/reads performed>
```

## Handoff

Return via `shared-subagent-handoff` with `Skill(s) used: functional-investigation-report`.
