# SEO Priority Matrix

**Purpose:** Single reference for what SEO work to do and when. Gated by development phase and linked to the detailed guides. Reference this file at the start of every feature sprint that touches public-facing pages.

**Rollout bar:** This matrix is part of ecosystem **definition of done** — see [`governance/definition_of_done.md`](../../../governance/definition_of_done.md) §3 (P0 in-PR when touching listed files; tier updates at rollout close).

**Decision (2026-05-03):** SEO P0 quick wins ride with the **PWA sprint** (next sprint). All other SEO work is deferred to the appropriate phase gate below.

---

## Priority Tiers

### P0 — Ride with PWA Sprint (< 1 hour total)

These items have zero architectural conflict with PWA work and should be committed as a side task during the PWA sprint.


| Task                                                             | File(s) Touched                          | Est. Time | Guide Reference                                             | Status                                |
| ---------------------------------------------------------------- | ---------------------------------------- | --------- | ----------------------------------------------------------- | ------------------------------------- |
| Fix `index.html` meta tags, OG tags, canonical URL               | `finance_manager_web/index.html`         | 30 min    | [Guide 02 §1.1](./SEO_GUIDE_02_TECHNICAL_IMPLEMENTATION.md) | **DONE** (2026-05-03, PWA sprint T04) |
| Add `robots.txt` (block `/app/`, allow public routes)            | `finance_manager_web/public/robots.txt`  | 5 min     | [Guide 02 §1.2](./SEO_GUIDE_02_TECHNICAL_IMPLEMENTATION.md) | **DONE** (2026-05-03)                 |
| Add `sitemap.xml` (3 public routes)                              | `finance_manager_web/public/sitemap.xml` | 15 min    | [Guide 02 §1.3](./SEO_GUIDE_02_TECHNICAL_IMPLEMENTATION.md) | **DONE** (2026-05-03)                 |
| Add JSON-LD structured data (SoftwareApplication + Organization) | `finance_manager_web/index.html`         | 15 min    | [Guide 02 §2](./SEO_GUIDE_02_TECHNICAL_IMPLEMENTATION.md)   | **DONE** (2026-05-03)                 |


---

### P1 — S1.B Late / S1.C Entry (2-3 hours)

Do these when the PWA sprint is closed and before public-facing feature work begins.


| Task                                                          | File(s) Touched                                                  | Est. Time | Guide Reference                                           | Status |
| ------------------------------------------------------------- | ---------------------------------------------------------------- | --------- | --------------------------------------------------------- | ------ |
| Register Google Search Console, verify domain, submit sitemap | External (Google)                                                | 30 min    | [Guide 02 §6](./SEO_GUIDE_02_TECHNICAL_IMPLEMENTATION.md) | `TODO` |
| Install `react-helmet-async`, per-route meta tags             | `main.tsx`, `LandingPage.tsx`, `SignupPage.tsx`, `LoginPage.tsx` | 2 hrs     | [Guide 02 §3](./SEO_GUIDE_02_TECHNICAL_IMPLEMENTATION.md) | `TODO` |


---

### P2 — T-6 Months Before Public Launch (4-8 hours)

Do these when the product is approaching public beta readiness.


| Task                                                                | File(s) Touched                  | Est. Time | Guide Reference                                           | Status     |
| ------------------------------------------------------------------- | -------------------------------- | --------- | --------------------------------------------------------- | ---------- |
| Implement prerendering for public routes (`vite-ssg` or equivalent) | `vite.config.ts`, build pipeline | 4-8 hrs   | [Guide 02 §4](./SEO_GUIDE_02_TECHNICAL_IMPLEMENTATION.md) | `DEFERRED` |
| Core Web Vitals audit and optimization                              | Various (bundle, images, fonts)  | 2-4 hrs   | [Guide 02 §5](./SEO_GUIDE_02_TECHNICAL_IMPLEMENTATION.md) | `DEFERRED` |
| Begin blog/educational content (Clusters 3, 5 — informational)      | New public routes / CMS          | Ongoing   | [Guide 03 §2, §3](./SEO_GUIDE_03_CONTENT_AND_KEYWORDS.md) | `DEFERRED` |


---

### P3 — T-3 Months Before Public Launch (Ongoing)


| Task                                                          | File(s) Touched      | Est. Time | Guide Reference                                           | Status     |
| ------------------------------------------------------------- | -------------------- | --------- | --------------------------------------------------------- | ---------- |
| Feature-focused content (Clusters 1, 2 — GCash/Maya tracking) | Blog / feature pages | Ongoing   | [Guide 03 §2, §3](./SEO_GUIDE_03_CONTENT_AND_KEYWORDS.md) | `DEFERRED` |
| Competitor comparison articles                                | Blog                 | Ongoing   | [Guide 03 §3](./SEO_GUIDE_03_CONTENT_AND_KEYWORDS.md)     | `DEFERRED` |
| Link building outreach (r/phinvest, guest posts, press)       | External             | Ongoing   | [Guide 03 §5](./SEO_GUIDE_03_CONTENT_AND_KEYWORDS.md)     | `DEFERRED` |


---

### Ongoing — Every Sprint (Per-Sprint SEO Checklist)

Run this if the sprint touched any public-facing page:

- Check Google Search Console for new crawl errors
- Update `sitemap.xml` if new public routes were added
- Run PageSpeed Insights on modified public pages
- Verify meta tags are unique and keyword-targeted per [Guide 03 §4](./SEO_GUIDE_03_CONTENT_AND_KEYWORDS.md)

---

## Cross-References


| Document                                                                               | Purpose                                        |
| -------------------------------------------------------------------------------------- | ---------------------------------------------- |
| [SEO_GUIDE_01_FOUNDATIONS.md](./SEO_GUIDE_01_FOUNDATIONS.md)                           | Concepts, YMYL, SPA challenges, glossary       |
| [SEO_GUIDE_02_TECHNICAL_IMPLEMENTATION.md](./SEO_GUIDE_02_TECHNICAL_IMPLEMENTATION.md) | Code-level changes, tooling, sprint backlog    |
| [SEO_GUIDE_03_CONTENT_AND_KEYWORDS.md](./SEO_GUIDE_03_CONTENT_AND_KEYWORDS.md)         | Keyword clusters, content calendar, checklists |
| [DECISION_MATRIX.md](./DECISION_MATRIX.md)                                             | Marketing timeline gating (Matrix 5)           |
| [DISTRIBUTION_RESEARCH_NOTES.md](./DISTRIBUTION_RESEARCH_NOTES.md)                     | Ad cost benchmarks justifying SEO-first        |


---

*Last updated: 2026-05-03. Revisit priority tiers at each phase transition.*