---
name: shared-subagent-handoff
description: Standardize delegated task outputs into a concise handoff contract. Use when a subagent completes work and results need to be merged, reviewed, or passed to another agent.
---

# Shared Subagent Handoff

Return-contract mechanism for all delegated Cursor work.

## Doctrine

None — this is the contract itself.

## Loads

None.

## Tools

None.

## Output contract

Use this exact section order:

```markdown
## Objective
<what was requested and scope boundary; include plan task or slice ID (T## / T##.SL#) when governed>

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
- GitHub mergeability reconciliation: clean | conflicting | dirty | unknown

## Skill(s) used
<every skill actually loaded during this task — required, auditable against delegation packet>

## Next Action
- ...
```

## Rules

- Keep each section compact and concrete.
- **`Skill(s) used`** is required — list every skill loaded, not just the primary one.
- Call out blockers immediately instead of hiding uncertainty.
- If no files changed, state "Changed: none".
- If verification is partial, explain exactly what remains.
