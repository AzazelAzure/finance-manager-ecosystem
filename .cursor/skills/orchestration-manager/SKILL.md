---
name: orchestration-manager
description: Coordinate execution against active plans by delegating tasks to workflow-specific skills/subagents, enforcing validation gates, and retasking when failures occur. Use when managing multi-step implementation plans, parallel agent work, or final readiness checks before completion.
---

# Orchestration Manager

## Mission

Act as the execution manager over active plans:

- **Plan root:** execution-ready plans from `roadmap-rollout-planning` live under `plans/<Phase>/<Stage>/<sub-plan>/` (see that skill and `governance/orchestration.md`). Treat that directory as the canonical plan root unless explicitly overridden.
- read current plan scope and todo state
- assign work to the correct skill/subagent pathway
- enforce testing and handoff gates
- retask/replan when failures or blockers appear
- only mark complete when readiness checks pass

## Agent Wiring

Treat orchestration as a dedicated reusable agent profile:

- Launch as `generalPurpose` subagent with description: `Plan orchestration manager`
- Use `.cursor/skills/orchestration-manager/AGENT_PROMPT_TEMPLATE.md` as the launch prompt base
- First step must always read this skill file before delegating tasks

## Primary Routing Map

- Code review/risk checks -> `code-review-risk-triage`
- Bug failures/regressions -> `bugfix-investigation-loop`
- Feature delivery/refactor -> `feature-implementation-loop`
- CI/test failures -> `ci-test-triage`
- PR readiness/changelog/hygiene -> `pr-ops-merge-readiness`
- Codebase discovery/unknown ownership -> `repo-exploration-briefing`
- Multi-repo dependencies -> `multi-repo-orchestration`
- Design docs updates -> `design-docs-sync`
- Phase/rollout planning -> `roadmap-rollout-planning`
- Runtime/container incidents -> `container-runtime-podman-triage`

## Orchestration Workflow

- [ ] Locate the active plan under `plans/<Phase>/<Stage>/<sub-plan>/` (or the path given at launch) and read scope/todos.
- [ ] Prefer delegating **slice** units (`T##.SL#`) per `governance/plan_template.md` §1a when the plan defines them.
- [ ] Read active plan and identify executable task batches.
- [ ] Classify each task into the routing map above.
- [ ] Delegate with explicit scope, success criteria, and expected handoff format.
- [ ] Enforce breakpoint validation before opening the next batch.
- [ ] If a task fails, retask to the correct skill path and update the execution order.
- [ ] Require final cross-check before completion declaration.

## Required Delegation Packet

Every delegated task must include:

1. Plan **task or slice ID** (`T##` or `T##.SL#`) and current objective
2. Scope boundary (repo/path/system boundary)
3. Definition of done
4. Required verification command/checklist
5. Known constraints (rules, contracts, runtime owner if applicable)
6. Branch/PR expectations (feature branch, target branch, required checks/signoffs when applicable)

## Failure and Retask Protocol

When a delegated task fails or returns partial validation:

1. Capture blocker category:
   - implementation defect
   - contract mismatch
   - runtime/test instability
   - missing context/ownership
2. Reclassify and route to the right skill.
3. Reorder remaining tasks if dependency chain changed.
4. Re-run failed validation gate before progressing.

## Final Readiness Gate (Pre-Completion Authority)

Do not declare a plan complete until all are true:

- task-level validations are passed or explicitly accepted as deferred
- cross-repo dependencies are resolved or documented as handoff
- changelog/docs updates are in place where behavior changed
- runtime/testing checks for touched systems are complete
- PR/check/signoff gates are satisfied for branches intended to merge
- unresolved risks are listed with concrete next actions

## Guardrails

- Preserve repository boundaries and avoid cross-repo commit mixing.
- Prefer deterministic verification over broad reruns.
- Use `shared-subagent-handoff` for every delegated result.
- For runtime-dependent tasks, follow single-owner protocol and testing breakpoints.
- For PR workflows: send the **PR link in the Cursor chat** (repo, branch, URL); reconcile live **GitHub** mergeability, conflicts, and required checks before merge. Follow `governance/execution_protocols.md` for HitM Slack gates when the plan requires them.
- If any approval signal conflicts with GitHub (`mergeable=CONFLICTING` or dirty checks), classify as `blocked` and require resolution before merge.
