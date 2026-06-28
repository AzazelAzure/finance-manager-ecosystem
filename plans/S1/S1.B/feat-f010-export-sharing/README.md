---
plan_id: PLAN_CROSS_EXPORT_SHARING_F010_2026-05-05
status: completed
priority: P1
created: 2026-05-05
updated: 2026-06-28
owner: pproctor

plan_root: plans/S1/S1.B/feat-f010-export-sharing/
intended_branch: cursor/s1b/feat/f010-export-sharing
parent_plan: plans/S1/S1.B/

target_repos:
  - finance_manager_api
  - finance_manager_web

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with: []
conflicts_with: []

slack_gates:
  pre_execution: optional
  pre_merge: required
  pre_close: optional

deployment:
  required: true
  target_services: [api, js]
  bundle_required: true
  rollback_plan_id: null
  smoke_targets:
    - GET /api/health/
    - Export download authz smoke (no cross-user leak)
  notes: **Necessary alongside PWA completion** — offline users need data portability; sharing surfaces must respect auth. Coordinate sequencing with PWA/outbox owners (`PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT_2026-05-03`); add explicit `depends_on` only when that plan is **completed** in registry. **Owner manual + D4-exec** still required per `pwa-install-offline-sync-research` before claiming PWA exit.

standalone: true
standalone_notes: ""
---

# F-010 — Export & sharing (data portability)

**Feature idea:** [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) (F-010).

## Task and slice IDs

Per [`governance/plan_template.md`](../../../../governance/plan_template.md) **§1a Task slices (T##.SL#)** and [`governance/branching_guidelines.md`](../../../../governance/branching_guidelines.md): decompose execution into **tasks** (`T##`, with task branch `…/t##-<slug>` when shipping code) and **slices** (`T##.SL#`). **`SL`** avoids collision with Phase/Stage **S** notation (`S1`, `S1.B`). Default one slice per **web route/page** or per **API model/viewset seam**; do not assign whole-product scope to a single agent pass unless the touched surface is trivially small. Executors must **ask clarifying questions** when acceptance criteria or contracts are underspecified instead of guessing.

## 0) Strategic Inheritance

- **Wedge respected:** yes — trust + household support (“send this month to spouse”).
- **Locked decisions touched:** export may touch encryption/export policy in design_docs.
- **Cost cap impact:** large exports streamed; rate limits.
- **Validation gates affected:** S1.B PWA trust bar; complements D4 smoke when offline data exists.

## 1) Objective

Ship **export** (CSV / structured backup minimum) and **sharing** (PDF month summary and/or time-limited read-only link — exact v1 in tasks) with correct authorization and audit logging.

## 2) Scope

### In scope

- Authenticated export endpoints + web UX; size/time limits; optional async job for large accounts.
- Sharing v1 scope locked in T01 (link vs file attach).

### Out of scope

- Public leaderboards; open unauthenticated exports.

## 3) Source Evidence

- [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) §F-010.
- `pwa-install-offline-sync-research/README.md` §6 (production bar).

## 4) Phase Plan or Task List

| Task | Slug | Scope | Repos |
|---|---|---|---|
| T01 | csv-export-api | `GET /finance/export/transactions/csv/` — scoped CSV download | api |
| T02 | full-backup-export-api | `GET /finance/export/full/` — full JSON backup | api |
| T03 | export-ui-datahub | Export section in DataHubPage; offline-aware | web |
| T04 | share-token-api | ExportShareToken model + create/access/revoke endpoints | api |
| T05 | share-ui | Share panel in DataHubPage; copy link, revoke | web |

**Execution order:** T01 → T02 → T03 (API must land before web); T04 → T05 (same reason). T01–T03 and T04–T05 are two independent chains; ship in a single branch sequentially.

## 5) Execution Order

Export before share links (simpler auth surface).

## 6) Verification Gates

- Security tests: cannot export other user’s data; token expiry on share links.
- Manual: download + open in LibreOffice/Sheets.

## 7) Documentation Sync Required

- Changelogs; user-facing privacy note for share links.

## 8) Strategic Phase Impact

Registry; marketing can cite portability after ship.

## 9) Completion Criteria

- Export GA; sharing per T01 minimum viable.

## 10) Risks and Rollback

| Risk | Trigger | Rollback | Owner |
| ---- | ------- | -------- | ----- |
| Token leak | share URL too guessable | Short TTL + revoke endpoint; disable feature | api |
