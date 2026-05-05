# `#sprint-queue` — F-007 polish (examples + ordering)

**Canonical spec (normative):** [`governance/sprint_queue_message_spec_v1.md`](../../../../governance/sprint_queue_message_spec_v1.md) — **all** `#sprint-queue` posts must follow that document (field order, **`Task Id:`** on line 2 — exact spelling/casing the runner parses — `BRANCH:` suffix, tilde paths). **Do not** fork the spec here; extend only via **`sprint-queue-v2`** when that huddle lands.

**Bridge / PA:** [`design_docs/40_System_Design/12_Cursor_CLI_Slack_Cloud_Agent_Bridge.md`](../../../../design_docs/40_System_Design/12_Cursor_CLI_Slack_Cloud_Agent_Bridge.md) · [`governance/cursor_pa_slack_visibility.md`](../../../../governance/cursor_pa_slack_visibility.md)

---

## Slice posting order (F-007 polish)

Post **one top-level message per slice** in this order (aligns with [`README.md`](./README.md) §4a slice catalog):

1. `T00.SL1` → `T00.SL2` (protocol + sprint_verify dry-run)
2. `T01.SL1` → `T01.SL2` → `T01.SL3` → `T01.SL4` (help-mode flow)
3. `T02.SL1` → `T02.SL2` → `T02.SL3` → `T02.SL4` → `T02.SL5` (form modals)
4. `T03.SL1` → `T03.SL2` → `T03.SL3` → `T03.SL4` (calendar tour)

---

## `WORKSPACE_PATH` for this plan

- **Plan / markdown under `plans/`** (T00.SL1, parts of handoff): use the **monorepo parent** checkout, e.g. `~/agent-workspaces/cursor-executor/finance_manager`, so `plans/...` paths resolve.
- **Web implementation slices** (T01+ code): use the **web sub-repo** root per [`governance/sprint_queue_message_spec_v1.md`](../../../../governance/sprint_queue_message_spec_v1.md) template, e.g. `~/agent-workspaces/cursor-executor/finance_manager/finance_manager_web`.

Match the executor machine layout before posting; wrong root sends work to a tree that cannot see the files.

---

## Example — `T00.SL1` (copy into Slack)

Use **`Task Id:`** (capital **I**, lowercase **d**) on line 2 — required for **cursor-agent** queue routing (not local Cursor chat).

```text
@Cursor PA
Task Id: F-007
REPO: finance_manager_web
WORKSPACE_PATH: ~/agent-workspaces/cursor-executor/finance_manager
BRANCH: cursor/s1b/feat/f007-walkthrough-polish (already checked out)
SLICE: T00.SL1 — Protocol acceptance (definition of done + parent BUG links)

READ FIRST:
~/agent-workspaces/cursor-executor/finance_manager/plans/S1/S1.B/feat-f007-walkthrough-polish/runtime_handoff.md
~/agent-workspaces/cursor-executor/finance_manager/plans/S1/S1.B/feat-f007-walkthrough-polish/tasks/T00_protocol_and_acceptance.md
~/agent-workspaces/cursor-executor/finance_manager/plans/S1/S1.B/feat-f007-guided-walkthroughs/runtime_handoff.md

TASKS:

1. Open plans/S1/S1.B/feat-f007-walkthrough-polish/tasks/T00_protocol_and_acceptance.md and complete the T00.SL1 checklist (V0): write definition of done for (a) help-mode to linear tour without an extra button press after widget select unless a11y requires explicit confirm; (b) form modals — minimum at least 2 visible Joyride steps per primary modal type; (c) calendar — tour covers month nav + cell selection path.
2. Link parent F-007 plans/S1/S1.B/feat-f007-guided-walkthroughs/runtime_handoff.md BUG rows this polish plan supersedes or extends.

FILES TO MODIFY:

- plans/S1/S1.B/feat-f007-walkthrough-polish/tasks/T00_protocol_and_acceptance.md
- plans/S1/S1.B/feat-f007-walkthrough-polish/evidence/ (optional short V0 notes)

ACCEPTANCE:

- T00.SL1 checkboxes in the task file marked complete with concrete prose.
- No npm run build required for this doc-only slice.
- Do not start T00.SL2 until orchestrator queues the next slice.
- If you commit: use subject prefix docs(f007):.

SPEC: sprint-queue-v1
PLAN_ID: PLAN_CROSS_F007_WALKTHROUGH_POLISH_2026-05-21
PLAN_ROOT: plans/S1/S1.B/feat-f007-walkthrough-polish/
SLICE_ID: T00.SL1
VERIFY_TIERS: V0
RETRY_OF: none
```

Adjust `WORKSPACE_PATH` / `BRANCH` suffix to match the executor’s actual checkout before posting.
