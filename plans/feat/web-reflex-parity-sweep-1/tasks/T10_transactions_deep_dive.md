# T10 — Transactions deep-dive (`/app/transactions/deep-dive`)

**Phase:** P4 — Transactions suite  
**Skill:** `feature-implementation-loop`  
**Branch:** `feat/web-transactions-suite`

## Reference

Reflex `transactions_deep_dive_page` + `transactions_deep_dive_content`.
API: `GET /finance/transactions/visualization/` with `start_date`, `end_date`.

## Objective

A single visualization page: flow daily bar, type-mix pie, top categories bar.

## Implementation checklist

- [x] `src/pages/transactions/DeepDivePage.tsx` with three `<ChartFrame/>`
      cards.
- [x] Range picker at the top (defaults to current month).
- [x] Charts: `viz_flow_daily` bar, type pie, top categories bar — all via
      `<ChartFrame/>`.
- [x] Link back to `/app/transactions` ("View transactions in this range") that
      passes the range as URL query.

### Progress note (2026-04-29)
- Initial deep-dive page scaffold is implemented and wired to
  `/finance/transactions/visualization/`.
- Remaining polish: validate chart data mapping against edge payloads and tune
  labels/colors/tooltips for parity-level readability.

## Definition of done

- [ ] Three charts render, range picker works, link back applies the range.

## Verification

Manual on VPS with real data.
