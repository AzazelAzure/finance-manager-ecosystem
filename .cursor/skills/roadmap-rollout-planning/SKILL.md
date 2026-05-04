---
name: roadmap-rollout-planning
description: Build phased roadmaps and feature rollout plans with clear breakpoints, triggers, dependencies, and validation gates. Use when planning implementation phases, milestone sequencing, or future design_docs updates.
---

# Roadmap and Rollout Planning

## Plan artifact location (orchestration handoff)

When a rollout plan is **ready to execute** (not while still brainstorming in chat), materialize it on disk for `/orchestration-manager`:

- **Path:** `plans/<Phase>/<Stage>/<sub-plan>/` (hierarchical layout locked 2026-04-30; active Stage S1.B lives under `plans/S1/S1.B/` as of 2026-05-04). See `governance/branching_guidelines.md` and `strategy/strategic-roadmap-reframe-53be/README.md` §8. Example: drift cleanup → `plans/S1/S1.B/drift-cleanup/`. Git branch names still use `cursor/s1b/...` until a branch rename workstream lands.
- Legacy top-level `plans/feat/`, `plans/fix/`, `plans/volatile/` trees were moved under `plans/archived/` on 2026-05-01; do not add new plans there.
- Put the phased plan, task packets, checkpoints, and any manifest files **inside** that folder so the orchestrator has a single root to read. Use `governance/plan_template.md` for required metadata fields.

This is **implicit** for all roadmap outputs that transition from planning to execution: do not leave execution-ready plans only in chat or ad hoc paths.

## Planning Inputs

- Current architecture and constraints
- Target user/business outcome
- Cross-repo dependencies
- Delivery risk and operational limits

## Planning Routine

- [ ] For multi-surface features, author **tasks** `T##` and **slices** `T##.SL#` in plan artifacts per `governance/plan_template.md` §1a (`SL` avoids confusion with Phase `S1` / Stage `S1.B`).
- [ ] Define phase goals and completion criteria.
- [ ] Set breakpoints (decision gates) between phases.
- [ ] Define triggers for moving to next phase.
- [ ] Capture required implementation artifacts and ownership.
- [ ] Add validation checkpoints for each phase.
- [ ] Document rollback/mitigation paths for high-risk steps.
- [ ] When the plan is execution-ready, create `plans/<Phase>/<Stage>/<sub-plan>/` and write artifacts there for orchestration manager consumption; register in `governance/plan_registry.md` when promoting past `draft`.

## Deliverable Format

```markdown
## Phase
- Goal:
- Entry criteria:
- Exit criteria:
- Breakpoints:
- Triggers:
- Dependencies:
- Required implementation updates:
- Verification gate:
- Risks and mitigations:
```

## Delegation Defaults

- Use `explore` to gather architecture/current-state evidence.
- Use `generalPurpose` to author phased rollout updates and to create the `plans/<Phase>/<Stage>/<sub-plan>/` tree when moving to execution.
- Feed outputs into `design-docs-sync` when plan requires doc edits.
- Hand execution to `orchestration-manager` with the plan root path under `plans/<Phase>/<Stage>/<sub-plan>/`.
