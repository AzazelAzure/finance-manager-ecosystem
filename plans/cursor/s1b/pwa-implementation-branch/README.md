---
plan_id: PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT_2026-05-03
status: draft
priority: P0
created: 2026-05-03
updated: 2026-05-03
owner: pproctor

plan_root: plans/cursor/s1b/pwa-implementation-branch/
intended_branch: cursor/s1b/pwa-implementation-branch
target_repos:
  - finance_manager_web
  - finance_manager_api

strategic_phase: S1
strategic_link: plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on:
  - PLAN_RESEARCH_PWA_INSTALL_OFFLINE_SYNC_2026-05-01
blocks: []
parallel_safe_with: []
conflicts_with: []

slack_gates:
  pre_execution: required
  pre_merge: required
  pre_close: required

deployment:
  required: true
  target_services:
    - api
    - js
  bundle_required: false
  rollback_plan_id: null
  smoke_targets:
    - "GET https://thehivemanager.com:8443/ (or active prod hostname per deploy docs) — landing 200"
    - "POST /api/token/ — auth"
    - "GET /api/health/ or documented health — version/build payload if exposed"
    - "Chrome PWA install + offline shell per D4 checklist (manual)"
  notes: >-
    Authoritative manual exit is D4-exec on VPS HTTPS :8443 per
    pwa-install-offline-sync-research/D4_SMOKE_CHECKLIST_AND_ADR.md.
    Use scripts/fm_docker.sh and scripts/fm_services.sh for lifecycle per
    container-testing-orchestration.

standalone: true
standalone_notes: ""
---

# S1.B — Advanced PWA implementation + SEO (P0 parallel, P1 deferred)

**Orchestration root:** this directory (`plans/cursor/s1b/pwa-implementation-branch/`, not `plans/cursor/pwa-implementation-branch/`). **Host branch:** `cursor/s1b/pwa-implementation-branch`. **Research SSoT:** [`../pwa-install-offline-sync-research/README.md`](../pwa-install-offline-sync-research/README.md) (§1.1–1.7 Advanced tier, §6 production bar, D4-exec). **SEO matrix:** [`../distribution-channel-research/SEO_PRIORITY_MATRIX.md`](../distribution-channel-research/SEO_PRIORITY_MATRIX.md). **Live blockers + VPS color notes:** [`runtime_handoff.md`](runtime_handoff.md) (continuation section).

## 0) Strategic Inheritance

- **Wedge respected:** yes — PH-first, **Chrome desktop + Chrome Android** certified per D0 Option B; iOS/WebKit not blocking v1.
- **Locked decisions touched:** Advanced PWA tier; D2 API/outbox contract; D3 auth/offline session; D4 smoke + ADR; ~3-month install seed + offline disclaimers + atomicity; single API + compatibility windowing (no Redis HTTP API routing); blue/green stable hostnames (research README §3.1).
- **Cost cap impact:** none beyond existing VPS blue/green posture; no mandatory third-party PWA SaaS.
- **Validation gates affected:** [`plans/cursor/strategic-roadmap-reframe-53be/validation_gates.md`](../../strategic-roadmap-reframe-53be/validation_gates.md) S1.B flagship **install-as-app** bullet; this plan’s **BP_D4_EXEC** and **BP_SPRINT_CLOSE** must pass before research sub-plan can close with D4-exec and registry moves to completed.

**Ready-state rule:** Per `plans/_governance/plan_template.md`, do not set this plan’s `status: ready` until `PLAN_RESEARCH_PWA_INSTALL_OFFLINE_SYNC_2026-05-01` is `completed` in `plan_registry.md` (or governance waives dependency). Until then remain `draft` / `in_progress` as execution proceeds.

## 1) Objective

Ship the **flagship web** as an **installable Advanced PWA** (manifest, SW, offline read/write, IndexedDB outbox, resync, client build + force-upgrade path) with **API support** per locked D2, aligned with **D3** session rules and **D4-exec** on deployed `:8443`. Land **SEO P0** quick wins in parallel during the sprint. Defer **SEO P1** until **BP_SPRINT_CLOSE** after PWA exit criteria are met.

