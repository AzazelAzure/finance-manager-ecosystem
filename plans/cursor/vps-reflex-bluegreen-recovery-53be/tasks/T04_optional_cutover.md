# T04 — Optional cutover + rollback drill (gated)

**Status (2026-04-29):** **Waiting** on T03 success + human `pre_cutover` per deployment protocol. See [`../PASSDOWN.md`](../PASSDOWN.md).

## Objective

Only after inactive smoke is **extended** and human approves **pre_cutover** per [deployment_protocol.md](../../_governance/deployment_protocol.md).

## Steps

1. Post `pre_cutover` gate to `#cli-interface` with evidence bullets from T03.
2. On approval: `./scripts/fm_server_beta.sh switch --to <color>` (or `promote` alias per script).
3. Re-smoke active path; record human manual verification.
4. Run rollback drill to prior color at least once in non-peak window if policy requires.

## Handoff output

- Cutover time (UTC)
- Active color after switch
- Rollback command tested: yes/no
