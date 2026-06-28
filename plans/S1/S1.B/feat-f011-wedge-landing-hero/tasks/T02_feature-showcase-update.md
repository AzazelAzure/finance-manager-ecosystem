# T02 — Feature Showcase Update (2026-06-28 production batch)

> **Superseded by [T03](./T03_landing-reflect-shipped.md) + [T04](./T04_landing-roadmap-future.md)** (2026-06-28).
> T03 covers shipped-reality surfaces; T04 covers forward roadmap. Both ship on PR #90.

> **Run this task AFTER** F-004, F-001, F-010, and F-005 have merged and are live on VPS.
> Landing page should reflect shipped reality, not planned work.

## End State

The landing page (`/`) feature showcase, hero section, and value proposition copy reflect all features currently live in the app. No internal codes (F-0##), no "coming soon" that has shipped, no missing bullets for shipped capabilities.

## Features to reflect (confirm each is live before adding copy)

| Feature | What shipped | Landing page angle |
|---|---|---|
| Guided tours (F-007) | In-app step-by-step walkthroughs on first use | "Gets you set up in minutes" |
| Support intake (F-012) | Bug report + feature request form in-app | "Direct line to the team during beta" |
| STS pay cycles (F-004) | Semi-transparent salary, volatile vs rigid bills | "Built for how PH income actually works" |
| Balance history (F-001) | Day-end balance charts, trend view | "See where your money goes over time" |
| Savings goals (F-005) | Goal tracking with progress | "Set goals, watch them grow" |
| Export/sharing (F-010) | Export data, share reports | "Your data, your way" |
| Legal pages (ToS/Privacy) | Live at /terms, /privacy, /cookies | Trust signal — mention data privacy commitment |

## Acceptance Criteria

1. [V3] Landing page hero copy mentions STS/pay-cycle awareness specifically — this is the wedge, it must be prominent
2. [V3] Feature section lists at least 4 of the above features with human-readable names and one-line descriptions
3. [V3] No "coming soon" text for any feature that is currently live
4. [V3] No internal codes (F-007, F-012, etc.) visible anywhere on the page
5. [V3] i18n: all new copy has en-US and tl-PH keys
6. [V3] Page renders correctly on mobile (bottom nav still accessible, hero not clipped)
7. [V1] `npm run build` passes, `tsc -b` clean

## Scope Lock

### Files to modify
- Landing page component(s) — hero, feature showcase, value props sections
- i18n `en-US.json` and `tl-PH.json` — new keys for any new copy
- Do NOT add pricing, waitlist forms, or any conversion element not already present

### Files NOT to touch
- Auth pages
- App shell / dashboard
- Legal page content (handled in PLAN_CROSS_PRODUCTION_UX_FIX T04)
- SEO meta tags beyond what the landing page already has (separate SEO pass)

## Slices

### T02.SL1 — Audit current landing page state
- Read current landing page components
- List: (a) what's already mentioned, (b) what's missing, (c) any "coming soon" that shipped
- Evidence: [V0] findings written as a comment in Cursor chat before proceeding

### T02.SL2 — Update hero and feature showcase
- Update hero copy to lead with STS/pay-cycle awareness (the wedge)
- Add or update feature bullets for all live features in the table above
- Remove or replace any stale "coming soon" text
- Evidence: [V3] screenshot of updated landing page on desktop + mobile

### T02.SL3 — i18n and build
- Add all new i18n keys in en-US and tl-PH
- `npm run build` + `tsc -b` clean
- Evidence: [V1] build log

## Notes

- The wedge sentence is the most important copy on the page. Check `design_docs/01_Business_Vision.md` for the canonical wedge statement before writing hero copy — don't deviate from the positioning.
- tl-PH copy for STS is high-signal: PH users reading in Tagalog seeing pay-cycle language they recognize is a strong trust signal.
- CPPRD (web CHANGELOG + design_docs if feature showcase doc exists)