## 2) Scope

### In scope

- API: idempotency storage, mutating-route allowlist, `X-Client-Build` + 409 force-upgrade contract, DELETE idempotent semantics per [`../pwa-install-offline-sync-research/D2_API_OUTBOX_CONTRACT.md`](../pwa-install-offline-sync-research/D2_API_OUTBOX_CONTRACT.md).
- Web: client build header, upgrade UX, manifest/icons, service worker + Vite-safe caching + update lifecycle, IndexedDB seed (~3 months), offline read, outbox + replay, D3 auth refresh-first + logout confirm, optional Background Sync (Chromium) with fallback.
- SEO P0: `index.html` meta/OG/canonical, `public/robots.txt`, `public/sitemap.xml`, JSON-LD per SEO matrix.
- SEO P1 (gated): Search Console + `react-helmet-async` per matrix, only after sprint close gate.
- Documentation: CPPRD changelogs, short `design_docs` cross-link per research README §7.

### Out of scope

- Native Android/iOS apps (separate W6 / future iOS).
- SEO P2/P3 (prerender, CWV program, blog/content clusters) — remain in distribution research only.
- Parallel API stacks, Redis-driven HTTP version routing, Cloudflare Workers as v1 requirement (per research README §11).
- Changing blue/green hostname topology or replacing `:8443` verification posture.

## 3) Source Evidence

- [`../pwa-install-offline-sync-research/README.md`](../pwa-install-offline-sync-research/README.md) — tier, gates, production bar, effort bands A–D.
- [`../pwa-install-offline-sync-research/D0_BROWSER_MATRIX.md`](../pwa-install-offline-sync-research/D0_BROWSER_MATRIX.md), `D2_API_OUTBOX_CONTRACT.md`, `D3_AUTH_OFFLINE_SESSION.md`, `D4_SMOKE_CHECKLIST_AND_ADR.md`, `SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md`, `API_VERSION_AND_CLIENT_WINDOW.md`.
- [`../distribution-channel-research/SEO_PRIORITY_MATRIX.md`](../distribution-channel-research/SEO_PRIORITY_MATRIX.md).
- [`../../strategic-roadmap-reframe-53be/validation_gates.md`](../../strategic-roadmap-reframe-53be/validation_gates.md) — S1.B PWA bullet.
- [`../README.md`](../README.md) — Sprint activation index — PWA (`#pwa-sprint-activation-index`).
- Other S1.B research folders (entity, payment, distribution, wedge audit) may run in parallel **if** no shared-file conflicts per `plan_template.md` §7; declare `conflicts_with` when overlap appears.
- `deploy/BLUEGREEN_SWITCHOVER.md`, `design_docs/40_System_Design/08_Android_Offline_First_Sync_Architecture.md` (vocabulary alignment).

## 4) Phase compass (progress map)

