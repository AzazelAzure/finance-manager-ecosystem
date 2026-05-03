# Validation gates — PWA implementation + SEO sprint

**Plan ID:** `PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT_2026-05-03`

**Strategic cross-check:** [`plans/cursor/strategic-roadmap-reframe-53be/validation_gates.md`](../../strategic-roadmap-reframe-53be/validation_gates.md) (S1.B flagship PWA install bullet).

Each breakpoint must be **PASS** before the orchestrator opens the next dependent batch (unless explicitly parallel). Fail → re-task via `bugfix-investigation-loop`, `ci-test-triage`, or `container-runtime-podman-triage`, then re-run the same gate.

---

## BP0 — Plan freeze

- **Pass when:** `README.md`, `validation_gates.md`, `runtime_handoff.md`, `CROSS_AGENT_COORDINATION.md`, and task files **T00–T16** exist under `plans/cursor/s1b/pwa-implementation-branch/`.
- **Status:** **PASS** (2026-05-03) — artifact tree authored; implementation work not started.

---

## BP_API_D2_CORE

- **Pass when:** T01 definition of done: idempotency storage + mutating allowlist behavior matches [`../pwa-install-offline-sync-research/D2_API_OUTBOX_CONTRACT.md`](../pwa-install-offline-sync-research/D2_API_OUTBOX_CONTRACT.md) for agreed routes; API tests/lint pass per repo standards.
- **Status:** pending.

---

## BP_API_D2_BUILD

- **Pass when:** T02 definition of done: `X-Client-Build` enforcement path + standardized **409** force-upgrade body on writes when configured; contract documented in API changelog.
- **Status:** pending.

---

## BP_WEB_BUILD

- **Pass when:** T03: web sends `X-Client-Build` on mutating requests; handles 409 with user-visible upgrade/reload path per [`../pwa-install-offline-sync-research/API_VERSION_AND_CLIENT_WINDOW.md`](../pwa-install-offline-sync-research/API_VERSION_AND_CLIENT_WINDOW.md).
- **Status:** pending.

---

## BP_SEO_P0

- **Pass when:** T04: meta/OG/canonical on `index.html`; `public/robots.txt` blocks `/app/`; `public/sitemap.xml` lists public routes; JSON-Ld present per [`../distribution-channel-research/SEO_PRIORITY_MATRIX.md`](../distribution-channel-research/SEO_PRIORITY_MATRIX.md) P0 table; `npm run build` green.
- **Status:** pending.

---

## BP_MIN_PWA

- **Pass when:** T05: valid web app manifest; 192 + 512 icons; install path succeeds on **Chrome Android + Chrome desktop** (certified); `start_url` + `display` standalone-compatible per research README §6.
- **Status:** pending.

---

## BP_SW_CACHE

- **Pass when:** T06: service worker registers; app shell / hashed assets policy avoids stale `index.html` trapping old chunks (network-first or equivalent for HTML document per research README §3.1); core shell loads with network off after second visit (tier ≥ Standard expectation for shell).
- **Status:** pending.

---

## BP_SW_UPDATE

- **Pass when:** T07: `registration.waiting` / update UX documented and functional (prompt or policy explicit in repo).
- **Status:** pending.

---

## BP_SEED

- **Pass when:** T08: IndexedDB schema + ~3 month seed path per [`../pwa-install-offline-sync-research/SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md`](../pwa-install-offline-sync-research/SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md); disclaimers for limited offline history.
- **Status:** pending.

---

## BP_OFFLINE_READ

- **Pass when:** T09: agreed routes readable offline with stale indicators; not `navigator.onLine` as sole signal.
- **Status:** pending.

---

## BP_OUTBOX

- **Pass when:** T10: outbox enqueue + idempotent replay against API for v1 allowlist (transactions + upcoming expenses); conflicts/409 handled per contract.
- **Status:** pending.

---

## BP_D3_AUTH

- **Pass when:** T11: refresh-first replay; queue rules; logout confirm if outbox non-empty; cross-tab `AUTH_CHANGED_EVENT` respect per [`../pwa-install-offline-sync-research/D3_AUTH_OFFLINE_SESSION.md`](../pwa-install-offline-sync-research/D3_AUTH_OFFLINE_SESSION.md).
- **Status:** pending.

---

## BP_BGSYNC (optional)

- **Pass when:** T12 either **SKIPPED** (documented) or PASS with Chromium enhancement + fallback path tested once.
- **Status:** pending.

---

## BP_BG_PWA

- **Pass when:** T13: operator notes + smoke path for blue/green post-switch + installed PWA on production origin documented; no accidental cross-origin staging mix per research README §3.1.
- **Status:** pending.

---

## BP_D4_EXEC

- **Pass when:** T14: all applicable boxes in [`../pwa-install-offline-sync-research/D4_SMOKE_CHECKLIST_AND_ADR.md`](../pwa-install-offline-sync-research/D4_SMOKE_CHECKLIST_AND_ADR.md) §2–§4 executed on **VPS HTTPS :8443** with Chrome certified; results recorded in plan folder or linked artifact.
- **Status:** pending.

---

## BP_DOCS

- **Pass when:** T15: changelogs + design_docs note + ADR touchpoint per research §7 / D4 doc.
- **Status:** pending.

---

## BP_SPRINT_CLOSE

- **Pass when:** **BP_D4_EXEC** + **BP_DOCS** + **BP_OUTBOX** + **BP_D3_AUTH** + **BP_MIN_PWA** + **BP_SW_CACHE** + **BP_SW_UPDATE** + **BP_SEED** + **BP_OFFLINE_READ** + **BP_API_D2_CORE** + **BP_API_D2_BUILD** + **BP_WEB_BUILD** are PASS; **BP_SEO_P0** PASS; strategic S1.B PWA checklist satisfied per research README §6.
- **Status:** pending.

---

## BP_SEO_P1_START (hard gate)

- **Entry rule:** **BP_SPRINT_CLOSE** must be PASS before any merge of T16 work. SEO P1 is **not** in the PWA critical path.
- **Status:** blocked until BP_SPRINT_CLOSE.

---

## BP_SEO_P1

- **Pass when:** T16: Google Search Console registered + domain verified + sitemap submitted; `react-helmet-async` on landing/login/signup (and any matrix-listed routes); build/lint green.
- **Status:** pending.
