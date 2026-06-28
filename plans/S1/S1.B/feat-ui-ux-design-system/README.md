---
plan_id: PLAN_CROSS_UI_UX_DESIGN_SYSTEM_2026-06-26
status: completed
priority: P2
created: 2026-06-26
updated: 2026-06-28
owner: pproctor

plan_root: plans/S1/S1.B/feat-ui-ux-design-system/
intended_branch: cur/s1b/feat/ui-ux-design-system
target_repos:
  - finance_manager_web

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with: []
conflicts_with:
  - PLAN_FEAT_F007_WALKTHROUGH_SANDBOX_2026-06-03

manual_gates:
  pre_execution: required
  pre_merge: required
  pre_close: optional

deployment:
  required: true
  target_services: [js]
  bundle_required: true
  rollback_plan_id: null
  smoke_targets:
    - / (landing page — verify LCP ≤ 2.5s, no layout shift)
    - /login (Helmet title + meta description present; visual regression check)
    - /app/dashboard (dark mode renders; balance number visible; charts render)
    - PWA install still functional (manifest, service worker scope intact)
  notes: >-
    **Do NOT start this plan until PLAN_FEAT_F007_WALKTHROUGH_SANDBOX_2026-06-03 is merged.**
    F-007 sandbox touches TourProvider.tsx, ui.css, and ProtectedShell.tsx — all of which
    overlap with this plan's scope. Starting in parallel will produce merge conflicts.

standalone: true
standalone_notes: ""
---

## 0) Strategic Inheritance

- **Wedge respected:** yes — performance and visual polish directly serve "feels like a real product, not a side project" trust signal for PH beta users
- **Locked decisions touched:** `web` is flagship (locked 2026-04-30); PH-first market (performance + peso-native design obligations); Pro ₱249/mo (UI must justify pricing; premium feel is required)
- **Cost cap impact:** shadcn/ui + Radix + Tailwind v4 are zero-cost open source; `motion` (formerly Framer Motion) is MIT-licensed; no new SaaS dependencies
- **Validation gates affected:** `strategy/strategic-roadmap-reframe-53be/validation_gates.md` — "Worth paying for" feature work; Lighthouse CI thresholds (LCP ≤ 2.5s, INP ≤ 200ms, Performance ≥ 90) are implied S1.B quality bar

## 1) Objective

Establish a professional-grade design system in `finance_manager_web` by: (1) formalizing design tokens as CSS variables, (2) auditing and extending the existing component stack with shadcn/ui primitives, (3) applying the token system to the dashboard, navigation, and auth screens, and (4) adding purposeful micro-interactions via Motion. The benchmark is "Copilot Money feel in a PH-optimized React PWA" — every pixel accountable, sub-200ms interactions, ≤200KB initial JS.

**Pre-execution gate (required):** HitM must confirm F-007 sandbox plan is merged before this agent starts. Check `governance/plan_registry.md` — `PLAN_FEAT_F007_WALKTHROUGH_SANDBOX_2026-06-03` must be `status: completed`.

## 2) Scope

### In scope
- **Stage 0 — Tokens (foundational, must merge before Stage 1):**
  - CSS variable token layer: base palette (OKLCH), semantic aliases (`--color-positive`, `--color-warning`, `--color-negative`, `--color-pending`), 4px spacing scale, type scale with `tabular-nums` for money
  - Dark mode (`#0f172a` base) via Tailwind v4 `@theme` directive; no flash on reload; theme provider wiring
  - Money display audit: find all raw float rendering of monetary values; apply `tabular-nums` class; flag any bare `number * 0.01` math for `currency.js` or `Dinero.js` migration
- **Stage 1 — Components + screens:**
  - shadcn/ui audit vs existing component stack; init (new-york style, OKLCH, CSS vars) without breaking existing; apply to Card, Button, Input primitives
  - Dashboard: hero number prominence (safe-to-spend/balance as dominant element), spacing grid, Recharts integration with semantic token colors (green → amber → red budget pace)
  - Navigation shell: sidebar-on-desktop (≥lg), bottom-tabs + Sheet drawer on mobile
- **Stage 2 — Polish (can run after Stage 1 merges):**
  - LoginPage / SignupPage visual update (high-contrast, trust microcopy, biometric call-to-action)
  - Motion (`motion` package, formerly Framer Motion): `LazyMotion` wrapper, `prefers-reduced-motion` gating, budget dial animation, key transition polish