| Phase | Layer | Task files | Suggested branch | Breakpoint |
| ----- | ----- | ---------- | ---------------- | ------------ |
| P0 | Plan + coordination | `tasks/T00_plan_freeze_and_branch.md` | `cursor/s1b/pwa-implementation-branch` | **BP0** |
| P1 | API D2 — idempotency + allowlist | `tasks/T01_api_d2_idempotency_allowlist.md` | `cursor/s1b/pwa-implementation-branch` or `.../t01-api-idempotency` | **BP_API_D2_CORE** |
| P2 | API D2 — client build + 409 | `tasks/T02_api_client_build_force_upgrade.md` | same | **BP_API_D2_BUILD** |
| P3 | Web — build header + upgrade UX | `tasks/T03_web_client_build_header_and_upgrade_ux.md` | same | **BP_WEB_BUILD** |
| P1b | SEO P0 (parallel slot) | `tasks/T04_seo_p0_meta_robots_sitemap_jsonld.md` | same | **BP_SEO_P0** |
| P4 | PWA manifest + icons | `tasks/T05_pwa_manifest_icons_installability.md` | same | **BP_MIN_PWA** |
| P5 | Service worker + cache policy | `tasks/T06_service_worker_shell_and_vite_cache_policy.md` | same | **BP_SW_CACHE** |
| P6 | SW update lifecycle UX | `tasks/T07_sw_update_lifecycle_ux.md` | same | **BP_SW_UPDATE** |
| P7 | IndexedDB + 3-month seed | `tasks/T08_indexeddb_schema_and_seed_three_month.md` | same | **BP_SEED** |
| P8 | Offline read + stale UX | `tasks/T09_offline_read_routes_and_stale_ux.md` | same | **BP_OFFLINE_READ** |
| P9 | Outbox + replay | `tasks/T10_outbox_core_and_replay.md` | same | **BP_OUTBOX** |
| P10 | D3 auth / session | `tasks/T11_d3_auth_refresh_first_logout_confirm.md` | same | **BP_D3_AUTH** |
| P11 | Optional Background Sync | `tasks/T12_optional_background_sync_chromium.md` | same | **BP_BGSYNC** (optional PASS) |
| P12 | Blue/green + installed PWA notes | `tasks/T13_bluegreen_installed_pwa_smoke_notes.md` | same | **BP_BG_PWA** |
| P13 | D4-exec record | `tasks/T14_d4_exec_vps_chrome_record_results.md` | same | **BP_D4_EXEC** |
| P14 | Docs + CPPRD | `tasks/T15_design_docs_and_changelog_cpprd.md` | same | **BP_DOCS** |
| P15 | SEO P1 (post-close) | `tasks/T16_seo_p1_gsc_and_react_helmet_async.md` | same | **BP_SEO_P1** |

### 4.1) MVP posture and next lane (HitM — 2026-05-03)

