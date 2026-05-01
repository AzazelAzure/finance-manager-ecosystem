# D3 — Auth, session, and offline writes (Advanced PWA)

**Status:** research lock for implementation (HitM — 2026-05-01).  
**Depends on:** D1 Advanced, D2 idempotency contract, `[API_VERSION_AND_CLIENT_WINDOW.md](./API_VERSION_AND_CLIENT_WINDOW.md)` §3.3 UX states.  
**Parent:** `[README.md](./README.md)` appendix **D3**.

---

## 1) Current behavior (flagship web — evidence)


| Mechanism         | Detail                                                                                                                                                                                                        |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Storage**       | Access + refresh JWTs in `**localStorage`** (`fm_access_token`, `fm_refresh_token`) — `finance_manager_web/src/state/auth.ts`.                                                                                |
| **Session / UI**  | `getEffectiveAccessTokenForSession()` returns **empty** when access JWT `exp` is past (30s skew) — user appears logged out for auth-gated UI even if refresh still exists.                                    |
| **API client**    | `api` axios instance adds `Authorization: Bearer <access>` only when effective access non-empty (`client.ts`).                                                                                                |
| **401 handling**  | Response interceptor retries once after `POST /api/token/refresh/` via `refreshClient` (no auth on that call); on failure → `clearSession`, `queryClient.clear()`, redirect to `/login` from protected paths. |
| **Refresh chain** | Single in-flight `refreshChain` dedupes concurrent refreshes.                                                                                                                                                 |


---

## 2) Bottom line (D3 question)

**Is offline write allowed before the token refresh / re-auth story is specified?**  
**Yes — locked** with the rules below. Offline **recording** of mutations and **online replay** are split: replay **always** attempts **refresh-first** when access is missing/expired; **hard block** only when refresh is missing or rejected.

---

## 3) Locked rules (v1)

### 3.1 Where outbox replay runs

- **Outbox drain (network calls) runs in the main window** (or a dedicated worker that **receives** tokens from the window via `postMessage` — **not** v1 default).  
- **Rationale:** `localStorage` is **not** available inside a **service worker** global scope the same way; today’s tokens live in `localStorage`. Keeping replay on the **main thread** avoids shipping refresh tokens into SW cache by accident.

### 3.2 Allow offline **queueing** without valid access

- **Allowed:** User may **append** to the local outbox while **offline** even if the access JWT is **already expired**, **provided** a **refresh token** is still present in `localStorage` (same origin, same profile as today).  
- **Rationale:** intermittent connectivity often coincides with access expiry; forbidding queue would drop legitimate edits.

### 3.3 When access is expired **and** refresh is **missing** or empty

- **Do not** send blind mutations to the API (no `Authorization`, no recovery).  
- **UI:** **Sync blocked — sign in again** (reuse or align with `[API_VERSION_AND_CLIENT_WINDOW.md](./API_VERSION_AND_CLIENT_WINDOW.md)` **Auth blocked** state).  
- **Data:** **Retain** outbox entries (do not auto-delete) until user signs in successfully or explicitly **discards** draft queue (product copy + confirm).

### 3.4 Replay order when connectivity returns

1. If **no** `refresh` in storage → show **Auth blocked**; do not call finance APIs.
2. If access missing/expired but refresh exists → `**postRefresh`** first (reuse `refreshClient` / same contract as `api` interceptor); on success → attach new access → **drain outbox** in order with `**Idempotency-Key`** per D2.
3. If refresh returns **401/403** or network failure after backoff → **pause** drain, surface error, **retain** queue.

### 3.5 Logout / `clearSession` with pending outbox

- If **outbox depth > 0** when user requests logout: show **confirm** with at least: **Cancel** (abort logout), **Discard unsynced and sign out** (clear outbox for this session’s uid, then `clearSession()`), and when **online**: **Sync now** (run §3.4 drain, then logout if user still confirms).  
- **Never** silently drop queued mutations without user choice.

### 3.6 Account switch / uid mismatch

- Each outbox entry stores **owning uid** (from session at enqueue time). **Do not replay** entries whose uid ≠ current session uid; surface **discard or sign in as that user** (implementation copy); v1 may **auto-hide** mismatched queue behind settings/debug if product prefers minimal UX.

### 3.7 Cross-tab

- If another tab calls `clearSession`, `AUTH_CHANGED_EVENT` fires — **pause or cancel** active drain in this tab; re-evaluate tokens before resuming.

### 3.8 Security note (no new architecture in v1)

- **Refresh in `localStorage`** is existing XSS surface; PWA does not move refresh to SW.  
- **HttpOnly cookies** are **not** v1 (would change API CORS/cookie contract) — **park** for future hardening note in `PARKING_LOT` or security backlog, not D3 blocker.

---

## 4) Implementation checklist (for sprint)

- Outbox writer: allow enqueue if `getRefreshToken()` non-empty **or** `getEffectiveAccessTokenForSession()` non-empty.  
- Drain orchestrator: `refresh → outbox loop` on `online` / app focus / manual “Sync”.  
- Map refresh failure to **Auth blocked** + preserve queue.  
- Logout confirm when outbox > 0.  
- E2E: offline edit with expired access + valid refresh → online → single refresh → mutations succeed with D2 keys.

---

## 5) Relation to D2

- Idempotent replays **after** successful refresh use the same headers as online clients (`Authorization`, `Idempotency-Key`, `X-Client-Build`).

---

## 6) Out of scope (v1)

- **Passkeys / step-up** auth for high-value mutations.  
- **Per-mutation signing** or device binding.  
- **HttpOnly** session migration.

