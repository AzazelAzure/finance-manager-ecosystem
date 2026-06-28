# SEO Guide 01 — Foundations & Concepts

**Purpose:** A from-zero introduction to SEO for the Finance Manager ecosystem. Read this first before touching any code. This guide explains *what* matters and *why*, so that implementation decisions (Guide 02) and ongoing optimization (Guide 03) make sense.

**Sprint link:** This guide feeds into every future S1.B/S1.C feature sprint that touches public-facing pages. Reference it when building new routes or landing content.

---

## 1. What Is SEO and Why Does It Matter for Us?

SEO (Search Engine Optimization) is the practice of making your website appear in organic (unpaid) search results when people search for something relevant.

**Why it's critical for us specifically:**
- Our ad economics are brutal. Google Search CPC for finance in the PH is ~₱195 per *click*. With a ₱249/mo Pro subscription, paid acquisition is deeply unprofitable until LTV proves out over many months.
- SEO is **free traffic**. Every user who finds us via Google search costs us ₱0 in acquisition.
- SEO compounds over time. A well-optimized page can generate traffic for years without ongoing spend.

## 2. The Three Pillars of SEO

### Pillar 1: Technical SEO
Can Google actually *find and read* your pages?

- **Crawlability**: Can Googlebot discover your pages by following links?
- **Indexability**: Once found, can the page be added to Google's index?
- **Renderability**: Can Google execute your JavaScript to see the actual content?

> [!WARNING]
> **Our current state is essentially invisible to Google.** The `index.html` file contains only `<div id="root"></div>`. When Googlebot fetches our page without executing JavaScript, it sees *nothing*. This is the single biggest SEO problem we have and must be solved before any other optimization matters.

### Pillar 2: On-Page SEO
Is the content on each page optimized for the keywords people actually search for?

