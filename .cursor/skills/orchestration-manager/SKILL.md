---
name: orchestration-manager
description: Coordinate execution against active plans by delegating to phase-mapped skills with explicit Skill(s) to load fields, enforcing validation gates, and retasking on failures. Use when managing multi-step plans, parallel agent work, or execution coordination across repos including parent HFM.
---

# Orchestration Manager

Fresh coordinator scoped to the deploy-lifecycle phase map (`tp-deploy-lifecycle-skills/notes.md`).
Absorbs parent-repo scope from the retired `multi-repo-orchestration` — repo list includes
`finance_manager_api/`, `finance_manager_web/`, `finance_manager_cli/`, and **parent `HFM/`**
(ecosystem/governance/submodule work).

## Doctrine

- `governance/plans/plan_lifecycle.md`, `governance/execution/execution_protocols.md`.
- `.cursor/rules/agent-delegation.mdc` — always-applied routing (cited, not migrated).
- `strategy/meetings/week27/meeting2026-07-02/tp-skill-generation/cursor_skill_rebuild_spec.md` — phase routing map.

## Loads (imperative)

**First, read this skill file.** Then load whichever Phase 2–6b skill matches the task — always
named explicitly in the delegation packet.

## Tools

- `plan_lookup` — active plan context.
- `queue_status` — FIFO queue state.
- `ws_status` — workspace claims.

## Phase routing map

| Phase | Skill |
|---|---|
| 0 Session | `session-orientation` |
| 1 Feeder | `functional-investigation-report` |
| 2 Pickup | `pickup-and-claim` |
| 3 Implement | `feature-implementation-loop`, `bugfix-investigation-loop`, `ci-test-triage`, `code-review-risk-triage`, `container-runtime-podman-triage`, `repo-exploration-briefing` |
| 4 Open PR | `pr-ops-merge-readiness` |
| 5 Merge | `pr-review-and-merge` (WS3) |
| 6a/6b Deploy | `deploy-execution` |

**Not Cursor:** Phase 7 (HitM verify), 6c/6d (cutover — Claude/HFM), Phase 8 close (Claude/HitM).

## Agent wiring

- Launch as `generalPurpose` subagent, description: `Plan orchestration manager`.
- Use `.cursor/skills/orchestration-manager/AGENT_PROMPT_TEMPLATE.md` as launch prompt base.
- First step: read this skill file.

## Orchestration workflow

- [ ] Locate active plan under `plans/<Phase>/<Stage>/<status>/<sub-plan>/`.
- [ ] Prefer slice units (`T##.SL#`) per `plan_template.md` §1a.
- [ ] Classify each task into phase routing map above.
- [ ] Delegate with full packet including **`Skill(s) to load: <name>`**.
- [ ] Enforce testing breakpoints before next batch.
- [ ] On failure, retask with updated `Skill(s) to load`.
- [ ] Require final readiness gate before completion declaration.

## Required delegation packet

Every delegated task must include:

1. Plan task or slice ID (`T##` / `T##.SL#`) and objective
2. Scope boundary — **include parent `HFM/` when ecosystem/governance/submodules involved**
3. Definition of done
4. Required verification commands/checklist
5. Known constraints (rules, contracts, runtime owner)
6. Branch/PR expectations
7. **`Skill(s) to load: <name(s)`** — mandatory, never implicit

## Failure and retask

Per `execution_protocols.md` §2.3 — reclassify, route with new `Skill(s) to load`, re-run failed gate.

## Final readiness gate

Do not declare complete until: validations passed, cross-repo deps resolved, changelog/docs in place,
runtime checks done, PR gates satisfied for merge-intended branches, risks listed.

## Guardrails

- Preserve repo boundaries — no cross-repo commits in one step.
- Use `shared-subagent-handoff` for every delegated result.
- PR links in Cursor chat; GitHub reconciliation before merge.
- `design-docs-sync` is **not** a Cursor skill — deferred to Gemini.
