# Validation gates — web parity sweep #1

Plan ID: `PLAN_WEB_REFLEX_PARITY_SWEEP_1_2026-04-29`

Each breakpoint must be **PASS** before the next phase opens. Fail → orchestrator
re-tasks via the appropriate skill (bugfix-investigation-loop, ci-test-triage,
container-runtime-podman-triage) and re-runs the same gate. PR cannot merge if
its phase gate is not green.

---

## BP0 — Plan freeze

- **Pass when:** README + validation gates + AGENT_LAUNCH_PROMPT +
CROSS_AGENT_COORDINATION + runtime_handoff exist under
`plans/archived/feat/web-reflex-parity-sweep-1/`; tasks T00–T17 present.
- **Status:** **PASS** on commit of this plan.

## BP1 — Foundations

- **Pass when:**
  1. `npm run build` green; `npm run lint` green.
  2. New layout shells render: `<PublicShell>` for `/`, `/login`, `/signup`;
    `<ProtectedShell>` for `/app/*` (sidebar ≥900 px; horizontal scroll strip
     <900 px).
  3. Theme tokens live in `:root` + `[data-theme="dark"]`; no inline `#hex`
    literals in component code (CSS only).
  4. Breakpoint constants exposed via `src/lib/breakpoints.ts` and matching
    `--bp-sm/md/lg/xl` CSS vars.
  5. Axios response interceptor handles **401** → single refresh attempt →
    retry; on refresh failure clears tokens and routes to `/login`. Logged-in
     dashboard survives a forced 401 in dev.
  6. Cookie consent banner renders (parity with Reflex `cookie_banner`) and
    stores acceptance in cookie.
  7. Existing `/app/dashboard` (moved from `/dashboard`) still loads snapshot.
- **Verification:** `npm run build && npm run lint`; manual click-through; dev
forced-401 test (e.g. revoke token in DevTools then trigger refetch).

## BP2 — Public surface

- **Pass when:**
  1. `/` renders splash with hero, value props grid, feature showcase tabs (with
    `prefers-reduced-motion` fallback), live preview (static), roadmap, CTA,
     locale picker, cookie banner.
  2. `/login` overlay over splash backdrop; submit hits `POST /api/token/`;
    stores access + refresh; routes to `/app/dashboard`.
  3. `/signup` page hits `POST /finance/user/`, then login flow.
  4. Both forms use **react-hook-form + zod** with field-level errors.
  5. Visual parity at **640 / 900 / 1200 / 1440 px** (no horizontal scroll, no
    overlapping content, hero text remains legible).
- **Verification:** manual browser at 4 widths; Lighthouse a11y ≥ 90 on `/`.

## BP3 — Dashboard parity

- **Pass when:**
  1. `/app/dashboard` renders all KPI tiles defined by Reflex `build_kpis`
    (income, outgoing, total_assets, remaining_expenses, safe_to_spend,
     total_leaks, net, tx_count) — N/A label when source field is null.
  2. Charts: multi-series flow (income / outgoing / leaks) with toggles, daily
    spend bar, category pie (click slice → drillthrough into transactions),
     tag pie.
  3. Tables: source balances, recent transactions (scroll area; date/type/
    description/amount/source/category badges).
  4. Filter row: current month, tx type chips, tag chips, advanced (tag /
    category / source / currency / date range / last month / previous week),
     Apply + Refresh.
  5. Dedup loads via signature key (no duplicate fetch on Apply with same
    filters).
  6. Mobile: ≤900 px collapses to single column without losing data; tables
    scroll horizontally; charts resize.
  7. Empty/loading/error states present via shared `<LoadingState/>`,
    `<EmptyState/>`, `<ErrorState/>`.
- **Verification:** real account snapshot on VPS `https://jsdevtesting…`;
filter combinations; mobile viewport.

## BP4 — Transactions suite

