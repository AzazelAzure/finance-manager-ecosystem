# T14 — Settings / profile (`/app/settings/profile`)

**Phase:** P6 — Profile + onboarding  
**Skill:** `feature-implementation-loop`  
**Branch:** `feat/web-profile-onboarding`

## Reference

Reflex `features/profile/view.py` (`settings_profile_page`, `_profile_content`,
`password_change_form`, `danger_zone_section`, `account_deletion_modal`),
`profile/state.py`. API: `GET/PATCH /finance/appprofile/`,
`GET /finance/appprofile/snapshot/`, `PATCH/DELETE /finance/user/`.

## Objective

Three tabs (Overview / Settings / Security): snapshot rollup, preferences
edit, password change, danger zone delete.

## Implementation checklist

### Page (`src/pages/settings/SettingsProfilePage.tsx`)
- [x] `<Tabs/>` primitive with 3 tabs.

### Overview tab
- [x] Snapshot KPI cards (total assets, savings, checking, investment, cash,
      ewallet, monthly spending, remaining expenses, leaks).
- [x] Reuses `<KPI/>` primitive.

### Settings tab
- [x] Edit form (RHF + zod):
  - `spend_accounts` — comma-separated input → array on submit.
  - `base_currency` — currency select.
  - `start_week` — Sunday/Monday select. **Note**: API GET returns
        `start_of_week` but PATCH expects `start_week` (call out in
        `CROSS_AGENT_COORDINATION.md` if this catches anyone).
  - `timezone` — IANA select (use Intl.supportedValuesOf when available).
- [x] On submit: PATCH `/finance/appprofile/`; toast success.

### Security tab
- [x] Password change form: `old_password`, `new_password`,
      `new_password_confirm` (zod: ≥ 8 chars, match).
- [x] PATCH `/finance/user/` with `{old_password, new_password}`.
- [x] **Danger zone**: delete account button → confirm dialog requiring the
      user to type their email + current password, then DELETE
      `/finance/user/` with `password`. On success: clear session, navigate to
      `/`.

### Theme switcher
- [x] Add to Settings tab: light / dark / system. Persists in cookie
      `fm_theme`. Drives `data-theme` on `<html>`.

## Definition of done

- [ ] All three tabs work end-to-end on VPS.
- [ ] Preferences round-trip (refresh page, values match).
- [ ] Theme switcher applies live to all pages.

## Verification

Manual end-to-end; create a throwaway account to test delete flow.

## Progress notes

- 2026-04-29: Replaced `/app/settings/profile` placeholder with `SettingsProfilePage`.
- Implemented Overview/Settings/Security tabs with snapshot KPIs, profile patch form, password change, and account delete confirmation.
- Added theme preference control (`light` / `dark` / `system`) persisted via `fm_theme` and applied to `html[data-theme]`.
