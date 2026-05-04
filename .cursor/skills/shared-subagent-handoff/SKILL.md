---
name: shared-subagent-handoff
description: Standardize delegated task outputs into a concise handoff contract. Use when a subagent completes work and results need to be merged, reviewed, or passed to another agent.
---

# Shared Subagent Handoff

## Output Contract

Use this exact section order:

```markdown
## Objective
<what was requested and scope boundary; include plan **task or slice ID** (`T##` / `T##.SL#`) when work came from a governed plan>

## Assumptions and Unknowns
- ...

## Evidence
- Commands/searches/tests run
- Key observations

## Files
- Reviewed:
- Changed:

## Risks
- ...

## Verification
- Status: pass | partial | blocked
- What was verified:

## Branch/PR Status
- Branch:
- PR URL/status:
- Required checks/signoffs:
- Slack notify sent to `#pull-requests`: yes/no
- Slack authorization state seen: approved | merged | changes_requested | blocked | pending
- GitHub mergeability reconciliation: clean | conflicting | dirty | unknown

## Next Action
- ...
```

## Rules

- Keep each section compact and concrete.
- Call out blockers immediately instead of hiding uncertainty.
- If no files changed, explicitly state "Changed: none".
- If verification is partial, explain exactly what remains.
