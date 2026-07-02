---
name: deploy-execution
description: Execute inactive-color VPS deploy and smoke after pre_deploy approval — bundle, rebuild, smoke, record manifest. Does not perform cutover. Use at end of Cursor's deploy cycle for HitM manual verification on inactive color.
disable-model-invocation: true
---

# Deploy Execution

Phase 6a/6b skill — Cursor-owned inactive deploy. Cutover (Phase 6c/6d) is Claude/HFM + HitM,
not this skill.

## Doctrine

- `governance/deployment/deployment_protocol.md` §3–§4.
- `governance/deployment/Server_Runtime_Agent_Operations_Contract.md`.
- `governance/deployment/Runtime_Signup_Sheet.md`.

## Loads

None. Gate-protocol mechanics inlined below — resolved 2026-07-02, doctrine citation above was
sufficient across all 3 gate-using skills; no separate reference skill needed.

## Tools

- `create_runtime_bundle.sh` — `scripts/ops/create_runtime_bundle.sh`
- `push_runtime_bundle.sh` — `scripts/ops/push_runtime_bundle.sh`
- `verify_release_manifest.sh` — manifest verification on VPS
- `fm_server_beta.sh deploy|rebuild-color` — `scripts/ops/fm_server_beta.sh`
- `fm_server_beta.sh smoke --color {inactive}` — inactive-color smoke
- `vps_state`, `vps_claim` / `vps_release` — VPS authority and read-only state

## Procedure

1. Confirm runtime owner per `Runtime_Signup_Sheet.md`; claim via `vps_claim` if needed.
2. Post `[GATE: pre_deploy]` per `deployment_protocol.md` §3; block until 👍 or 24h timeout.
3. On approval:
   - Build runtime bundle if plan metadata requires it (`create_runtime_bundle.sh`).
   - Push bundle to VPS inactive color (`push_runtime_bundle.sh`).
   - Verify release manifest (`verify_release_manifest.sh` / push script output).
   - Deploy/rebuild inactive color (`fm_server_beta.sh deploy` or `rebuild-color`).
   - Smoke inactive color (`fm_server_beta.sh smoke --color <inactive>`).
4. Record manifest identity (bundle name, commit SHA, color) in plan `runtime_handoff.md`.
5. **Stop here** — HitM V3 verification (Phase 7) and cutover (Phase 6c/6d) are not this skill's job.

## Handoff

Return contract must state explicitly: **cutover is not this skill's job.**

Hands off to HitM (Phase 7 verification) then Claude/`HFM` (Phase 6c/6d pre_cutover + cutover).

`Skill(s) used: deploy-execution`
