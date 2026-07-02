---
name: vps-deploy-readiness-check
description: Use to own the full Phase 6c/6d pre_cutover-through-cutover sequence for a deploy. The HFM workspace (HitM + Claude Code) holds explicit VPS flip authority — this is not Cursor's job. Checks drift, presents the pre_cutover gate, executes cutover on HitM approval, and captures HitM's V3 verification notes.
---

# VPS Deploy Readiness Check

Scope widened 2026-07-02 (HitM confirmed) from a pure pre-check to owning the actual cutover
authority, per direct evidence in `governance/execution/workspace_protocol.md` §2: the `HFM` workspace row
lists "VPS flip authority" explicitly; `WS1`/`WS2` (Cursor) do not have it. Cursor's
`deploy-execution` skill stops after inactive-color deploy + smoke (Phase 6a/6b) and hands off to
HitM verification (Phase 7), which hands off here.

## Doctrine

- `governance/deployment/deployment_protocol.md` §5 (`pre_cutover` gate), §6 (cutover actions), §7
  (monitoring window), §8 (rollback), §9 (pre-close deployment evidence).
- `governance/execution/workspace_protocol.md` §2 — the flip-authority basis for this skill's scope.
- `deploy/BLUEGREEN_SWITCHOVER.md` — hostnames, switch steps.

## Loads

- `status-verification-spotcheck` (imperative) — verify the inactive-color smoke evidence Cursor
  reported is real before presenting the `pre_cutover` gate on the strength of it.

## Tools

- `vps_state` — live snapshot.
- `vps_freshness` — local vs. VPS SHA drift.
- `vps_claim` / `vps_release` — VPS authority lock.

## Procedure

1. Confirm Cursor's Phase 6a/6b work completed (inactive color deployed + smoked) and HitM's
   Phase 7 V3 browser verification happened — this skill picks up *after* both, not before.
2. Present the `pre_cutover` gate (verbatim template: `governance/deployment/deployment_protocol.md` §5).
3. Wait for HitM reply (👍 cutover / 👎 hold / "extend" for more smoke).
4. On approval: run the cutover (`fm_server_beta.sh switch --to {color}`), post-cutover smoke,
   tail logs for the monitoring window (P0=60m / P1=30m / P2=15m per plan priority).
5. On failure at any point: `[HANDOFF: failure]`, plan → `blocked`, do not retry without fresh
   HitM authorization.
6. Capture HitM's verification notes into the plan's `runtime_handoff.md` →
   `### HitM Manual Verification Notes`.
7. Hand off to `plan-registry-lifecycle-transition` for the eventual Phase 8 close, once the
   monitoring window completes clean.

## Handoff

`Skill(s) used: vps-deploy-readiness-check, status-verification-spotcheck` recorded in
`runtime_handoff.md` and the meeting decision log.
