---
name: roadmap-rollout-planning
description: Build phased roadmaps and feature rollout plans with clear breakpoints, triggers, dependencies, and validation gates. Use when planning implementation phases, milestone sequencing, or future design_docs updates.
---

# Roadmap and Rollout Planning

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
- Use `generalPurpose` to author phased rollout updates.
- Feed outputs into `design-docs-sync` when plan requires doc edits.
