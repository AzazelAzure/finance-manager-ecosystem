# T03 — Landing / splash page

**Phase:** P2 — Public surface  
**Skill:** `feature-implementation-loop`  
**Branch:** `feat/web-public-surface`  
**Repo scope:** `finance_manager_web/`

## Reference

Reflex source: `finance_manager_reflex/finance_manager_reflex/features/profile/view.py`
(`splash_page`, `_splash_value_props`, `_splash_feature_showcase_tabs`,
`_splash_live_preview`, `_splash_upcoming_features`, `_splash_cta`).

## Objective

Build `/` as the public marketing landing matching the Reflex splash flow:
hero, value props grid, rotating feature showcase tabs (cross-fade with
`prefers-reduced-motion` fallback), static "live preview" panel, roadmap grid,
final CTA, locale picker, cookie banner.

## Implementation checklist

- [ ] `src/pages/LandingPage.tsx` rendered at `/` inside `<PublicShell>`.
- [ ] **Hero** (`src/components/landing/Hero.tsx`): heading, subheading, two
  CTAs (`Get started` → `/signup`, `Sign in` → if access token exists then
  `/app/dashboard` else `/login`).
- [ ] **Value props grid** (`ValueProps.tsx`): 3-up at ≥ `--bp-lg`, 2-up at
  `--bp-sm`, 1-up below.
- [ ] **Feature showcase tabs** (`FeatureShowcase.tsx`): tab list + cross-fade
  panel; CSS `@keyframes` fade; `@media (prefers-reduced-motion: reduce)`
  swaps to instant change. Auto-advance every 6 s, pause on hover/focus.
- [ ] **Live preview** (`LivePreview.tsx`): static demo data hard-coded in a
  module (no API calls); KPI tiles + a tiny table; mirrors Reflex
  `SplashState.preview_*`. Marked `aria-label="Demo data"`.
- [ ] **Roadmap grid** (`Roadmap.tsx`): 4 cards.
- [ ] **CTA** (`CTASection.tsx`): one large `Get started` button.
- [ ] **Locale picker** (`LocalePicker.tsx`): `en-US` / `tl-PH`. Stored in
  cookie `fm_locale`. Stub `tr(key)` helper in `src/lib/i18n.ts` — actual
  translations stay English-only this sweep, but the wiring is there.
- [ ] **Cookie banner**: rendered by `<PublicShell>` already (T01).
- [ ] Page is fully responsive across **640 / 900 / 1200 / 1440 px** with no
  horizontal scrollbars and the hero CTA always visible above the fold on
  desktop.

## Definition of done

- [ ] `/` renders all 6 sections in order on desktop.
- [ ] Tabs auto-advance with cross-fade; reduced-motion users see instant
  swap.
- [ ] CTAs route correctly based on auth state.
- [ ] Lighthouse a11y on `/` ≥ 90.

## Verification

Manual at 4 widths; check `prefers-reduced-motion` (DevTools Rendering tab).
