# T07 — Dashboard widgets (KPI tiles, recent tx, source balances, profile overview)

**Phase:** P3 — Dashboard parity  
**Skill:** `feature-implementation-loop`  
**Branch:** `feat/web-dashboard-parity`

## Reference

Reflex `mappers.py::build_kpis`, `view_components.py::recent_transactions`,
`spend_account_balances`, `profile_overview_widget`.

## Objective

Ship the non-chart dashboard widgets so the page reads as the Reflex dashboard
does.

## Implementation checklist

### KPI tiles (`src/components/dashboard/KPIRow.tsx`)
- [ ] 8 tiles in priority order:
  1. Income (this period)
  2. Outgoing (this period)
  3. Total assets
  4. Remaining expenses
  5. Safe to spend (N/A label when source is null)
  6. Total leaks
  7. Net (strict backend `net*` field; N/A if absent)
  8. Tx count (explicit field or `transactions_for_month.length`)
- [ ] Each tile: label, large value, small delta vs previous period (when we
  can compute it client-side from snapshot — log gap for sweep #2 if not).
- [ ] Use `<KPI/>` primitive from T01.
- [ ] Color-code deltas with **icon + sign + color** (a11y: not color alone).

### Recent transactions (`src/components/dashboard/RecentTransactions.tsx`)
- [ ] Scroll area max-height ≈ 600 px desktop / 400 px mobile.
- [ ] Columns: date, type badge, description, amount (right-aligned), source
  badge, category badge.
- [ ] Below `--bp-md`: collapse to stacked card per row.
- [ ] Empty state: "No transactions in this period" with a button "Add
  transaction" → `/app/transactions/new`.

### Source balances (`src/components/dashboard/SourceBalances.tsx`)
- [ ] Table rows: source name, acc_type badge, amount + currency.
- [ ] Negative balance amounts in `--danger` color + minus sign + warning icon
  (a11y: not color alone).

### Profile overview (`src/components/dashboard/ProfileOverview.tsx`)
- [ ] Compact card with: base currency, timezone, start of week, spend
  accounts (badges).
- [ ] Edit button → `/app/settings/profile`.

### Quick-action button row (`src/components/dashboard/QuickActions.tsx`)
- [ ] Buttons: **+ Income**, **+ Expense**, **+ Transfer**, **+ Bill**.
- [ ] Each opens the transaction editor modal pre-set to the right `tx_type`
  (modal lives in T08; T07 wires the button to `navigate('/app/transactions/new?type=...')`
  as a placeholder until T08 ships, then is replaced).

## Definition of done

- [ ] All 8 KPI tiles render with real numbers and N/A handling.
- [ ] Recent transactions table works on mobile (stacked cards).
- [ ] Negative balances visually flagged with icon + sign.
- [ ] Profile overview card matches the live profile.

## Verification

Manual at 2 widths; check N/A handling by temporarily nulling
`snapshot.safe_to_spend` in DevTools.
