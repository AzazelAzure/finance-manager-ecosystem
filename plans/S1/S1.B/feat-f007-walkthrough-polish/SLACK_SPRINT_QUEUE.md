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

Use **`@CursorPA`** on line 1 (no space — `@Cursor PA` breaks the mention in HitM’s Slack) and **`Task Id:`** (capital **I**, lowercase **d**) on line 2 — required for **cursor-agent** queue routing (not local Cursor chat).

```text
@CursorPA
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

---

## After a slice completes (review + next slice)

**Automated (default):** run [`scripts/sprint_slack_pipeline_bridge.py`](../../../../scripts/sprint_slack_pipeline_bridge.py) with `SLACK_BOT_TOKEN` and channel envs. In the **sprint task thread**, append one line:

`SPRINT_PIPELINE_JSON: {"status":"READY_FOR_REVIEW",...}`

per [`governance/sprint_queue_message_spec_v1.md`](../../../../governance/sprint_queue_message_spec_v1.md) §**Machine-readable pipeline**. Optional next-slice file under [`evidence/pipeline_queue/`](./evidence/pipeline_queue/README.md).

**Manual fallback:** top-level `#review-queue` prose envelope + verdict, same as before.

### Thread reply — `SPRINT_PIPELINE_JSON` (pick up by `sprint_slack_pipeline_bridge.py`)

Post **one Slack message** in the **same thread** as the original `#sprint-queue` task (reply to parent). The body should be **only** the line below (no leading fence in Slack — fences here are for doc display). Replace `COMMIT` with the short SHA you pushed (or `none` before first push).

```text
SPRINT_PIPELINE_JSON: {"status":"READY_FOR_REVIEW","slice_id":"T00.SL1","plan_root":"plans/S1/S1.B/feat-f007-walkthrough-polish/","plan_id":"PLAN_CROSS_F007_WALKTHROUGH_POLISH_2026-05-21","repo":"finance_manager_web","branch":"cursor/s1b/feat/f007-walkthrough-polish","commit":"COMMIT","v1_evidence":"tasks/T00_protocol_and_acceptance.md + evidence/T00.SL1_V0_acceptance_notes.md; PR https://github.com/AzazelAzure/finance-manager-ecosystem/pull/55","verify_tiers":"V0","requires_hitm":false,"next_queue_message_path":"next_t00_sl2.txt"}
```

- **`next_queue_message_path`:** relative to `SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR` (see [`evidence/pipeline_queue/README.md`](./evidence/pipeline_queue/README.md)); file [`next_t00_sl2.txt`](./evidence/pipeline_queue/next_t00_sl2.txt) is the queued **T00.SL2** sprint top-level.
- **`verify_tiers":"V0"`** + `SPRINT_BRIDGE_AUTO_PASS_V0=1` → bridge posts synthetic **PASS** and then posts `next_t00_sl2.txt` to `#sprint-queue` automatically.
- For **V1+** slices, set `verify_tiers` accordingly and have a reviewer post **`REVIEW_VERDICT`** JSON in `#review-queue` (or extend automation later).

**Executor workspace:** if the clone is a collaborator mirror, run `git fetch origin main && git merge origin/main` (or rebase) on the feature branch before T00.SL2 so `scripts/` and `governance/` match this ecosystem repo.

## Ordering

Post slices in execution order (README §4a): **T00.SL1 → T00.SL2 → T01.SL1 → …** One message per slice.
