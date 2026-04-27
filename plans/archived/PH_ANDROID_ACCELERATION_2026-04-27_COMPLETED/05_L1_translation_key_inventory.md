# L1 Translation Key Inventory (Cycle 3)

## Purpose

Track the critical-path key coverage delivered in L1-T1 and identify remaining hardcoded copy for translator onboarding.

## Implemented i18n Surface

- Core utility and catalogs:
  - `finance_manager_reflex/finance_manager_reflex/core/i18n.py`
- Locale state:
  - `finance_manager_reflex/finance_manager_reflex/features/profile/state.py`
- Selector placement:
  - `finance_manager_reflex/finance_manager_reflex/app/shell.py`

## Implemented Key Groups (Current)

- Common:
  - `common.*` (apply/cancel/filters/sign in/sign out/new/date labels/language labels)
- Auth:
  - `auth.welcome_back`
  - `auth.create_account`
  - `auth.back_to_splash`
  - `auth.already_have_account`
  - `auth.create_my_account`
  - `auth.continue_to_dashboard`
  - `auth.loading_data`
  - `auth.signup_helper`
- Profile:
  - `profile.title`, `profile.subtitle`
  - `profile.tab.overview`, `profile.tab.settings`, `profile.tab.security`
  - `profile.refresh_all`
  - `profile.financial_snapshot`
  - `profile.no_snapshot`, `profile.no_snapshot_help`
  - `profile.account_preferences`
  - `profile.no_profile`, `profile.no_profile_help`
- Dashboard:
  - `dashboard.title`, `dashboard.subtitle`
  - `dashboard.customize`
  - `dashboard.refresh`
  - `dashboard.add_expense`
  - `dashboard.add_income`
  - `dashboard.add_transfer`
  - `dashboard.refreshing_snapshot`
- Transactions:
  - `transactions.title`, `transactions.subtitle`
  - `transactions.filters_help`
  - `transactions.all_types`
  - `transactions.all_sources`
  - `transactions.all_categories`
  - `transactions.all_currencies`
- Upcoming expenses:
  - `upcoming.title`, `upcoming.subtitle`
  - `upcoming.filters_help`
  - `upcoming.current_month_remaining`
  - `upcoming.next_month`
  - `upcoming.current_month_paid`
  - `upcoming.new_expense`
  - `upcoming.no_expenses`, `upcoming.no_expenses_help`
  - `upcoming.create_first_expense`

## Remaining Hardcoded Copy Buckets (Critical Surfaces)

- `features/profile/view.py`
  - security/danger-zone labels and warnings
  - profile snapshot metric labels
- `features/agentdash/view_components.py`
  - chart/widget titles, helper text, tutorial copy, dialog labels
- `features/transactions/view_components.py`
  - form labels, modal titles, table headers, tutorial copy
- `features/upcoming_expenses/view_components.py`
  - modal labels and status badges
- `features/auth/view.py`
  - minor leftover labels where key migration is incomplete

## Translator Onboarding Payload (Next)

- Export key list from `core/i18n.py` for review.
- Provide context screenshots for each critical path in `en-US`.
- Review and refine `tl-PH` strings with glossary.

## Cycle 4 Delta

Additional key coverage executed:
- Profile overview labels (`profile.*` snapshot and preference labels)
- Transactions route links (`transactions.calendar`, `transactions.deep_dive`)
- Upcoming filter labels (`upcoming.recurring`, `upcoming.payment_status`, `upcoming.any`, `upcoming.non_recurring`, `upcoming.paid`, `upcoming.unpaid`, `upcoming.remaining_only`)

Validation:
- `python -m py_compile` pass on touched Reflex files.

## Cycle 5 Delta

Additional key coverage executed:
- AgentDash widget and chart labels:
  - KPI summary, quick actions, chart preferences, quick filter action labels
  - flow/spend/category empty-state labels
  - monthly activity widget title
  - customize dialog title/description/button

Files:
- `finance_manager_reflex/finance_manager_reflex/core/i18n.py`
- `finance_manager_reflex/finance_manager_reflex/features/agentdash/view_components.py`

Validation:
- `python -m py_compile` pass on AgentDash and i18n files.
