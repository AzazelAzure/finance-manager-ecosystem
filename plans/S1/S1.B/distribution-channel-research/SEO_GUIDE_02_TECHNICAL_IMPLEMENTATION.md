# SEO Guide 02 — Technical Implementation for finance_manager_web

**Purpose:** Actionable code-level changes to make our React/Vite SPA visible to search engines. This is the "how to fix it" companion to Guide 01.

**Sprint link:** Each section below maps to a ticket-sized unit of work. When a feature sprint touches public routes, reference this guide's relevant section.

**Current audit summary:**
- `index.html`: No meta description, no OG tags, generic `<title>`, no structured data, no sitemap, no `robots.txt`
- Rendering: Pure CSR — Google sees an empty `<div id="root"></div>`
- Routes: Uses `react-router-dom` with `BrowserRouter` (good — no hash routing)

---

## 1. Quick Wins (Do First — Minimal Effort, Immediate Impact)

### 1.1 Fix `index.html` (< 30 minutes)

The current `index.html` is critically bare. At minimum, add:

```html
<!doctype html>
<html lang="en" data-theme="light">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <!-- SEO: Primary meta tags -->
    <title>Finance Manager — Free Personal Budget Tracker for Filipinos</title>
    <meta name="description" content="Track your GCash, Maya, and bank expenses automatically. Free budgeting app built for Filipino households. Start saving today." />

    <!-- SEO: Open Graph (Facebook/social sharing) -->
    <meta property="og:type" content="website" />
    <meta property="og:title" content="Finance Manager — Free Budget Tracker for Filipinos" />
    <meta property="og:description" content="Track GCash, Maya, and bank expenses. Built for Filipino families." />
    <meta property="og:url" content="https://thehivemanager.com" />
    <meta property="og:image" content="https://thehivemanager.com/og-image.png" />

    <!-- SEO: Twitter Card -->
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:title" content="Finance Manager — Free Budget Tracker" />
    <meta name="twitter:description" content="Track GCash, Maya, and bank expenses. Built for Filipino families." />

    <!-- SEO: Canonical URL -->
    <link rel="canonical" href="https://thehivemanager.com/" />

    <!-- SEO: Language/Region targeting -->
    <meta name="geo.region" content="PH" />
    <meta name="geo.placename" content="Philippines" />
    <link rel="alternate" hreflang="en-ph" href="https://thehivemanager.com/" />
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
```

**File:** [index.html](file:///home/pproctor/Documents/python/finance_manager/finance_manager_web/index.html)

### 1.2 Add `robots.txt` (< 5 minutes)

Create `public/robots.txt`:

```
User-agent: *
Allow: /
Disallow: /app/
Sitemap: https://thehivemanager.com/sitemap.xml
```

This tells crawlers:
- Crawl public pages (landing, login, signup)
- Do NOT crawl authenticated app routes (`/app/*`)
- Here's where the sitemap lives

### 1.3 Add `sitemap.xml` (< 15 minutes)

Create `public/sitemap.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://thehivemanager.com/</loc>
    <changefreq>weekly</changefreq>
    <priority>1.0</priority>
  </url>
  <url>
    <loc>https://thehivemanager.com/signup</loc>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>
  <url>
    <loc>https://thehivemanager.com/login</loc>
    <changefreq>monthly</changefreq>
    <priority>0.5</priority>
  </url>
</urlset>
```

> [!NOTE]
> As we add public pages (blog, pricing, about), add them here. Consider automating sitemap generation in the build pipeline later (see §4).

---

## 2. Structured Data / JSON-LD (Medium Effort)

Structured data tells Google *what* our app is, not just what the page says. This can trigger rich snippets in search results (star ratings, pricing, etc.).

### 2.1 SoftwareApplication Schema

Add this to `index.html` inside `<head>`:

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "SoftwareApplication",
  "name": "Finance Manager",
  "operatingSystem": "Web, Android",
  "applicationCategory": "FinanceApplication",
  "description": "Free personal finance management app for Filipino households. Track GCash, Maya, and bank expenses automatically.",
  "offers": {
    "@type": "Offer",
    "price": "0.00",
    "priceCurrency": "PHP",
    "category": "Free"
  },
  "author": {
    "@type": "Organization",
    "name": "The Hive Manager",
    "url": "https://thehivemanager.com"
  },
  "inLanguage": "en",
  "countriesSupported": "PH"
}
</script>
```

### 2.2 Organization Schema

Establishes brand identity for Google's Knowledge Graph:

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "The Hive Manager",
  "url": "https://thehivemanager.com",
  "logo": "https://thehivemanager.com/favicon.svg",
  "sameAs": [
    "https://www.facebook.com/thehivemanager"
  ],
  "contactPoint": {
    "@type": "ContactPoint",
    "contactType": "customer support",
    "availableLanguage": ["English", "Filipino"]
  }
}
</script>
```

