---
plan_id: PLAN_CROSS_PRODUCTION_UX_FIX_2026-06-28
status: completed
priority: P1
created: 2026-06-28
updated: 2026-06-28
completed: 2026-06-28
owner: pproctor

plan_root: plans/S1/S1.B/fix-production-ux-2026-06-28/
intended_branch: cur/s1b/feat/production-ux-batch
target_repos:
  - finance_manager_web
  - finance_manager_api

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks:
  - PLAN_CROSS_GUIDED_TOURS_F007_2026-05-05

parallel_safe_with:
  - PLAN_CROSS_BALANCE_HISTORY_F001_2026-05-05
  - PLAN_CROSS_SAVINGS_GOALS_F005_2026-05-05

conflicts_with: []

manual_gates:
  pre_execution: none
  pre_merge: required
  pre_close: none

deployment:
  required: true
  target_services: [api, web]
  bundle_required: false
  rollback_plan_id: null
  smoke_targets: [dashboard, login, quick-add, upcoming, legal-pages]
  notes: >-
    T02 (bill linking) touches API logic — needs API deploy to inactive color.
    T01, T03, T04, T05 are web-only.

standalone: false
standalone_notes: "T02 has an API component. All other tasks are web-only and can ship independently."

legal_impact:
  tos: true
  privacy_policy: true
  cookie_policy: false
  notes: "T04 edits legal page content — remove internal codes (F-007 etc.) from ToS and Privacy Policy copy."
---

## 0) Strategic Inheritance

- Wedge respected: yes — all fixes are polish/correctness on existing features
- Locked decisions touched: none
- Cost cap impact: none
- Validation gates affected: none — these are correctness fixes, not new gates

## 1) Objective

Production UX bug fix batch identified during 2026-06-28 production pass. Five issues:

1. No path back to the landing page from the dashboard without logging out
2. Quick add expense → bill linking does not mark the bill paid; overdue recurring bills have no recovery path
3. Some form labels render internal variable names instead of human-readable text
4. Legal pages (ToS, Privacy Policy) reference internal feature codes (e.g. "F-007") meaningless to users
5. Onboarding wizard is disabled; new users bypass it entirely; tours are ~80% complete

**Success state:** All five issues resolved. New user registration triggers a useful first-run experience. Legal pages are user-facing clean. All form labels are human-readable.

## 2) Read First

1. `finance_manager_web/src/` — routing (`App.tsx` or equivalent), nav shell, auth state
2. `finance_manager_api/finance/models.py` — `UpcomingExpense` model (bill linking logic)
3. `finance_manager_web/src/pages/legal/` — ToS and Privacy Policy content
4. `finance_manager_web/src/i18n/` — translation files (form label i18n keys)
5. `DECISION_LOG.md` — check before any auth flow or routing change
6. `governance/definition_of_done.md` — i18n is part of done

## 3) Tasks

| Task | Slug | Scope | Repos | Notes |
|---|---|---|---|---|
| T01 | nav-return-to-landing | Landing page icon nav + logged-in login state | web | Pure routing fix |
| T02 | bill-link-mark-paid | Bill linking in quick add + overdue recovery | api + web | API logic + UI |
| T03 | form-label-fixes | Form labels showing variable names | web | i18n key audit |
| T04 | legal-content-cleanup | Remove internal codes from legal pages | web | Content only |
| T05 | onboarding-wizard-reactivate | Re-enable wizard + tour gap assessment | web | Design + code |

## 4) Task Details

### T01 — Navigation: return to landing page

**Problem:** No path from the app back to the splash/landing page without logging out. A user who wants to share the landing URL with someone, or return to it themselves, is stuck.

**Fix:**
- Top-left brand icon/logo in the nav shell → clicking it while authenticated navigates to `/` (landing page), not `/dashboard`
- On the `/login` route: if the user is already authenticated, show a "Back to Dashboard" link/button prominently rather than presenting the login form again. Do NOT log them out.

**Scope lock:**
- Modify: nav shell component (top bar brand icon link target)
- Modify: Login page component (auth guard / redirect logic)
- Do NOT change: any existing route guards that redirect unauthenticated users to `/login`

