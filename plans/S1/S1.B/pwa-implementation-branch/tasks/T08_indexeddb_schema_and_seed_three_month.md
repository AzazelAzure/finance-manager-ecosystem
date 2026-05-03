---
task_id: T08
status: pending
owner: unassigned
phase: P7
breakpoint: BP_SEED
last_verification: null
---

# T08 — IndexedDB schema + ~3 month seed

## Objective

On install or first eligible activation, **prefetch ~3 months** of data into **IndexedDB** per [`../../pwa-install-offline-sync-research/SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md`](../../pwa-install-offline-sync-research/SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md); API receives deltas via outbox only, not full re-upload of seed.

## Repo scope

- `finance_manager_web/`

## Dependencies

- T06–T07 stable enough to run app shell; API list endpoints available for seed ranges.

## Checklist

- [ ] IDB schema versioning + migration strategy.
- [ ] Seed window logic (~3 months) configurable or constant per spec.
- [ ] User-visible **offline history limited** disclaimers when showing seeded data.
- [ ] Atomicity at page/batch boundaries per seeding doc (coordinate with T10).

## Definition of done

- **BP_SEED** PASS.

## Verification

- Manual: fresh profile → seed completes → DevTools IDB shows expected stores.
- Automated tests where feasible (idb mock or integration).

## Risks

- Large initial download on cellular — consider progress UI and cancellation.

## PR expectations

- Web PR; note any API query params needed for date-bounded fetch.