- **PWA class:** B — online-only for data; PWA shell/install must not regress (SW scope, manifest, offline shell)
- **Localization:** All new user-visible strings use existing `tr()`/`i18n.ts` keys or add new ones in both `en-US` and `tl-PH` blocks. Shelved exception: motion animation descriptions (no i18n needed).
- **SEO:** Login/Signup Helmet tags (T16.SL1–SL2 from `SEO_PASSTHROUGH_PASSDOWN.md`) should be incorporated into T05 auth polish, or confirmed already shipped via separate SEO agent before this plan runs.

### Out of scope
- New financial features (no new data models, no new API endpoints)
- Capacitor / Tauri wrapping (Stage 2 cross-platform — future plan)
- WASM/Rust money engine (deferred to v2 per brief §4 verdict)
- Recharts → ECharts migration (only if transaction history exceeds ~1,000 chart points — not yet)
- Removing or replacing Joyride / tour system (F-007 domain; do not touch TourProvider.tsx)
- ~~Any modification to `ProtectedShell.tsx` beyond reading it; F-007 sandbox owns that file~~
  **Lifted 2026-06-26:** the F-007 sandbox plan (`PLAN_FEAT_F007_WALKTHROUGH_SANDBOX_2026-06-03`)
  was superseded/orphaned by the merged F-007 rework (PR #63), so its concurrent-edit gate is
  moot. `ProtectedShell.tsx` is now **owned by T04** (responsive nav shell). Tour/help-mode
  wiring inside it is preserved untouched.

## 3) Source Evidence

- `strategy/UI_UX_research_brief.md` — full design brief (June 25, 2026); primary reference
- `plans/S1/S1.B/distribution-channel-research/SEO_PASSTHROUGH_PASSDOWN.md` — SEO tasks T16.SL1/SL2 (auth Helmet tags); incorporate or confirm shipped
- `governance/definition_of_done.md` — PWA class, i18n, SEO, and DoD checklist
- `plans/S1/S1.B/pwa-install-offline-sync-research/README.md` — PWA Advanced tier contract (do not regress)
- shadcn/ui docs (https://ui.shadcn.com), Tailwind v4 upgrade guide, Motion docs (https://motion.dev)

## 4) Phase Plan / Task List

### Stage 0 — Foundations (ship first; gate Stage 1 on this merge)

| Task | File | Slices | Surface |
|------|------|--------|---------|
| **T01** | `tasks/T01_design_tokens.md` | T01.SL1–SL3 | `tokens.css`, dark mode wiring, money type audit |

### Stage 1 — Components + Core Screens

| Task | File | Slices | Surface |
|------|------|--------|---------|
| **T02** | `tasks/T02_shadcn_scaffold.md` | T02.SL1–SL2 | shadcn audit + primitive swap |
| **T03** | `tasks/T03_dashboard_layout.md` | T03.SL1–SL2 | Dashboard hero number + Recharts tokens |
| **T04** | `tasks/T04_nav_shell.md` | T04.SL1–SL2 | Sidebar/bottom-tab responsive shell |

### Stage 2 — Polish

| Task | File | Slices | Surface |
|------|------|--------|---------|
| **T05** | `tasks/T05_auth_polish.md` | T05.SL1–SL2 | Login/Signup visual + SEO Helmet (if not yet shipped) |
| **T06** | `tasks/T06_motion_layer.md` | T06.SL1–SL2 | LazyMotion install + micro-interactions |

## 5) Execution Order

**Stage 0 (required first):**
1. `tasks/T01_design_tokens.md`: T01.SL1 → T01.SL2 → T01.SL3 (sequential)

**Stage 1 (after Stage 0 merges OR on same branch if no breaking changes):**
2. `tasks/T02_shadcn_scaffold.md`: T02.SL1 → T02.SL2
3. `tasks/T03_dashboard_layout.md`: T03.SL1 → T03.SL2
4. `tasks/T04_nav_shell.md`: T04.SL1 → T04.SL2
   - T02 and T03 may proceed in parallel if on the same branch; T04 is independent of T03

**Stage 2 (after Stage 1 is stable; may ship as separate PR):**
5. `tasks/T05_auth_polish.md`: T05.SL1 → T05.SL2
6. `tasks/T06_motion_layer.md`: T06.SL1 → T06.SL2

**Hard rule:** `npm run build` must pass and `npm run lint` must be clean before each slice is marked PASS. Do not carry TS errors across slices.

## 6) Verification Gates

| Slice | Pass condition |
|-------|---------------|
| T01.SL1 | `src/styles/tokens.css` (or equivalent) exists; CSS vars for `--color-positive/warning/negative/pending`, `--spacing-1` through `--spacing-8`, `--text-xs` through `--text-3xl` present; imported in main entry |
| T01.SL2 | Dark mode toggle switches theme via CSS var swap with no layout flash; build passes |
| T01.SL3 | Zero monetary values rendered via raw JS float (no `toFixed(2)` on raw multiplication); `tabular-nums` class present on all balance/amount displays; `currency.js` or `Dinero.js` present if float math found |
| T02.SL1 | shadcn CLI reports no errors; `components/ui/` directory populated; existing layout renders; build passes |
| T02.SL2 | Card, Button, Input components pull color from `--color-*` tokens rather than hardcoded hex; dark mode visual check passes |
| T03.SL1 | Dashboard lead element (balance or safe-to-spend) is largest visible text; spacing between all card elements is a multiple of 4px; `[V3]` screenshot captured |
| T03.SL2 | Recharts charts use semantic colors (`var(--color-positive)` etc.) rather than hardcoded color strings; no chart renders white-on-white in dark mode |
| T04.SL1 | At `≥lg` breakpoint, sidebar renders and is keyboard-navigable; at `<lg`, bottom tab bar renders; layout does not break PWA standalone view |
| T04.SL2 | Mobile Sheet drawer opens/closes on tap; no z-index conflicts with existing modals |
| T05.SL1 | Login/Signup pages pass `[V3]` visual check: high-contrast, visible biometric CTA placeholder (or note), trust microcopy present |
| T05.SL2 | If SEO Helmet tags not yet shipped: `<title>` and `<meta name="description">` change per route on /login and /signup; confirmed in browser DevTools |
| T06.SL1 | `motion` package installed; `LazyMotion` wraps animation entry points; `prefers-reduced-motion` media query disables animations; no bundle size regression > 50KB gzipped |
| T06.SL2 | At least one budget pace / balance update animation plays on dashboard; `[V3]` recording captured; animation does not fire if `prefers-reduced-motion: reduce` |

**Lighthouse gate (pre-merge):** Run `npm run build && npx lighthouse-ci` (or equivalent). LCP ≤ 2.5s, Performance ≥ 85 minimum on throttled profile. If regression, block merge and fix before PR.

## 7) Documentation Sync Required

- `governance/plan_registry.md`: move row to In Progress on start; Completed on final merge
- `strategy/current_status.md` §6 (Web): update with design system shipped (admin update — not executor scope)
- `governance/definition_of_done.md` §3 SEO: confirm T16.SL1/SL2 shipped (either by this plan's T05 or separate SEO agent)

## 8) Strategic Phase Impact

When closing this plan, executor must:
- [ ] Confirm `npm run build` clean (zero TS errors, zero lint warnings)
- [ ] Confirm PWA install still functional (manifest intact, SW scope not broken)
- [ ] Update `governance/plan_registry.md` status to `completed`
- [ ] Post completion summary + Lighthouse score screenshot to IDE Chat

## 9) Completion Criteria

- All V-tier gates in §6 met
- `npm run build` passes; `npm run lint` clean
- PWA class B confirmed (install functional; no offline regression on app shell)
- Lighthouse: Performance ≥ 85, no LCP regression vs baseline
- All new user-visible strings have `en-US` + `tl-PH` keys in `i18n.ts`
- PR created via `gh pr create`; HitM pre-merge gate cleared

## 10) Risks and Rollback

| Risk | Trigger | Rollback action | Owner |
|---|---|---|---|
| Tailwind v4 migration breaks existing styles | `@theme` directive conflicts with v3 utilities still in use | Pin to Tailwind v3; apply tokens via CSS-only layer without upgrading | Cursor executor — check Tailwind version before starting T01 |
| shadcn init clobbers existing components | shadcn overwrites files in `components/ui/` that have custom logic | Use `--overwrite` flag explicitly; diff carefully; keep originals in git stash | Cursor executor |
| Motion bundle bloat exceeds 50KB gzipped budget | Full Framer Motion imported instead of LazyMotion | Remove motion; replace with CSS transitions for all non-critical animations | Cursor executor — measure with `npm run build -- --report` |
| F-007 merge conflict (plan started before F-007 closes) | Both agents modify `ui.css` or `ProtectedShell.tsx` | Stop execution; wait for F-007 to merge; rebase on updated main | HitM gate — pre-execution check required |
| tabular-nums breaks existing UI in unexpected font | Numeric glyph widths differ from current monospace treatment | Scope to a wrapper class `.money` rather than global; verify on mobile viewport | Cursor executor |
