---
name: pickup-and-claim
description: Claim workspace, post the pre_execution gate, and hand off to the correct Phase-3 skill after HitM approval. Use when a plan task moves from ready to in_progress and Cursor picks up execution.
---

# Pickup and Claim

Phase 2 skill — bridges queue sequencing (Claude) to slice implementation (Cursor).

## Doctrine

- `governance/plans/plan_lifecycle.md` §C — ready → in_progress transition.
- `governance/execution/execution_protocols.md` §1.1 (`[GATE: pre_execution]` template), §3 (reply parsing), §6 (timeout policy).
- `governance/execution/workspace_protocol.md` §2–§4 — workspace claims and dispatch.

## Loads

None. Gate-protocol mechanics are inlined below (resolved 2026-07-02 — checked against what all
3 gate-using skills actually needed: the Doctrine citation above plus this inline section was
already sufficient; no separate reference skill needed, not building one proactively).

## Tools

- `ws_status` — check claims before claiming.
- `ws_claim` — claim workspace for this task.
- `queue_push` / `ws_dispatch` — when self-dispatching from queue.

## Procedure

1. Run `ws_status`; confirm target workspace is available.
2. **Worker checkout orientation** (WS-API / WS-WEB / parent `HFM`):
   - Confirm `FM_PRIMARY_WORKSPACE` and worker path via `session_brief` or `ws_status`.
   - `cd` to the **worker directory** (not the orchestrator clone): `~/Hive_Financial_Manager/WS-API` or `WS-WEB`; parent-repo tasks stay in `HFM/`.
   - `git fetch origin && git status && git branch --show-current` — report drift before branching.
   - Create or checkout task branch: `git checkout -b cur/s1b/<type>/<slug>` from updated `main` (or reuse existing task branch if resuming).
   - Do **not** open implementation until `ws_claim` succeeds for the orchestrating workspace (`WS1`/`WS2` or `HFM` for parent).
3. Claim via `ws_claim` for the correct orchestrating workspace (`WS1` for API dispatch, `WS2` for web, `HFM` is implicit for parent — no `WS-PARENT` row).
4. Post `[GATE: pre_execution]` per `execution_protocols.md` §1.1 with plan ID, branch, repos, scope.
5. Block until HitM replies 👍 or 24h timeout (timeout → plan status `paused`).
6. On approval, classify the task and produce a delegation packet to the correct Phase-3 skill with **`Skill(s) to load: <phase-3-skill-name>`** explicitly named.
7. Do not begin implementation in this skill — hand off immediately after gate approval.

> **Why not a separate skill?** The ritual is identical across plans — only paths and branch slug change.
> Extending `pickup-and-claim` keeps one Phase-2 entry point instead of a thin duplicate skill.

## Gate inline (kept inline by design — see Loads)

- Post the exact template from `execution_protocols.md` §1.1.
- Parse replies per §3: 👍 = proceed, 👎 = stop, hold = wait.
- On timeout (§6): set `paused`, do not proceed.

## Handoff

Delegation packets to Phase-3 skills must include:

- Plan task or slice ID (`T##` / `T##.SL#`)
- Scope boundary (repo/path)
- Definition of done and verification expectations
- **`Skill(s) to load: <name>`** — e.g. `feature-implementation-loop`, `bugfix-investigation-loop`
