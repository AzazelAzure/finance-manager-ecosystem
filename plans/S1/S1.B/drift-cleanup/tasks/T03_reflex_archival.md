# T03 — Reflex Archival (Topic 2 Detailed Scope)

## Objective

Execute the per-file Reflex archival scope locked at huddle Topic 2 (2026-04-30). Remove Reflex from production architecture entirely; preserve repo as historical artifact only.

## Scope Boundary

- Repos: `finance_manager` (parent — compose, proxy, scripts, deploy, env), `finance_manager_api/` (settings.py CORS/CSRF defaults), `finance_manager_reflex/` (add ARCHIVED.md only)
- Branch: `cursor/s1b/drift-cleanup/t03-reflex-archival`
- Likely 2–3 PRs across repos (parent + API; reflex repo gets a 1-line ARCHIVED.md).

## Pre-Implementation State (huddle 2026-04-30)

- Reflex containers already stopped per BP7 snapshot.
- Cloudflare tunnel for `reflex-api.thehivemanager.com` torn down by HitM 2026-04-30.
- Uncommitted Reflex branch `fix/reflex-dashboard-ui-regression` to be **abandoned** (no commit, no merge).

## Removal Targets

### Parent repo (`finance_manager`)

| File | Action |
|---|---|
| `docker-compose.yml` | Remove Reflex service block |
| `docker-compose.bluegreen.yml` | Remove `reflex-blue` and `reflex-green` services |
| `docker-compose.bluegreen.parallel.yml` | Remove Reflex services |
| `proxy/nginx.bluegreen.conf` | Remove Reflex hostname routing (`reflex-api.thehivemanager.com`) |
| `proxy/nginx.conf` | Remove any Reflex routing blocks |
| `scripts/server/create_runtime_bundle.sh` | Remove `finance_manager_reflex/` from bundle includes |
| `scripts/fm_services.sh` | Remove Reflex local-services commands if present |
| `deploy/server.env.example` | Remove Reflex env-var examples |

### `finance_manager_api/`

| File | Action |
|---|---|
| `finance_api/settings.py` | Remove `reflex-api.thehivemanager.com` from `CORS_ALLOWED_ORIGINS` and `CSRF_TRUSTED_ORIGINS` defaults |

### `finance_manager_reflex/`

| File | Action |
|---|---|
| `ARCHIVED.md` (NEW, repo root) | Pointer-only content: archive date, reason, links to canonical strategic context |

### Branches to abandon (no commit)

- `fix/reflex-dashboard-ui-regression` — abandon. Don't commit, don't merge. Branch can be deleted at HitM discretion.

## Retention (do NOT modify)

- `finance_manager_reflex/` repo content (preserve as historical artifact).
- `finance_manager_reflex/CHANGELOG.md` (historical record).
- `finance_manager_web/CHANGELOG.md` Reflex-parity historical entries.
- `finance_manager_web/src/lib/breakpoints.ts` (Reflex-style breakpoint patterns are fine; just remove "current"-implying comments if any).
- All historical execution plans referencing Reflex (`plans/archived/feat/web-reflex-parity-sweep-1/`, etc.).
- Submodule pointer in parent repo: leave frozen at last commit.

## ARCHIVED.md Content (proposed)

```markdown
# Repository Archived

This repository (`finance_manager_reflex`) was archived on 2026-04-30 as part of the post-beta huddle Topic 2 decision.

The Reflex frontend has been replaced by `finance_manager_web` (React + Vite + TypeScript) which is now the flagship product.

This repository is preserved as historical evidence only. Do not use as a reference for ongoing work.

## Canonical Sources

- Strategic context for archival: `plans/cursor/strategic-roadmap-reframe-53be/00_strategic_context.md` §3.1
- Per-product launch state: `governance/glossary.md` §8 (current state shows `reflex:Archived`)
- Active flagship: `finance_manager_web` (`web:Tight Beta` as of 2026-04-30)

## Branch Status

The branch `fix/reflex-dashboard-ui-regression` had uncommitted work at archival time. It was deliberately abandoned (not merged) as part of the archival decision.
```

## Acceptance Criteria

- All "Removal Targets" file changes shipped.
- `ARCHIVED.md` added to `finance_manager_reflex/` root.
- `fix/reflex-dashboard-ui-regression` branch abandoned (no force-delete required; can stay as historical reference).
- Production smoke after deploy: web + API still functional; Reflex routes return appropriate 404 (not 502 from missing service, not 500 from CORS misconfiguration).
- Submodule pointer in parent repo unchanged (frozen at last commit).

## Verification Commands

```bash
# Check no Reflex references in compose files
grep -ril "reflex" docker-compose*.yml proxy/ scripts/server/ deploy/server.env.example

# Check no Reflex hostname in API CORS defaults
grep -i "reflex" finance_manager_api/finance_api/settings.py

# Production smoke after deploy
ssh dev@159.198.75.194 'cd ~/finance_manager && \
  ./scripts/fm_docker.sh status && \
  curl -kfsS https://api.thehivemanager.com/api/health/ && \
  curl -kfsS https://thehivemanager.com/'
```

## Risks / Rollback

| Risk | Trigger | Rollback |
|---|---|---|
| Removing Reflex routing breaks an unexpected external dependency (Cloudflare config?) | Post-deploy 502 on web/API hostname | Color flip rollback per `deployment_protocol.md` §8 |
| API CORS removal breaks an existing integration | OPTIONS request fails from a known origin | Re-add removed origin via env override; investigate before next attempt |
| Production runtime relies on Reflex env var that wasn't documented | Container startup fails | Roll back env changes; investigate; document; re-attempt |

## Slack Gates

- `pre_execution`: required.
- `pre_deploy`: required.
- `pre_cutover`: required.
- `pre_close`: optional (low downstream risk once smoke verifies).

## Estimated Effort

2–4 hours (multiple files, multi-repo coordination, deploy + smoke).
