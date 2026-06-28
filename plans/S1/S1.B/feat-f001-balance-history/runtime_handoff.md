# F-001 Balance History — Runtime Handoff

> Hard limit: 200 lines. Keep current.

## Status: COMPLETE — active production blue

**As of:** 2026-06-28T11:20+08:00

## Delivered
- **API** (`cur/s1b/feat/f001-balance-history`): T01–T03 — model `0014`, Celery capture + backfill, `GET /finance/balance-history/`
- **Web** (`cur/s1b/feat/f001-balance-history`): T04 — dashboard chart + PWA cache/seed
- **PRs merged:** API [#56](https://github.com/AzazelAzure/finance-manager-api/pull/56) | Web [#84](https://github.com/AzazelAzure/finance-manager-web/pull/84)
- **Production:** active color **blue** after `switch --to blue`; rollback color **green**

## Verification
- [x] V1 API: `pytest finance/tests/balance_tests/` (14 passed)
- [x] V1 Web: `npm run build`
- [x] V2: inactive blue deploy + smoke passed; migration `0014` applied; balance-history route returned `401` unauthenticated
- [x] V3: HitM approved jsdevtesting dashboard rendering before promotion
- [x] Active production smoke: web `200`; API health `200`; balance-history route `401`

## PWA
- `fetchBalanceHistory` uses local-first IndexedDB cache + offline empty/cached fallback (Class B read — no offline write path).
- Offline seed prefetches `30d` and `90d` series.
- Mutation invalidation includes `balance-history` query key.
- Follow-up from review: existing PWA installs that already completed `offline_seed_v3` only cache balance history after an online dashboard visit; consider `offline_seed_v4` / incremental seed in a follow-up.

## Runtime / branch signup
- Checked in for local implementation at 11:00+08; checked in for VPS deploy at 13:05+08; released at 11:20+08 after active-blue promotion (`Runtime_Signup_Sheet.md`, `Git_Branch_Signup_Sheet.md`).
- Full backfill run after ux_demo proof: 4,143 `BalanceSnapshot` rows upserted.
- Agent review: no critical blockers. Known follow-up: snapshots can go stale after historical transaction edits until targeted recompute/backfill exists.
