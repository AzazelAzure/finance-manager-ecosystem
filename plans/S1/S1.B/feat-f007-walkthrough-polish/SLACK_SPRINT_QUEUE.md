# `#sprint-queue` — F-007 polish (examples + ordering)

**Canonical spec (normative):** [`governance/sprint_queue_message_spec_v1.md`](../../../../governance/sprint_queue_message_spec_v1.md) — **all** `#sprint-queue` posts must follow that document (field order, `Task Id:` line 2, `BRANCH:` suffix, tilde paths). **Do not** fork the spec here; extend only via **`sprint-queue-v2`** when that huddle lands.

**Bridge / PA:** [`design_docs/40_System_Design/12_Cursor_CLI_Slack_Cloud_Agent_Bridge.md`](../../../../design_docs/40_System_Design/12_Cursor_CLI_Slack_Cloud_Agent_Bridge.md) · [`governance/cursor_pa_slack_visibility.md`](../../../../governance/cursor_pa_slack_visibility.md)

---

## Slice posting order (F-007 polish)

Post **one top-level message per slice** in this order (aligns with [`README.md`](./README.md) §4a slice catalog):

1. `T00.SL1` — Protocol acceptance  
2. `T00.SL2` — Help-mode extra click  
3. `T00.SL3` — Form step-by-step  
4. `T00.SL4` — Transaction calendar  
5. `T01.SL1` … `T01.SL4` — Help-mode polish (after T00)  
6. `T02.SL2` … `T02.SL5` — Form polish (after T00)  
7. `T03.SL1` … `T03.SL4` — Transaction calendar polish (after T00)  
8. `T04` … `T07` — remaining rows per README

---

## Example — `T00.SL1` (copy into Slack)

```text
@Cursor PA
Task Id: F-007
REPO: finance_manager_web
WORKSPACE_PATH: ~/agent-workspaces/cursor-executor/finance_manager/finance_manager_web
BRANCH: cursor/s1b/feat/f007-walkthrough-polish (already checked out)
SLICE: T00.SL1 — Protocol acceptance

READ FIRST:
~/agent-workspaces/cursor-executor/finance_manager/plans/S1/S1.B/feat-f007-walkthrough-polish/README.md
~/agent-workspaces/cursor-executor/finance_manager/governance/plan_template.md

TASKS:

1. Read README §4a and confirm slice catalog + V-tier table for T00.
2. Confirm no code edits for T00.SL1 (V0); documentation + registry alignment only.

FILES TO MODIFY:

- none

ACCEPTANCE:

- No TypeScript changes in this slice.
- If README or registry edits: commit with message prefix `docs(f007):`.
- Post evidence paths in thread (or next message) after push.

SPEC: sprint-queue-v1
PLAN_ID: PLAN_CROSS_F007_WALKTHROUGH_POLISH
PLAN_ROOT: plans/S1/S1.B/feat-f007-walkthrough-polish/
SLICE_ID: T00.SL1
VERIFY_TIERS: V0
RETRY_OF: none
```

Adjust `WORKSPACE_PATH` / `BRANCH` suffix to match the executor’s actual checkout before posting.
