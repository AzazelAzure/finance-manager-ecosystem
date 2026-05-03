# PWA “standalone brain” (D) — optimistic local + reconciliation

**Status:** In progress (web implementation landed incrementally; this folder tracks the formal contract and tests).

**Goal:** Treat IndexedDB + outbox as the **authoritative UI read model** while offline (and optionally while online in installed PWA), with deterministic merge rules and a documented sync protocol before expanding golden coverage.

## Implemented in web (incremental)

- **Filter coercion:** `txlist:*` cache keys from `JSON.parse` can carry numeric flags (`current_month: 1`). List/snapshot overlay matching now stringifies/coerces so pending POST rows are not dropped vs URL string filters.
- **Offline queue session gate:** allowlisted mutating writes queue when the device is disconnected **if either** refresh or access token is present (drain still requires refresh to upload).
- **Optimistic Dexie merge on enqueue:** after POST `/finance/transactions/` is queued, synthetic `pending:<idempotency-key>` rows are merged into every matching `txlist:*` cache row so PWA cache-first reads stay aligned with `applyTransactionOutboxToList`.

## Next (tracked here)

1. **`SYNC_PROTOCOL.md`** — lock ordering, idempotency keys, conflict class, replay failure modes, multi-tab policy.
2. **Golden tests** — expand `finance_manager_web/src/offline/*.test.ts` for overlay + merge + drain simulation (mock `api`).
3. **Snapshot cache** — optional same-pattern merge for `snapshot:*` rows (month-scoped) if materialized reads diverge from list-only paths.
4. **`design_docs` hygiene** — deferred until PWA exit; link this folder from the eventual ADR.

## References

- Locked research: `plans/S1/S1.B/pwa-install-offline-sync-research/`
- Web changelog: `finance_manager_web/CHANGELOG.md`
