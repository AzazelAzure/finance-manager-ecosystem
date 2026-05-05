# Sprint queue message spec — `sprint-queue-v1`

**Status:** normative (ecosystem). **Origin:** Materialized from Cursor agent session (transcript id `2d3663f0-2e98-4ec6-a2c3-09757db0880d`) + HitM runner requirements; **do not** fork this spec into per-plan copies — link here and extend only via **`sprint-queue-v2`** when that huddle lands.

**Bridge doc:** [`design_docs/40_System_Design/12_Cursor_CLI_Slack_Cloud_Agent_Bridge.md`](../design_docs/40_System_Design/12_Cursor_CLI_Slack_Cloud_Agent_Bridge.md)  
**Outbox / PA policy:** [`cursor_pa_slack_visibility.md`](./cursor_pa_slack_visibility.md)

---

## Why this exists

Orchestrators post **one top-level message per slice** to **`#sprint-queue`** so **Cursor PA** routes work to the **cursor-agent / executor** workspace. Without the **`Task Id:`** line in the correct position, the runner may treat the post as **local daemon** intake and create bottlenecks.

### First-line mention (Slack)

Line 1 **must** be **`@CursorPA`** (no space). In HitM’s workspace, **`@Cursor PA`** (with a space) **does not** resolve to the runner’s user mention, so the ping breaks and tasks may skip the **cursor-agent** queue. The Slack app’s *display* name may still read “Cursor PA”; the **mention handle** for `#sprint-queue` is **`@CursorPA`** unless the runner config documents otherwise.

---

## Sprint queue message spec (v1) — required

All posts **must** use this **exact block order** (blank line between major sections as shown). Omitting a section is allowed only where noted.


| #   | Field              | Rule                                                                                                                                                 |
| --- | ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | `@CursorPA`        | Alone on the first line — **no space** (see “First-line mention” above).                                                                                |
| 2   | `Task Id:`         | **Second line always.** Stable feature / intake id (e.g. `F-007`). Without this line, the runner does **not** treat the message as a workspace task. |
| 3   | `REPO:`            | Sub-repo name: `finance_manager_web` \| `finance_manager_api` \| `finance_manager_cli` \| etc.                                                      |
| 4   | `WORKSPACE_PATH:`  | Executor **tilde** path to the **checkout root for that REPO** (not the monorepo parent unless REPO is parent).                                      |
| 5   | `BRANCH:`          | Git branch name **plus** a **Branch suffix** (below). No bare branch.                                                                                |
| 6   | `SLICE:`           | One line: plan slice id + em dash + short title, e.g. `T00.SL1 — Protocol acceptance`.                                                               |
| —   | *(blank line)*     | Recommended for Slack readability.                                                                                                                   |
| 7   | `READ FIRST:`      | One or more tilde-relative paths or plan pointers.                                                                                                   |
| 8   | `TASKS:`           | Blank line after header, then numbered list `1.` `2.` …                                                                                              |
| 9   | `FILES TO MODIFY:` | Blank line after header, then `-` bullets; use `- none` for doc-only / V0 slices with no code edits.                                                 |
| 10  | `ACCEPTANCE:`      | Blank line after header, then `-` bullets (build, commit message, push, evidence paths, “do not start next slice”, etc.).                            |


**Tilde paths only** in Slack (`~/...`).

### Branch suffix standard (required — automation)

The `BRANCH:` line **must** end with one of these parentheticals:


| Suffix                  | Meaning                                                                          |
| ----------------------- | -------------------------------------------------------------------------------- |
| `(already checked out)` | Executor is **already** on this branch; do not switch unless the task says to.   |
| `(checkout required)`   | Executor must `git fetch` / `git checkout` (or create) this branch before edits. |


**Format:** `BRANCH: <branch-name> (already checked out)` or `BRANCH: <branch-name> (checkout required)` — lowercase inside parens, exact wording.

---

## Optional footer metadata (after `ACCEPTANCE:`)

Parsers may ignore unknown keys. Include **`SPEC: sprint-queue-v1`** when using a footer block.

```text
SPEC: sprint-queue-v1
PLAN_ID: <PLAN_CROSS_…>
PLAN_ROOT: plans/<Phase>/<Stage>/<sub-plan>/
SLICE_ID: T##.SL#
VERIFY_TIERS: V0 | V1 | …
RETRY_OF: none
```

