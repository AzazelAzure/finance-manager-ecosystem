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

## Pipeline continuity — why review and “next task” do not auto-fire

**`sprint-queue-v1` standardizes only intake** (the top-level post Cursor PA / cursor-agent picks up from **`#sprint-queue`**). It does **not**, by itself, enqueue code review, V2 deploy smoke, V3 browser proof, or the **next** slice.

Per **[`design_docs/40_System_Design/14_Inter_Agent_Message_Relay_and_Ownership_Contract.md`](../design_docs/40_System_Design/14_Inter_Agent_Message_Relay_and_Ownership_Contract.md)** §**Phased Rollout**:

| Phase | What runs today | Review / continuation |
|--------|-----------------|------------------------|
| **Phase 1 (current)** | Tasks land in `#sprint-queue`; executor completes work and may reply **in thread**. | **Executor (or HitM / orchestrator) must post a new top-level message to `#review-queue`** with V1 evidence and slice metadata. Reviewer reacts there. **Next** `#sprint-queue` slice is a **separate** top-level post — not emitted automatically by this repo. |
| **Phase 2 (designed, not turnkey)** | Optional `scripts/cursor_headless_slack_agent.py` polling `#sprint-queue`; optional second `antigravity_slack_runner.py` on `#review-queue`. | Antigravity runner is **deprecated** for new sprint traffic; Cursor PA + outbox is canonical — **extend PA** if you want the same process to drain completion and post `#review-queue`. |
| **Phase 3 (future)** | Structured relay + automated slice progression when V-tiers allow. | See relay contract §**Phase 3**. |

### What to fix (concrete)

1. **Cursor PA** (`~/CursorAgent/headless-cursor-agent/`): on successful slice completion, **post** (or outbox-drain) a **`#review-queue`** message using the **Slice completion** envelope in the relay contract (`SLICE`, `PLAN`, `COMMIT`, `V1_EVIDENCE`, `READY_FOR`, …). Optionally **enqueue** the next `sprint-queue-v1` top-level when review returns **PASS** (or gate that behind human ack).
2. **Until PA does that:** HitM or orchestrator performs the **`#review-queue`** post **manually** after reading the executor thread, then tracks reviewer verdict and posts the next slice or `#hitm-gate` per relay rules.
3. **Do not assume** IDE Slack MCP or in-repo pollers close the loop — they are orthogonal to PA Socket Mode intake.

See also [`cursor_pa_slack_visibility.md`](./cursor_pa_slack_visibility.md) §**Sprint pipeline: what PA does not do yet**.

---

## `#review-queue` — completion envelope (normative handoff)

Use a **top-level** post (not only a thread under `#sprint-queue`) so a reviewer or Phase-2 poller can own the handoff. Align fields with **[relay contract § Message format](../design_docs/40_System_Design/14_Inter_Agent_Message_Relay_and_Ownership_Contract.md)**; minimal set:

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

Reviewer posts **verdict** in `#review-queue` (or `#hitm-gate` when promoting) with `VERDICT: PASS | FAIL`, `NEXT: hitm-gate | sprint-queue`, and `FEEDBACK` on FAIL.