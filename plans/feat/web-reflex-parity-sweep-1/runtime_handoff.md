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

## Rollback

Each phase is shipped as **its own PR**. If a phase regresses production:

1. `git revert <merge_commit>` in the affected repo (web first, then ecosystem
   parent submodule bump).
2. Push to `main`, pull on VPS.
3. Rebuild `web-blue` / `web-green` per recipe above.

Because color is **blue**, the simpler immediate mitigation is to swap
`active_color.conf` to **green** if green still has the prior good image.
Confirm green has the previous image before flipping.
