# D2 — API + schema changes for Advanced PWA (outbox replay)

**Status:** research lock for implementation (HitM — 2026-05-01).  
**Depends on:** D1 Advanced, `[API_VERSION_AND_CLIENT_WINDOW.md](./API_VERSION_AND_CLIENT_WINDOW.md)`, D0 Chrome matrix.  
**Parent:** `[README.md](./README.md)` appendix **D2**.

---

## 1) Bottom line

**Yes — the API must change** for safe outbox replay. Today there is **no** `Idempotency-Key` handling, **no** `X-Client-Build` enforcement, and **no** standardized **force-upgrade** response. **Transaction POST** without dedupe can create **duplicate rows** if the same offline mutation is submitted twice (`tx_id` is server-generated in `Updater.fix_tx_data`; client cannot supply it).

---

## 2) Evidence from current codebase


| Observation                                                                                                   | Where                                                          |
| ------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------- |
| Client may **not** send `tx_id` / `entry_id` on create; both rejected with **403** if present.                | `finance_manager_api/finance/views/tx_views.py` `_txset_check` |
| `tx_id` generated server-side as `{YYYY-MM-DD}-{UUID8}` when missing.                                         | `finance_manager_api/finance/logic/updaters.py` `fix_tx_data`  |
| **Unique** `(tx_id, uid)` on `Transaction`.                                                                   | `finance_manager_api/finance/models.py`                        |
| **UpcomingExpense** unique `(name, uid)` — duplicate POST replay can **integrity-error** or need idempotency. | `finance_manager_api/finance/models.py`                        |
| Mutating endpoints include transactions, upcoming expenses, categories, sources, tags, profile, user.         | `finance_manager_api/finance_api/urls.py`                      |


---

## 3) Locked contract (v1 — first Advanced ship)

### 3.1 Idempotency (required)

- **Header:** `Idempotency-Key: <uuid>` (or opaque string ≤128 chars) on **mutating** requests the PWA outbox replays.
- **Semantics:** For a given **authenticated user**, within a **retention window** (recommend **7 days**, configurable), the same `(uid, Idempotency-Key)` **MUST** return the **same HTTP status + body** as the first successful response, **without** applying the mutation twice.
- **Optional header behavior:** If `**Idempotency-Key` is absent**, behavior remains **unchanged** (backward compatible for current web). **PWA / offline client MUST send** the key on every outboxed mutation.
- **Storage:** new **Django model** (not Redis routing — aligns with §11): e.g. `IdempotencyResponse` with `uid`, `key` (or SHA-256 of key), `method`, `path`, `body_hash`, `status_code`, `response_body` (JSON, size-capped or store only ids like `tx_id` for creates), `created_at`, index on `(uid, key)` unique. TTL cleanup via periodic task or delete-on-insert for keys older than window.
- **v1 allowlist** (paths under same host as today, no URL change):

  | Method   | Path pattern                         | Notes                                     |
  | -------- | ------------------------------------ | ----------------------------------------- |
  | `POST`   | `/finance/transactions/`             | **Highest risk** without dedupe           |
  | `PATCH`  | `/finance/transactions/<tx_id>/`     | Replay must not double-apply side effects |
  | `DELETE` | `/finance/transactions/<tx_id>/`     | See §3.3                                  |
  | `POST`   | `/finance/upcoming_expenses/`        | Unique `(name, uid)`                      |
  | `PATCH`  | `/finance/upcoming_expenses/<name>/` | URL-encoded name                          |
  | `PUT`    | `/finance/upcoming_expenses/<name>/` | If used by client for bills               |


**Phase 2 (not v1 blockers unless PWA scope expands):** categories, sources, tags, `appprofile` PATCH, `user` — add to allowlist when those flows are offline-capable.

### 3.2 Client build + force upgrade (required)

- **Request header:** `X-Client-Build` — semver or CI build id (see version framework doc).
- **Enforcement:** Django setting `**CLIENT_BUILD_MIN_WRITE`** (nullable = off). When set and header **below** minimum on a **mutating** request → **409** with body per `[API_VERSION_AND_CLIENT_WINDOW.md](./API_VERSION_AND_CLIENT_WINDOW.md)` §4.4 (`CLIENT_BUILD_UNSUPPORTED`).
- **Reads:** optional softer behavior (log only) until you tighten policy.

### 3.3 DELETE replay (required behavior)

- On second `DELETE` for same `tx_id` with same `Idempotency-Key` **or** new key after resource deleted: return **204** or **200** with a stable JSON body `**{ "idempotent": true, "tx_id": "..." }`** — **avoid** treating **404** as the only success path for outbox (client logic stays simpler). **Exact shape** to be mirrored in OpenAPI when implemented.

### 3.4 PATCH / conflict policy (locked default)

- **Default:** **last-write-wins** per `tx_id`; duplicate PATCH with identical normalized body returns **200** with current row (idempotency cache) or recomputes same result.
- **No `If-Match` / ETag** required for v1 unless you later add collaborative editing.

### 3.5 Auth endpoints

- **Out of v1 idempotency allowlist:** `POST /api/token/`, refresh, registration — handled by **session refresh on reconnect** (D3), not by transaction idempotency table.

---

## 4) Schema / migration summary


| Change                                                       | Required?                                 |
| ------------------------------------------------------------ | ----------------------------------------- |
| New model `IdempotencyResponse` (name TBD in implementation) | **Yes**                                   |
| New fields on `Transaction`                                  | **No** for v1 idempotency (key is enough) |
| Migrations                                                   | **Yes** (one new table + indexes)         |


---

## 5) Open items for implementation sprint (not D2 blockers)

- Exact **max JSON size** stored for idempotent response (truncate + store `tx_id` only for 201 creates).
- **OpenAPI** / `schema.yml` regeneration after headers.
- Whether `**PUT`** upcoming replaces entire row — include in same idempotency path as PATCH if client uses it.

---

## 6) Handoff

- **API repo:** middleware + model + allowlist + tests + changelog.  
- **Web repo:** axios interceptor to attach `Idempotency-Key` + `X-Client-Build` on mutating methods from outbox; handle **409** force-upgrade.

