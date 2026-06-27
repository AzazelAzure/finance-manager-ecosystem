# T06 — Dexie.js Encryption at Rest

## Context
Audit 2026-06-27 confirmed `offline/db.ts` uses plain Dexie with no encryption plugin. Financial data (outbox mutations, API response caches) is stored unencrypted in IndexedDB. Privacy policy §3.12 cannot claim encryption-at-rest until this is implemented.

Since the app uses a dual-write model (financial data is also stored server-side), the Dexie copy is primarily an offline access mirror. The encryption key can safely be fetched from the API after authentication — loss of the key on page reload is acceptable because data is recoverable from the server.

## End State
- All Dexie stores (`outbox`, `caches`, `meta`) encrypted using `dexie-encrypted`
- Encryption key fetched from the API immediately after successful login/silent refresh; stored in memory only (never in localStorage, sessionStorage, or cookies)
- On page reload with no key: silent refresh restores access token → API returns encryption key → Dexie is accessible again
- Indexed fields remain unencrypted (required by Dexie constraint — only non-indexed fields can be encrypted)

## Acceptance Criteria
1. [V1] `npm run build` passes with `dexie-encrypted` installed
2. [V1] After login, raw IndexedDB inspection (devtools → Application → IndexedDB) shows encrypted values in `outbox` and `caches` tables — payload is not human-readable
3. [V1] App reads and writes transactions correctly through the encrypted DB
4. [V1] After page reload, Dexie data is accessible within the silent refresh flow (key restored before Dexie is opened)
5. [V0] Encryption key is NOT present in `localStorage`, `sessionStorage`, or any cookie after login

## Scope Lock

### Web changes (`finance_manager_web`)
- `package.json` + lockfile — add `dexie-encrypted`
- `src/offline/db.ts` — wrap `FinanceOfflineDB` with `applyEncryptionMiddleware` from `dexie-encrypted`; accept the encryption key as a constructor argument or via a setter called after login
- Add a key provider mechanism: after login (and after T05 silent refresh), the app fetches a per-session encryption key from the API and passes it to the Dexie instance before any offline read/write
- Do NOT encrypt indexed fields: `outbox.id`, `outbox.createdAt`, `outbox.idempotencyKey`; `caches.id`, `caches.fetchedAt`; `meta.key` — these must remain plaintext for Dexie indexing to work

### API changes (`finance_manager_api`)
- Add a lightweight endpoint (e.g., `GET /api/auth/dexie-key/`) that returns a per-user, per-session AES-256 key
- Key derivation: generate deterministically from `HMAC(secret, user_uuid)` using a server-side secret env var (`DEXIE_KEY_SECRET`) — same user always gets the same key, so existing encrypted Dexie data remains accessible after re-login
- Key endpoint must be authenticated (requires valid access token)
- `DEXIE_KEY_SECRET` added to `.secrets/` env file only — never committed

### Files NOT to touch
- Any offline queue logic (`optimisticTxEnqueue.ts`, `outbox.ts`, etc.) — these call Dexie but don't need to know about encryption; it's transparent at the DB layer
- Django model files or migrations

## Technical Decisions (pre-locked)
- Use `HMAC(DEXIE_KEY_SECRET, user_uuid)` for key derivation — deterministic means re-login works without re-encrypting existing data; simpler than per-session random keys
- `dexie-encrypted` uses `tweetnacl` (XSalsa20-Poly1305) by default — acceptable; no need to configure a different cipher for MVP
- Key is 32 bytes (256 bits), returned as base64
- The Dexie instance should not open until the key is available — gate the offline DB initialization behind the key fetch
- If key fetch fails (API unreachable), Dexie operates in offline-only mode: reads from already-open encrypted DB if it was previously opened this session; no new decryption possible until key is restored

## Slice Decomposition
| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T06.SL1 | API: dexie-key endpoint | V1 | `GET /api/auth/dexie-key/` returns HMAC-derived key; `DEXIE_KEY_SECRET` env var; auth required |
| T06.SL2 | Web: install + wire dexie-encrypted | V1 | `npm install dexie-encrypted`; wrap DB class; non-indexed fields encrypted |
| T06.SL3 | Web: key fetch on login/refresh | V1 | After token acquisition, fetch key from API; pass to Dexie before first read/write |
| T06.SL4 | Web: key gating | V0 | Gate offline DB open behind key availability; graceful degradation if offline and no key in memory |

## Evidence
- `evidence/T06.SL1_key_endpoint.txt` — curl output showing key endpoint returns a base64 key when authenticated
- `evidence/T06.SL2_indexeddb_encrypted.txt` — browser devtools screenshot showing encrypted IndexedDB values
- `evidence/T06.SL3_flow.txt` — console/network trace of login → key fetch → Dexie open sequence

## Privacy Note
After this is implemented, §3.12 of `privacy_policy_requirements.md` can accurately state:
- Dexie.js encryption-at-rest using XSalsa20-Poly1305
- Encryption key derived server-side, held in memory only during session
- Non-indexed fields encrypted; indexed fields (timestamps, IDs) remain plaintext
