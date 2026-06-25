# Roadmap and rollout planning (governance mirror)

**Antigravity source:** `roadmap-rollout-planning`
**This file:** same workflow for agents reading `governance/` only. Keep in sync when planning rules change.

---

## Mission

Build phased roadmaps and feature rollout plans with clear breakpoints, triggers, dependencies, and validation gates. Use when planning implementation phases, milestone sequencing, or future `design_docs` updates.

## Plan artifact location (orchestration handoff)

When a rollout plan is **ready to execute** (not while brainstorming only in chat), materialize it on disk for the orchestration manager:

- **Path:** `plans/<Phase>/<Stage>/<sub-plan>/` (hierarchical layout locked 2026-04-30; active Stage S1.B: `plans/S1/S1.B/`). See `governance/branching_guidelines.md` and `strategy/strategic-roadmap-reframe-53be/README.md` §8. Example: drift cleanup → `plans/S1/S1.B/drift-cleanup/`. Git branch names may still use `agy/s1b/...` until a rename workstream lands.
- Legacy top-level `plans/feat/`, `plans/fix/`, `plans/volatile/` trees live under `plans/archived/`; do not add new execution plans there.
- Put phased plan bodies, task packets, checkpoints, and manifests **inside** that folder so the orchestrator has a single root. Use `governance/plan_template.md` for required metadata fields.

Do not leave execution-ready plans only in chat or ad hoc paths.

## Planning inputs

- Current architecture and constraints
- Target user or business outcome
- Cross-repo dependencies
- Delivery risk and operational limits

## Planning routine

- [ ] For multi-surface delivery, decompose into **tasks** `T##` and **slices** `T##.SL#` per `plan_template.md` §1a (one page or one API seam per slice by default).
- [ ] Define phase goals and completion criteria.
- [ ] Set breakpoints (decision gates) between phases.
- [ ] Define triggers for moving to the next phase.
- [ ] Capture required implementation artifacts and ownership.
- [ ] Add validation checkpoints for each phase.
- [ ] Document rollback or mitigation paths for high-risk steps.
- [ ] When execution-ready, create `plans/<Phase>/<Stage>/<sub-plan>/`, write artifacts there, and register in `governance/plan_registry.md` when promoting past `draft`.

## Deliverable format

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

## Delegation defaults

- Use read-only exploration to gather architecture and current-state evidence.
- Use implementation-capable agents to author phased rollout updates and to create the `plans/<Phase>/<Stage>/<sub-plan>/` tree when moving to execution.
- Feed outputs into design-docs sync when the plan requires vault edits.
- Hand execution to the orchestration workflow with the plan root path under `plans/<Phase>/<Stage>/<sub-plan>/` (see `governance/skill_orchestration_manager.md`).
