---
plan_id: PLAN_CROSS_LEGAL_PAGES_2026-06-27
status: draft
priority: P1
created: 2026-06-27
updated: 2026-06-27
owner: pproctor

plan_root: plans/S1/S1.B/feat-legal-pages/
intended_branch: cur/s1b/feat/legal-pages
target_repos:
  - finance_manager_web

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks:
  - PLAN_CROSS_SIGNUP_CLICKWRAP_2026-06-27
parallel_safe_with:
  - PLAN_CROSS_EMAIL_COMMS_2026-06-27
  - PLAN_CROSS_UI_UX_TEST_SEED_2026-06-27
conflicts_with: []

manual_gates:
  pre_execution: optional
  pre_merge: required
  pre_close: optional

deployment:
  required: true
  target_services: [js]
  bundle_required: true
  rollback_plan_id: null
  smoke_targets:
    - GET /privacy (200, renders content)
    - GET /terms (200, renders content)
    - GET /cookies (200, renders content)
    - GET / (200, footer links to /privacy, /terms, /cookies)
  notes: >-
    Web-only deploy. New public routes (no auth). Cookie banner update goes live
    with this deploy — users will see the updated banner on next visit.

standalone: true
standalone_notes: ""

legal_impact:
  tos: true
  privacy_policy: true
  cookie_policy: true
  notes: >-
    This plan PUBLISHES the policies. All three legal documents go live when this
    deploys. No policy content changes are in scope here — content comes from
    strategy/legal/drafts/. Any future plan that modifies site behavior covered
    by those policies must register a pending update in legal_workflow_coordination.md.
---

## 0) Strategic Inheritance

- Wedge respected: yes — public legal pages are pre-beta compliance infrastructure; does not change the product wedge
- Locked decisions touched: none
- Cost cap impact: none — react-markdown is a small dep; no new API calls
- Validation gates affected: S1.B public beta gate (legal compliance required before public launch)

## 1) Objective

Add three public-facing legal pages (`/privacy`, `/terms`, `/cookies`) to the web app, rendered from publication-ready markdown files. Add a minimal footer to the landing page with links to all three. Update the cookie banner to include a "Cookie Policy" link. Install `react-markdown` + `remark-gfm` as dependencies.

This makes The Hive's legal posture visible to users and satisfies the pre-beta compliance requirement. The pages render from curated markdown source files (not the internal draft files) so policy updates can be made via text edits without touching React code.

## 2) Scope

### In scope
- Install `react-markdown` and `remark-gfm` npm packages
- Create `src/content/legal/privacy_policy.md` — publication-ready Privacy Policy text (stripped of all draft markers; see §3)
- Create `src/content/legal/tos.md` — publication-ready Terms of Service text
- Create `src/content/legal/cookies.md` — publication-ready Cookie Policy text
- Create `src/pages/legal/PrivacyPage.tsx` — renders `privacy_policy.md` via react-markdown
- Create `src/pages/legal/TermsPage.tsx` — renders `tos.md` via react-markdown
- Create `src/pages/legal/CookiesPage.tsx` — renders `cookies.md` via react-markdown
- Add routes `/privacy`, `/terms`, `/cookies` under `PublicShell` in `App.tsx` (public, no auth required)
- Add `LegalPageShell` wrapper component: back link ("← Home"), page title, constrained-width container, basic typography styles for rendered markdown
- Update `LandingPage.tsx` to add a `<LegalFooter />` component: simple centered row with links to `/privacy`, `/terms`, `/cookies`, and copyright line
- Update `CookieBanner.tsx`: add "Cookie Policy" link pointing to `/cookies` in the banner text; banner text updated to be more informative (see T01 task)
- Add Helmet SEO meta to each legal page (`noindex` to prevent legal drafts from ranking before attorney review is done)
- i18n: English-only for now; i18n keys can be added as a follow-up

### Out of scope
- Editing legal content — content comes verbatim from the publication-ready markdown files created in T01
- In-app legal links from the authenticated app shell (Settings page, etc.) — separate follow-up
- Age gate or consent modal — separate plan (PLAN_CROSS_SIGNUP_CLICKWRAP)
- Native mobile / Android — not applicable at this stage
- Internationalization of legal text — deferred; policies are English only for public beta

## 3) Source Evidence

- `strategy/legal/drafts/privacy_policy_v1.md` — source policy text (corrected 2026-06-27)
- `strategy/legal/drafts/tos_v1.md` — source ToS text
- `strategy/legal/drafts/cookie_policy_v1.md` — source cookie policy text (corrected 2026-06-27)
- `strategy/legal/legal_workflow_coordination.md` — authoritative implementation state and pending markers
- `finance_manager_web/src/App.tsx` — existing route structure (PublicShell / RequireAuth layout)
- `finance_manager_web/src/components/CookieBanner.tsx` — current cookie banner implementation
- `finance_manager_web/src/pages/LandingPage.tsx` — current landing page (no footer currently)
- `finance_manager_web/src/components/landing/landing.css` — landing page styles reference

