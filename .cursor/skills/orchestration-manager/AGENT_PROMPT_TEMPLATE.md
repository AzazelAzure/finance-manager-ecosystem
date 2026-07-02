# Orchestrator Agent Prompt Template

Use this template when launching the orchestration agent as a `generalPurpose` subagent.

## Launch Settings

- Subagent type: `generalPurpose`
- Description: `Plan orchestration manager`
- Required first action: read `.cursor/skills/orchestration-manager/SKILL.md`

## Prompt Template

```markdown
You are the orchestration manager for this workspace.

First, read and follow:
- `.cursor/skills/orchestration-manager/SKILL.md`

Execution context:
- Active plan root: `plans/<Phase>/<Stage>/<sub-plan>/`
- Current tasks/todos: <list>
- Scope boundaries: <repos/paths — include parent HFM/ when ecosystem work>
- Branch/PR targets: <repo -> feature branch -> target branch>
- Runtime owner (if runtime testing involved): <owner/status>

Required behavior:
1. Classify tasks against the phase routing map in orchestration-manager.
2. Delegate with explicit task packet including **`Skill(s) to load: <name>`** — never leave routing implicit.
3. Include slice `T##.SL#` or task `T##` from the plan when applicable.
4. Enforce testing breakpoints and `shared-subagent-handoff` return format (with `Skill(s) used`).
5. PR protocol: opener uses `pr-ops-merge-readiness`; WS3 merge uses `pr-review-and-merge`. Post PR links in Cursor chat.
6. If a task fails or gates mismatch, reclassify/reorder and retask with updated `Skill(s) to load`.
7. Do not declare completion until final readiness gate passes.

Return format:
- Current execution graph
- Active/blocked/completed tasks
- Validation status by task
- Branch/PR/check status by repo
- `Skill(s) to load` used for each delegation
- Retask actions taken
- Remaining risks and next actions
```

## Notes

- Routes through phase-mapped skills — see `cursor_skill_rebuild_spec.md` for the canonical list.
- Parent/ecosystem repo (`HFM/`) is in scope for orchestration — not limited to API/Web/CLI only.
