---
name: parent-repo-dispatch-routing
description: Use whenever a task touches the parent/ecosystem repo itself (scripts/, .cursor/, governance/, root-level config) rather than a sub-repo. Decides whether Claude does the work directly (governance/planning content) or it needs Cursor (code/script/skill-config content), and if Cursor, which dispatch path is actually live right now.
---

# Parent-Repo Dispatch Routing

Built per the first real skill authored under `skill_authoring_template.md`'s 7-section shape —
`strategy/meetings/week27/meeting2026-07-02/tp-skill-generation/skill_authoring_template.md`.

## Category

Phase skill (Phase 2 / pickup-adjacent) — a specialization of `cross-repo-queue-sequencing` for
the one case that skill's general logic doesn't cover: the parent repo has no per-repo worker
the way `api`/`web` do.

## Doctrine

- `governance/execution/workspace_protocol.md` §2 — `HFM` is explicitly "Not pooled"; there is no
  `WS-PARENT` clone the way `WS-API`/`WS-WEB` exist.
- `CLAUDE.md` — Claude's own boundary ("no code implementation... write the governance/planning
  artifact, note Cursor owns execution"). This is the actual test this skill applies at step 1.
- `strategy/meetings/week27/meeting2026-07-02/tp-skill-generation/ws_parent_infra_spec.md` — the
  proposed (not yet implemented, as of 2026-07-02) `parent` queue extension. Check this file's own
  "Status" line before assuming a dispatch path exists.

## Loads

- `cross-repo-queue-sequencing` (imperative) — this skill's dispatch-sequencing logic still
  applies once a parent-repo task is confirmed to need Cursor; this skill only adds the
  classification step in front of it.

## Tools

- `queue_push` — usable **only if** `ws_parent_infra_spec.md`'s status shows the `parent` repo
  value has actually been implemented (not just spec'd). Check before using; do not assume.

## Procedure

1. **Classify the task.** Is it governance/planning/doc content (a `.md` file under `governance/`,
   `strategy/`, a plan artifact, a skill spec) or code/script/config content (`scripts/*.sh`,
   `scripts/mcp/*.py`, `.cursor/rules/*.mdc`, `.cursor/skills/*/SKILL.md`, anything that executes)?
2. **If governance/planning content:** Claude does it directly — this is squarely in-lane, no
   dispatch needed. Most parent-repo work is this category (this session's entire governance
   folder reorg, all tp-* docs, all skill specs).
3. **If code/script/config content:** this is Cursor's lane regardless of dispatch-path
   availability — do not attempt the change directly, even if it looks simple (a one-line script
   fix is still "code implementation" per `CLAUDE.md`).
4. **Check dispatch-path availability** (`ws_parent_infra_spec.md` status):
   - **If `parent` queue is live:** `queue_push(repo=parent, ...)`, load
     `cross-repo-queue-sequencing` for the actual sequencing decision.
   - **If not yet live (the current state as of 2026-07-02):** no queue path exists. Write a
     precise, dispatch-ready spec (doctrine, scope, definition of done — same shape as
     `cursor_skill_rebuild_spec.md` used tonight) and flag to HitM that it needs manual
     `cursor agent --print --workspace <repo-root> --trust --force` dispatch, same as T01 and
     tonight's skill rebuild. Do not silently work around the gap by writing the code change
     yourself.

## Handoff

- To Cursor (queued or manual): `Skill(s) to load: <matching Cursor-side phase skill>` — e.g.
  `orchestration-manager` for coordination-scoped changes, or the specific Phase 3 skill that
  matches the work.
- Decision log / meeting record: `Skill(s) used: parent-repo-dispatch-routing,
  cross-repo-queue-sequencing` (when loaded).
