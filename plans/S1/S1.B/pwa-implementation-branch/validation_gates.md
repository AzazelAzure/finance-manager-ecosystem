# Validation gates — PWA implementation + SEO sprint

**Plan ID:** `PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT_2026-05-03`

**Strategic cross-check:** `[plans/cursor/strategic-roadmap-reframe-53be/validation_gates.md](../../../cursor/strategic-roadmap-reframe-53be/validation_gates.md)` (S1.B flagship PWA install bullet).

Each breakpoint must be **PASS** before the orchestrator opens the next dependent batch (unless explicitly parallel). Fail → re-task via `bugfix-investigation-loop`, `ci-test-triage`, or `container-runtime-podman-triage`, then re-run the same gate.

---

## BP0 — Plan freeze

- **Pass when:** `README.md`, `validation_gates.md`, `runtime_handoff.md`, `CROSS_AGENT_COORDINATION.md`, and task files **T00–T16** exist under `plans/S1/S1.B/pwa-implementation-branch/`.
- **Status:** **PASS** (2026-05-03) — artifact tree authored; implementation work not started.

---

## BP_API_D2_CORE

- **Pass when:** T01 definition of done: idempotency storage + mutating allowlist behavior matches `[../pwa-install-offline-sync-research/D2_API_OUTBOX_CONTRACT.md](../pwa-install-offline-sync-research/D2_API_OUTBOX_CONTRACT.md)` for agreed routes; API tests/lint pass per repo standards.
- **Status:** **PASS** (2026-05-03) — `IdempotencyRecord` + `PwaWriteContractMiddleware`; targeted tests in `finance/tests/test_pwa_write_contract.py`.

---

## BP_API_D2_BUILD

- **Pass when:** T02 definition of done: `X-Client-Build` enforcement path + standardized **409** force-upgrade body on writes when configured; contract documented in API changelog.
- **Status:** **PASS** (2026-05-03) — optional `CLIENT_BUILD_MIN_WRITE`; health payload fields; changelog + README env table.

---

## BP_WEB_BUILD

- **Pass when:** T03: web sends `X-Client-Build` on mutating requests; handles 409 with user-visible upgrade/reload path per `[../pwa-install-offline-sync-research/API_VERSION_AND_CLIENT_WINDOW.md](../pwa-install-offline-sync-research/API_VERSION_AND_CLIENT_WINDOW.md)`.
- **Status:** **PASS** (2026-05-03) — Axios request header from Vite-injected build id; `ClientBuildUpgradeGate` on `CLIENT_BUILD_UNSUPPORTED`.

---

## BP_SEO_P0

- **Pass when:** T04: meta/OG/canonical on `index.html`; `public/robots.txt` blocks `/app/`; `public/sitemap.xml` lists public routes; JSON-Ld present per `[../distribution-channel-research/SEO_PRIORITY_MATRIX.md](../distribution-channel-research/SEO_PRIORITY_MATRIX.md)` P0 table; `npm run build` green.
- **Status:** **PASS** (2026-05-03) — `finance_manager_web` `index.html`, `public/robots.txt`, `public/sitemap.xml`; P0 matrix rows marked DONE; `npm run build` + `npm run lint` green on branch.

---

## BP_MIN_PWA

- **Pass when:** T05: valid web app manifest; 192 + 512 icons; install path succeeds on **Chrome Android + Chrome desktop** (certified); `start_url` + `display` standalone-compatible per research README §6.
- **Status:** **PASS (artifacts)** (2026-05-03) — `public/manifest.webmanifest` + `pwa-192.png` / `pwa-512.png` present and referenced; **certified install smoke** still required on promoted `:8443` hostname (D4 §3.1) and is tracked under **BP_D4_EXEC**.

---

## BP_SW_CACHE

- **Pass when:** T06: service worker registers; app shell / hashed assets policy avoids stale `index.html` trapping old chunks (network-first or equivalent for HTML document per research README §3.1); core shell loads with network off after second visit (tier ≥ Standard expectation for shell).
- **Status:** **PASS** (2026-05-03) — `vite-plugin-pwa` `generateSW`; **NetworkFirst** for `navigate` in `vite.config.ts`; precache glob for hashed assets + shell.

---

## BP_SW_UPDATE

- **Pass when:** T07: `registration.waiting` / update UX documented and functional (prompt or policy explicit in repo).
- **Status:** **PASS** (2026-05-03) — `registerType: "prompt"` + `src/components/SwUpdateBanner.tsx` + `src/registerPwa.ts`.

---

## BP_SEED

