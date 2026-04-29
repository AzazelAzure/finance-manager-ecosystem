# Cross-agent coordination — JS web beta rollout

This plan runs in parallel with **[vps-reflex-bluegreen-recovery-53be](../vps-reflex-bluegreen-recovery-53be/README.md)** (Reflex + blue-green on VPS). Both agents may SSH as **`dev@159.198.75.194`** at the same time; only **one runtime owner** should run container lifecycle commands—see [Runtime Signup Sheet](../../../../design_docs/30_Releases/Runtime_Signup_Sheet.md).

## Runtime ownership

- **Local** API (`runserver`) + Vite: claim a **local** testing window in [Runtime Signup_Sheet](../../../../design_docs/30_Releases/Runtime_Signup_Sheet.md) if your org uses mixed local + VPS (set `mixed runtime` only if policy allows; default is **no**).
- **VPS** container restarts: **Reflex agent owns** unless you receive explicit sublet — do not run `fm_docker.sh restart` on VPS without sheet coordination.

## Check status of the sibling (Reflex) plan

| What | Where |
|------|--------|
| Reflex plan root | [../vps-reflex-bluegreen-recovery-53be/README.md](../vps-reflex-bluegreen-recovery-53be/README.md) |
| Reflex gates | [../vps-reflex-bluegreen-recovery-53be/validation_gates.md](../vps-reflex-bluegreen-recovery-53be/validation_gates.md) |
| Reflex handoff | [../vps-reflex-bluegreen-recovery-53be/runtime_handoff.md](../vps-reflex-bluegreen-recovery-53be/runtime_handoff.md) |

**Before opening PRs that change `proxy/nginx*.conf` or root `docker-compose*.yml`:** read Reflex `runtime_handoff.md` — avoid conflicting with active cutover or inventory.

## API contract handoffs

When this plan changes **API** ([`finance_manager_api/`](../../../finance_manager_api)) (CORS, hosts, auth):

- Note PR URL and env vars in this file under **Last API changes** (below).
- Reflex agent may need to rebuild API container — coordinate via Runtime Signup Sheet.

### Last API changes

- **2026-04-29 (web beta rollout):** Default `CORS_ALLOWED_ORIGINS` / `CSRF_TRUSTED_ORIGINS` extended for Vite (`5173`) and `https://jsdevtesting.thehivemanager.com` — branch `cursor/finance-manager-web-beta-rollout-53be`, open PR: https://github.com/AzazelAzure/finance-manager-api/pull/new/cursor/finance-manager-web-beta-rollout-53be — merge and deploy API before relying on prod CORS for those Origins. **Add:** `https://jsdevprodtest.thehivemanager.com` (VPS preview tunnel) — API commit `31af0f3`+ on same branch; deploy for prod.
- _(agent: append dated line: PR, CORS origins added, ALLOWED_HOSTS touch, etc.)_

## CPPR+D

Same as sibling: [deployment_protocol.md](../../_governance/deployment_protocol.md). JS static/container deploy to VPS is still **D** with gates when it touches production paths.
