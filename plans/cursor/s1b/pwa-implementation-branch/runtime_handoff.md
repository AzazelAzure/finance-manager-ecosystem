# Runtime handoff — PWA implementation + SEO sprint

**Plan ID:** `PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT_2026-05-03`

**Single-owner rule:** Only one agent controls container start/stop/rebuild at a time. Record owner changes here. Prefer project scripts per `.cursor/rules/container-testing-orchestration.mdc`.

## Lifecycle scripts (default)

```bash
# From workspace root
scripts/fm_docker.sh status
scripts/fm_services.sh status
# Before/after testing batches as needed:
scripts/fm_docker.sh restart   # or start / stop / rebuild — per local policy
scripts/fm_services.sh restart
```

## Verification surface

- **Authoritative PWA exit:** manual **D4-exec** on **deployed HTTPS :8443** (active blue/green stack), **Chrome desktop + Chrome Android** only for certified exit (D0 Option B).
- **Staging / cutover hostnames:** follow `deploy/BLUEGREEN_SWITCHOVER.md` — production origin for installed PWA vs `jsdevtesting` / inactive color validation.

## Current snapshot

| Field | Value |
| ----- | ----- |
| **Runtime owner** | _(unassigned — set on first test batch)_ |
| **Mode** | VPS containerized blue/green (`~/finance_manager`, Podman) |
| **Last lifecycle command** | `FM_PUBLIC_*` override + `./scripts/fm_server_beta.sh status` + `smoke --color active` (2026-05-03) |
| **Last :8443 / D4 checkpoint** | **PARTIAL** — §2 smoke PASS; §3–§4 Chrome manual pending — [`evidence/D4_EXEC_2026-05-03.md`](evidence/D4_EXEC_2026-05-03.md) |

## Smoke log

| Date | Task / BP | Color | Result | Notes |
| ---- | --------- | ----- | ------ | ----- |
| 2026-05-03 | BP_D4_EXEC §2 / T14 | blue (active) | PASS | VPS `fm_server_beta.sh smoke --color active`; see evidence file. |

## Rollback

- SW-related production incident: disable SW registration via feature flag (per research README §10) after HitM approval; hotfix branch per `git-repo-workflow`.
