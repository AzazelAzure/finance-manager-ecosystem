# Validation gates — web parity sweep #1

Plan ID: `PLAN_WEB_REFLEX_PARITY_SWEEP_1_2026-04-29`

Each breakpoint must be **PASS** before the next phase opens. Fail -> orchestrator
re-tasks via the appropriate skill (bugfix-investigation-loop, ci-test-triage,
container-runtime-podman-triage) and re-runs the same gate. PR cannot merge if
its phase gate is not green.

---

## BP0 — Plan freeze

- **Pass when:** README + validation gates + AGENT_LAUNCH_PROMPT +
CROSS_AGENT_COORDINATION + runtime_handoff exist under
`plans/feat/web-reflex-parity-sweep-1/`; tasks T00-T17 present.
- **Status:** **PASS** on commit of this plan.

## BP1 — Foundations

- **Pass when:**
  1. `npm run build` green; `npm run lint` green.
  2. New layout shells render: `<PublicShell>` for `/`, `/login`, `/signup`;
    `<ProtectedShell>` for `/app/`* (sidebar >=900 px; horizontal strip
     <900 px).
  3. Theme tokens live in `:root` + `[data-theme="dark"]`; no inline hex
    literals in component code (CSS only).
  4. Breakpoint constants exposed via `src/lib/breakpoints.ts` and matching
    `--bp-sm/md/lg/xl` CSS vars.
  5. Axios response interceptor handles **401** -> single refresh attempt ->
    retry; on refresh failure clears tokens and routes to `/login`.
  6. Cookie consent banner renders and stores acceptance.
  7. Existing `/app/dashboard` still loads snapshot.
- **Status:** **PASS** (2026-04-29).

## BP2 — Public surface

- **Pass when:**
  1. `/` renders splash with hero, value props, feature showcase, preview,
    roadmap, CTA, locale picker, cookie banner.
  2. `/login` submits `POST /api/token/`; stores tokens; routes to dashboard.
  3. `/signup` calls `POST /finance/user/` then login flow.
  4. Forms use react-hook-form + zod.
  5. Visual parity at 640 / 900 / 1200 / 1440 px.
- **Status:** **PASS** (2026-04-29).

## BP3 — Dashboard parity

- **Pass when:**
  1. Dashboard KPI tiles match Reflex set.
  2. Charts: flow, spend, category pie, tag pie.
  3. Tables: source balances, recent transactions.
  4. Filter row and apply/refresh behavior.
  5. Dedup loads for same filter signature.
  6. Mobile layout is stable and complete.
  7. Empty/loading/error states present.
- **Status:** **PASS** (2026-04-29) — polish follow-ups tracked for BP7.

## BP4 — Transactions suite

- **Pass when:**
  1. `/app/transactions` supports list/filter/edit/delete.
  2. Editor supports single tx + transfer pair and tags/bill linking.
  3. `/app/transactions/new` opens editor.
  4. Calendar view renders expected controls + drill.
  5. Deep-dive view renders flow/type/category charts.
  6. Drillthrough from dashboard lands with pre-applied filters.
- **Status:** **PASS** (2026-04-29) — blank category behavior aligned with API.

## BP5 — Bills + data hub

- **Pass when:**
  1. `/app/upcoming-expenses` CRUD + quick filters.
  2. `/app/upcoming-expenses/deep-dive` KPI + chart + timeline.
  3. `/app/data` cards for sources/categories/tags with CRUD and category totals.
  4. No duplicate fetches on data hub initial load.
- **Status:** **PASS** (2026-04-29) — upcoming expenses and data hub behavior
accepted for beta launch, with source-edit polish tracked in BP7 follow-ups.

## BP6 — Profile + onboarding

- **Pass when:**
  1. `/app/settings/profile` has Overview / Settings / Security tabs.
  2. Onboarding flow under `/app/onboarding[/sources|/categories|/review]`
    with sequential guards.
  3. New users route to onboarding when forced.
- **Verification:** new account end-to-end; preferences round-trip; password
change; onboarding complete.
- **Status:** **PASS (2026-04-29)** — profile tabs + onboarding flow verified in
merged web changes.

## BP7 — Polish + hardening (final)

- **Known follow-up (from BP2):** fullscreen/mobile menu visual + motion polish.
- **Known follow-up (from BP3):** dashboard smart/live reload UX evaluation and
drill interaction preference (redirect vs in-place).
- **Known follow-up (from BP5):** Data Hub Sources polish — expand edit dialog
to support updating `currency` and `amount` in-place alongside source rename.
- **Known follow-up (from BP7 launch hardening):** Dashboard `Quick add -> +Bill`
is intentionally disabled for beta launch pending product decision on whether this
flow should be a quick upcoming-expense creator, a quick pay-bill action, or a
hybrid path with explicit mode switching.
- **Execution sequencing:** phased PR rollout
  1. Public surface visual depth + interactivity polish (`/`, `/login`, `/signup`)
  2. App shell/nav polish
  3. Dashboard/data surfaces polish
  4. Remaining app surfaces + final hardening
- **Status:** **PASS** (2026-04-29) — BP7 polish + hardening accepted for beta
launch with known follow-up item(s) captured above.
- **Pass when:**
  1. Lighthouse a11y >= 90 on key routes.
  2. Lighthouse perf >= 80 mobile on `/` and `/app/dashboard`.
  3. Skeleton loaders on key data surfaces.
  4. Empty/error/success states used consistently.
  5. Vitest smoke tests present and green.
  6. ESLint clean; TypeScript strict build.
  7. VPS smoke walk-through documented.

---

## Final readiness gate

Sweep #1 complete when:

- BP1-BP7 are PASS. ✅
- Phase PRs merged in `finance_manager_web` and required submodule bumps merged.
- VPS rebuild + smoke documented in `runtime_handoff.md`.
- `finance_manager_web/CHANGELOG.md` updated per phase.
- User manual VPS sign-off recorded.