- **Pass when:** T08: IndexedDB schema + ~3 month seed path per `[../pwa-install-offline-sync-research/SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md](../pwa-install-offline-sync-research/SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md)`; disclaimers for limited offline history.
- **Status:** **PASS** (2026-05-03) — Dexie schema + `src/offline/seed.ts`; `OfflineHistoryBanner` in protected shell.

---

## BP_OFFLINE_READ

- **Pass when:** T09: agreed routes readable offline with stale indicators; not `navigator.onLine` as sole signal.
- **Status:** **PASS** (2026-05-03) — cached reads + `SyncStatusBar` / offline UX paths beyond `navigator.onLine` alone (failed fetch + manual sync).

---

## BP_OUTBOX

- **Pass when:** T10: outbox enqueue + idempotent replay against API for v1 allowlist (transactions + upcoming expenses); conflicts/409 handled per contract.
- **Status:** **PASS** (2026-05-03) — `src/offline/outbox.ts`, `drain.ts`, API client adapter; transactions + upcoming modules handle queued responses.

---

## BP_D3_AUTH

- **Pass when:** T11: refresh-first replay; queue rules; logout confirm if outbox non-empty; cross-tab `AUTH_CHANGED_EVENT` respect per `[../pwa-install-offline-sync-research/D3_AUTH_OFFLINE_SESSION.md](../pwa-install-offline-sync-research/D3_AUTH_OFFLINE_SESSION.md)`.
- **Status:** **PASS** (2026-05-03) — `ProtectedShell` outbox-aware logout; cross-tab session clear path; refresh-first drain in offline layer.

---

## BP_BGSYNC (optional)

- **Pass when:** T12 either **SKIPPED** (documented) or PASS with Chromium enhancement + fallback path tested once.
- **Status:** **SKIPPED** (2026-05-03) — optional Chromium Background Sync deferred; **main-thread / manual “Sync now”** path is the supported durability mechanism per D3/D4 research.

---

## BP_BG_PWA

- **Pass when:** T13: operator notes + smoke path for blue/green post-switch + installed PWA on production origin documented; no accidental cross-origin staging mix per research README §3.1.
- **Status:** **PASS** (2026-05-03) — `finance_manager_web/docs/BLUEGREEN_INSTALLED_PWA_SMOKE.md`.

---

## BP_D4_EXEC

- **Pass when:** T14: all applicable boxes in `[../pwa-install-offline-sync-research/D4_SMOKE_CHECKLIST_AND_ADR.md](../pwa-install-offline-sync-research/D4_SMOKE_CHECKLIST_AND_ADR.md)` §2–§4 executed on **VPS HTTPS :8443** with Chrome certified; results recorded in plan folder or linked artifact.
- **Status:** **PARTIAL** (2026-05-03) — **§2** automated smoke **PASS** on VPS (see `[evidence/D4_EXEC_2026-05-03.md](evidence/D4_EXEC_2026-05-03.md)`). **§3–§4** Chrome desktop + Android certified checklist **not run** in this session; complete and re-sign before claiming full **PASS** or closing strategic S1.B PWA bullet.

---

## BP_DOCS

- **Pass when:** T15: changelogs + design_docs note + ADR touchpoint per research §7 / D4 doc.
- **Status:** **PASS** (2026-05-03) — `design_docs/40_System_Design/12_Web_PWA_Install_Offline_Sync.md`; `finance_manager_web/CHANGELOG.md` updated; D4 ADR remains *Proposed* until full D4-exec sign-off (research doc §1).

---

## BP_SPRINT_CLOSE

- **Pass when:** **BP_D4_EXEC** + **BP_DOCS** + **BP_OUTBOX** + **BP_D3_AUTH** + **BP_MIN_PWA** + **BP_SW_CACHE** + **BP_SW_UPDATE** + **BP_SEED** + **BP_OFFLINE_READ** + **BP_API_D2_CORE** + **BP_API_D2_BUILD** + **BP_WEB_BUILD** are PASS; **BP_SEO_P0** PASS; strategic S1.B PWA checklist satisfied per research README §6.
- **Status:** **pending** — blocked on **BP_D4_EXEC** full **PASS** (Chrome §3–§4 on deployed `:8443` + HitM initials) and research README “D4-exec complete” semantics; all other listed breakpoints PASS or SKIPPED as above.

---

## BP_SEO_P1_START (hard gate)

- **Entry rule:** **BP_SPRINT_CLOSE** must be PASS before any merge of T16 work. SEO P1 is **not** in the PWA critical path.
- **Status:** blocked until BP_SPRINT_CLOSE.

---

## BP_SEO_P1

- **Pass when:** T16: Google Search Console registered + domain verified + sitemap submitted; `react-helmet-async` on landing/login/signup (and any matrix-listed routes); build/lint green.
- **Status:** pending.