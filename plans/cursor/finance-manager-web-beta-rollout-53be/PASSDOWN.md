# Passdown — finance_manager_web beta rollout (cloud agent)

**Plan root:** `plans/cursor/finance-manager-web-beta-rollout-53be/`  
**Plan ID:** `PLAN_FINANCE_MANAGER_WEB_BETA_ROLLOUT_2026-04-29`  
**Orchestration branch (ecosystem parent):** `cursor/finance-manager-web-beta-rollout-53be`  
**Last updated:** 2026-04-29 (Cursor agent session)

---

## 1. Objective (unchanged)

Ship the Vite/React `finance_manager_web` track: submodule hygiene, CORS/auth diagnosability, then Lane B (`jsdevtesting.thehivemanager.com`) or optional Lane A, with CPPR+D and manual smoke per `validation_gates.md`.

---

## 2. What is done

| Item | Evidence / location |
|------|---------------------|
| **Breakpoint 0 — Lane choice** | `runtime_handoff.md`: primary **Lane B** (VPS jsdevtesting + prod API), Lane A optional. |
| **T01 — Submodule** | Ecosystem `.gitmodules` includes `finance_manager_web` → `git@github.com:AzazelAzure/finance-manager-web.git`. Submodule present; initial `main` pushed; README env section, `.env.example`, `.gitignore` for env files. |
| **T02 — Code (not necessarily prod)** | **API:** branch `cursor/finance-manager-web-beta-rollout-53be`, commit `7b1f7d4` — default `CORS_ALLOWED_ORIGINS` / `CSRF_TRUSTED_ORIGINS` extended for `http://localhost:5173`, `http://127.0.0.1:5173`, `https://jsdevtesting.thehivemanager.com`; `CHANGELOG.md` updated. **Web:** same branch, commit `2ed4704` — `LoginPage` shows Axios/status/code/body hints in **`import.meta.env.DEV` only**. |
| **Coordination note** | `CROSS_AGENT_COORDINATION.md` — **Last API changes** lists API branch/PR creation link and deploy caveat. |
| **Verification (local)** | `npm ci` && `npm run build` succeeded in `finance_manager_web` after changes. |

---

## 3. What is left

| Item | Owner / gate |
|------|----------------|
| **PRs + Slack** | Open/merge PRs; post each to Slack `#pull-requests` (repo, branch, PR URL); reconcile Slack automation with GitHub mergeability before merge (workspace rule). |
| **API deploy** | Until API PR is **merged and deployed**, prod `https://api.thehivemanager.com` may not emit new CORS defaults — local login from `http://localhost:5173` can still fail preflight. Optional: set `CORS_ALLOWED_ORIGINS` / `CSRF_TRUSTED_ORIGINS` on server env without waiting for code merge. |
| **Parent submodule bump (API)** | Ecosystem parent **intentionally did not** bump `finance_manager_api` submodule (avoid pinning ecosystem to unreleased API SHA). After API PR merges to `main`, decide whether ecosystem PR should bump `finance_manager_api` pointer. |
| **Breakpoint 2** | Manual: JWT login + snapshot from **actual** browser Origin; log status + `access-control-allow-origin` if failure. |
| **T03** | Optional Lane A: document local `runserver` + `.env` / `VITE_API_BASE_URL` per task packet. |
| **T04 + Breakpoint 3** | Lane B: DNS, Cloudflare tunnel, nginx static (or container) for `jsdevtesting.thehivemanager.com` — **coordinate** [vps-reflex-bluegreen-recovery-53be](../vps-reflex-bluegreen-recovery-53be/README.md) and `design_docs/30_Releases/Runtime_Signup_Sheet.md` before VPS container/proxy surgery. |
| **Plan repo hygiene** | Ecosystem commit added only part of this plan folder (e.g. `runtime_handoff.md`, `CROSS_AGENT_COORDINATION.md`). Remaining plan files (`README.md`, `validation_gates.md`, `tasks/`, `AGENT_LAUNCH_PROMPT.md`, this file) may still be untracked in ecosystem — add/commit if you want a single canonical tree. |
| **Final gate** | CPPR+D, human login + dashboard smoke, update coordination footer after API lands. |

---

## 4. What to do next (ordered)

1. **Cloud agent:** Clone/update ecosystem on `cursor/finance-manager-web-beta-rollout-53be`; `git submodule update --init finance_manager_web`.
2. **PR workflow:** Ensure three PRs exist or are merged — ecosystem (submodule + plan snippets), **finance-manager-web**, **finance-manager-api**. Use GitHub “new PR” links if branches exist but PRs are missing:  
   - Ecosystem: `https://github.com/AzazelAzure/finance-manager-ecosystem/pull/new/cursor/finance-manager-web-beta-rollout-53be`  
   - Web: `https://github.com/AzazelAzure/finance-manager-web/pull/new/cursor/finance-manager-web-beta-rollout-53be`  
   - API: `https://github.com/AzazelAzure/finance-manager-api/pull/new/cursor/finance-manager-web-beta-rollout-53be`
3. **Slack:** Post PR URLs to `#pull-requests`; wait for automation state; do not merge if GitHub is `CONFLICTING` / `DIRTY` even if Slack says approved.
4. **After API merge + deploy:** Re-run preflight (`OPTIONS` from real Origin) and Breakpoint 2 smoke; update `validation_gates.md` / `runtime_handoff.md` with results.
5. **T04:** Execute Lane B infra; external HTTPS smoke; mark Breakpoint 3.
6. **Optional:** Track `finance_manager_web` submodule on `main` after feature branches merge, and bump ecosystem submodule SHA accordingly.

---

## 5. Constraints (do not skip)

- **Sub-repos:** Commits live in **finance-manager-web**, **finance-manager-api**, **finance-manager-ecosystem** separately — no cross-repo mixed commits.
- **Runtime:** Single runtime owner for `scripts/fm_docker.sh` / VPS lifecycle; read Runtime Signup Sheet before restarts.
- **Sibling plan:** Before editing root `docker-compose.yml` or `proxy/nginx.conf`, read `vps-reflex-bluegreen-recovery-53be/runtime_handoff.md`.
- **Secrets:** Never commit `.env` / credentials; use `.env.example` patterns only.

---

## 6. Quick clone / verify commands

```bash
# Ecosystem (example)
git clone git@github.com:AzazelAzure/finance-manager-ecosystem.git && cd finance-manager-ecosystem
git checkout cursor/finance-manager-web-beta-rollout-53be
git submodule update --init finance_manager_web

# Web sanity
cd finance_manager_web && npm ci && npm run build
```

---

## 7. Primary references for the next agent

| Doc | Purpose |
|-----|---------|
| [README.md](./README.md) | Phases, task index, **execution status** |
| [validation_gates.md](./validation_gates.md) | Breakpoints 0–Final |
| [runtime_handoff.md](./runtime_handoff.md) | Lane, URLs, copy/paste handoff |
| [CROSS_AGENT_COORDINATION.md](./CROSS_AGENT_COORDINATION.md) | Reflex sibling + API change log |
| [AGENT_LAUNCH_PROMPT.md](./AGENT_LAUNCH_PROMPT.md) | Full agent bootstrap text |
| [../../_governance/deployment_protocol.md](../../_governance/deployment_protocol.md) | Deploy (D) when touching production paths |

---

## 8. Assumptions / unknowns

- VPS path on host may be `/home/dev/finance_manager` — confirm over SSH (`dev@159.198.75.194`).
- Whether `jsdevtesting` DNS/tunnel already exists is **unknown**; T04 may be greenfield.
- Prod API stack’s effective env vars for CORS are **unknown** until inspected post-deploy.