- **Title tags** — The `<title>` element is the single most important on-page ranking signal
- **Meta descriptions** — The snippet shown in search results (doesn't directly affect ranking, but affects click-through rate)
- **Heading structure** — Proper `<h1>` → `<h2>` → `<h3>` hierarchy
- **Content quality** — Does the page actually answer what someone searched for?
- **Internal linking** — Do pages link to each other logically?

### Pillar 3: Off-Page SEO
Does the internet trust your site?

- **Backlinks** — Other websites linking to you (signals authority)
- **Brand mentions** — People talking about you online
- **Social signals** — Shares and engagement (indirect effect)

## 3. YMYL: Why Finance Is Harder

Google classifies financial content as **YMYL** (Your Money, Your Life). These are topics where bad information could directly harm users financially. Google applies **much stricter quality standards** to YMYL content.

### E-E-A-T (Experience, Expertise, Authoritativeness, Trustworthiness)

For a PFM app, Google wants to see:
- **Experience**: Does the content creator have real-world experience with personal finance?
- **Expertise**: Is the content written by someone who knows what they're talking about?
- **Authoritativeness**: Is the site/brand recognized as a credible source?
- **Trustworthiness**: Is the site secure (HTTPS), transparent (privacy policy, contact info), and honest?

**What this means practically:**
- Every public page needs clear authorship and company transparency
- Security features (HTTPS, data encryption) must be visible and documented
- Privacy policy and terms of service are not just legal checkboxes — they're ranking signals
- Testimonials and trust badges matter more for finance than for, say, a recipe site

## 4. How Google Handles SPAs (Our Architecture)

Our app is a React SPA (Single Page Application) built with Vite. Here's the problem:

```
What Google sees when it fetches our page:
┌─────────────────────────────────────┐
│ <html>                              │
│   <head>                            │
│     <title>finance_manager_web</title> │
│   </head>                           │
│   <body>                            │
│     <div id="root"></div>           │  ← This is ALL Google sees initially
│     <script src="main.tsx"></script> │
│   </body>                           │
│ </html>                             │
└─────────────────────────────────────┘
```

Google *can* execute JavaScript (it uses a headless Chromium), but:
- It's a **second-wave crawl** — there's a delay between discovery and JS rendering
- Not all bots execute JS (social media scrapers like Facebook/Twitter don't)
- Rendering JS at scale is expensive for Google, so complex SPAs may be deprioritized

### Solutions (ranked by effectiveness):

| Approach | Description | Effort | SEO Benefit |
| --- | --- | --- | --- |
| **SSR/SSG** (Next.js, Remix, Astro) | Server renders full HTML on every request | High (architecture change) | Best |
| **Prerendering** (vite-ssg, Puppeteer) | Build-time HTML snapshots for each route | Medium | Very Good |
| **Dynamic rendering** | Serve prerendered HTML to bots, SPA to users | Medium | Good |
| **Meta tag injection only** | Add meta tags to `index.html` but keep SPA | Low | Minimal |

> [!TIP]
> **Recommended path for us:** Since our app is behind authentication (dashboard, transactions, etc.), only the **public-facing pages** (Landing, Login, Signup) need SEO treatment. A practical approach is to **prerender only the public routes** and leave the authenticated SPA as-is. This gives us 80% of the benefit at 20% of the effort.

## 5. Keywords 101 — What People Actually Search

Keywords are the words/phrases people type into Google. They have different "intents":

| Intent Type | Example | What They Want | Our Opportunity |
| --- | --- | --- | --- |
| **Informational** | "how to budget in Philippines" | Learn something | Blog/guide content |
| **Navigational** | "GCash expense tracker" | Find a specific product | Brand awareness |
| **Commercial** | "best budgeting app Philippines" | Compare options | Landing page / reviews |
| **Transactional** | "download budget tracker app free" | Take action now | Signup / app store |

### Long-Tail Keywords (Our Sweet Spot)

Short keywords like "budget app" are dominated by massive companies (Mint, YNAB). We will never rank for those.

**Long-tail keywords** are longer, more specific phrases with less competition but higher conversion rates:

| Competitor Keyword (Avoid) | Long-Tail Alternative (Target) |
| --- | --- |
| "budget app" | "free budget tracker app Philippines GCash" |
| "expense tracker" | "how to track GCash and Maya expenses automatically" |
| "personal finance" | "personal finance tips for Filipino first-time earners" |

## 6. Key Metrics to Track

Once SEO work begins, these are the numbers that matter:

| Metric | What It Tells You | Where to See It |
| --- | --- | --- |
| **Impressions** | How often you appear in search results | Google Search Console |
| **Clicks** | How many people click through to your site | Google Search Console |
| **CTR** (Click-Through Rate) | % of impressions that became clicks | Google Search Console |
| **Average Position** | Where you rank on average for queries | Google Search Console |
| **Indexed Pages** | How many of your pages Google has indexed | Google Search Console |
| **Core Web Vitals** | Page speed and user experience scores | PageSpeed Insights / GSC |

## 7. Glossary of Terms

| Term | Definition |
| --- | --- |
| **SERP** | Search Engine Results Page — what you see after searching |
| **Crawl** | When Googlebot visits your page to read its content |
| **Index** | Google's database of all pages it knows about |
| **Canonical URL** | The "official" URL for a page when duplicates exist |
| **Sitemap** | An XML file listing all your pages for Google to discover |
| **robots.txt** | A file telling bots which pages they can/cannot crawl |
| **Backlink** | A link from another website pointing to yours |
| **Schema / Structured Data** | Machine-readable metadata (JSON-LD) that helps Google understand your page |
| **Core Web Vitals** | Google's page experience metrics (LCP, CLS, INP) |
| **SSR** | Server-Side Rendering — the server sends fully rendered HTML |
| **SSG** | Static Site Generation — HTML is pre-built at deploy time |
| **CSR** | Client-Side Rendering — the browser builds the page via JavaScript |

---

**Next:** [SEO_GUIDE_02_TECHNICAL_IMPLEMENTATION.md](./SEO_GUIDE_02_TECHNICAL_IMPLEMENTATION.md) — Specific code changes and tooling for our React/Vite stack.
