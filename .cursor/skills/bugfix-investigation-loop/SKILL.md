---
name: bugfix-investigation-loop
description: Run a reproduce-isolate-fix-verify loop focused on root cause and minimal-risk patches. Use when investigating bugs, regressions, runtime failures, or unexpected behavior.
---

# Bugfix Investigation Loop

## Workflow Checklist

- [ ] Confirm active sub-repo and scope boundary.
- [ ] Reproduce the failure with a concrete command or scenario.
- [ ] Isolate root cause (not only symptom path).
- [ ] Apply minimal coherent fix.
- [ ] Verify with targeted tests and sanity checks.
- [ ] Document cause, fix, and residual risk in handoff format.

## Guidance

- Prefer deterministic reproductions over speculative fixes.
- Maintain architecture boundaries from scoped rules.
- If fix requires cross-repo changes, stop and provide handoff/follow-up plan.
- Use `shared-subagent-handoff` for final output.
