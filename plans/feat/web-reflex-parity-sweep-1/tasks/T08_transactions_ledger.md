# T08 — Transactions ledger (`/app/transactions` and `/app/transactions/new`)

**Phase:** P4 — Transactions suite  
**Skill:** `feature-implementation-loop`  
**Branch:** `feat/web-transactions-suite`

## Reference

Reflex `features/transactions/`: `view.py`, `view_components.py`,
`state_filters.py`, `state_mutations.py`, `models.py`, `form_helpers.py`,
`filter_contract.py`.

## Objective

Ship the transactions page parity: quick entry, filter row (basic + advanced),
results table with row actions, **editor modal** (single + transfer pair),
**tag picker dialog**, **two-step delete confirm**, **drillthrough** consumer
on page load.

## Implementation checklist

### Page (`src/pages/transactions/TransactionsPage.tsx`)
- [x] Layout: filter row, quick entry, table.
- [x] Route `/app/transactions` and alias `/app/transactions/new` (same page,
  opens editor modal on load with `mode="new"`).

### Filter row
- [x] Mirrors Reflex `filter_contract.TransactionFilters`: tx_type, tag_name,
      category, source, currency_code, date / start_date / end_date /
      current_month / last_month / previous_week.
- [x] URL query string is the source of truth.

### Quick entry (`QuickEntryForm.tsx`)
- [x] One-line form: date, amount + currency, source, tx_type, category,
      description, tag chips, optional bill link → submit `POST
      /finance/transactions/`.
- [x] On success: invalidate the transactions query and the dashboard
      snapshot query.

### Editor modal (`TransactionEditorModal.tsx`)
- [x] Two modes: **single** (income/expense/leak) and **transfer** (XFER_OUT
      paired with XFER_IN). Transfer mode shows source A → source B with a
      delta preview string ("$120.00 will move from Cash to Wallet").
- [x] Tag picker dialog (`TagPickerDialog.tsx`) accessible from the modal —
      reuses `GET /finance/tags/` cache.
- [x] Custom category path: typing a category not in the list opens an
      inline confirm to create it (delegates to `POST /finance/categories/`).
- [x] Bill link: select from unpaid `GET
      /finance/upcoming_expenses/?paid_flag=false`.
- [x] Edit mode pre-fills from `GET /finance/transactions/<id>/` (note: API
      returns `{ transaction, amount }` — handle that shape).

### Table (`TransactionsTable.tsx`)
- [x] Columns: date, type, description, amount (right-aligned), source,
      category, tags, actions (edit/delete).
- [x] Below `--bp-md`: collapse to stacked card per row.
- [x] Two-step delete: first click sets the row to "Confirm delete?" state for
      5 s; second click within that window deletes via `DELETE
      /finance/transactions/<id>/`.
- [x] Empty state with CTA "Add your first transaction".

### Drillthrough consumer
- [x] On page load, read URL query params; if `?fromDashboardCategory=…` or
      similar, show a `<SuccessState/>` callout "Filtered by category XYZ —
      [Clear]".
- [x] Cleared callout removes the filter and refetches.

### Progress note (2026-04-29)
- Ledger now includes create/edit/delete flow, transfer pair create mode, tag
  picker, category create-confirm, unpaid-bill linking, and drillthrough clear.
- Remaining work is primarily parity polish + full VPS manual verification from
  the Definition of done section.

## Definition of done

- [ ] Create / edit / delete a transaction (single + transfer) end-to-end.
- [ ] Tag picker creates new tags or selects existing.
- [ ] Drillthrough from a dashboard pie slice lands here with filter applied
      + callout shown.
- [ ] Mobile flows: stacked cards, modal full-height with sticky footer.

## Verification

Manual end-to-end on VPS; DevTools mobile viewport.
