---
plan_id: PLAN_WEB_REFLEX_PARITY_SWEEP_1_2026-04-29
execution_model: delegated_agents_sequential_with_pr_gates
orchestration_branch: feat/web-reflex-parity-sweep-1
sibling_plans:
  - plans/cursor/finance-manager-web-beta-rollout-53be   # base rollout (auth, Docker, proxy, jsdev*)
  - plans/cursor/vps-reflex-bluegreen-recovery-53be      # VPS blue/green
deployment:
  required: true
  target_services:
    - web-blue
    - web-green
    - proxy
  bundle_required: false
  rollback_plan_id: null
  smoke_targets:
    - "GET https://jsdevtesting.thehivemanager.com/  (landing)"
    - "POST /api/token/  (login)"
    - "GET /finance/appprofile/snapshot/  (dashboard)"
    - "GET /finance/transactions/  (transactions list)"
    - "GET /finance/transactions/calendar/  (calendar)"
    - "GET /finance/upcoming_expenses/  (bills)"
    - "GET /finance/sources/, /finance/categories/, /finance/tags/  (data hub)"
  notes: >-
    Smoke set grows per phase. Each phase ships its own PR(s); user merges and
    pulls on VPS before next phase enters BP gate.
---

# `finance_manager_web` — Reflex parity sweep #1

**Goal:** bring the JS web app to **functional + visual parity** with the Reflex
app (`finance_manager_reflex/`) for the **public surface**, **dashboard**,
**transactions suite**, **upcoming expenses**, **data hub**, **profile/settings**,
and **onboarding**, with **first-class responsiveness** (mobile + tablet +
desktop) and **a11y** baselines.

This is **sweep #1**. After PRs land and the user manually verifies on the VPS,
**sweep #2** will refine UX details, add missing widgets surfaced in review,
harden tests, and any net-new features uncovered in walk-through.

## Inputs (collected during planning)

- **Reflex inventory** (routes, widgets, breakpoints, UX patterns, known bugs):
  see §10 in this README.
- **Web inventory** (only `/login` + `/dashboard` exist today, ~no shared
  components, no theme tokens, no refresh token handling): see §11.
- **API contract** (full endpoint catalog incl. snapshot serializer): see §12.

## Phase compass

| Phase | Tasks | Branch (suggested) | PR target | BP gate |
|-------|-------|--------------------|-----------|---------|
| **P0 — Plan freeze** | T00 plan ratify | `chore/plan-web-parity-sweep-1` | n/a (docs) | BP0 |
| **P1 — Foundations** | T01 layout shell + theme tokens + breakpoints + router; T02 auth refresh + 401 handling + cookie consent | `feat/web-foundations` | `main` (web) | **BP1** |
| **P2 — Public surface** | T03 landing/splash; T04 signup | `feat/web-public-surface` | `main` (web) | **BP2** |
| **P3 — Dashboard parity** | T05 dashboard layout/filters; T06 charts (flow/spend/category/tag pies); T07 widgets (recent tx, source balances, profile overview, KPI tiles) | `feat/web-dashboard-parity` | `main` (web) | **BP3** |
| **P4 — Transactions suite** | T08 ledger (table + quick entry + editor modal + tag picker + drillthrough); T09 calendar; T10 deep-dive | `feat/web-transactions-suite` | `main` (web) | **BP4** |
| **P5 — Bills + data hub** | T11 upcoming expenses (list + modal + filters); T12 upcoming deep-dive; T13 data hub (sources/categories/tags CRUD) | `feat/web-bills-and-data-hub` | `main` (web) | **BP5** |
| **P6 — Profile + onboarding** | T14 settings (overview/preferences/security); T15 onboarding 4-step flow | `feat/web-profile-onboarding` | `main` (web) | **BP6** |
| **P7 — Polish + hardening** | T16 a11y + responsive polish + skeletons + empty/error/success states; T17 lint + tests + perf budget + final smoke | `feat/web-polish-hardening` | `main` (web) | **BP7** |

Each phase produces **one PR per repo touched** (web is primary; ecosystem
parent gets a submodule-bump PR per phase). The user merges per phase, pulls on
the VPS, manually verifies, then the next phase opens.

## Foundations (decisions baked into the plan)

These are decided up front to prevent rework across phases.

### Routing
- Continue with **`react-router-dom` v7** (already installed). Add nested layout
  routes; reserve **`/`** for the landing/splash and a dedicated
  **`<ProtectedRoute>`** wrapper for `/app/*`.

### Layout shell
- **Public shell** (header + minimal footer + `<Outlet/>`) for landing/login/signup.
- **Protected shell** (left sidebar on ≥900 px, sticky horizontal nav strip on
  <900 px) for everything under `/app/*`. Mirrors Reflex `app/shell.py`.

