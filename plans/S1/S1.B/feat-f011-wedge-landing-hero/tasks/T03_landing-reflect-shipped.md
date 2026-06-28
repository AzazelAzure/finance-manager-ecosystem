# T03 — Landing reflects shipped reality (post-June production batch)

> **Living-plan pass.** Authored 2026-06-28 after the June production batch (F-001, F-004,
> F-005, F-010) merged to `main` and promoted to production. The public landing page must
> stop describing shipped capabilities as "coming soon" and start showing them as live.
>
> **Ships together with [T04](./T04_landing-roadmap-future.md)** on a single web branch /
> PR / inactive-color deploy: both edit the same landing surface and the same `i18n.ts`
> file, so splitting them into separate PRs would only create same-file conflicts. T03 owns
> the "what shipped" surfaces; T04 owns the "what's next" surface.

## End State

The public landing page (`/`) **VersionHistory**, **FeatureShowcase**, **ValueProps**, and
**Hero** sections accurately reflect every capability currently live in production. No
"coming soon" for anything shipped; no internal `F-0##` / `T##` codes; the wedge
(pay-cycle-aware safe-to-spend) is prominent.

## Cross-reference (source of truth for "what shipped")

Confirm each is live before writing copy. Sources: `strategy/priority_matrix_2026-06-28.md`
(Tier 0 "Completing Today") and `governance/plan_registry.md` (Recently Completed).

| Capability | Plan | Registry status | Landing angle |
|---|---|---|---|
| Pay cycles + bill realism | F-004 | completed 2026-06-28 | **The wedge** — safe-to-spend tied to real payday, volatile vs rigid bills, partial payments |
| Balance history & trends | F-001 | completed 2026-06-28 | Day-end balance charts (7d/30d/90d/all) |
| Savings goals | F-005 | completed 2026-06-28 | Goals with per-cycle pace + progress |
| Export & sharing | F-010 | completed 2026-06-28 | CSV export, JSON backup, time-limited share links |
| Guided walkthroughs | F-007 | completed 2026-06-27 | Interactive tours (already on page) |
| Offline-first PWA | PWA sprint | completed 2026-06-28 | Already on page — keep |
| Legal / privacy | legal pages | completed 2026-06-27 | Trust signal (footer already links) |

## Acceptance Criteria

1. [V3] VersionHistory shows a new release entry covering the June batch (balance history, savings goals, pay cycles, export/sharing) — newest entry first.
2. [V3] FeatureShowcase reflects shipped surfaces: a Goals tab exists; dashboard/bills blurbs mention safe-to-spend + pay cycles.
3. [V3] Hero body + at least one value prop reference pay-cycle-aware safe-to-spend (the wedge).
4. [V3] No "coming soon" for any shipped capability; no internal codes (`F-0##`, `T##`) visible anywhere.
5. [V3] i18n: every new/changed key exists in both `en-US` and `tl-PH`.
6. [V1] `npm run build` + `tsc -b` clean; `vitest run` green.
7. [V3] Renders correctly on mobile (hero not clipped, tabs scrollable).

## Scope Lock

### Files to modify
- `src/components/landing/VersionHistory.tsx`
- `src/components/landing/FeatureShowcase.tsx`
- `src/components/landing/ValueProps.tsx`
- `src/components/landing/Hero.tsx`
- `src/lib/i18n.ts` (en-US + tl-PH)
- `CHANGELOG.md`

### Files NOT to touch
- `Roadmap.tsx` and `roadmap.*` i18n keys → owned by **T04**
- Auth pages, app shell, in-app DashboardPage
- Legal page content
- API repo (web-only task)

## Slices

### T03.SL1 — VersionHistory + FeatureShowcase
Add June release entry; add Goals tab + sharpen dashboard/bills blurbs. Evidence: [V3] desktop + mobile screenshots.

### T03.SL2 — Hero + ValueProps wedge copy
Sharpen hero body + one value prop to lead with pay-cycle safe-to-spend. Evidence: [V3] screenshot.

### T03.SL3 — i18n + build
All new/changed keys in en-US + tl-PH; `npm run build` + `tsc -b` + `vitest run`. Evidence: [V1] build log.

## Notes

- Wedge sentence is canonical in `design_docs/01_Business_Vision.md` — do not deviate.
- PWA/offline is part of done: landing is a public static surface (no offline state to wire), so no overlay work required — note this explicitly in the PR.
- CPPRD: web `CHANGELOG.md` updated in the same change.
