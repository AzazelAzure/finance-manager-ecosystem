---
name: repo-exploration-briefing
description: Produce fast codebase briefings mapping structure, ownership, and execution paths for unknown-ownership work. Use when the user asks where logic lives or how systems connect — broader than functional-investigation-report's narrow design questions.
---

# Repo Exploration Briefing

Distinct from `functional-investigation-report` (narrow T00-style factual answers for design gates).
This skill maps unknown territory before implementation planning.

## Doctrine

General codebase discovery — no phase-specific governance beyond `AGENTS.md` §5 sub-repo map.

## Loads

None.

## Tools

Repo search/read only.

## Procedure

- [ ] Define question scope and target repository (include parent `HFM/` when ecosystem-wide).
- [ ] Breadth-first mapping: key modules, entry points, ownership boundaries.
- [ ] Trace main data/control flow paths for the question at hand.
- [ ] Capture unknowns and ambiguous ownership — label assumptions clearly.
- [ ] Recommend next action (which phase skill, which plan slice).
- [ ] Return via `shared-subagent-handoff` with `Skill(s) used: repo-exploration-briefing`.

## Guidance

- Smallest file set for confidence — avoid deep dives before scope is clear.
- Do not propose product/design decisions; map what exists.
