---

plan_id: PLAN_RESEARCH_PWA_INSTALL_OFFLINE_SYNC_2026-05-01
status: draft
priority: P0
created: 2026-05-01
updated: 2026-05-03
owner: pproctor

plan_root: plans/cursor/s1b/pwa-install-offline-sync-research/
intended_branch: cursor/s1b/pwa-install-offline-sync-research
parent_plan: plans/cursor/s1b/
target_repos:

- finance_manager_web

strategic_phase: S1
strategic_link: plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with:

- PLAN_RESEARCH_ENTITY_FORMATION_2026-04-30
- PLAN_RESEARCH_DISTRIBUTION_CHANNEL_2026-04-30
- PLAN_RESEARCH_AI_ECONOMICS_2026-04-30
conflicts_with: []

slack_gates:
  pre_execution: required
  pre_merge: none
  pre_close: required

deployment:
  required: false

## standalone: true
standalone_notes: ""

# S1.B Sub-Plan — PWA Install-as-App + Offline / Resync Research

## 0) Strategic Inheritance

**Referenced from S1.B (when implementation sprint activates):** Stage hub [`plans/cursor/s1b/README.md`](../README.md) section **Sprint activation index — PWA** (anchor `#pwa-sprint-activation-index`); exit bar [`plans/cursor/strategic-roadmap-reframe-53be/validation_gates.md`](../../strategic-roadmap-reframe-53be/validation_gates.md) (S1.B); phase/workstreams [`plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md`](../../strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md) (W2/W3/W6); portfolio [`governance/plan_registry.md`](../../../../governance/plan_registry.md) (`PLAN_RESEARCH_PWA_INSTALL_OFFLINE_SYNC_2026-05-01`).

- **Wedge respected:** yes — PH-first implies **Chrome on Android** as the primary install surface; iOS Safari PWA limitations are documented risks, not blocking assumptions for v1.
- **Locked decisions touched:** `00_strategic_context.md` §3.3 (Android pull-forward); offline/sync narrative must align with `design_docs/40_System_Design/08_Android_Offline_First_Sync_Architecture.md` so web PWA patterns **reuse** the same mental model (outbox, idempotency) where possible.
- **Cost cap impact:** none for research; implementation must stay within existing VPS/static hosting posture (no mandatory third-party PWA SaaS).
- **Validation gates affected:** S1.B exit now includes flagship **install-as-app** production bar (see `validation_gates.md`); this plan defines the testable criteria and decision gates that control how implementation proceeds.

## 1) Objective

Establish a **signed architecture and phased delivery path** for the flagship web app as an **installable PWA** (“Install app” / Add to Home Screen), including an explicit choice of **offline depth** (shell-only vs read-only vs read/write with resync). De-risk **pre-Android** distribution by giving invited PH testers an app-like surface **before** `android:Tight Beta`.

Close the research track with **decision records** so engineering does not thrash between incompatible sync models during W3/W6 execution.

### 1.1 Tier and sequencing lock (HitM — 2026-05-01)

- **D1 scope tier:** **Advanced** — install + standalone + service worker + **offline read/write** with **IndexedDB outbox**, **resync** to the live API when online, **forced client upgrade** when outside the support window (see [`API_VERSION_AND_CLIENT_WINDOW.md`](./API_VERSION_AND_CLIENT_WINDOW.md)), optional **Background Sync** as Chromium-only enhancement with fallback.
- **Sequencing:** Land Advanced PWA **out of the box** and **before** additional net-new user feature work in W3 — this work is a **dedicated sprint** (or more per §12 band **D**), not a sidecar. It addresses **intermittent connectivity** (including US grandfathered testers on unreliable links), de-risks **feature rollouts** for users who upgrade when back online, and **bridges** product semantics toward future **native Android / iOS** without pulling native app dev forward now.
- **Native apps:** Still planned later; this PWA does **not** replace them — it shares **outbox / idempotency / force-upgrade** vocabulary with W6 Android doc when implemented.

### 1.2 Owner sequencing (HitM — 2026-05-01)

