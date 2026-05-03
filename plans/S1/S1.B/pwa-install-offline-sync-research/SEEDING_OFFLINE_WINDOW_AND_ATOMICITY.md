# Install-time seeding, offline data window, and atomicity (HitM product intent)

**Status:** research / product note (2026-05-01). Extends **Advanced** tier; does **not** reopen D0–D4 gates — implementation details for execution planning.  
**S1.B linkage:** Summarized in parent plan [`README.md`](./README.md) **§1.7**; stage sprint index [`plans/S1/S1.B/README.md`](../README.md#pwa-sprint-activation-index); strategic exit language in [`validation_gates.md`](../../../cursor/strategic-roadmap-reframe-53be/validation_gates.md) (S1.B PWA bullet) and [`S1_public_beta_position.md`](../../../cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md) (W2 / exit criteria).  
**Related:** [`D2_API_OUTBOX_CONTRACT.md`](./D2_API_OUTBOX_CONTRACT.md) (writes), [`D3_AUTH_OFFLINE_SESSION.md`](./D3_AUTH_OFFLINE_SESSION.md) (auth), [`API_VERSION_AND_CLIENT_WINDOW.md`](./API_VERSION_AND_CLIENT_WINDOW.md) (local schema version).

---

## 1) Goal (user-visible)

- When the user **installs as app** (or on **first eligible activation** after install — exact trigger TBD in implementation), **prefetch ~3 months** of server-backed data into **local storage** so Advanced features (dashboards, lists, quick entry) have **usable context offline**.
- **Outbound:** only **new / changed** data goes to the API (outbox + deltas), not a full re-upload of the seed.
- **UX:** persistent **banner or inline disclaimer** in **offline mode** stating that **history is limited to the seeded window** until online; full history and any pre-window corrections require connectivity.
- **Safety:** transfers **both directions** must be **atomic at the boundaries we control** so we do not corrupt local state or server state.

---

## 2) Default constants (tunable later)

| Constant | Proposed default | Notes |
|----------|------------------|--------|
| `OFFLINE_SEED_MONTHS` | **3** | Product + perf tradeoff; may differ per entity (e.g. snapshot vs tx list). |
| Retention of local seed | Rolling window aligned to same months **or** expand on each successful online sync | TBD — avoid unbounded IndexedDB growth. |

---

## 3) Trigger options (pick one at implementation)

1. **`appinstalled` event** + first launch of standalone PWA.  
2. **First run** after `beforeinstallprompt` → user accepts install, then post-login bootstrap.  
3. **Explicit “Prepare for offline”** in settings (fallback if auto-seed fails).

**Lock recommendation:** combine **(1) or (2)** with **(3)** as escape hatch.

---

## 4) What to seed (v1 alignment)

Must align with **D2** mutation allowlist and **actual screens** that ship offline-capable in v1:

| Data | Role offline | API direction |
|------|----------------|---------------|
| **Transactions** (date range) | Lists, calendar slice, quick-add context | `GET` with `start_date` / `end_date` (existing list API patterns); paginate if needed. |
| **Upcoming expenses** | Bills / recurring context | `GET` list + detail as today. |
| **Financial snapshot** (if separate) | KPIs / safe-to-spend | `GET` snapshot endpoint — confirm single round-trip vs derived from tx. |
| **Profile / base currency** | Display + validation | Small payload; always include in seed bundle metadata. |

**Phase 2** (not in initial seed contract): category/tag/source master data beyond what tx rows already embed — unless needed for validators offline (separate spike).

---

## 5) Local storage choice

- **IndexedDB** primary store: versioned object stores (`seed_meta`, `transactions`, `upcoming`, `outbox`, `sync_cursors`).  
- **Cache API** for shell/assets only (SW); **not** for authoritative financial rows.  
- Store **`last_successful_sync_at`** (server clock or response header) and **`seed_window_end`** for UX copy.

---

## 6) UX — banners / disclaimers

- **When offline** (or when serving reads from seed while network flaky): show **non-dismissible** or **session-persistent** strip, e.g. *“Offline — showing activity from [start] to [end]. Connect for full history.”*  
- **When online but seed stale:** optional lighter notice until background refresh completes.  
- Copy is **HitM / product** owned; engineering provides **slots** + i18n keys.

---

## 7) Atomicity and corruption avoidance

### 7.1 Inbound (server → local seed)

- Fetch **paged** (e.g. 200–500 rows per request); within IndexedDB use **`transaction` on multiple stores** where the browser allows one readwrite transaction across stores — commit **per page** after validation.  
- Advance **`sync_cursor` / `seed_checkpoint`** only after the page is **fully written** and checksum or row count matches response metadata (if API adds it later; v1 can use row-count + max `date`).  
- **Partial failure mid-seed:** do **not** advance checkpoint; retry page or abort and show “Offline prep incomplete — Retry”.

### 7.2 Outbound (local → server)

- Already covered by **D2** (`Idempotency-Key`) + **ordered outbox** + **D3** refresh-first.  
- **Rule:** never send the **entire seed** as bulk POST; only **outbox entries** representing user actions since last successful sync.

### 7.3 Online reconciliation (after reconnect)

- **Pull** server changes for window **since `last_successful_sync_at`** (and handle deletes/tombstones if API exposes them — if not, full re-fetch window is safer but heavier).  
- **Merge policy (v1 default):** **server wins** on same `tx_id` / stable keys for conflicts; local-only optimistic rows without server id yet keep client temp id until 201 response maps to `tx_id` (existing create flow).  
- Apply merges in a **single IndexedDB transaction** then update cursors.

### 7.4 Install / update race with blue/green

- Seed against **current active API** host; if **409 upgrade** mid-seed, pause and prompt reload (per version framework).  
- After **SW update** post-deploy, consider **incremental re-seed** or “refresh offline data” action if schema/build changed.

---

## 8) API work likely beyond current D2 list

| Need | Purpose |
|------|---------|
| Efficient **date-range + pagination** for transactions (and consistent ordering) | Bounded seed time and memory. |
| Optional **`If-None-Match` / ETag** on snapshot** | Skip re-download when unchanged (phase 1.1). |
| **Tombstone or `updated_at`** on rows (future) | Cheaper incremental sync than full window re-pull. |

Track these in the **implementation** plan; only add to D2 doc if contracts change.

---

## 9) Explicit **out of scope** for this note

- Offline **full account history** without limit.  
- **Bi-directional CRDT** merge for collaborative editing.  
- **E2EE** of local seed at rest (optional future; not v1 default).

---

## 10) Handoff checklist for execution plan

- [ ] Choose **install trigger** (§3).  
- [ ] Confirm **GET** contracts support 3-month window + pagination.  
- [ ] Define **IndexedDB schema v1** + migration hook (`API_VERSION…` local schema).  
- [ ] Implement **banner** component + offline detector integration.  
- [ ] Add **D4-exec** cases: cold install → seed completes → airplane mode → browse within window → outbox sync.
