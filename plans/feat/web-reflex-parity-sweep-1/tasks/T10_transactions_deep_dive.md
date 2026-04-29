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

- [ ] `src/pages/transactions/DeepDivePage.tsx` with three `<ChartFrame/>`
      cards.
- [ ] Range picker at the top (defaults to current month).
- [ ] Charts: `viz_flow_daily` bar, type pie, top categories bar — all via
      `<ChartFrame/>`.
- [ ] Link back to `/app/transactions` ("View transactions in this range") that
      passes the range as URL query.

## Definition of done

- [ ] Three charts render, range picker works, link back applies the range.

## Verification

Manual on VPS with real data.
