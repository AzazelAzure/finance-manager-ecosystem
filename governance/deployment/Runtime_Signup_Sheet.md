# Runtime Signup Sheet

> **Example session below is historical (2026-04-27).** Update this sheet whenever a human or agent **owns** the shared runtime. Container stacks today are **API + web + proxy** (Reflex removed from architecture 2026-04-30).

## Purpose
Coordinate a single shared runtime across multiple agents during testing windows, minimizing redundant shutdown/startup cycles.

## Related Coordination Docs

- Git ownership transfer template:
  - `governance/deployment/Git_Owner_Handoff_Template.md`
- Runtime ownership transfer template:
  - `governance/deployment/Runtime_Owner_Handoff_Template.md`

## Runtime Session
- Session ID: `s1b-queue-drain-blue-promotion-2026-07-06`
- Current owner: _(released — unassigned)_
- Runtime mode: `containerized` (VPS blue-green, fm-beta)
- Current status: `live` (active **BLUE** after HitM walkthrough verify; inactive **GREEN** warm rollback)
- Started at: `2026-07-06T16:50:00+08:00`
- Last updated at: `2026-07-06T16:50:00+08:08`

### Current Users
- Owner: _(released — unassigned)_ — blue promotion complete (HitM authorized)

### Queue-drain blue promotion log (2026-07-06) — PROMOTED
- Trigger: API **#86** (migration 0019 dedup), Web **#113–#116** (README paths, React align, F-006 edit mode, mobile header, landing refresh). HitM verified auto-deduct + mobile on inactive **blue** before flip.
- Pre-flip: active **green**, inactive **blue** (rebuilt from `main`); `smoke --color blue` **passed**.
- HitM authorized flip: `switch --to blue` — active **green → blue**; post-switch `smoke --color active` **passed** (captured 2026-07-06T16:50+08).
- Deployed heads at cutover: API `e79a6bc`, Web `e74057b`; migration `0019_payment_source_source_id` applied on active API.
- Public origin: `thehivemanager.com` + `api.thehivemanager.com` → **200**; `jsdevtesting` stack check **OK** (now serves inactive **green**).
- Rollback color: **green** (warm).

### Profile-fix green restage + promotion log (2026-06-30) — PROMOTED
- Trigger: Web PR **#97** merged to `main` (`9436e3b` — Profile tab black-screen Rules-of-Hooks fix + app/route `ErrorBoundary`). API `main` unchanged (`9938614`, #72); no new migration in this batch.
- Live status before restage (captured 2026-06-30T07:13+08): active **blue**, inactive **green**; all containers healthy (green stale at F-011 build, up 38h).
- `scripts/ops/sprint_verify.sh --color green --branch main --repos api,web --smoke --smoke-color inactive --no-cache`: rebuilt inactive **green** (api/web + celery worker/beat); orphan prune `0`; `api-green` healthy in 4s. Checked-out heads: **api-green `9938614`**, **web-green `9436e3b`** (both match `origin/main`).
- Known anomaly observed: `sprint_verify.sh --smoke` skipped the smoke step (SSH heredoc env passthrough drops `DO_SMOKE`; logged anomaly `2026-06-29_BILL-RECURRENCE_sprint-verify-skips-smoke.md`). Ran smoke manually instead.
- Pre-flip smoke (captured 2026-06-30T07:19+08): `fm_server_beta.sh smoke --color green` **passed**.
- HitM authorized flip (2026-06-30): `switch --to green` — pre-cutover smoke passed; active color switched **blue -> green**; post-switch `smoke --color green` passed (captured 2026-06-30T07:24+08).
- Post-switch status: active **green**, inactive **blue** (warm rollback); deployed heads at cutover: API `9938614`, Web `9436e3b`.
- Secret-redaction check: rebuild log + smoke output scanned for `--env`/secret patterns — none leaked.
- Evidence: `deploy/generated/green-restage-2026-06-30/sprint_verify_20260629T231442Z.log` (gitignored).

