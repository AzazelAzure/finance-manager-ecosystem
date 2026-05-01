# API version discrepancies and client support windowing (PWA)

**Location:** research artifact under `pwa-install-offline-sync-research/` (not shipped code).  
**Status:** framework for future implementation; evolves until D1–D2 lock.  
**Strategic context:** `[README.md](./README.md)` (gates D0–D4, §3.1 blue/green + SW, §11 rejected approaches).  
**Principle:** **One production API** behind stable hostnames; **bounded** backward compatibility; **client refresh** when unsupported — not parallel “old API” fleets.

---

## 1. Goals

1. Users may run an **old cached shell** (service worker + static assets) or hold **stale local data** after being offline.
2. After reconnect, **writes** must be **safe** (idempotent where possible) and **reads** must **converge** without silent corruption.
3. Operations stay compatible with **blue/green** (single active API per public hostname; see ecosystem `deploy/BLUEGREEN_SWITCHOVER.md`).

Non-goals:

- Routing traffic to **N historical Django stacks** by client age.
- Using **Redis** as an HTTP router or “version picker” for APIs (see `[README.md](./README.md)` §11).
- **Cloudflare Workers** as a requirement for v1 (optional later; §8).

---

## 2. Vocabulary


| Term                         | Meaning                                                                                                                              |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| **Client build**             | Immutable identifier for a shipped web bundle (e.g. `VITE_APP_BUILD_ID` / `import.meta.env` git SHA or semver from CI).              |
| **API compatibility window** | Server policy: “API accepts requests from clients with build ≥ **B_min**” for **write** paths (and optionally relaxed for **read**). |
| **Local schema version**     | Integer or semver stored in **IndexedDB** metadata for offline cache / outbox format.                                                |
| **Outbox**                   | Queue of mutations while offline; each entry carries **idempotency key**, **client build**, **payload version** (see §5).            |


---

## 3. Client responsibilities (PWA / SPA)

### 3.1 Always send client identity (lightweight)

On **every API request** (or at minimum on **mutations** and **session/bootstrap**):

- Header example: `X-Client-Build: <git-sha-or-semver>`  
- Optional: `X-Client-Schema: <local outbox schema int>`

Server uses this for **logging**, **windowing**, and **targeted 409** responses (§4).

### 3.2 Service worker + shell freshness

- Prefer **network-first** (or SWR) for **navigation / HTML**; **immutable** caching for hashed assets.  
- On `registration.waiting`, surface **“Update available”** → user reload (policy locked at D1 in research plan).  
- After successful **update + reload**, client build changes; next requests use new header.

### 3.3 Offline / reconnect UX states

Use **request outcome**, not only `navigator.onLine`:


| State                | User-facing                                           | Notes                                   |
| -------------------- | ----------------------------------------------------- | --------------------------------------- |
| **Live**             | Normal                                                | Reads/writes succeed.                   |
| **Offline**          | “Changes saved on this device; will sync when online” | Tier-dependent (D1).                    |
| **Syncing**          | Progress / non-blocking banner                        | Outbox drain.                           |
| **Upgrade required** | Blocking modal; single **Reload** CTA                 | Server returned **force-upgrade** (§4). |
| **Auth blocked**     | “Sign in again to sync”                               | D3; separate from version.              |


### 3.4 Local data migration (IndexedDB)

- Store `local_schema_version` in a meta store.  
- On app start: if `local_schema_version < code_bundled_min`, run **incremental migrators** (v1→v2) or, if gap too large, **clear local caches + full refetch** (product decision per entity risk).  
- **Outbox entries** from an unsupported schema: **do not replay blind** — either migrate payload or **drop with user-visible notice** + server refetch.

---

## 4. Server responsibilities (API)

### 4.1 Compatibility window policy (config)

Single source in Django settings (example names):

- `CLIENT_BUILD_MIN_WRITE` — optional git SHA ordering or **time-based** “builds after DATE”; simplest v1 is **calendar window** (“writes accepted from builds not older than **90 days**”) if SHA ordering is hard.  
- Prefer **semver or monotonic build number** from CI over raw git if comparing is needed often.

Document the policy in API release notes / internal runbook when changed.

### 4.2 Tolerant reads (within reason)

- Prefer **optional fields** on serializers; unknown fields **ignore** (DRF default patterns).  
- Do not break old clients for **GET** lightly; **breaking reads** should coincide with **raised** `CLIENT_BUILD_MIN_*` and clear client messaging.

### 4.3 Writes: idempotency + versioned payloads

- Require or strongly recommend `**Idempotency-Key`** (or body field) for create/update from outbox.  
- Accept `**client_build**` / `**payload_version**` in body or header; server may **transform** old shape → new models **inside one codebase** (not “old API stack”).  
- If transform is impossible: return structured error → client surfaces **upgrade** or **manual fix**.

### 4.4 Force-upgrade response (contract)

Define **one** JSON shape, e.g. HTTP **409** or **426** (pick one and document):

```json
{
  "code": "CLIENT_BUILD_UNSUPPORTED",
  "message": "This app version is too old to sync. Please update.",
  "min_supported_build": "2026.05.15",
  "documentation_url": "https://…"
}
```

Client: on this response, **stop outbox drain**, show **Upgrade required**, call `registration.update()` / hard navigation to origin to pick up new SW.

### 4.5 DB migrations vs API contract

- **Server DB migrations** remain normal Django migrations.  
- **API contract** evolves with **expand-contract-remove**: add new nullable fields → migrate clients → later remove old fields after window ends.  
- Never rely on “old API container still running” — rely on **one** server version + transforms.

---

## 5. Outbox replay rules (Advanced tier)

1. Sort by **created_at**; cap **retries** with backoff.
2. Each entry: `{ idempotency_key, method, path, body, client_build, payload_version }`.
3. Before replay: if `client_build < CLIENT_BUILD_MIN_WRITE` → **upgrade UI**, no replay.
4. On **409 CLIENT_BUILD_UNSUPPORTED** → same as §4.4.
5. On **400** validation: if **permanent** (unknown field removed), **dead-letter** entry + user message; do not infinite loop.

---

## 6. Observability

- Log **client build** on 4xx/5xx for mutations.  
- Optional metric: count of **force-upgrade** responses per day (signals window too aggressive or SW update broken).

---

## 7. Alignment with Android (W6)

Reuse **outbox**, **idempotency key**, and **force-upgrade** contract so `finance_manager_android` and **web PWA** share the same server semantics. Android doc: `design_docs/40_System_Design/08_Android_Offline_First_Sync_Architecture.md` (when present).

---

## 8. Cloudflare Workers (optional, not v1)

**Current setup:** origin + Nginx blue/green is sufficient; DNS/SSL may already pass through Cloudflare as **proxy only**.

**Workers** become interesting if you later need:

- Edge A/B by header without touching origin,
- WAF/rate limits at edge,
- **Geo** or **bot** rules.

They are **not** required to solve PWA version skew; **client window + single API** remains the default. If you add Workers later, keep **version policy** on the API; use Workers only for **routing experiments**, not as the source of truth for compatibility.

---

## 9. Review checklist (before changing policy)

- Updated `CLIENT_BUILD_MIN_`* documented with **effective date** and reason.  
- Client still sends `X-Client-Build` on mutations.  
- SW update path tested after deploy (see research plan `[README.md](./README.md)` §3.1 blue/green).  
- Outbox + force-upgrade manually tested on **throttled** network.