- **Pass when:**
  1. `/app/transactions` renders quick entry form, filter row (basic +
    advanced), table with row actions (edit / delete with confirm).
  2. Editor modal supports **single tx** and **transfer pair**
    (XFER_OUT / XFER_IN) with delta preview string. Tag picker dialog. Bill
     link to unpaid upcoming names.
  3. `/app/transactions/new` opens editor on load.
  4. `/app/transactions/calendar` renders date range, calendar bar chart, day
    grid (heat 0–4 buckets), due events table, day drill table.
  5. `/app/transactions/deep-dive` renders flow daily bar, type pie, top
    categories bar.
  6. Drillthrough from dashboard pies/cards lands on `/app/transactions` with
    filters pre-applied + success callout.
- **Verification:** create / edit / delete a transaction; calendar day click;
drillthrough from dashboard; mobile.

## BP5 — Bills + data hub

- **Pass when:**
  1. `/app/upcoming-expenses` lists bills with quick filters (recurring / paid /
    date) + table; modal CRUD for create/edit/delete.
  2. `/app/upcoming-expenses/deep-dive` renders KPI row, monthly bar, timeline
    table.
  3. `/app/data` shows three cards (sources / categories / tags); each supports
    create / rename / delete via dialogs; per-category totals displayed
     (mirrors Reflex `category_totals`: income +, expense / xfer_out −).
  4. No duplicate fetches (single React Query load per card; no double-load
    pattern from Reflex).
- **Verification:** create + delete across all three; bill marked paid; mobile.

## BP6 — Profile + onboarding

- **Pass when:**
  1. `/app/settings/profile` exposes 3 tabs (Overview / Settings / Security):
    snapshot cards; PATCH preferences (`spend_accounts` comma-separated,
     `base_currency`, `start_week`); password change; danger zone delete with
     confirm dialog.
  2. Onboarding 4-step flow under `/app/onboarding[/sources|/categories|/review]`
    with sequential guards (`profile_preferences_saved` → `source_added` →
     `category_added`); Finish → `/app/dashboard`.
  3. `force_onboarding_next_login` (set in signup) routes new users into
    onboarding instead of dashboard.
- **Verification:** new account end-to-end; preferences round-trip; password
change; onboarding complete.

## BP7 — Polish + hardening (final)

- **Pass when:**
  1. **Lighthouse a11y ≥ 90** on `/`, `/login`, `/app/dashboard`,
    `/app/transactions`, `/app/upcoming-expenses`.
  2. **Lighthouse perf ≥ 80** mobile on `/` and `/app/dashboard`; bundle JS
    gzip ≤ **350 kB** for main route (split if over).
  3. Skeleton loaders on dashboard widgets, transactions table, upcoming list,
    data hub cards.
  4. `<EmptyState/>`, `<ErrorState/>`, `<SuccessState/>` cards used everywhere a
    fetch can return empty / fail / mutate.
  5. **Vitest** smoke test suite present and green: at minimum
    `auth.refresh.test.ts` (interceptor refresh+retry) and
     `breakpoints.snapshot.test.tsx` (shell collapse). `npm test` runs in CI
     image.
  6. ESLint clean; TypeScript `strict` build.
  7. **VPS smoke**: full walk-through against real API on
    `https://jsdevtesting.thehivemanager.com/` documented in this file.
- **Verification:** Lighthouse runs (results pasted here); `npm run build`,
`npm run lint`, `npm test`; VPS click-through.

---

## Final readiness gate

Sweep #1 marked **complete** when:

- All BP1–BP7 are **PASS**.
- Each phase PR is **merged to `main`** in `finance_manager_web` and the
matching submodule-bump PR is **merged in ecosystem parent**.
- VPS rebuild + smoke documented per phase in `runtime_handoff.md`.
- **CHANGELOG.md** updated per phase in `finance_manager_web/`.
- User performs **manual verification** on the VPS and signs off (logged in
this file under "Sweep #1 sign-off").

### Sweep #1 sign-off

*(append: date, user, deviations / sweep #2 backlog items)*