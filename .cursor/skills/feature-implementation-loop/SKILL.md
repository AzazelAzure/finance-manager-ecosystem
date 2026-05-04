---
name: feature-implementation-loop
description: Deliver scoped features and refactors through incremental changes with verification and rollback awareness. Use when building new behavior, extending flows, or refactoring existing code.
---

# Feature Implementation Loop

## Workflow Checklist

- [ ] Confirm repository scope and relevant architecture rules.
- [ ] If work comes from a governed plan, confirm the assigned **task or slice** (`T##` or `T##.SL#` per `governance/plan_template.md` §1a) and stay inside that surface (typically one page or one API seam).
- [ ] If acceptance criteria, contracts, or UX are underspecified, **ask clarifying questions** before coding; do not guess product intent.
- [ ] Define acceptance criteria and constraints.
- [ ] Implement incrementally in reviewable steps.
- [ ] Verify behavior with focused tests/checks.
- [ ] Update changelog/docs if behavior changed.
- [ ] Provide residual risks and follow-up items.

## Guidance

- Keep one coherent intent per change set.
- Reuse existing helpers/patterns before introducing new abstractions.
- Preserve existing contracts unless explicitly changing them.
- Use `shared-subagent-handoff` for delivery.
