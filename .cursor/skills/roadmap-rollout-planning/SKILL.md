---
name: roadmap-rollout-planning
description: Build phased roadmaps and feature rollout plans with clear breakpoints, triggers, dependencies, and validation gates. Use when planning implementation phases, milestone sequencing, or future design_docs updates.
---

# Roadmap and Rollout Planning

## Plan artifact location (orchestration handoff)

When a rollout plan is **ready to execute** (not while still brainstorming in chat), materialize it on disk for `/orchestration-manager`:

- **Path:** `plans/<proposed-git-branch-name>/`
- **`<proposed-git-branch-name>`** is the primary feature branch you intend to use for that execution batch (one directory per plan/batch). Mirror git’s `/` segments as nested folders (e.g. branch `fix/reflex-login-form` → `plans/fix/reflex-login-form/`). If you prefer a single segment, flatten with hyphens (e.g. `plans/fix-reflex-login-form/`) but stay consistent within the workspace.
- Put the phased plan, task packets, checkpoints, and any manifest files **inside** that folder so the orchestrator has a single root to read.

This is **implicit** for all roadmap outputs that transition from planning to execution: do not leave execution-ready plans only in chat or ad hoc paths.

## Planning Inputs

- Current architecture and constraints
- Target user/business outcome
- Cross-repo dependencies
- Delivery risk and operational limits

## Planning Routine

- [ ] Define phase goals and completion criteria.
- [ ] Set breakpoints (decision gates) between phases.
- [ ] Define triggers for moving to next phase.
- [ ] Capture required implementation artifacts and ownership.
- [ ] Add validation checkpoints for each phase.
- [ ] Document rollback/mitigation paths for high-risk steps.
- [ ] When the plan is execution-ready, create `plans/<proposed-git-branch-name>/` and write artifacts there for orchestration manager consumption.

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
- Use `generalPurpose` to author phased rollout updates and to create the `plans/<proposed-git-branch-name>/` tree when moving to execution.
- Feed outputs into `design-docs-sync` when plan requires doc edits.
- Hand execution to `orchestration-manager` with the plan root path under `plans/<proposed-git-branch-name>/`.
