# T01 — Design Token Layer — Execution Summary

**Branch:** `cur/s1b/feat/ui-ux-design-system`
**Date:** 2026-06-26
**Status:** SL1 PASS · SL2 PASS (V1; V3 browser screenshot pending HitM) · SL3 PASS-with-deviation

## Context correction vs. plan assumptions
The plan/task spec assumed a greenfield token file + Tailwind v3/v4. **Reality:**
`finance_manager_web` uses **no Tailwind** (not in `package.json`) — it has a
mature hand-rolled CSS-variable system in `src/styles/tokens.css`, light-default
with dark via `html[data-theme="dark"]`, switched by `src/lib/theme.ts`.
Therefore T01 was implemented **additively** (layering the locked token names on
top of the existing system) rather than scaffolding from scratch. The Tailwind
risk row in README §10 is moot (no Tailwind to migrate).

## SL1 — Token file (PASS)
`src/styles/tokens.css` extended with the LOCKED names from the task spec:
- `--color-brand-primary`, `--color-surface-base/-card/-border` (aliased to the
  existing theme-adaptive `--bg/--surface/--border` so theming keeps working)
- Semantic budget-pace palette `--color-positive/-warning/-negative/-pending/-neutral`
  (OKLCH) + dark-mode lightness overrides for legibility on `#0b0f1a`
- 4px grid `--spacing-1 … --spacing-16` (px)
- Type scale `--text-xs … --text-3xl` + `--text-hero`
- `--font-numeric`, `--font-feature-tabular`
Build passes (`evidence/T01.SL1_build_output.txt`).

## SL2 — Dark-mode no-flash (PASS, V1)
CSS-var swap already instant (no layout shift). Added a pre-paint inline script
in `index.html` (mirrors `theme.ts`) that resolves `fm_theme`/system pref and
sets `data-theme` **before first paint**, eliminating the light→dark FOUC on
reload. CSP already permits inline scripts. V3 dual-mode screenshot deferred to
HitM/browser verification (no dev server run in this slice).

## SL3 — Money audit (PASS-with-deviation)
Audit in `evidence/T01.SL3_float_grep.txt`. Added `.money-value`/`.money`
tabular-nums utility (`index.css`) and applied tabular figures to `.ui-kpi h3`.
**Deviation:** did NOT install currency.js — the genuine float arithmetic is in
the offline overlay modules; migrating those is a behavior-bearing change that
must not regress PWA class B and belongs in its own slice. Flagged as follow-up.

## Files changed (web repo)
- `src/styles/tokens.css` — token layer + dark overrides
- `src/index.css` — `.money-value`/`.money` utility
- `src/components/ui/ui.css` — tabular figures on KPI values
- `index.html` — pre-paint theme script

## Verification
- `npm run build`: PASS (exit 0, tsc clean)
- `npm run lint`: 18 pre-existing problems in untouched `.ts/.tsx` files
  (timezones, connectivity, DashboardPage, TransactionsPage, UpcomingExpenses,
  registerPwa). CSS/HTML aren't linted → T01 adds zero new lint issues.

## Carry-forward / follow-ups
1. Integer-centavo money handling (currency.js) across the 3 offline overlays
   + display path — dedicated slice with offline-sync regression tests.
2. JS bundle is 364 kB gzip (pre-existing, > 200 kB target) — code-splitting is
   a separate perf follow-up.
3. T03 dashboard task to extend tabular-nums/`.money-value` to transaction rows.