## 4) Phase Plan — Task List

| Task | Title | Slices | V-tier |
|---|---|---|---|
| T01 | Publication-ready content files | T01.SL1 Content curation; T01.SL2 Dep install | V0, V1 |
| T02 | Legal page components + routes | T02.SL1 LegalPageShell; T02.SL2 Three page components; T02.SL3 App.tsx routes | V1, V3 |
| T03 | Landing footer + cookie banner update | T03.SL1 LegalFooter component; T03.SL2 CookieBanner update | V3 |

See `tasks/` for detailed slice files.

## 5) Execution Order

Execute T01 first (content files + deps must exist before components can render). T02 and T03 can run in parallel after T01.

1. `tasks/T01_content_and_deps.md` — T01.SL1 → T01.SL2
2. `tasks/T02_page_components.md` — T02.SL1 → T02.SL2 → T02.SL3
3. `tasks/T03_footer_and_banner.md` — T03.SL1 → T03.SL2

## 6) Verification Gates

- [V1] `npm run build` passes with react-markdown installed and all three legal pages compiled
- [V1] TypeScript: no new type errors in legal page components
- [V3] Browser: `/privacy`, `/terms`, `/cookies` each load and render formatted policy text
- [V3] Browser: Landing page shows legal footer with working links to all three pages
- [V3] Browser: Cookie banner shows "Cookie Policy" link; clicking it navigates to `/cookies`
- [V3] Browser: All three legal pages have `noindex` meta tag (verify via DevTools)
- [V3] Browser: Legal pages are accessible without login (test in incognito)

## 7) Documentation Sync Required

- `strategy/legal/legal_workflow_coordination.md`: update "Legal Document Status" table — mark all three docs as "published to /privacy, /terms, /cookies" once deploy is confirmed
- `governance/plan_registry.md`: move this plan to Completed on close

## 8) Strategic Phase Impact

When closing this plan, executor must:
- [ ] Update `strategy/legal/legal_workflow_coordination.md` — mark three docs as published
- [ ] Update `governance/plan_registry.md` status to `completed`
- [ ] Post completion summary to IDE Chat

## 9) Completion Criteria

- All V1/V3 gates in §6 met
- HitM confirms legal pages render correctly on VPS (pre_merge gate)
- PR merged
- §8 actions complete

## 10) Risks and Rollback

| Risk | Trigger | Rollback action | Owner |
|---|---|---|---|
| react-markdown SSR incompatibility | Build fails or hydration error | Pin to known-good version or use dynamic import | Cursor |
| Policy content contains unpublished draft markers | `[PENDING...]` or `[ATTORNEY REVIEW]` visible on live page | Immediately pull from CookieBanner/routes and revert deploy | HitM |
| Legal page routes conflict with future route additions | Path collision | Rename route segment (low risk — `/privacy`, `/terms`, `/cookies` are standard) | Cursor |

---

## Content Curation Notes (for T01.SL1)

### What to strip from draft → publication-ready markdown

The draft files in `strategy/legal/drafts/` contain internal markers that must NOT appear on the live site:

| Marker | What to do in published file |
|---|---|
| `> **DRAFT STATUS:** ...` block at top | Remove entirely |
| `[PENDING T05]` / `[PENDING T06]` as standalone labels | Remove the label; keep the SENTENCE that describes current state (e.g., "Until T05 is deployed, tokens are stored in localStorage" stays — it's accurate disclosure) |
| `[ATTORNEY REVIEW]` blockquotes | Remove entire blockquote |
| `[PLACEHOLDER: OAuth]` etc. | Replace with brief "Coming soon" note OR omit if it would be confusing |
| `---` section dividers | Keep — they aid readability |
| Version/date headers | Keep — `Version: 1.0` and date are public-facing metadata |

### What to KEEP in the published version

- All `[PENDING T05]` / `[PENDING T06]` body text that describes the CURRENT accurate state (e.g., "tokens currently stored in localStorage"; "local copy not currently encrypted at rest") — these are accurate disclosures, not internal notes
- All `[PLACEHOLDER: OAuth]` text that is a genuine user-facing notice ("When Google login is added...") can be kept as is
- All retention periods, processor tables, rights tables — keep verbatim
- GDPR CYA sections — keep (same reason as CCPA: coverage, not targeting)