> [!TIP]
> **Validate your schema** after adding it using [Google's Rich Results Test](https://search.google.com/test/rich-results) or the [Schema Markup Validator](https://validator.schema.org/).

---

## 3. Dynamic Meta Tags with `react-helmet-async` (Medium Effort)

Since our SPA has multiple public routes (/, /login, /signup), each should have unique meta tags. Install and use `react-helmet-async`:

```bash
npm install react-helmet-async
```

### 3.1 Wrap the app

In `main.tsx`:
```tsx
import { HelmetProvider } from 'react-helmet-async';

// Wrap <App /> with <HelmetProvider>
<HelmetProvider>
  <BrowserRouter>
    <App />
  </BrowserRouter>
</HelmetProvider>
```

### 3.2 Per-page usage

In `LandingPage.tsx`:
```tsx
import { Helmet } from 'react-helmet-async';

export function LandingPage() {
  return (
    <>
      <Helmet>
        <title>Finance Manager — Free Personal Budget Tracker for Filipinos</title>
        <meta name="description" content="Track your GCash, Maya, and bank expenses automatically. Free budgeting app built for Filipino households." />
        <link rel="canonical" href="https://thehivemanager.com/" />
      </Helmet>
      <div className="landing-page">
        {/* existing components */}
      </div>
    </>
  );
}
```

In `SignupPage.tsx`:
```tsx
<Helmet>
  <title>Sign Up — Finance Manager | Start Tracking Your Budget Free</title>
  <meta name="description" content="Create your free Finance Manager account. Track GCash, Maya, and bank transactions in one place." />
  <link rel="canonical" href="https://thehivemanager.com/signup" />
</Helmet>
```

> [!IMPORTANT]
> `react-helmet-async` only helps when Google executes our JavaScript (second-wave crawl). For first-wave crawl visibility, the `index.html` meta tags serve as the fallback. This is why §1.1 matters even with Helmet installed.

---

## 4. Prerendering Strategy (Higher Effort — Future Sprint)

For the best SEO results, we should prerender public routes so Googlebot gets full HTML on the first request.

### Option A: `vite-plugin-ssr` / `vike`
- Full SSR/SSG framework for Vite
- Can selectively prerender only public routes
- Keeps the SPA behavior for authenticated routes

### Option B: Build-time prerendering with `vite-ssg`
- Generates static HTML at build time for each route
- Simpler than full SSR
- Works well for our small number of public routes (3-5 pages)

### Option C: Separate marketing site (Astro/Next.js)
- Host the landing page, blog, and marketing content on a separate lightweight stack
- The React SPA lives at `/app/` or a subdomain
- Best SEO but highest architectural overhead

**Recommendation for our scale:** Start with **Option B** (`vite-ssg`) when we have bandwidth. It's the lowest-effort path to prerendered public pages without rearchitecting the entire app.

---

## 5. Core Web Vitals Checklist

Google uses these as ranking signals. Check them at [PageSpeed Insights](https://pagespeed.web.dev/):

| Metric | What It Measures | Target | How to Improve |
| --- | --- | --- | --- |
| **LCP** (Largest Contentful Paint) | How fast the main content loads | < 2.5s | Optimize images, reduce JS bundle, preload fonts |
| **INP** (Interaction to Next Paint) | How responsive the page is to user input | < 200ms | Reduce main thread work, code-split aggressively |
| **CLS** (Cumulative Layout Shift) | Visual stability — do things jump around? | < 0.1 | Set explicit dimensions on images/embeds, avoid late-injected content |

### Quick performance wins for our stack:
- **Code-split** with `React.lazy()` for page-level components
- **Preload** the Inter font (already in `@fontsource-variable/inter`)
- **Compress images** — use WebP format for any screenshots/previews
- **Tree-shake** unused Lucide icons (they bundle individually, so this should be fine)

---

## 6. Google Search Console Setup (Do Early)

1. Go to [Google Search Console](https://search.google.com/search-console)
2. Add property: `https://thehivemanager.com`
3. Verify ownership via DNS TXT record or HTML file in `/public/`
4. Submit `sitemap.xml`
5. Use "URL Inspection" to check if Google can render the landing page

> [!CAUTION]
> **Do this even before the app is public.** It takes time for Google to start crawling and indexing. Starting early means we build index authority before we need traffic.

---

## 7. Implementation Priority (Sprint Backlog)

| Priority | Task | Effort | Sprint |
| --- | --- | --- | --- |
| P0 | Fix `index.html` meta tags (§1.1) | 30 min | Next available |
| P0 | Add `robots.txt` (§1.2) | 5 min | Next available |
| P0 | Add `sitemap.xml` (§1.3) | 15 min | Next available |
| P1 | Add JSON-LD structured data (§2) | 1 hr | Next available |
| P1 | Register Google Search Console (§6) | 30 min | Next available |
| P2 | Install `react-helmet-async` (§3) | 2 hrs | S1.B or S1.C |
| P3 | Implement prerendering (§4) | 4-8 hrs | S1.C |
| P3 | Core Web Vitals audit (§5) | 2-4 hrs | S1.C |

---

**Previous:** [SEO_GUIDE_01_FOUNDATIONS.md](./SEO_GUIDE_01_FOUNDATIONS.md)
**Next:** [SEO_GUIDE_03_CONTENT_AND_KEYWORDS.md](./SEO_GUIDE_03_CONTENT_AND_KEYWORDS.md)