### S1.B recurrence + inactive-polish deploy log (2026-06-29) — PROMOTED
- Morning inactive BLUE deploy: Bill Recurrence Engine API/Web stack on `main` (API #63/#64/#65, Web #91); migration `0017_upcomingexpense_bill_cadence` applied; inactive BLUE smoke passed.
- Afternoon inactive BLUE polish deploy: pulled `main` on VPS clones and rebuilt inactive **blue** with API `a9f7972` (#66 share-link endpoint shutdown) and Web `64daf28` (#92–#95: share UI removal, dashboard/nav polish, Data Hub/Profile restructure, guide/walkthrough expansion). Manual `smoke --color blue` passed; share endpoint returned `404`.
- Modal-form tour fix deploy: Web #96 merged and inactive **blue** rebuilt again; deployed Web `ed8d2a2` (disabled broken auto-start Joyride on Quick Add / Transactions / Upcoming modal forms; per-field guide mode retained). Manual `smoke --color blue` passed.
- HitM verified inactive BLUE checklist items needed before flip; unverified items were live-only/mobile/offline checks.
- `switch --to blue`: pre-cutover smoke passed; active color switched **green -> blue**.
- Post-switch status: active **blue**, inactive **green**; `api-blue` + `web-blue` healthy; celery worker/beat and proxy up. Post-switch `smoke --color blue` passed.
- Deployed heads at cutover: API `a9f7972`, Web `ed8d2a2`.
- Export-share token cleanup: API PR #72 merged (`9938614`); active **blue** rebuilt from API `main`; migration `0018_revoke_export_share_tokens` applied; `finance_exportsharetoken` count verified at `0`; `smoke --color blue` passed.

### F-011 deploy log (2026-06-28) — PROMOTED
- Web PR #90 merged to `main` @ `8c117ee`. Visuals HitM-approved.
- `sprint_verify.sh --color green --branch main --repos web --smoke --no-cache`: rebuilt inactive **green** from `main`; web-green HEAD `8c117ee` matches `origin/main`; api-green healthy in 4s.
- `switch --to green`: pre-cutover smoke passed; active color switched **blue -> green**; post-switch active smoke passed.
- Public origin smokes (`:8443` via `--resolve`): web `/` → 200, API `/api/health/` → 200; prod bundle `index-BVjefLyJ.js` contains "Money, with Realism", "Pay Cycles & Real Bills", "Recurring Bill Automation".
- Rollback color: **blue** (warm).
- Runtime ownership released after active-green promotion + public smoke.

### F-005 deploy log (2026-06-28)
- Merged API/Web PRs to `main`: API F-005 savings-goals model + CRUD stack (#61, #62); Web F-005 goals page + dashboard widget (#88, #89).
- Pulled `main` on VPS clones: API `42bfd0e`, Web `8c493b6`.
- `rebuild-color --no-cache blue` (api/web blue + celery worker/beat); orphan prune clean; `api-blue` healthy in 3s.
- Migration `0016_savings_goal` shows `[X]` applied on shared DB (additive new table; safe for green rollback).
- `smoke --color blue`: passed. Route checks on api-blue: `/api/health/` → 200, `/finance/savings-goals/` → 401 (route present, auth required).
- `switch --to blue`: pre-cutover smoke passed; active color switched **green -> blue**.
- Post-switch origin smokes (`:8443` via `--resolve`): API health `200`, `/finance/savings-goals/` unauth `401`, web `/app/goals` `200`.
- P2 monitoring window: 6/6 spaced checks over ~15 min — health `200`, `api-blue` healthy, `TOTAL_NON2XX=0`.
- Runtime ownership released after active-blue smoke + monitoring.

### F-010 deploy log (2026-06-28)
- Merged API/Web landing PRs to `main`: API F-010 export/share stack and Web Data Hub export/share UI.
- Pulled `main` on VPS clones: API `defd844`, Web `ac341b6`.
- `scripts/ops/sprint_verify.sh --color green --branch main --repos api,web --smoke --smoke-color inactive --no-cache`: rebuilt inactive **green**; `api-green` healthy in 4s; script smoke passed.
- Migration `0015_export_share_token_f010` shows `[X]` applied on shared DB (additive share-token table; safe for blue rollback).
- `switch --to green`: pre-cutover smoke passed; active color switched **blue -> green**.
- Post-switch public origin smokes: API health `200`, CSV export unauth `401`, full backup unauth `401`, unknown share token `404`, web `/app/data` `200`.
- Runtime ownership released after active-green smoke.

### F-010 local validation log (2026-06-28)
- Cursor F-010 executor: **local-only** validation (`manage.py test`, `npm run build`); no VPS `fm_server_beta.sh` lifecycle commands run.
- No runtime ownership claimed; inactive-color deploy deferred until API/Web PR stack merges.

### F-001 deploy log (2026-06-28)
- Pulled `main` on VPS clones: API `e9a9670` (#56), Web `1e6dfaf` (#84).
- `rebuild-color --no-cache blue` (api/web blue + celery worker/beat); orphan prune clean; api-blue healthy in 3s.
- Migration `0014_balance_snapshot_f001` shows `[X]` applied on shared DB (additive new table; safe for green rollback).
- `smoke --color blue`: passed.
- `GET /finance/balance-history/?range=30d` on api-blue → `401` (route present, auth required).
- `backfill_balance_snapshots` full run: 4,143 snapshot rows upserted (after ux_demo scoped proof wrote 2,904 rows).
- `switch --to blue`: pre-cutover smoke passed; active color switched **green -> blue**.
- Post-switch smoke: active blue passed; public web `200`, public API health `200`, public balance-history route `401` (auth required).
- Sublet users:
  - _(none)_

### Lifecycle Commands (script-only)
- Last command: `fm_server_beta.sh switch --to green` + `smoke --color green` (Web #97 promotion; active **green**)
- Last status check (2026-06-30T07:24+08): active **green**, inactive **blue** (warm); post-switch green smoke passed; heads API `9938614`, Web `9436e3b`
- Prior restage (2026-06-30T07:19+08): `sprint_verify.sh --color green --branch main --repos api,web --no-cache` + manual green smoke
- Prior status check (2026-06-30T07:13+08): active **blue**, inactive **green**; all containers healthy before restage
- Prior status check (2026-06-29T19:03+08):
  - `scripts/ops/fm_server_beta.sh status`: active **blue**, inactive **green**
  - `api-blue` / `web-blue`: healthy; `api-green` / `web-green`: healthy (rollback color)
  - `celery-worker` + `celery-beat`: up
  - `proxy`: up on `:8080` / `:8443`
  - active blue smoke: passed
- Prior status check (2026-06-28T13:27+08):
  - `scripts/ops/fm_server_beta.sh status`: active **blue**, inactive **green**
- Prior status check (2026-06-28T12:32+08):
  - `scripts/ops/fm_server_beta.sh status`: active **green**, inactive **blue**
  - `api-green` / `web-green`: healthy; `api-blue` / `web-blue`: healthy (rollback color)
  - `celery-worker` + `celery-beat`: up
  - `proxy`: up on `:8080` / `:8443`
  - public smoke: `https://thehivemanager.com:8443/app/data` → 200; `https://api.thehivemanager.com:8443/api/health/` → 200; F-010 export unauth routes → 401; unknown share token → 404
  - migrations applied: `0011_tos_acceptance_fields`, `0012_appprofile_pay_cycle_fields`, `0013_upcomingexpense_bill_realism_fields`, `0014_balance_snapshot_f001`, `0015_export_share_token_f010`

### Queue / Waiting Agents
- Agent: _(none)_
  requested_scope: _(n/a)_
  requested_at: _(n/a)_
  priority: `P0`

### Ownership Transfer
- Pending transfer to: _(none)_
- Transfer condition: _(n/a)_
- Transfer timestamp: `2026-06-28T12:32:00+08:00` (released after F-010 active-green deploy)

### Notes
- **F-004 deploy complete:** pulled API/Web `main`, rebuilt inactive **green**, applied additive migrations `0011`, `0012`, `0013`, smoked green, switched active color **blue -> green**, and released ownership.
- **F-001 deploy complete:** pulled API/Web `main`, rebuilt inactive **blue**, applied additive migration `0014`, backfilled balance snapshots, smoked blue, switched active color **green -> blue**, public smoke passed, and released ownership.
- **F-010 deploy complete:** pulled API/Web `main`, rebuilt inactive **green**, applied additive migration `0015`, smoked green, switched active color **blue -> green**, public smoke passed, and released ownership.
- **F-005 deploy complete:** pulled API/Web `main`, rebuilt inactive **blue**, applied additive migration `0016_savings_goal`, smoked blue, switched active color **green -> blue**, origin smoke passed (`/finance/savings-goals/` 401, web `/app/goals` 200), and released ownership. Rollback color: **green** (warm).
- **S1.B recurrence + inactive polish deploy complete:** pulled API/Web `main`, rebuilt inactive **blue**, verified recurrence and polish on inactive, disabled broken modal-form Joyride auto-tours via Web #96, smoked blue, switched active color **green -> blue**, and released ownership. Rollback color: **green** (warm).
- **Prior closeout:** CI/CD plan (`PLAN_CROSS_CI_CD`), F-012/F-013/F-014 closeout, secret-redaction deploy, and production-UX promotion completed before this F-004 deploy.
- **Rollback:** inactive **green** retained (warm); `./scripts/ops/fm_server_beta.sh rollback` if needed.
- **Stale orphans:** legacy `finance-manager-db` / `finance-manager-proxy` containers show `Exited (2 weeks ago)` — harmless pre–blue-green names; optional cleanup on a future maintenance pass.
- **Next agent:** update `Current owner` in this sheet **before** `rebuild-color`, `switch`, `deploy`, or other lifecycle commands. Read-only curls/smoke against public URLs do not require ownership.
- Mixed runtime allowed? `no`

## Runtime Owner Handoff (closeout — 2026-06-28)

- Previous owner: `Cursor (cur/s1b/chore/f012-f014-governance)` / CI/CD + VPS maintenance session
- New owner: _(released — unassigned)_
- Timestamp: `2026-06-28T08:45:00+08:00`

### Runtime State
- Active mode: `containerized` (VPS `fm-beta`, active color **blue**)
- Last lifecycle command: `fm_server_beta.sh switch --to blue` (production UX closeout)
- Current status summary:
  - VPS `fm-beta`: db, redis, api-blue, web-blue, api-green, web-green, celery-worker, celery-beat, proxy all up; active color **blue**
  - GitHub Health Check on `main`: green (`28306647911`)

### Active Testing Breakpoint
- Breakpoint: C (regression sanity) — **passed** for promoted stack
- Current objective: _(none — session closed)_
- Validation completed: API/Web CI green on `main`; health-check cron verified; VPS on latest promoted `main`; public endpoints 200
- Validation pending: _(none for this session)_

### Known Issues / Blockers
- Critical: _(none)_
- High: _(none)_
- Notes: `fm_server_beta.sh check` nginx `-t` harness still fails on missing `00-resolver.conf` mount (logged anomaly; live proxy healthy). Branch protection waived (private repos, no GitHub Pro).

### Safety Constraints
- Mixed runtime allowed? `no`
- Forbidden actions for non-owner agents: `fm_server_beta.sh` start/stop/rebuild/switch/deploy until a new owner is recorded in this sheet

### Next Expected Actions
1. Next plan needing VPS lifecycle: claim ownership in this sheet first.
2. Optional: prune legacy `finance-manager-*` exited containers on a maintenance pass.
3. Optional: fix `fm_server_beta.sh check` nginx test harness (separate chore).

## Status Vocabulary

- `loading`: owner is starting or rebuilding runtime
- `live`: runtime is healthy and available for shared testing
- `sublet`: non-owner agent is actively using owner's live runtime
- `shutting_down`: owner is ending testing window and performing teardown
- `offline`: runtime is not active

## Active Runtime Record (Single Source of Truth)

```markdown
## Runtime Session
- Session ID:
- Current owner:
- Runtime mode: containerized | local-services
- Current status: loading | live | sublet | shutting_down | offline
- Started at:
- Last updated at:

### Current Users
- Owner:
- Sublet users:
  - Agent:
    scope:
    started_at:

### Lifecycle Commands (script-only)
- Last command:
- Last status check:
  - `scripts/ops/fm_server_beta.sh status`:
  - `scripts/local-stack/fm_services.sh status`:

### Queue / Waiting Agents
- Agent:
  requested_scope:
  requested_at:
  priority: P0 | P1

### Ownership Transfer
- Pending transfer to:
- Transfer condition:
- Transfer timestamp:

### Notes
- Blockers:
- Mixed runtime allowed? no (default) / yes (must justify):
```

## Protocol

1. First agent needing runtime creates/updates current session and becomes owner.
2. Owner sets status to `loading` then `live` after successful status checks.
3. Additional agents do not start runtime; they add themselves under `Sublet users`.
4. If owner finishes first and another sublet user still needs runtime, transfer ownership in the sheet before owner exits.
5. Last active owner performs teardown (if needed), sets status to `offline`, and records final status checks.

## Guardrails

- Shared runtime is preferred over repeated up/down cycles.
- Non-owner agents must not run start/stop/rebuild/clean commands.
- Every ownership transfer must be paired with a runtime handoff record in:
  - `governance/deployment/Runtime_Owner_Handoff_Template.md`
