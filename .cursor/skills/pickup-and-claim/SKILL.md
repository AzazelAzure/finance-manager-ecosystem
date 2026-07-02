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
2. Claim via `ws_claim` for the correct worker checkout (`WS-API`, `WS-WEB`, or parent `HFM` for ecosystem work).
3. Post `[GATE: pre_execution]` per `execution_protocols.md` §1.1 with plan ID, branch, repos, scope.
4. Block until HitM replies 👍 or 24h timeout (timeout → plan status `paused`).
5. On approval, classify the task and produce a delegation packet to the correct Phase-3 skill with **`Skill(s) to load: <phase-3-skill-name>`** explicitly named.
6. Do not begin implementation in this skill — hand off immediately after gate approval.

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
