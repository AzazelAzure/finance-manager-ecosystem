# L1 Translation Decision Memo (PH + US, Tagalog Readability)

## Decision

Chosen path: **B - Translator-onboarding lane with immediate critical-path translation scaffold**.

This means:
- We will not attempt a full app-wide translation sweep in one pass.
- We will implement a minimal, deterministic translation framework on critical frontend surfaces first.
- We will onboard translators with a controlled glossary/review workflow to complete Tagalog copy safely.

## Why this path

- Preserves `[Now]` beta stability by avoiding uncontrolled large UI copy churn.
- Creates reusable localization infrastructure needed by Android gate dependencies.
- Delivers near-term Tagalog readability on critical workflows while keeping logic/contracts in English.

## Scope Rules

- Localize **user-facing frontend copy** only.
- Keep **business logic, API contracts, schema keys, and internal identifiers** in English.
- Restrict initial execution to critical paths:
  - auth
  - profile
  - dashboard
  - transactions
  - upcoming expenses (already in critical viewport path)

## Interim Language Selection Plan (Beta)

Implement a lightweight selector for `en-US` and `tl-PH`:
- Add app-level locale state with default fallback to `en-US`.
- Use static translation catalogs (`en-US`, `tl-PH`) for critical-path keys.
- Route all critical-path visible strings through translation lookup.
- If a key is missing in `tl-PH`, fallback to `en-US` and log missing key.

If selector implementation cannot fit current slice safely:
- run a timeboxed research spike and lock one option before Gate A pass.

## Translator Onboarding Workflow

- Create a translation glossary for finance-critical terms (USD/PHP, transfer, balance, pending, recurring, due date).
- Define review protocol:
  1. engineer adds/updates key
  2. translator proposes Tagalog copy
  3. reviewer validates clarity and domain meaning
  4. merge after screenshot-based check
- Require UI context notes for ambiguous strings.

## Execution Tickets (L1 Sub-slices)

### L1-T1: i18n scaffold on critical surfaces
- Add translation lookup utility and locale state.
- Wire auth/profile/dashboard/transactions/upcoming-expenses copy to keys.
- Acceptance: no hardcoded user-facing strings remain on critical-path surfaces.
- Status: **complete (v0)**.
- Implemented evidence (current):
  - `finance_manager_reflex/finance_manager_reflex/core/i18n.py`
  - `finance_manager_reflex/finance_manager_reflex/features/profile/state.py` (locale state)
  - `finance_manager_reflex/finance_manager_reflex/app/shell.py` (language selector)
  - `finance_manager_reflex/finance_manager_reflex/features/auth/view.py`
  - `finance_manager_reflex/finance_manager_reflex/features/transactions/view_components.py`
  - `finance_manager_reflex/finance_manager_reflex/features/upcoming_expenses/view_components.py`
  - `finance_manager_reflex/finance_manager_reflex/features/profile/view.py`
- Acceptance outcome:
  - critical-path i18n scaffold and key routing are in place for auth/profile/dashboard/transactions/upcoming-expenses.
  - remaining non-critical copy is deferred and tracked.

### L1-T2: language selector + fallback behavior
- Add simple UI selector (`en-US`, `tl-PH`) in accessible location.
- Add deterministic fallback for missing keys.
- Acceptance: user can switch language and see critical-path copy update without breaking flows.
- Status: **complete (v0)**.

### L1-T3: Tagalog v0 pack + glossary review
- Fill `tl-PH` for critical keys.
- Add glossary and reviewer signoff checklist.
- Acceptance: critical paths are readable in Tagalog and pass walkthrough checks.
- Status: **complete (v0)** with glossary artifact:
  - `plans/archived/PH_ANDROID_ACCELERATION_2026-04-27_COMPLETED/06_L1_tagalog_glossary_v0.md`

### L1-T4: evidence pack for Gate A
- Capture before/after screenshots for each critical path in both locales.
- Link checklist results and unresolved terms.
- Acceptance: Gate A evidence checklist is complete and reviewable.
- Status: **complete** with artifact:
  - `plans/archived/PH_ANDROID_ACCELERATION_2026-04-27_COMPLETED/07_L1_gateA_evidence_pack.md`

## Gate A Impact

- L1-T1..T4 evidence is now attached for v0.
- Gate A can advance to `pass` with accepted deferrals recorded in the evidence pack.

## Research Note (if needed)

Potential tooling options for later evaluation:
- in-repo static catalog + manual review (default now)
- managed localization SaaS integration (future)
- translator helper tool for key extraction and review queue (future candidate)
