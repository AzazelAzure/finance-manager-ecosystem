# Passdown — VPS Reflex blue-green recovery

**Plan:** `PLAN_VPS_REFLEX_BLUEGREEN_RECOVERY_2026-04-29`  
**Plan root:** `plans/cursor/vps-reflex-bluegreen-recovery-53be/`  
**Last updated:** 2026-04-29 (host session; T03 attempt + cleanup)

Use this file as the primary handoff for the **next executor** (host agent or human). Re-read [`CROSS_AGENT_COORDINATION.md`](./CROSS_AGENT_COORDINATION.md) and [`../../_governance/deployment_protocol.md`](../../_governance/deployment_protocol.md) before any VPS lifecycle work.

---

## What is done

| Item | Evidence / notes |
|------|------------------|
| **T01 — VPS inventory** | [`tasks/T01_inventory_results.md`](./tasks/T01_inventory_results.md): single-stack `finance_manager` project live; **pseudo** blue-green (`proxy/nginx.bluegreen.conf`, `proxy/active_color.conf` = blue); live `proxy/nginx.conf` still single-stack (`reflex:3000`). |
| **Breakpoint A** | Inventory + mapping documented; [`runtime_handoff.md`](./runtime_handoff.md) updated. |
| **Bundle includes blue-green compose** | [`scripts/server/create_runtime_bundle.sh`](../../../scripts/server/create_runtime_bundle.sh) stages `docker-compose.bluegreen.yml` and lists it in `RELEASE_MANIFEST.txt`. **Committed** on parent branch `cursor/finance-manager-web-beta-rollout-53be` as `a2e495a` (*Include docker-compose.bluegreen.yml in server runtime bundles*). |
| **VPS sync (bundle push)** | `push_runtime_bundle.sh --host 159.198.75.194 --user dev --remote-dir /home/dev/finance_manager` ran successfully; bundle `finance_manager_runtime_20260429_073503` extracted; remote `verify_release_manifest.sh` passed. |
| **T02 — Smoke host env** | Verified on VPS: `FM_PUBLIC_APP_HOST`, `FM_PUBLIC_API_HOST`, `FM_PUBLIC_BASE_URL` for **thehivemanager.com**; `fm_server_beta.sh check` passes. Export block copied into [`runtime_handoff.md`](./runtime_handoff.md). |
| **`fm_server_beta.sh check` on VPS** | Compose `config` OK; nginx blue/green `nginx -t` OK (via ephemeral container mounts). |
| **T03 `deploy green` attempt** | **Failed:** host **5432** (and would also conflict on **8080/8443**) with live `finance-manager-*` stack. Partial `fm-beta` state **removed**; single-stack healthy. See [`tasks/T03_exec_notes_2026-04-29.md`](./tasks/T03_exec_notes_2026-04-29.md). |

---

## Where we left off

- **Live user traffic** unchanged: **single-stack** `finance_manager` / `finance-manager-*` all **Up**, api **healthy** after T03 cleanup.
- **`fm_server_beta` inactive deploy is blocked** while single-stack owns **5432** and **8443/8080** on the same host. T03 is **not** “side-by-side with legacy”; it needs a **migration / maintenance** design (see T03 notes).
- **Breakpoint B** (public user path) still not re-validated this session.
- **Breakpoint C** remains **partial** (`check` only; **deploy+smoke inactive** not achieved).
- **Current parent git branch (workspace):** `cursor/finance-manager-web-beta-rollout-53be` @ `cb66e48` (includes bundle commit `a2e495a` in history; synced with `origin`).

---

## What is next (ordered)

1. **Product/ops decision:** one of:
   - **Maintenance cutover:** agreed window → stop `finance_manager` stack → stand up `fm-beta` (full BG) with DB volume/import plan → smoke → later `pre_cutover` for traffic; or
   - **Engineering change:** adjust blue-green compose / `fm_server_beta.sh` so **inactive** candidate does not bind the same host ports and/or reuses the existing DB (substantive repo work + review).
2. **Claim runtime owner** + **`pre_deploy`** (per protocol) before any future stop/migrate.
3. Re-attempt **T03** only after (1) is decided and implemented. Record results in `tasks/T03_exec_notes_*.md` and `runtime_handoff.md`.
4. **T04** only after T03 smoke passes + human **`pre_cutover`**.

---

## VPS quick facts

| Key | Value |
|-----|--------|
| SSH | `dev@159.198.75.194` |
| Workspace | `/home/dev/finance_manager` |
| Compose (live) | `docker-compose.yml`, project `finance_manager` |
| Blue-green compose (on disk) | `docker-compose.bluegreen.yml` (default project `fm-beta` in `fm_server_beta.sh`) |
| Proxy TLS | `https://127.0.0.1:8443` from host to proxy |

### Smoke exports (thehivemanager)

```bash
export FM_PUBLIC_APP_HOST=thehivemanager.com
export FM_PUBLIC_API_HOST=api.thehivemanager.com
export FM_PUBLIC_BASE_URL=https://127.0.0.1:8443
```

---

## Execution plane

- Use a **host-trusted agent** or human for SSH, bundle push, and `fm_server_beta` lifecycle. Follow [`deployment_protocol.md`](../../_governance/deployment_protocol.md) for gates.

---

## Git / PR follow-up

- Bundle work is on **`cursor/finance-manager-web-beta-rollout-53be`** (includes `a2e495a`); current tip `cb66e48` was **pushed** to `origin` as of this session’s `git` check.
- Plan docs under `plans/cursor/vps-reflex-bluegreen-recovery-53be/` should be committed on an appropriate feature branch when ready.

---

## First files to read on pickup

1. This file (**PASSDOWN.md**)
2. [`runtime_handoff.md`](./runtime_handoff.md)
3. [`validation_gates.md`](./validation_gates.md)
4. [`README.md`](./README.md) (Execution status section)
5. [`CROSS_AGENT_COORDINATION.md`](./CROSS_AGENT_COORDINATION.md)