- **During Decompression:** continue **research** workstreams (including this sub-plan) — lower / different mental load than feature coding.
- **After Decompression:** finish clearing **research blockers** HitM cares about for this Stage.
- **Next implementation sprint (flagship web):** **Advanced PWA** immediately once those research gates are cleared — no other user-feature sprint queued ahead of it (per §1.1).

### 1.3 D0 browser matrix lock (HitM — 2026-05-01)

- **Locked:** **Option B** — **Certified** (exit smoke + bugfix priority): **Google Chrome (desktop)** and **Google Chrome (Android)** only. **Secondary QA** (not release blockers): Microsoft Edge, Samsung Internet. **Best-effort / not certified:** Safari (iOS/macOS), Firefox. **Rationale:** PH is **mobile-first** and **Android-primary**; Chrome is the default path for most PH users; **PC is secondary**. iOS/WebKit parity is **not** required for v1 — if iPhone experience is insufficient, users defer to **future native iOS app** (acceptable trade). Detail: [`D0_BROWSER_MATRIX.md`](./D0_BROWSER_MATRIX.md).

### 1.4 D2 API / outbox contract lock (HitM — 2026-05-01)

- **Answer:** **Yes** — Advanced PWA requires **API + migration** work: idempotency storage, mutating-route allowlist, **`X-Client-Build`** enforcement for writes (when `CLIENT_BUILD_MIN_WRITE` set), standardized **409** force-upgrade body, and **DELETE** idempotent success semantics. **v1 allowlist:** `POST/PATCH/DELETE` transactions + `POST/PATCH` (and `PUT` if used) upcoming expenses. Other finance mutators **phase 2** until offline scope expands. Full spec: [`D2_API_OUTBOX_CONTRACT.md`](./D2_API_OUTBOX_CONTRACT.md).

### 1.5 D3 auth / offline session lock (HitM — 2026-05-01)

- **Offline writes before “full” re-auth story:** **Yes** — **queue** allowed while offline if **refresh token** exists OR access still valid; **replay** always **refresh-first** then outbox drain on **main thread** (tokens in `localStorage` today). **Hard block** (Auth blocked, queue retained) if refresh missing/invalid. **Logout** with non-empty outbox requires explicit confirm (**Sync now** / **Discard** / **Cancel**). Cross-tab: respect `AUTH_CHANGED_EVENT`. Full spec: [`D3_AUTH_OFFLINE_SESSION.md`](./D3_AUTH_OFFLINE_SESSION.md).

### 1.6 D4 smoke checklist + ADR lock (HitM — 2026-05-01)

- **Research deliverable locked:** [`D4_SMOKE_CHECKLIST_AND_ADR.md`](./D4_SMOKE_CHECKLIST_AND_ADR.md) — **D4-research**: operator steps (`fm_server_beta.sh` smoke, health), **Chrome desktop + Chrome Android** manual PWA/offline/outbox/auth checks, **blue/green installed-PWA** post-switch check, **D4-exec** recording template, **ADR-PWA-ADVANCED-001** stub, **Advanced v1 out-of-scope** list (§6 of that file). **D4-exec** (run all boxes on deployed `:8443`) is **implementation exit** work, not a prerequisite to continue **other** S1.B research threads.

### 1.7 Install-time seeding, offline window UX, and atomicity (HitM intent — 2026-05-01)

- On **install as app** (or first eligible activation — see doc), **prefetch ~3 months** of data into **IndexedDB** so offline mode is usable; **API receives only new/changed data** (outbox), not a full re-upload of the seed. **Banners/disclaimers** in offline mode explain **history is limited to that window** until online. **Bidirectional atomicity** at page/batch boundaries plus D2/D3 patterns to avoid corruption. Full note: [`SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md`](./SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md).

## 2) Scope

### In scope