### Theme + tokens
- Replace inline `#hex` literals with **CSS variables** in `:root` and
  `[data-theme="dark"]`. Tokens: `--bg`, `--fg`, `--surface`, `--surface-2`,
  `--border`, `--accent`, `--accent-fg`, `--success`, `--warn`, `--danger`,
  `--muted`, `--shadow-sm/md/lg`, plus a numeric scale (`--space-1..8`,
  `--radius-sm/md/lg`, `--font-sm/md/lg/xl/2xl`).
- Keep `Inter` as primary; load via `@font-face` from `public/` to avoid CDN
  dependency.

### Breakpoints (matches Reflex `index.css`)
- **`--bp-sm`**: 640 px (compact phone)
- **`--bp-md`**: 900 px (Reflex shell collapses below this)
- **`--bp-lg`**: 1200 px (Reflex dashboard collapses below this)
- **`--bp-xl`**: 1440 px (wide desktop spacing)
- Use **container queries** where a widget's layout depends on its slot, not the
  viewport (e.g. KPI tiles inside variable-width grid cells).

### Charts
- Stay on **`recharts`** (already installed). Wrap in a `<ChartFrame>` that
  enforces `ResponsiveContainer`, theme-aware colors, empty/loading skeletons,
  and accessible labels.

### Tables
- Lightweight in-house `<DataTable>` (no new dep) with: column config, sticky
  header, mobile collapse to **stacked card per row** below `--bp-md`, sortable
  columns, and an `<EmptyState/>` slot.

### Forms
- **`react-hook-form` + `zod` + `@hookform/resolvers`** (already in
  `package.json`, currently unused). Single `<Form/>` shell + `<Field/>`
  primitives so all forms (login, signup, transaction editor, expense modal,
  data hub dialogs, profile prefs, onboarding) share validation + error UX.

### State / data
- **React Query** as the cache (already installed). Set sane defaults:
  `staleTime: 30s`, `gcTime: 10m`, `retry: 1`, `refetchOnWindowFocus: false`.
- Auth: keep `localStorage` for **access token**; add **refresh token** storage
  (same key family) and an **axios response interceptor** that catches **401**,
  attempts a single refresh via `POST /api/token/refresh/`, retries the original
  request, and on failure clears tokens and routes to `/login` (or `/` per
  guard). Mirrors Reflex `core/api_client.py` `refresh_on_401`.
- Add **cookie consent banner** primitive (parity with Reflex `cookie_banner`).

### A11y baseline
- Every input has explicit `<label htmlFor>` + `id`.
- Visible focus ring (`:focus-visible`).
- Color-coded deltas use **icon + sign** in addition to color.
- Charts get `<title>` + role-appropriate ARIA via `recharts` `aria-*` props.

### Out-of-parity (intentionally NOT ported)
- Reflex `simulation_mode` toggles + window alerts.
- Data Hub double-load pattern (we will load once via React Query).
- Reflex `active_route` quirks on `/transactions/*` sub-routes — we will set
  `active_route` truthfully per route.
- Legacy unrouted Reflex defs (`data_page`, `splash_shell_page_protected`).

## How to use this plan with `orchestration-manager`

1. Launch the orchestration agent with **`AGENT_LAUNCH_PROMPT.md`** in this
   folder.
2. Orchestrator reads tasks in **`tasks/`** in numerical order (T00 → T17). Each
   task packet declares its routing skill (feature loop, design-docs sync,
   PR-ops, etc.).
3. Validation gates in **`validation_gates.md`** are the only authoritative
   "done" lines; orchestrator must not progress past a gate without a PASS.
4. Cross-repo work coordination lives in **`CROSS_AGENT_COORDINATION.md`**.
5. VPS / runtime guidance lives in **`runtime_handoff.md`**.

## Execution status (living)

| Phase | Status | PR(s) | Notes |
|-------|--------|-------|-------|
| P0 plan ratify | **READY** | n/a | This document is the plan freeze. |
| P1 foundations | **NOT STARTED** | — | Waiting orchestrator. |
| P2 public surface | **NOT STARTED** | — | Depends on BP1. |
| P3 dashboard | **NOT STARTED** | — | Depends on BP2. |
| P4 transactions | **NOT STARTED** | — | Depends on BP3. |
| P5 bills + data hub | **NOT STARTED** | — | Depends on BP4. |
| P6 profile + onboarding | **NOT STARTED** | — | Depends on BP5. |
| P7 polish + hardening | **NOT STARTED** | — | Depends on BP6. |

After **sweep #1** PRs are merged and pulled on VPS, the user does a manual
walkthrough; **sweep #2** opens to address findings.

---

## §10 — Reflex inventory snapshot (parity surface)

**Routes** (10 user-facing + 4 onboarding):

- `/`  splash/landing — `splash_marketing_content`, hero, value props,
  feature showcase tabs (cross-fade w/ `prefers-reduced-motion`), live preview
  (static `SplashState`), roadmap grid, signup CTA, cookie banner, locale
  selector. **Public.**
