# Orchestration manager (governance mirror)

**Cursor source:** `.cursor/skills/orchestration-manager/SKILL.md`  
**This file:** same workflow for agents reading `governance/` only. Keep in sync when orchestration rules change.

---

## Mission

Coordinate execution against active plans by delegating to workflow-specific skills or subagents, enforcing validation gates, and retasking when failures occur. Use for multi-step plans, parallel agent work, or final readiness checks.

## Plan root

- **Default:** `plans/<Phase>/<Stage>/<sub-plan>/` (see `governance/branching_guidelines.md`, `plans/README.md`). Read the sub-plan `README.md`, task files, or `execution_manifest.md` inside that folder unless the session overrides the path.
- Treat that directory as the canonical plan root for batching and delegation.

## Agent wiring (Cursor)

- Launch as a general-purpose subagent with a clear description (for example: plan orchestration manager).
- Use `.cursor/skills/orchestration-manager/AGENT_PROMPT_TEMPLATE.md` as the launch prompt base when driving from Cursor.
- First step: read the Cursor skill file above **or** this governance mirror before delegating.

## Primary routing map

- Code review / risk → code-review-risk-triage  
- Bug / regression → bugfix-investigation-loop  
- Feature / refactor → feature-implementation-loop  
- CI / tests → ci-test-triage  
- PR / changelog / hygiene → pr-ops-merge-readiness  
- Discovery / ownership → repo-exploration-briefing  
- Multi-repo dependencies → multi-repo-orchestration  
- Design vault updates → design-docs-sync  
- Phase / rollout planning → roadmap-rollout-planning (see `governance/skill_roadmap_rollout_planning.md`)  
- Container runtime → container-runtime-podman-triage  

## Orchestration workflow

- [ ] Locate the active plan under `plans/<Phase>/<Stage>/<sub-plan>/` (or the path given at launch) and read scope and todos.
- [ ] Identify executable task batches.
- [ ] Classify each task into the routing map.
- [ ] Delegate with explicit scope, success criteria, and expected handoff format.
- [ ] Enforce breakpoint validation before opening the next batch.
- [ ] On failure, retask to the correct skill path and update execution order.
- [ ] Require a final cross-check before declaring completion.

## Required delegation packet

Every delegated task should include:

1. Plan task ID and current objective  
2. Scope boundary (repo, path, or system boundary)  
3. Definition of done  
4. Required verification command or checklist  
5. Known constraints (rules, contracts, runtime owner if applicable)  
6. Branch and PR expectations (feature branch, target branch, required checks and signoffs when applicable)  

## Failure and retask protocol

When a delegated task fails or returns partial validation:

1. Capture blocker category: implementation defect, contract mismatch, runtime or test instability, missing context or ownership.  
2. Reclassify and route to the right skill.  
3. Reorder remaining tasks if the dependency chain changed.  
4. Re-run the failed validation gate before progressing.  

## Final readiness gate (pre-completion)

Do not declare a plan complete until:

- Task-level validations pass or are explicitly accepted as deferred.  
- Cross-repo dependencies are resolved or documented as a handoff.  
- Changelog and docs updates are in place where behavior changed.  
- Runtime and testing checks for touched systems are complete.  
- PR, check, and signoff gates are satisfied for branches intended to merge.  
- Unresolved risks are listed with concrete next actions.  

## Guardrails

- Preserve repository boundaries; avoid cross-repo commit mixing in one commit.  
- Prefer deterministic verification over broad reruns.  
- Use `shared-subagent-handoff` (Cursor skill) for delegated results when available.  
- For runtime-dependent tasks, follow single-owner protocol and testing breakpoints in `.cursor/rules/container-testing-orchestration.mdc`.  
- **PR workflow:** Open PRs from feature branches; send the **PR link in the Cursor chat** (repo, branch, full URL); reconcile **GitHub** mergeability and required checks before merge. Follow `governance/execution_protocols.md` for HitM Slack gates where the plan requires them.  
- If automation or chat says approved but GitHub reports conflicting or dirty merge state, treat as blocked until resolved.  