- Web App Manifest requirements, installability criteria per **D0** (**Chrome desktop + Chrome Android** certified; see [`D0_BROWSER_MATRIX.md`](./D0_BROWSER_MATRIX.md)), and **minimum production checklist** for “fully functioning install as app” as used in `validation_gates.md`.
- Service worker role: app shell caching, runtime caching strategies, and update/lifecycle UX (refresh vs `skipWaiting` policy).
- Offline data: IndexedDB vs Cache API vs `localStorage` for **outbox** and user-visible offline state.
- Resync patterns: online/offline detection limits, retry/backoff, **idempotent** API assumptions, optional **Background Sync** as Chromium-only enhancement.
- Cross-doc alignment with Android offline-first sync architecture (shared vocabulary: outbox, conflict policy, auth refresh on reconnect).
- **Decision gates** (section 5) that block or allow the next implementation slice.

### Out of scope

- Native Android app implementation (separate W6 / `finance_manager_android` track).
- Replacing the blue-green HTTPS deployment model or proxy port strategy.
- Push notification product spec (may be mentioned as optional future capability only).
- **Certified Safari / WebKit parity on iPhone** for v1 (D0 Option B); Safari/Firefox remain **best-effort** only; iPhone users may rely on **native iOS app** when shipped if web install/offline is inadequate.

## 3) Source Evidence