**Slices:**
- T01.SL1: Brand icon → `navigate('/')` in nav shell. Confirm landing page renders correctly when navigated to while authenticated.
- T01.SL2: Login page auth check — if `isAuthenticated`, render "Return to Dashboard" CTA instead of login form. i18n key: `login.return_to_dashboard`.

**Verification:**
- [V3] Logged-in user clicks brand icon → lands on splash page, session intact
- [V3] Logged-in user navigates to `/login` → sees "Return to Dashboard" link, not login form
- [V3] Logged-out user navigates to `/login` → sees login form (regression check)

---

### T02 — Bill linking: mark paid + overdue recovery

**Two bugs:**

**Bug A — Quick add doesn't mark bill paid:**
When a user selects an upcoming bill from the quick add expense form, submitting the expense should set `UpcomingExpense.paid_flag = True` on the linked bill. Currently it doesn't.

Likely cause: the quick add API call doesn't send the bill ID, or the API endpoint doesn't handle it. Investigate both sides.

- If the bill ID is sent but API ignores it: fix the transaction POST handler to accept an optional `upcoming_expense_id` field and mark paid.
- If the form doesn't send it: fix the frontend to include the bill ID in the POST body.
- Write a test: POST to transaction endpoint with `upcoming_expense_id` → verify `UpcomingExpense.paid_flag = True`.

**Bug B — Overdue recurring bills have no recovery path:**
A recurring bill whose `due_date` is >1 month in the past shows as overdue with no way to advance it. User cannot mark historical occurrences as paid and cannot get the bill to show the next period's due date.

Fix: Add a "Mark as paid + advance to next period" action on the overdue bill card. On confirm:
- Mark current bill `paid_flag = True`
- Create or update the next occurrence with an advanced `due_date` (next month / next pay cycle)
- If there are multiple missed periods: show a count and allow bulk "catch up" (mark all past occurrences paid, advance to current period). Limit bulk catch-up to 24 periods to avoid runaway loops.

**HitM clarifying question before T02.SL3:** How should the recurrence period be calculated for catch-up? Options: (a) advance by calendar month, (b) advance by the bill's original interval (days between `start_date` and `due_date`), (c) always advance to next 1st/15th of month. Preference?

**Slices:**
- T02.SL1: Audit quick add flow end-to-end (form → API → DB) to identify where bill ID is dropped
- T02.SL2: API fix — `UpcomingExpense.paid_flag` set on linked transaction POST
- T02.SL3: Web fix — overdue bill card gets "Mark paid + advance" action (requires HitM input on recurrence calc)
- T02.SL4: Test — API test for bill-link-on-transaction-create; V2 smoke on inactive color

---

### T03 — Form label fixes

**Problem:** Some form fields across the site display internal variable/key names instead of human-readable labels. Likely i18n keys that are missing translations and falling through to the key string.

**Fix:**
1. Audit all form components for labels that look like `variable_name`, `snake_case_key`, or raw i18n key paths
2. Add missing i18n entries in `en-US` and `tl-PH` for each
3. Verify every form renders human-readable labels in both locales

**Slices:**
- T03.SL1: Audit — grep for label props, placeholder props, and i18n `t('...')` calls with snake_case keys that have no corresponding en-US entry. Output a list.
- T03.SL2: Fix — add missing i18n entries; confirm renders in dev
- T03.SL3: Regression pass — open each major form in browser and verify labels

**Verification:**
- [V1] No i18n keys missing from `en-US` translation file for any key referenced in form components
- [V3] All forms reviewed in browser — no raw key strings visible

---

### T04 — Legal page content cleanup

**Problem:** ToS and Privacy Policy pages contain internal feature codes meaningless to users. Specifically "F-007" is mentioned (the guided walkthroughs feature). There may be others.

**Fix:**
1. Grep the legal page content (markdown files or inline copy) for `F-0`, `PLAN_`, and any other internal nomenclature
2. Replace with plain-language descriptions:
   - "F-007" → "our guided walkthrough feature" or "in-app guided tours"
   - Any other codes found → equivalent user-readable description