Do **not** place footer metadata before `Task Id:` or replace `Task Id:` with `PLAN_ID` alone.

---

## Copy-paste template (v1)

```text
@CursorPA
Task Id: <F-00X or registered intake id>
REPO: finance_manager_web
WORKSPACE_PATH: ~/agent-workspaces/cursor-executor/finance_manager/finance_manager_web
BRANCH: <branch-name> (already checked out)
SLICE: T##.SL# — <short title>

READ FIRST: <tilde-relative plan paths>

TASKS:

1. <Step one>
2. <Step two>

FILES TO MODIFY:

- <path under repo>

ACCEPTANCE:

- <Criteria>
- npm run build passes with zero errors (when code changes)
- Evidence paths when V1+
```

**`WORKSPACE_PATH`:** Must match the **executor** layout Cursor PA expects (example shows web sub-repo root).

---

## Retry / failure loop

New top-level message, same v1 shape. In footer:

```text
RETRY_OF: <permalink or parent message ts>
```

---

## Slack MCP (IDE) — config location

The Slack MCP is often **not** in this repo. Register from **user-level** Cursor plugin cache, e.g.:

`~/.cursor/plugins/cache/cursor-public/slack/<hash>/mcp.json`

Search under `~/.cursor/plugins/cache/cursor-public/slack/` if the hash changes.

Cursor PA **Socket / outbox** remains the durable automation path; see [`cursor_pa_slack_visibility.md`](./cursor_pa_slack_visibility.md).

---

## Shelved: `sprint-queue-v2` (MCP + channel/thread policy)

**Not in v1.** Letting cursor-agents use Slack MCP (or equivalent) to **dictate** channels and threads (sprint vs review vs status) needs runner support, auth review, and a spec bump — tracked in [`cursor_pa_slack_visibility.md`](./cursor_pa_slack_visibility.md).

---

## Worked examples (plan-local)

F-007 polish includes a **filled T00.SL1** example and ordering notes: [`plans/S1/S1.B/feat-f007-walkthrough-polish/SLACK_SPRINT_QUEUE.md`](../plans/S1/S1.B/feat-f007-walkthrough-polish/SLACK_SPRINT_QUEUE.md).

---

## Ordering rule

**One message per slice** unless Cursor PA documents an explicit batching exception; order follows the plan README slice catalog / execution order.

---

## Pipeline continuity — intake vs automation

**`sprint-queue-v1` standardizes intake** (top-level `#sprint-queue` posts). **Continuation** (review → next slice → HitM) is driven by either **manual** posts or the **in-repo bridge** below.

### In-repo automation: `scripts/sprint_slack_pipeline_bridge.py`

Long-lived poller (Slack Web API, same token family as other finance_manager Slack scripts):

1. Watches **thread replies** in `#sprint-queue` for a **single line** `SPRINT_PIPELINE_JSON: {...}` with `"status":"READY_FOR_REVIEW"` (see §Machine-readable pipeline).
2. Posts a formatted handoff to **`#review-queue`**.
3. Watches **`#review-queue`** for `SPRINT_PIPELINE_JSON` with `"status":"REVIEW_VERDICT"`. On **`PASS`**:
   - If `requires_hitm` is true → posts a short request to **`#hitm-gate`** (HitM verifies V3 / production — **human gate**).
   - Else if `next_queue_message_path` points to a file under `SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR` → posts that file’s **full text** as the **next** top-level `#sprint-queue` message (must already match `sprint-queue-v1`).

Optional **`SPRINT_BRIDGE_AUTO_PASS_V0=1`:** when `verify_tiers` is exactly `V0`, the bridge posts a synthetic **PASS** verdict so doc-only slices advance without a separate reviewer process (still **no** V2/V3 substitute — set `requires_hitm: true` in READY JSON when HitM must verify).

Runbook: script docstring + env vars. **MCP** in Cursor is **not** a substitute for this daemon (IDE-bound); run the script on the host that holds `SLACK_BOT_TOKEN`.