- `/login` — login overlay over splash backdrop; `POST /api/token/`. Public;
  `redirect_if_authenticated` → `/dashboard`.
- `/signup` — signup overlay; `POST /finance/user/` then login. Public;
  redirect-if-auth.
- `/dashboard` — KPI tiles, multi-series flow chart (income/outgoing/leaks),
  daily spend, category & tag pies, source balances, recent transactions,
  filter row (current month / type / tags / advanced), drillthrough into
  transactions modal. **Auth.**
- `/transactions` — quick entry, filters (basic + advanced), table CRUD, delete
  confirm, drillthrough applied on load. **Auth.**
- `/transactions/new` — same page; opens editor modal on load.
- `/transactions/calendar` — date range, calendar bar chart, day grid (heat),
  due events table, day drill table. `GET /finance/transactions/calendar/`.
- `/transactions/deep-dive` — flow daily, type pie, top categories.
  `GET /finance/transactions/visualization/`.
- `/upcoming-expenses` — bills pipeline, filters, table, modal CRUD.
- `/upcoming-expenses/deep-dive` — KPI row + monthly bar + timeline table.
- `/data` — sources/categories/tags CRUD card stack.
- `/settings/profile` — Overview / Settings / Security tabs; PATCH profile,
  password, danger zone, delete account.
- `/onboarding`, `/onboarding/sources`, `/onboarding/categories`,
  `/onboarding/review` — 4-step first-run flow.

**Navigation shell:** ~72 px collapsed left rail with hover-expand to ~240 px;
items Dashboard / Transactions / Calendar / Upcoming / Data / Profile (lucide
icons); sticky glass header with title + locale picker; bottom Guide + Logout;
cookie banner at root.

**Breakpoints actually used:** **1200 px** (dashboard tightens to 1-col); **900
px** (shell stacks; sidebar → sticky horizontal scroll strip).

**State:** JWT in `rx.Cookie` (same_site=lax, secure=true, max_age=7d); access
+ refresh; `httpx ApiClient` with `refresh_on_401`. **No business polling.**

**UX-alive cues:** glass header, KPI gradient text, hover-expand sidebar, pie
slice scale-on-hover, drillthrough success callouts, transfer delta preview,
two-step delete, tag suggestion chips, three-state cards (empty/success/error),
amber callout warnings, in-app tutorials.

## §11 — Current web inventory snapshot

- Vite 8 + React 19 + TS 6 + react-router-dom 7 + react-query 5 + axios +
  recharts 3. RHF/zod **declared but unused**; clsx/tailwind-merge declared but
  unused; **no Tailwind**.
- Routes: only `/login`, `/dashboard`, `*` → redirect.
- Auth: access token in `localStorage`; **refresh token discarded**; **no 401
  handling**.
- Components: none shared — everything inline in `LoginPage` / `DashboardPage`.
- Styles: plain global CSS (`src/index.css`); literal hex; **no theme tokens**;
  no media queries (`App.css` exists but isn't imported).
- API consumed: `POST /api/token/` and `GET /finance/appprofile/snapshot/?current_month=true`.
- Quality gaps: hard-coded login defaults; no skeletons/empty states; no a11y
  pass; no tests.

## §12 — API contract snapshot (relevant to this sweep)

Auth: `POST /api/token/`, `/api/token/refresh/`, `/api/token/verify/`. Access
1 d, refresh 7 d, rotate + blacklist on rotation.

Profile + snapshot:
- `GET/PATCH /finance/appprofile/`
- `GET /finance/appprofile/snapshot/` (full dashboard packet — KPIs, flow
  series, expense_by_category, source_balances, daily_spend, daily_income,
  monthly totals, snapshot rollup w/ `safe_to_spend`, `total_assets`, etc.)

Transactions: `GET/POST /finance/transactions/`, `GET/PATCH/DELETE
/finance/transactions/<id>/`, `GET /finance/transactions/calendar/`, `GET
/finance/transactions/visualization/`.

Sources / categories / tags: `GET/POST /finance/sources/` (and `/{source}/` for
PATCH/DELETE); same shape for categories and tags.

Upcoming expenses: `GET/POST /finance/upcoming_expenses/`,
`GET/PATCH/PUT/DELETE /finance/upcoming_expenses/<name>/`.

User: `POST /finance/user/` (signup), `GET/PATCH/DELETE /finance/user/`.

CORS already permits the `jsdev*` hostnames + `localhost:5173/4173`. No API
changes are expected for sweep #1 (call out in `CROSS_AGENT_COORDINATION.md` if
discovered).

---

**See also:**
- [`validation_gates.md`](./validation_gates.md)
- [`AGENT_LAUNCH_PROMPT.md`](./AGENT_LAUNCH_PROMPT.md)
- [`CROSS_AGENT_COORDINATION.md`](./CROSS_AGENT_COORDINATION.md)
- [`runtime_handoff.md`](./runtime_handoff.md)
- [`tasks/`](./tasks)