3. No structural changes — copy edits only

**Slices:**
- T04.SL1: Grep and replace all internal codes in legal page content. One commit, all legal pages.

**Verification:**
- [V1] `grep -r "F-0[0-9]\|PLAN_" src/pages/legal/` returns no matches
- [V3] Legal pages render correctly in browser with clean copy

---

### T05 — Onboarding wizard re-activation

**Context:** The onboarding wizard exists but is currently bypassed on new user creation. Tours are ~80% complete — they don't yet walk through each form (quick add, transaction edit, upcoming expenses). Without the wizard, new users land cold in the app with no structured setup.

**Decision required from HitM before execution:**

Option A — **Re-enable wizard as-is** with a prominent "Skip" option. Better than nothing; structured setup path exists even if imperfect. Tours handle feature discovery after setup.

Option B — **Complete tours to 100% first**, then re-enable wizard. Cleaner experience but delays the fix.

Option C — **Hybrid:** Re-enable wizard (short — just account currency + first payment source), and complete the missing form tours separately. Wizard handles setup; tours handle discovery.

Recommendation: **Option C**. The wizard's value is guiding the user through the critical first-run setup (currency, first source). Tours' value is feature discovery during normal use. They serve different moments. Keep them separate in scope.

**Pending HitM input on Option A/B/C.**

**Slices (assuming Option C):**
- T05.SL1: Re-enable wizard trigger on new user first login. Confirm wizard renders and "Skip" exits gracefully.
- T05.SL2: Scope wizard to: set base currency + add first payment source. Remove or skip any wizard steps beyond those two.
- T05.SL3: Identify missing tour form steps (quick add, transaction edit, upcoming expenses). Create task list for follow-up plan — do NOT implement tour changes in this plan's scope.

**Verification:**
- [V3] New ux_demo user (after `--reset`) → wizard appears on first login
- [V3] "Skip" on wizard → lands in dashboard, no errors
- [V3] Completing wizard → currency and source saved → lands in dashboard

## 5) Completion Criteria

- [x] T01: Brand icon navigates to landing page; authenticated users redirect into the app (no login interstitial); public header shows "Return to Dashboard" when authenticated
- [x] T02A: Quick add expense with linked bill marks bill paid in DB
- [x] T02B: Overdue recurring bill card has "Mark paid + advance" action; bulk catch-up works up to 24 periods
- [x] T03: No form labels show raw i18n keys or variable names in either locale
- [x] T04: No internal feature codes in legal page copy
- [x] T05: Onboarding triggers only on account creation (gated on `fm_onboarding_active_v1`); wizard scoped to currency + first source; skip works. Existing users are not forced into the wizard.

## 7) Closeout (2026-06-28)

- **Merged:** api [#51](https://github.com/AzazelAzure/finance-manager-api/pull/51) (`43b88fb`), web [#80](https://github.com/AzazelAzure/finance-manager-web/pull/80) (`e9e326c`).
- **Deploy:** VPS clones on `main`; promoted via `fm_server_beta.sh switch --to blue` (green → **blue**) after pre-cutover smoke.
- **Production smoke:** `thehivemanager.com` 200; `api.thehivemanager.com/api/health/` 200; catch-up route live (401 unauth, was 404 pre-switch).
- **HitM verification:** passed on `jsdevtesting` (login direct→dashboard, no onboarding for existing user, nav pill, T02–T05 surfaces).
- **Follow-ups:** bill-recurrence engine revamp — `strategy/anomalies/2026-06-28_PRODUCTION-UX-FIX_T02_bill-interval-cycle-revamp.md`; onboarding tour-form gaps — `tasks/T05_tour-gap-list.md`.
- **Rollback:** `fm_server_beta.sh rollback` (returns active color to green) if a regression surfaces.

## 6) Out of Scope

- Full tour completion (80% → 100%) — tracked as follow-up in T05.SL3
- Wizard design overhaul — re-enable and scope-trim only; redesign is a separate plan
- Billing recurrence engine rewrite — T02 fix is targeted: mark paid + advance, not a full recurrence system