Per **[relay contract § Phased Rollout](../design_docs/40_System_Design/14_Inter_Agent_Message_Relay_and_Ownership_Contract.md)** — Phase 1 manual envelopes remain valid; the bridge is the **default** automation path in this repo until Cursor PA implements the same graph out-of-repo.

See also [`cursor_pa_slack_visibility.md`](./cursor_pa_slack_visibility.md) §**Sprint pipeline: what PA does not do yet** (updated to reference the bridge).

---

## Machine-readable pipeline (`SPRINT_PIPELINE_JSON`)

Embed **exactly one JSON object per line** (no pretty-printed multi-line JSON). Prefix:

`SPRINT_PIPELINE_JSON:` + compact JSON.

### Executor → bridge (`READY_FOR_REVIEW`)

Posted as a **thread reply** under the active sprint task in `#sprint-queue` when the slice is ready for review:

| Field | Required | Notes |
|--------|-----------|--------|
| `status` | yes | literal `READY_FOR_REVIEW` |
| `slice_id` | yes | e.g. `T00.SL1` |
| `plan_root` | yes | repo-relative, e.g. `plans/S1/S1.B/feat-f007-walkthrough-polish/` |
| `plan_id` | recommended | e.g. `PLAN_CROSS_F007_WALKTHROUGH_POLISH_2026-05-21` |
| `repo` | yes | e.g. `finance_manager_web` |
| `branch` | yes | git branch name |
| `commit` | yes | sha or `none` |
| `v1_evidence` | yes | free text; paths, log names, or “doc-only” |
| `verify_tiers` | yes | e.g. `V0`, `V1`, `V1,V2` (bridge auto-pass only when value is exactly `V0` and env enabled) |
| `requires_hitm` | no | if true, PASS routes to `#hitm-gate` |
| `next_queue_message_path` | no | file name **relative to** `SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR` (e.g. `next_t00_sl2.txt`) — file content is the **next** sprint-queue top-level message |

Example line:

`SPRINT_PIPELINE_JSON: {"status":"READY_FOR_REVIEW","slice_id":"T00.SL1","plan_root":"plans/S1/S1.B/feat-f007-walkthrough-polish/","plan_id":"PLAN_CROSS_F007_WALKTHROUGH_POLISH_2026-05-21","repo":"finance_manager_web","branch":"cursor/s1b/feat/f007-walkthrough-polish","commit":"none","v1_evidence":"tasks/T00_protocol_and_acceptance.md SL1 checkboxes checked","verify_tiers":"V0","requires_hitm":false,"next_queue_message_path":"next_t00_sl2.txt"}`

### Reviewer → bridge (`REVIEW_VERDICT`)

Posted as a **top-level** or threaded message in `#review-queue`:

| Field | Required | Notes |
|--------|-----------|--------|
| `status` | yes | `REVIEW_VERDICT` |
| `slice_id` | yes | |
| `verdict` | yes | `PASS` or `FAIL` |
| `reviewer` | recommended | id or handle |
| `requires_hitm` | yes for PASS routing | if true → `#hitm-gate` |
| `v2_evidence` | recommended | text or `n/a` for V0-only |
| `next_queue_message_path` | conditional | required for PASS → next sprint when `requires_hitm` is false |

On **FAIL**, the bridge does not post the next slice; fix work and emit a new `READY_FOR_REVIEW` from the sprint thread when ready.

---

## `#review-queue` — completion envelope (human-readable, optional)

Same handoff as relay contract, if you prefer prose instead of the bridge watching only JSON lines — you can still post:

```text
SLICE_ID: T00.SL1
PLAN_ROOT: plans/S1/S1.B/feat-f007-walkthrough-polish/
REPO: finance_manager_web
BRANCH: cursor/s1b/feat/f007-walkthrough-polish
COMMIT: <sha>
EXECUTOR: cursor-executor
V_TIER: V1
V1_EVIDENCE: |
  <build log path, or "doc-only slice — task file updated" + paths>
READY_FOR: <reviewer identity or role, e.g. antigravity-reviewer | HitM>
SPRINT_THREAD: <optional link to #sprint-queue parent message for correlation>
```

For **full automation** with `sprint_slack_pipeline_bridge.py`, still append a **`SPRINT_PIPELINE_JSON`** `READY_FOR_REVIEW` line in the sprint thread so the bridge always fires.