- **Sync / status bar:** Current behavior is **responsive enough for MVP** after reachability gating (continuous online drain fixed, web **#48**). Further **copy, error-phase, and lie-fi** polish is **deferrable** unless it blocks D4-exec; track in [`runtime_handoff.md`](runtime_handoff.md) (*Deferred polish*).
- **Next lane (required for “real” offline product):** Implement **all user-visible reads** so they **materialize from IndexedDB caches plus outbox overlays** — same discipline as transactions / lookups / partial snapshot — so **KPIs, charts, flow aggregates, and every derived number** stay **internally consistent** while offline (within seed window + documented limits). This is the main gap between “writes queue” and “app feels whole offline.”
- **Execution hint:** Prefer extending **`transactionOutboxOverlay`**, **`lookupsOutboxOverlay`**, **`upcomingOutboxOverlay`**, **`profileOutboxOverlay`**, snapshot/totals/calendar/viz readers, and any **React Query** hooks that still hit “API-only” shapes without merging pending rows.

Execution order for orchestrator: **T00 → (T01,T02) → T03 → T04** (T04 may start after T00; coordinate `index.html` per `CROSS_AGENT_COORDINATION.md`) **→ T05 → T06 → T07 → T08 → T09 → T10 → T11 → T12 → T13 → T14 → T15 → T16** (T16 only after **BP_SPRINT_CLOSE**).

## 5) Execution Order

1. `tasks/T00_plan_freeze_and_branch.md`
2. `tasks/T01_api_d2_idempotency_allowlist.md`
3. `tasks/T02_api_client_build_force_upgrade.md`
4. `tasks/T03_web_client_build_header_and_upgrade_ux.md`
5. `tasks/T04_seo_p0_meta_robots_sitemap_jsonld.md`
6. `tasks/T05_pwa_manifest_icons_installability.md`
7. `tasks/T06_service_worker_shell_and_vite_cache_policy.md`
8. `tasks/T07_sw_update_lifecycle_ux.md`
9. `tasks/T08_indexeddb_schema_and_seed_three_month.md`
10. `tasks/T09_offline_read_routes_and_stale_ux.md`
11. `tasks/T10_outbox_core_and_replay.md`
12. `tasks/T11_d3_auth_refresh_first_logout_confirm.md`
13. `tasks/T12_optional_background_sync_chromium.md`
14. `tasks/T13_bluegreen_installed_pwa_smoke_notes.md`
15. `tasks/T14_d4_exec_vps_chrome_record_results.md`
16. `tasks/T15_design_docs_and_changelog_cpprd.md`
17. `tasks/T16_seo_p1_gsc_and_react_helmet_async.md` (**gated**)

## 6) Verification Gates

- Plan-local breakpoints: [`validation_gates.md`](validation_gates.md).
- Strategic S1.B PWA bullet: [`../../strategic-roadmap-reframe-53be/validation_gates.md`](../../strategic-roadmap-reframe-53be/validation_gates.md).
- D4-exec checklist: [`../pwa-install-offline-sync-research/D4_SMOKE_CHECKLIST_AND_ADR.md`](../pwa-install-offline-sync-research/D4_SMOKE_CHECKLIST_AND_ADR.md) §2–§4 on **deployed :8443**, Chrome certified only.

## 7) Documentation Sync Required

- `design_docs/40_System_Design/`: short **Web PWA install + offline** note cross-linking Android sync doc (T15).
- `finance_manager_web/CHANGELOG.md`, `finance_manager_api/CHANGELOG.md`: CPPRD entries when behavior ships (T15 per PR).
- Research plan README appendix / registry: when D4-exec passes, executor follows research README §8.

## 8) Strategic Phase Impact

When closing this plan, executor must:

- [ ] Confirm `validation_gates.md` S1.B PWA bullet remains satisfied (or update if tier waived — not expected).
- [ ] Update `_governance/plan_registry.md` status to `completed` for this plan_id when **BP_SPRINT_CLOSE** and **BP_D4_EXEC** are PASS.
- [ ] Run design-docs-sync per section 7.
- [ ] Post PR link(s) in Cursor chat (repo, branch, URL) per `AGENTS.md`; reconcile GitHub mergeability before merge.

## 9) Completion Criteria

- All breakpoints through **BP_SPRINT_CLOSE** PASS in `validation_gates.md`.
- **BP_D4_EXEC** PASS with recorded evidence (T14).
- **BP_SEO_P1** PASS after intentional start post **BP_SPRINT_CLOSE** (T16).
- Required PRs merged; changelogs and design doc note updated (T15).
- Research sub-plan completed + D4-exec per its README when flagship bar is met.

## 10) Risks and Rollback

| Risk | Trigger | Rollback action | Owner |
| ---- | ------- | ----------------- | ----- |
| Stale SW shell vs new Vite chunks (404) | White screen after deploy | Network-first HTML; clear caches on activate; hotfix disable SW via flag | web |
| Tier creep without API | D2 slip | Stop outbox merge; feature-flag writes offline | HitM + web |
| Auth token loss corrupts replay | D3 smoke fail | Block drain; preserve queue; fix refresh path | web + api |
| index.html merge conflicts (SEO vs PWA) | PR friction | Serialize T04 vs T03/T05 per coordination doc | orchestrator |
| `depends_on` research still draft | Registry validator blocks `ready` | Keep plan `draft` until research `completed` or governance waiver | HitM |

## 11) Coordination — Quick pay bill (KNOWN_ISSUES #2)

**Staged product decision** (not part of this sprint’s deliverables unless explicitly pulled in): dashboard **+Bill** → **Quick pay bill** — dropdown of upcoming expenses, editable amount defaulting to bill amount, submit creates a **transaction** with **`bill`** linked; v1 leaves description, category, and tags empty; remaining fields from upcoming row + form.

- **SSoT:** [`../quick-pay-bill-design/DESIGN_DECISION.md`](../quick-pay-bill-design/DESIGN_DECISION.md)
- **Conflict avoidance:** Implement Quick pay on a **dedicated feature branch** after PWA transaction/outbox work is stable, or merge only with explicit branch-owner review — **`QuickActions.tsx`** and shared transaction-create paths are overlap hotspots.
