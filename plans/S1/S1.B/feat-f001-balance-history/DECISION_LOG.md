# F-001 Balance History — Decision Log

Append-only. Check before any design choice.

---

## 2026-06-28 — Serialize API ownership behind F004 (HitM)

**Context:** Two Cursor agents were operating in the same `finance_manager_api/` working tree simultaneously (F001 balance history + F004 STS pay cycles / bill realism). A single git working tree allows only one checked-out branch; the F004 agent's branch switches wiped F001's uncommitted work, and both features independently created a `0012_*` migration (collision).

**Decision:** F001 API work is **paused** and **serialized** behind F004. Only one agent may hold the API checkout at a time. F001 resumes after API ownership transfers per `design_docs/30_Releases/Git_Branch_Signup_Sheet.md`.

**Rejected alternatives:** git-worktree isolation (deferred — adds shared-DB/migration coordination overhead); splitting F001 to web-only (rejected — T01–T03 are API and T04 depends on T03).

## 2026-06-28 — Migration numbering: next free after F004 (HitM)

**Decision:** F001's migration uses the **next free number after F004** (F004 committed `0012_appprofile_pay_cycle_fields`, so F001 is `0013_*` or later — confirm highest migration at implementation time). Accept a merge migration at integration to `main` if two leaf nodes appear.

## 2026-06-28 — Retain empty F001 branches (HitM)

**Decision:** Keep the empty placeholder branches `cur/s1b/feat/f001-balance-history`, `cur/s1b/feat/f001-balance-history-t01-balance-snapshot-model` (local), and pushed `origin/cur/s1b/feat/f001-balance-history` (all == `main`, zero commits). No F001 API code is committed.

## 2026-06-28 — Schema intent (carried from plan authoring; not yet implemented)

- `BalanceSnapshot`: one row per `(uid, source, snapshot_date)`; fields `closing_balance`, `currency`, `created_at`. Unique constraint per user/source/day. Store **native currency** at write; convert to base currency at read (T03) via existing `Calculator._calc_totals`.
- Day-end granularity only (no per-transaction rows).
- Separate read endpoint (`GET /finance/balance-history/`) rather than embedding in the existing snapshot payload, to keep the dashboard snapshot contract stable.
