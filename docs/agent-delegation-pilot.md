# Agent Delegation Pilot and Tuning

Use this to validate and tune skill/subagent efficiency across repos.

## Pilot Matrix

1. API task (`finance_manager_api/`): bugfix or feature touching service/logic boundaries.
2. Web task (`finance_manager_web/`): flagship SPA UI/UX with API contract dependency awareness (`finance_manager_reflex/` is **archived**).
3. CLI task (`finance_manager_cli/`): command flow or output behavior update.
4. Multi-repo task: one API contract shift with downstream **web** or CLI adaptation.
5. Documentation sync task: implementation change followed by `design_docs` updates.
6. Planning task: phase/rollout design with breakpoints and trigger definition.

## Metrics to Record

- Time to first correct change (minutes)
- Clarification loops required (count)
- Rework caused by misrouted delegation (count)
- Verification completeness (`pass`, `partial`, `blocked`)
- Cross-repo handoff misses (count)
- PR hygiene completeness (branch + PR + checks + signoff recorded: yes/no)
- Design docs drift resolved (yes/no and files)
- Planning artifact completeness (phases, triggers, breakpoints present)

## Execution Template

```markdown
### Pilot Task
- Repo:
- User intent:
- Chosen skill:
- Chosen subagent type:

### Outcome
- Time to first correct change:
- Clarification loops:
- Rework events:
- Verification status:
- Branch/PR/check/signoff status:

### Trigger Quality
- False positive? (skill invoked but not needed)
- False negative? (skill missed but should have been used)
- Suggested description/routing tweak:
```

## Tuning Rules

- If a workflow has repeated false positives, narrow trigger words in the skill description.
- If a workflow has repeated false negatives, add missing user-intent phrases to both the skill description and `agent-delegation.mdc`.
- If handoffs lack actionable content, enforce the shared handoff contract before final response.
