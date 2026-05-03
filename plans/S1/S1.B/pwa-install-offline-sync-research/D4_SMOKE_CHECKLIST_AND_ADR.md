# D4 — Smoke checklist, operator gates, and ADR stub (PWA Advanced)

**Status:** research lock (HitM — 2026-05-01). **Execution** of every checkbox happens **after** implementation on **VPS `https://…:8443`** (not Lane-A as sole proof).  
**Parent:** `[README.md](./README.md)` appendix **D4**, §6 production bar.

---

## 0) Two phases (read carefully)


| Phase                             | Meaning                                                                                                                                                                                                                                                                                              |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **D4-research (done now)**        | This document + ADR §1–§5 exist; appendix **D4** row filled — **contract** for what “green” means.                                                                                                                                                                                                   |
| **D4-exec (implementation exit)** | A human/agent runs **every** unchecked manual step on the **deployed** stack and records pass/fail + date in execution plan or `design_docs` handoff. **Plan `status: completed`** and S1.B PWA bullet in `validation_gates.md` require **D4-exec** pass (or documented waiver in `PARKING_LOT.md`). |


---

## 1) ADR stub — PWA Advanced (finance_manager_web + API)

**ADR ID:** `ADR-PWA-ADVANCED-001` (rename when moved to `design_docs/` or `finance_manager_web/docs/`).  
**Status:** *Proposed* at research close; move to **Accepted** when HitM + implementation sign off after D4-exec.

### 1.1 Context

- Flagship **React + Vite** on **blue/green** Nginx proxy; public **HTTPS :8443** (`deploy/BLUEGREEN_SWITCHOVER.md`).
- **D0 Option B:** certified **Chrome desktop + Chrome Android** only for exit smoke.
- **D1 Advanced:** offline read/write, IndexedDB outbox, resync, forced upgrade path.
- **D2:** `Idempotency-Key`, `X-Client-Build`, idempotency store, mutating allowlist (transactions + upcoming expenses).
- **D3:** `localStorage` JWTs; **refresh-first** outbox drain on **main thread**; logout confirm when queue non-empty.

### 1.2 Decision

1. Ship **installable PWA** (manifest + icons 192/512 + `start_url` + `display` standalone) + **service worker** with **network-first (or SWR) for HTML document** and **hash-long-cache** for fingerprinted assets; versioned cache names + `activate` cleanup.
2. **User-visible update:** `registration.waiting` → **“Update available — Reload”** (exact copy TBD); **no** silent `skipWaiting` without product sign-off (default: **prompt**).
3. **Offline:** Advanced scope per D1/D2/D3; **Background Sync** optional with **main-thread fallback** always implemented.
4. **Blue/green:** After `switch`, re-run **installed PWA** smoke (§3.1 parent README) — update banner + successful reload to new shell.

### 1.3 Consequences

- **Every** `switch` / web image promotion: run **script smoke** + **Chrome PWA subset** from checklist below.
- **OpenAPI** / client types must include new headers when D2 ships.
- **CPPRD:** subrepo `CHANGELOG` entries on ship.

### 1.4 Compliance / review

- Revisit ADR when **D0 matrix**, **idempotency retention window**, or **update policy** changes.

---

## 2) Operator / automated (run from VPS or CI with proxy reachability)

Use project scripts per workspace rules (`scripts/fm_server_beta.sh`, `scripts/fm_docker.sh` as applicable). Env vars per script help (`FM_PUBLIC_BASE_URL`, host headers, etc.).

- `**./scripts/fm_server_beta.sh status`** — active color known; proxy up.
- `**./scripts/fm_server_beta.sh smoke --color active**` — API + web probes for **active** color against **:8443** (or documented equivalent).
- `**curl -sk https://<public-host>:8443/api/health/`** (or health URL matching prod) returns **200** JSON ok.
- **Public web** `https://<apex>:8443/` returns **200** and serves SPA shell (not error page).

---

## 3) Chrome desktop (certified) — manual

Perform against **production hostname** on **:8443** (or `jsdevtesting` only for **pre-cutover** validation — **exit** still requires apex on active color per `validation_gates.md`).

### 3.1 Install + manifest

- DevTools → **Application** → **Manifest** parses with no errors; **192** and **512** icons present; `start_url` and `display` correct.
- **Install** from omnibox / menu → app opens in **standalone** window; URL bar scoped to app origin.

### 3.2 Service worker + shell

- **Application** → **Service Workers** shows **activated** worker for origin.
- **Second visit** (or hard reload after SW active): with **Network → Offline**, app shell still loads (**navigation** request strategy must not strand user on blank screen).
- With network **on**, primary authenticated **dashboard** (or agreed offline route set) loads.

### 3.3 Advanced — outbox + D2/D3 (post-implementation)

- **Offline:** create or edit within **v1 allowlist** (transactions / upcoming per D2); entries appear in **outbox** UI or debug surface.
- **Online:** **refresh-first** (D3) then drain; server shows **single** logical row for duplicate `**Idempotency-Key`** replay.
- **Auth blocked:** clear refresh token (or revoke server-side) → drain shows **sign in again**; queue **not** silently deleted.
- **Logout** with pending outbox → **confirm** dialog paths work (Cancel / Discard / Sync now when online).
- `**navigator.onLine` alone** is not the only trigger: failed fetch or explicit sync button also drives drain (document in code review).

### 3.4 Client build / force upgrade (post-D2 API)

- Send `**X-Client-Build`** below configured minimum → **409** with `CLIENT_BUILD_UNSUPPORTED` body; client shows **upgrade** path and stops drain.

### 3.5 Background Sync (optional)

- If implemented: Chromium path registers sync; **disable** sync in DevTools and confirm **main-thread** drain still succeeds.

### 3.6 Blue/green post-switch (installed PWA)

- After promoting inactive → active: open **installed** PWA → user receives **update** prompt or equivalent; **Reload** loads new shell without broken chunk 404 loop.

---

## 4) Chrome Android (certified) — manual

Repeat **§3.1–§3.3** (and §3.4–§3.6 when applicable) on a **physical device or emulator**; **Add to Home screen** → launch from home screen; **airplane mode** for offline shell test.

---

## 5) Recording D4-exec

Template (copy to execution plan or handoff doc):

```
D4-exec run: <date>
Environment: <host> :8443, active color <blue|green>
Chrome desktop: pass | fail (notes)
Chrome Android: pass | fail (notes)
fm_server_beta smoke --color active: pass | fail
Waiver: none | PARKING_LOT P-xx
Signer: HitM / agent id
```

---

## 6) Advanced v1 — explicit **out of scope** (product + QA)

Not required for **D4-exec** pass unless scope expands:

- Certified **Edge / Samsung** (secondary QA only per D0).
- **Safari / Firefox** parity testing.
- Offline mutating flows for **categories, sources, tags, profile** (D2 phase 2).
- **HttpOnly cookie** auth migration.
- **Outbox replay inside service worker** without main-thread token handoff.
- **Lane-A (Vite-only)** as the **only** proof of PWA behavior — **:8443** stack remains authoritative.
- **Unbounded offline browse** of full account history — v1 uses a **bounded seed window** per `[SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md](./SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md)`.

