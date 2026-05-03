# Runtime handoff — web parity sweep #1

VPS: `dev@159.198.75.194` — repo at `/home/dev/finance_manager`. Active color
is **blue** (api-blue, reflex-blue, web-blue). Stack runs via:

```bash
cd ~/finance_manager
COMPOSE_PROJECT_NAME=fm-beta \
  podman compose -f docker-compose.bluegreen.yml \
                 --env-file .secrets/server.env up -d
```

Public hostnames in scope:
- `https://jsdevtesting.thehivemanager.com/` (web)
- `https://jsdevprodtest.thehivemanager.com/` (web preview)
- `https://api.thehivemanager.com/` (API)

## Per-phase deploy + smoke recipe

After the user merges a phase PR and pulls submodules on the VPS:

```bash
cd ~/finance_manager/finance_manager_web && git pull
cd ~/finance_manager
COMPOSE_PROJECT_NAME=fm-beta \
  podman compose -f docker-compose.bluegreen.yml \
                 --env-file .secrets/server.env build web-blue web-green
COMPOSE_PROJECT_NAME=fm-beta \
  podman compose -f docker-compose.bluegreen.yml \
                 --env-file .secrets/server.env up -d
```

Then smoke (per phase BP in `validation_gates.md`).

## Sweep-level smoke targets (cumulative)

| Phase | Target |
|-------|--------|
| BP1 | `GET https://jsdevtesting…/` returns 200; forced 401 in dashboard triggers refresh + retry, not logout. |
| BP2 | `/`, `/login`, `/signup` render; signup → onboarding redirect after BP6, otherwise → dashboard. |
| BP3 | Dashboard widgets all render with real data on real account; mobile collapses. |
| BP4 | Transactions CRUD + calendar + deep-dive; drillthrough from dashboard pies. |
| BP5 | Upcoming bills CRUD; data hub CRUD across sources / categories / tags. |
| BP6 | Profile preferences round-trip; password change; onboarding 4-step new account. |
| BP7 | Lighthouse a11y ≥ 90 / perf ≥ 80; vitest green. |

## Per-phase smoke log

_(append per phase)_

| Date | Phase | Color | Result | Notes |
|------|-------|-------|--------|-------|
| 2026-04-29 | P0 plan freeze | n/a | n/a | Plan committed; no runtime change. |
| 2026-04-29 | P1 foundations | blue | OK | VPS `~/finance_manager/finance_manager_web`: `git pull origin main` → `53ace4f` (merge #2). `podman compose … build web-blue web-green` + stack up. `GET https://jsdevtesting.thehivemanager.com/` → 200. Ecosystem parent not present on VPS (flat clones). |
| 2026-04-29 | P2 public surface + cookie/login fix | blue | OK (pulled) | `finance_manager_web` on VPS pulled to `main` after [web #3](https://github.com/AzazelAzure/finance-manager-web/pull/3) merge. User confirmed pull; run `build web-blue web-green` + `up -d` if images not rebuilt yet. BP2 smoke/Lighthouse per `validation_gates.md`. |
| 2026-04-29 | P3 dashboard parity | blue | OK | VPS web pulled to `main` after merges through [web #7](https://github.com/AzazelAzure/finance-manager-web/pull/7), rebuilt `web-blue` / `web-green`, recreated proxy + web containers, and verified running web container image matches latest build. User BP3 validation: charts and filters work, no duplicate loads on same filter, mobile viewport good. Drill slice behavior currently redirects to Transactions (accepted for this sweep). BP7 follow-up logged for dashboard polish (smart/live reload UX + drill interaction expectations). |
| 2026-04-29 | P4 transactions suite | green | **PASS** | Follow-up fixes deployed through [web #11](https://github.com/AzazelAzure/finance-manager-web/pull/11) plus category fallback patch in local BP5 workstream. User verified CRUD path operational; blank category now defaults by tx type (Expense/Income/Transfer). BP7 polish items remain: calendar heatmap intensity and optional drillthrough preference mode. |
| 2026-04-29 | P7 polish + hardening closeout | blue | **PASS** | Final BP7 UX fixes accepted for beta launch. `Quick add -> +Bill` intentionally disabled pending redesign decision (deployed via runtime hotfix rebuild). Proxy traffic pinned to blue web target for `thehivemanager.com` and JS beta hostnames. Reflex containers stopped and removed from live request path (no longer serving production traffic). |

## Rollback

Each phase is shipped as **its own PR**. If a phase regresses production:

1. `git revert <merge_commit>` in the affected repo (web first, then ecosystem
   parent submodule bump).
2. Push to `main`, pull on VPS.
3. Rebuild `web-blue` / `web-green` per recipe above.

Because color is **blue**, the simpler immediate mitigation is to swap
`active_color.conf` to **green** if green still has the prior good image.
Confirm green has the previous image before flipping.