- `plans/cursor/strategic-roadmap-reframe-53be/validation_gates.md` (S1.B exit, S1.C entry).
- `plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md` (W2, W6).
- `design_docs/40_System_Design/08_Android_Offline_First_Sync_Architecture.md` (if present; else note gap in §7).
- MDN: [Offline and background operation (PWAs)](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/Guides/Offline_and_background_operation).
- web.dev: [Service workers](https://web.dev/learn/pwa/service-workers) and related PWA install guidance.
- Microsoft Learn: [Background syncs in PWAs](https://learn.microsoft.com/en-us/microsoft-edge/progressive-web-apps/how-to/background-syncs) (Chromium-oriented API detail).
- `deploy/BLUEGREEN_SWITCHOVER.md` and `proxy/nginx.bluegreen.conf` — how **active vs inactive** color maps to **stable hostnames** (`thehivemanager.com` + `api.thehivemanager.com` vs `jsdevtesting.*` + `api-jsdevtesting.*`).
- `[API_VERSION_AND_CLIENT_WINDOW.md](./API_VERSION_AND_CLIENT_WINDOW.md)` — client/API **windowing** and outbox replay (plans-side research artifact).
- `[RESEARCH_ARTIFACTS.md](./RESEARCH_ARTIFACTS.md)` — index of files in this folder.
- [`D0_BROWSER_MATRIX.md`](./D0_BROWSER_MATRIX.md) — **D0** browser/install options (A/B/C) and knowledge for locking the certified matrix.
- [`D2_API_OUTBOX_CONTRACT.md`](./D2_API_OUTBOX_CONTRACT.md) — **D2** idempotency, client-build enforcement, allowlist, DELETE semantics.
- [`D3_AUTH_OFFLINE_SESSION.md`](./D3_AUTH_OFFLINE_SESSION.md) — **D3** refresh-first replay, queue rules, logout confirm, cross-tab.
- [`D4_SMOKE_CHECKLIST_AND_ADR.md`](./D4_SMOKE_CHECKLIST_AND_ADR.md) — **D4** smoke checklist, ADR stub, D4-exec template, v1 out-of-scope.
- [`SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md`](./SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md) — **3-month seed** on install, offline disclaimers, atomic seed/outbox/reconcile.

### 3.1 Early finding — Blue/green + PWA + offline/sync (2026-05-01)

**How blue/green works for the browser (today):** Routing is flipped in Nginx from `proxy/active_color.conf`. Public users always use the **same URLs**; after a switch, `thehivemanager.com` and `api.thehivemanager.com` transparently point at the **new** `web-{active}` / `api-{active}` pair. Pre-cutover validation uses **different hostnames** (`jsdevtesting…` + `api-jsdevtesting…`) so inactive stack is exercised without moving production cookies/SW scope.

**Interaction with “install as app” / service worker:**

1. **Origin scope:** A PWA installed from production is scoped to `https://thehivemanager.com` (example). Color flips **do not change hostname** — the client does not need to “know” blue vs green. That is good: one SW registration per production origin.
2. **The real coupling is cache freshness vs server deploys:** A service worker that **over-caches `index.html` / navigation** can leave users on an **old shell** that references **old hashed Vite chunks**. After you promote a new `web-*` image, those old chunk URLs may **404** on the active container → white screen until the SW updates or the user hard-refreshes. This is the classic **PWA + frequent deploy** hazard; it is **orthogonal** to the flip mechanism but **shows up right after** `switch` if clients were mid-session. **Mitigation (design-time):** network-first or `stale-while-revalidate` for the **HTML document** / app shell entry; **immutable cache** only for fingerprinted `assets/*`; disciplined `activate` cleanup of prior cache names; explicit **“Update available — reload”** when `registration.waiting` appears (`skipWaiting` policy is a product decision: auto-update vs user consent).
3. **Inactive stack (`jsdevtesting`) vs installed PWA:** Staging is a **separate origin** → **separate** SW + storage + login (per `BLUEGREEN_SWITCHOVER.md` auth note). Operators still validate full stack before `switch`; end-user installed PWAs on production are **not** silently pointed at inactive APIs.
4. **Offline → online resync vs blue/green:** When the device comes back online, API calls go to `api.thehivemanager.com`, i.e. **whatever is active now** — not “the color cached when the user went offline.” That is usually what you want for **outbox replay** (mutations land on the live API). The tension is **read model**: **local IndexedDB** may have been filled under **build N** while **API + active bundle** are now **build N+1**. Strategy: treat local cache as **stale until reconciled**; after reconnect run **version check** (lightweight config or `/api/health/` payload) or **first failed contract** → prompt refresh / soft navigation to pick up new shell; keep **API backward compatible** for queued writes across one or two releases where possible (D2 idempotency).
5. **UX split offline vs online (sync-facing):** Blue/green does not add a third “mode” beyond what offline-first already needs. Recommended **user-visible states** (implementation detail, not Nginx): **Live** (read/write against API), **Offline** (local reads + queued writes per tier; clear “changes not synced” copy), **Reconnecting / syncing** (outbox drain in progress; spinner + non-blocking UI), **Blocked** (auth expired — D3; do not imply network fault). Do **not** rely on `navigator.onLine` alone to choose between them; use **request success/failure** and outbox depth.
6. **Rollout process unchanged:** Build → deploy to **inactive** color → smoke → `switch` remains the operator path. PWA work **adds** SW/cache/update policy checks to **smoke** (post-switch: installed client or Application tab: update + hard-offline shell load).

## 4) Phase Plan or Task List


| Phase | Deliverable                                                     | Gate   |
| ----- | --------------------------------------------------------------- | ------ |
| R0    | Browser matrix + “install” definition for HitM signoff          | **D0** |
| R1    | Scope tier pick (Minimum / Standard / Advanced) + rationale     | **D1** |
| R2    | Sync + conflict + idempotency assumptions mapped to API surface | **D2** |
| R3    | Auth/offline/session note + threat sketch                       | **D3** |
| R4    | Implementation sequencing + smoke checklist + ADR stub          | **D4** |


Optional task files under `tasks/` may be added when this plan moves to `in_progress` (e.g. `T01_chromium_smoke_matrix.md`).

## 5) Execution Order

1. Run **D0** (charter freeze for browser/product expectations).
2. Run **D1** (scope tier — controls how much code lands in first implementation PR).
3. Run **D2** (sync model — may require API contract tasks in `finance_manager_api`; record handoff).
4. Run **D3** (auth/session — may block “write offline” until resolved).
5. Run **D4** (implementation plan + checklist; link from `design_docs` per §7).

## 6) Verification Gates (testable)

### Decision gates (continue / stop / fork)

Each gate requires an **explicit HitM decision** (and optional agent recommendation memo). **Do not** merge substantial PWA implementation past the listed gate without clearing it.


| Gate   | Question                                                                                                                                                                                                                                                              | If YES / chosen path                                                               | If NO / deferred                                               | Continue-dev rule                                                                                    |
| ------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- | -------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| **D0** | **Locked 2026-05-01 (Option B):** **Certified** = **Chrome desktop + Chrome Android** only. **Secondary QA** = Edge, Samsung Internet (not exit blockers). **Best-effort** = Safari, Firefox. iOS/WebKit full parity **not** required v1; iPhone may wait for **native app**. PH mobile-first / Android-primary. | Proceed to D1; **exit smoke** targets Chrome certified list only.                  | Stop: redefine matrix before SW design.                        | D0 closed — see appendix + [`D0_BROWSER_MATRIX.md`](./D0_BROWSER_MATRIX.md).                          |
| **D1** | Which **scope tier** ships for S1.B exit? **Minimum** = install + standalone + online-only behavior + SW update strategy. **Standard** = Minimum + offline **read** for agreed routes. **Advanced** = Standard + **write** queue + resync + idempotent replay design. | Lock tier; size W3/W5 capacity accordingly.                                        | Re-run D1 within 1 sprint; ship **Minimum** only if timeboxed. | Implementation PRs must not exceed selected tier without reopening D1.                               |
| **D2** | **Locked 2026-05-01:** **Yes** — new **idempotency** model + middleware/allowlist for mutating paths; optional `Idempotency-Key` backward compatible; **`X-Client-Build`** + **409** force-upgrade on writes; **DELETE** idempotent success contract. v1 allowlist: transactions + upcoming expenses. | Implement per [`D2_API_OUTBOX_CONTRACT.md`](./D2_API_OUTBOX_CONTRACT.md); web waits on API branch or parallel PR. | Tier reduced only if implementation aborts Advanced. | D2 closed — API work is in scope for Advanced sprint.                                                |
| **D3** | **Locked 2026-05-01:** Offline **queue** with **refresh** present (or valid access); **replay** = refresh-first on main thread; **Auth blocked** if no refresh; **logout confirm** if outbox non-empty; cross-tab pause. | Implement per [`D3_AUTH_OFFLINE_SESSION.md`](./D3_AUTH_OFFLINE_SESSION.md).        | N/A — Advanced path approved.                                  | D3 closed.                                                                                           |
| **D4** | **Locked 2026-05-01 (research):** Written **smoke checklist + ADR stub** in [`D4_SMOKE_CHECKLIST_AND_ADR.md`](./D4_SMOKE_CHECKLIST_AND_ADR.md) (**D4-research**). **Implementation exit:** **D4-exec** — all checklist items pass on **VPS :8443** active stack (Chrome certified); `fm_server_beta.sh smoke --color active`; waivers only via `PARKING_LOT.md`. | **D4-research** done → proceed with other research. **S1.B PWA bar + plan `completed`:** require **D4-exec** pass. | Fix failures or file waiver. | **D4-research** closed; **D4-exec** gates plan completion per §0 / `validation_gates.md`. |


### Checklists

**Research complete (plan `completed`):**

- All gates **D0–D4** have a one-line decision + date in this README (appendix table) or linked ADR.
- Chosen tier documented with **explicit out-of-scope** list for deferred work — see [`D4_SMOKE_CHECKLIST_AND_ADR.md`](./D4_SMOKE_CHECKLIST_AND_ADR.md) §6 (**Advanced v1 out-of-scope**).
- **D4-exec:** all manual + automated checks in [`D4_SMOKE_CHECKLIST_AND_ADR.md`](./D4_SMOKE_CHECKLIST_AND_ADR.md) **§2–§4** executed and recorded on **deployed :8443** before `status: completed` and S1.B PWA validation bullet clears.

**Production “install as app” bar (S1.B exit — flagship `finance_manager_web` on VPS HTTPS :8443):**

- **Manifest** valid (`name`, `short_name`, `start_url`, `display: standalone` or `standalone`-compatible, icons including **192** and **512**).
- **HTTPS** origin matches production; no mixed-content blockers for shell.
- **Service worker** registers successfully; **second visit** loads core shell with **network disabled** (manual DevTools test) for tier ≥ Standard; for Minimum, SW may be update-only if explicitly decided at D1.
- **Install** path verified: Chrome “Install…” / Android “Add to Home screen” succeeds; installed icon launches **standalone** window scoped to app origin.
- **Update strategy** documented in repo (user prompt vs auto-`skipWaiting` policy).
- If **Advanced**: outbox replay proven against staging or prod with **idempotency**; `navigator.onLine` not sole source of truth; Background Sync treated as optional enhancement with fallback path tested once.

## 7) Documentation Sync Required

- `design_docs/40_System_Design/`: add or update a short **Web PWA install + offline** note cross-linking Android sync doc (after D1 tier lock).
- **This plan folder** remains the SSoT for research (`API_VERSION_AND_CLIENT_WINDOW.md`, `RESEARCH_ARTIFACTS.md`) until execution plans link here; optional copy into `design_docs/` or `finance_manager_web/` only after decisions lock.
- `finance_manager_web/CHANGELOG.md`: when implementation ships, CPPRD entry per workspace rule.

## 8) Strategic Phase Impact

When closing this plan, executor must:

- Confirm `validation_gates.md` S1.B PWA bullet still matches §6 (revise if tier changed).
- Update `governance/plan_registry.md` status to `completed`.
- Post completion summary per workspace Slack policy if `pre_close: required`.

## 9) Completion Criteria

- §6 research checklist satisfied.
- Decision appendix (below) filled.
- No open D2/D3 **blockers** without an explicit deferral recorded.

## 10) Risks and Rollback


| Risk                              | Trigger                    | Rollback action                                  | Owner     |
| --------------------------------- | -------------------------- | ------------------------------------------------ | --------- |
| Tier creep (Advanced without API) | D2 unresolved past timebox | Downgrade to Standard or Minimum at D1           | HitM      |
| iOS testers expect parity         | Support burden             | Messaging + docs: “best effort on Safari”        | HitM      |
| SW cache breaks auth or API       | Smoke fail at D4           | Disable SW registration via feature flag; hotfix | web owner |


## 11) Rejected approaches and infrastructure lessons (HitM records)

**Locked guidance (2026-05-01):** do **not** plan PWA longevity around **multiple concurrent API stacks** (one per old service worker age), **Redis-driven HTTP routing** to “stale APIs,” or **Cloudflare Workers** as a **v1 requirement** for version skew.

### 11.1 What Redis is actually for (here and in typical Django stacks)

Redis in `docker-compose.bluegreen.yml` is wired as `REDIS_URL` to the API — common uses include **cache**, **session store**, **channel layers** (WebSockets), and **rate limiting**. It is a **fast in-memory datastore** the application talks to over its **own** connection — **not** a reverse proxy and **not** where browser HTTP requests land. Using Redis to **choose which Django version** answers `api.*` would be a custom application design on top of Redis, not a standard pattern, and would **not** simplify operations versus a **single API** with explicit **compatibility windowing** (see [`API_VERSION_AND_CLIENT_WINDOW.md`](./API_VERSION_AND_CLIENT_WINDOW.md)).

### 11.2 Celery (when present) — preconception vs reality

**Celery** is a **distributed task queue**: you enqueue work (emails, reports, heavy jobs) to **workers** that run **asynchronously**, often with **Redis or RabbitMQ** as the **message broker** and sometimes result backend. It is for **“do this job soon / in the background”**, not for **versioning HTTP APIs** or routing user traffic to old codebases. This repo may or may not run Celery today; if Redis exists without Celery, Redis is still valid for cache/sessions alone.

### 11.3 Multi-version API pools and blue/green

**Blue/green** today means **two** colors to **promote** one logical production; it is **not** a model for retaining **five historical APIs** for ancient PWAs. Keeping many old containers for **years** blows **VPS memory**, **deploy complexity**, and **Cloudflare** config — contrary to the **₱100/mo** posture. The approved approach is **one active API**, **tolerant serializers + optional payload transforms**, **idempotent writes**, and **forced client reload** when the client is outside the support window.

### 11.4 Cloudflare Workers

Workers **can** route by headers or do edge logic at scale; they are **optional** and **not implied** by the current Nginx blue/green setup. If HitM later uses a **Cloudflare MCP** to manage Workers, treat that as **edge enhancement** (WAF, A/B, geo) — **not** the primary place to define **API compatibility policy**, which stays in **Django + documented headers** (`X-Client-Build`, force-upgrade JSON contract).

### 11.5 Plans-side source of truth (research phase)

Version windowing and related framework notes live **only under this sub-plan** until dev execution starts:

- `[RESEARCH_ARTIFACTS.md](./RESEARCH_ARTIFACTS.md)` (index)
- `[API_VERSION_AND_CLIENT_WINDOW.md](./API_VERSION_AND_CLIENT_WINDOW.md)` (framework)
- `[OFFLINE_MINIMAL_EXCHANGE_RATES.md](./OFFLINE_MINIMAL_EXCHANGE_RATES.md)` (parking: minimal FX matrix from user sources + roadmap hook; web “mostly offline” until Android)

## 12) Effort guidance (indicative — HitM vs AI hours)

Rough order-of-magnitude for **one flagship web codebase + existing VPS blue/green**, assuming **no** Cloudflare Worker build-out and **no** parallel API fleets. AI hours = agent-assisted implementation + iteration + tests; HitM hours = decisions (D0–D4), manual device QA, prod smoke, review/merge.


| Scope                                 | What it includes                                                                                       | HitM (hours) | AI (hours) |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------------ | ---------- |
| **A — Docs + version framework only** | Headers contract, force-upgrade JSON, settings knobs, changelog; **no** SW/offline                     | 3–6          | 6–14       |
| **B — Minimum PWA**                   | Manifest, icons, install, SW register, **safe cache** for Vite hashes, update UX, smoke on `:8443`     | 6–12         | 16–32      |
| **C — Standard PWA**                  | B + offline **read** for agreed routes (cache/API strategy, stale indicators)                          | 10–20        | 28–48      |
| **D — Advanced PWA**                  | C + IndexedDB outbox + replay + **API idempotency** / server transforms + Background Sync **optional** | 18–35        | 55–95      |


**Notes:** (1) **D** overlaps **API repo** work — split AI time or add parallel agent. (2) HitM time **dominates** if testing many **Android Chrome + desktop** combinations or if **auth refresh** (D3) is thorny. (3) First-time **SW + deploy** surprises can add **+8–20 AI hours** once; subsequent releases cheaper if patterns stabilize.

---

## Appendix — Decision log (fill on gate closes)


| Gate | Decision | Date | Notes |
| ---- | -------- | ---- | ----- |
| D0   | **Option B** | 2026-05-01 | Certified: **Chrome desktop + Chrome Android**. Secondary QA: Edge, Samsung Internet. Best-effort: Safari, Firefox. iPhone not blocking; native iOS later if needed. PH mobile-first. [`D0_BROWSER_MATRIX.md`](./D0_BROWSER_MATRIX.md) |
| D1   | **Advanced** | 2026-05-01 | HitM lock per §1.1: full offline write + outbox resync + upgrade path; dedicated sprint before net-new user features; bridge to native apps later. |
| D2   | **Yes — contract locked** | 2026-05-01 | Idempotency model + allowlist (transactions + upcoming); `X-Client-Build` + 409 upgrade; DELETE idempotent body. [`D2_API_OUTBOX_CONTRACT.md`](./D2_API_OUTBOX_CONTRACT.md) |
| D3   | **Locked** | 2026-05-01 | Refresh-first drain; queue if refresh or access ok; logout triage; main-thread replay. [`D3_AUTH_OFFLINE_SESSION.md`](./D3_AUTH_OFFLINE_SESSION.md) |
| D4   | **Research locked** | 2026-05-01 | Checklist + ADR stub in [`D4_SMOKE_CHECKLIST_AND_ADR.md`](./D4_SMOKE_CHECKLIST_AND_ADR.md). **D4-exec** (run all checks on :8443) at implementation exit. |


