# T13 — Data hub (`/app/data` — sources / categories / tags)

**Phase:** P5 — Bills + data hub  
**Skill:** `feature-implementation-loop`  
**Branch:** `feat/web-bills-and-data-hub`

## Reference

Reflex `features/data_hub/` (`view.py`, `view_components.py`, `state.py`,
`api.py`, `state_mutations.py`). API: sources / categories / tags CRUD.

## Objective

Card-stack page with full CRUD for the three taxonomies, and per-category
totals (mirrors Reflex `category_totals`: income +, expense / xfer_out −,
formatted with two decimals + thousands).

## Implementation checklist

### Page (`src/pages/data/DataHubPage.tsx`)
- [x] Three `<Card/>`s stacked (single column on `<--bp-lg`, 3-up on
      `>=--bp-lg`):
  - **Sources** (`SourcesCard.tsx`)
  - **Categories** (`CategoriesCard.tsx`)
  - **Tags** (`TagsCard.tsx`)

### Sources card
- [x] List rows with acc_type, source name, balance.
- [x] **Add** dialog: name, acc_type, starting balance, currency.
- [x] **Edit** dialog (PATCH `/finance/sources/<source>/`) *(rename flow via PATCH).*
- [x] **Delete** with two-step confirm; **disabled for `unknown` source** (API
      returns 403; pre-empt in UI with a tooltip).

### Categories card
- [x] List rows with name + computed total (income + / expense or xfer_out −);
      formatted `"{value:.2f}"` with comma thousands.
- [x] **Add / Edit / Delete** dialogs (PATCH `/finance/categories/<old>/`).

### Tags card
- [x] List rows with name + frequency.
- [x] **Add / Rename / Delete** dialogs (PATCH/DELETE accept JSON map per
      API).

### Loading
- [x] **Single** React Query load per card, no double-load like Reflex.

## Definition of done

- [ ] CRUD across all three taxonomies works on VPS *(pending live verification)*.
- [ ] `category_totals` formula matches Reflex (verify with one income, one
      expense, one transfer in the test account).
- [ ] No duplicate fetches in DevTools Network on page load.

## Verification

Manual on VPS; DevTools Network sanity check.

## Progress notes

- 2026-04-29: Implemented `DataHubPage` and routed `/app/data` to live UI.
- Added lookup API client mutations for source/category/tag create-rename-delete.
- Category totals and tag frequencies are now computed from transaction records.
