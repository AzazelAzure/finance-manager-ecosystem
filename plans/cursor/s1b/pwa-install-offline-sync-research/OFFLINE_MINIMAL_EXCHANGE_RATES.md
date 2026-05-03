# Offline exchange rates — minimal matrix (follow-up)

**Status:** parking / future implementation (not blocking current PWA “mostly usable offline” goal).  
**Context:** Web overlay math today uses **identity** when `tx.currency` ≠ source row currency or ≠ profile `base_currency` (see `finance_manager_web` `src/offline/transactionOutboxOverlay.ts` header). That is acceptable for **single-currency** users and as a **bridge** until Android enables richer native integration.

## Design intent (HitM — 2026-05-03)

- **Do not ship or sync “all world currencies.”** Persist only the **small set of rates actually needed** for the user’s data at **last successful online** session.
- **Derive the set from sources + recent activity:**
  - All **`currency` values on `PaymentSource`** (and optionally `base_currency` from profile).
  - Optionally union **transaction currencies** seen in cached lists / snapshot month rows so cross-currency txs the user already uses are covered.
- **Matrix size:** For a single-currency household, the offline rate store can be **empty** or trivial (no conversion). For “a handful” of currencies, the matrix is **O(k²)** with tiny **k** — fine for IndexedDB and periodic refresh.
- **Refresh policy:** On online reconnect (or background tick while online), refresh **only** the needed pairs (or a compact ECB slice the API already uses server-side, if exposed or bundled). Stale rates are better than no offline math for multi-ccy users who accept a disclaimer until sync.

## Product positioning

- **Web PWA:** “Mostly usable offline” for **tracking + calendar + dashboard** is the near-term bar; precise **multi-currency parity** with Django `convert_currency` is **second wave**, gated on minimal rates storage above.
- **Android (later):** Native stack can host **shared conversion** (Kotlin or optional WASM), background refresh, and tighter parity with server rules — without blocking the web wedge.

## Related implementation roadmap (web, execution order)

1. IndexedDB store for **minimal rate table** + version stamp (pairs derived as above).
2. Thin **online fetch** (dedicated API route or reuse server internals) to populate/update that store.
3. Wire `amountInBase` / `convertTxToSourceCurrency` in the offline overlay to the store (fallback to current identity when a pair is missing).
4. **Outbox DELETE echo** (or wider tx index) for balance reversals when the deleted tx was not in the cached month slice — see overlay module comments.
5. **Calendar / visualization** routes: same merge + rate helpers for consistent offline heatmaps.

No **Rust** requirement for (1)–(5); Rust/WASM remains optional if HitM later wants one binary kernel shared with Android.
