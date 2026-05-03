# Sync protocol (draft) — web PWA outbox + Dexie

This document will become the **normative** contract for client↔server reconciliation. Until reviewed, treat code in `finance_manager_web/src/offline/` as the live reference.

## 1. Scope v1

- **In scope:** allowlisted transaction + upcoming expense mutations (see `offline/allowlist.ts`), idempotency keys on replay, Dexie `caches` + `outbox` tables.
- **Out of scope v1:** arbitrary REST surface, server-side conflict branches beyond HTTP status handling, cross-device merge.

## 2. Identifiers

- **Client idempotency key:** random per enqueue (`outbox.ts`); replay sends `Idempotency-Key` header.
- **Pending transaction id:** `pending:<idempotency-key>` or `pending:<idempotency-key>:<index>` for multi-create (transfer pair).
- **Server id:** assigned after successful POST; client replaces pending rows after drain + refetch (today: invalidate queries).

## 3. Ordering

- Outbox rows replay **FIFO** by autoincrement `id` (`listOutboxOrdered`).
- **Dependency rule (future):** if a mutation depends on a prior create (same session), ordering must preserve referential integrity; v1 assumes API accepts independent rows or client batches where required.

## 4. Read path merge (overlay)

- `transactionOutboxOverlay.ts` replays POST/PATCH/DELETE onto base rows from network or Dexie caches.
- **Filter matching** must accept the same coercion rules as the API query object (including JSON round-trip from Dexie keys).

## 5. Optimistic materialization

- On enqueue for transaction POST, client may patch `txlist:*` cache payloads so cache-first reads match overlay (`optimisticTxEnqueue.ts`).
- **Invariant:** merged pending ids must match overlay ids to avoid duplicates when both paths run.

## 6. Drain / replay

- Requires **refresh token** to obtain access before `api.request` replay (`offline/drain.ts`).
- On success, row removed from outbox; on hard errors, drain stops and surfaces sync state.

## 7. Multi-tab (known gap)

- Leader election / `navigator.locks` for single writer — **not** implemented v1; document “avoid concurrent offline edits across tabs.”

## 8. Golden tests (planned)

- Overlay: period flags (string + number), dimension filters, transfer pair ids.
- Merge: Dexie `txlist` rows updated without duplicate pending ids.
- Drain: mock transport — success removes row; 401/refresh path.
