# SEO Passthrough & Passdown Document

**Purpose:** This document tracks the review of the current SEO implementation in the `finance_manager_web` React SPA, details the strategies to maximize search visibility in the Philippine market, and outlines the exact code changes passed down to the execution agent (**Cursor Pro+**) to implement during the feature sprint.

**Strategic Link:** `plans/S1/S1.B/distribution-channel-research/README.md` (PLAN_RESEARCH_DISTRIBUTION_CHANNEL_2026-04-30)
**Ecosystem Bar:** Part of the interconnected **Definition of Done** (§3 SEO Gate) in `governance/definition_of_done.md`.

---

## 1. Executive Summary & Review

As of June 2026, the `finance_manager_web` React SPA has implemented the **SEO P0** baseline during the PWA sprint:
- **`index.html`** contains primary meta/Open Graph tags, georegion targeting (PH/Philippines), canonical URL settings, and structured JSON-LD schemas (`SoftwareApplication` and `Organization`).
- **`robots.txt`** blocks crawling of `/app/*` paths and directs search engines to the sitemap.
- **`sitemap.xml`** maps the primary public landing routes: `/`, `/signup`, and `/login`.
- **`react-helmet-async`** is configured and active on `LandingPage.tsx` to handle dynamic localized title/description tags.

### Gaps Identified & Opportunities to Maximize SEO:
1. **No SEO Metadata on Auth pages:** `LoginPage.tsx` and `SignupPage.tsx` are public entry points defined in the sitemap but completely lack `<Helmet>` dynamic tags. They inherit whatever fallback tags are in `index.html`.
2. **Missing Localized Meta Keys:** The locale helper (`i18n.ts`) contains SEO keys for the landing page (`landing.seo.title` / `landing.seo.desc`) but nothing for the login and signup routes.
3. **URL Consistency:** We must ensure trailing slash uniformity across all canonical `<link>` and Open Graph tags.

---

## 2. Refined SEO Strategies & Guidance

### 2.1 SPA Speculation Rules Warning
According to modern web development standards, **Speculation Rules (prefetch/prerender)** must **NOT** be used inside Single Page Applications (SPAs). 
- *Why:* Speculation rules are designed for Multi-Page Applications (MPAs) that perform browser-level document navigations. 
- *Strategy:* Instead of speculative prefetching, we will continue to rely on **prerendering public routes at build-time** (Option B: `vite-ssg` or similar) in future gates (P2) to ensure Googlebot reads fully populated HTML rather than an empty `<div id="root"></div>`.

### 2.2 Core Web Vitals (CWV) Optimization
To maximize ranking signals for public pages:
1. **LCP (Largest Contentful Paint)**: Ensure that the main visual elements on the public landing page (like the hero dashboard preview screenshot) do not use lazy-loading (`loading="lazy"`). Instead, they should default to eager loading and employ `fetchpriority="high"` to tell the browser's scanner to fetch them immediately.
2. **INP (Interaction to Next Paint)**: Keep JavaScript main-thread tasks under 50ms. If heavy rendering or data processing occurs (such as ledger calculation on hydration), utilize the modern yielding API `scheduler.yield()` (with a fallback promise) to release the thread and respond immediately to user interactions.

---

## 3. Passdown Tasks for Cursor Pro+ (Execution Phase)

The following ticket-sized slices are passed down to **Cursor Pro+** for implementation.

### Task Slice T16.SL1: Localized SEO Translation Keys
**Target File:** [`finance_manager_web/src/lib/i18n.ts`](file:///home/pproctor/Documents/python/finance_manager/finance_manager_web/src/lib/i18n.ts)

Add the following localized keys to `MESSAGES` in both `"en-US"` and `"tl-PH"` blocks to support custom meta titles and descriptions for the authentication routes.

```diff
  "en-US": {
    "landing.seo.title": "Hive | Secure, Offline-First Personal Finance",
    "landing.seo.desc": "A private, local-first personal finance app. Track bills, budgets, and accounts with total clarity. No ads, no data selling, just your money under your control.",
+   "login.seo.title": "Sign In | Hive Financial Manager — Track GCash & Maya",
+   "login.seo.desc": "Log in to your Hive Financial Manager account. Secure, private, and offline-first personal budgeting for Filipino households.",
+   "signup.seo.title": "Create Account | Hive Financial Manager — Start Budgeting Free",
+   "signup.seo.desc": "Start tracking your GCash, Maya, and bank expenses. Sign up for a free Hive Financial Manager account today.",
```

```diff
  "tl-PH": {
    "landing.seo.title": "Hive | Secure, Offline-First Personal Finance",
    "landing.seo.desc": "Isang pribado at local-first na personal finance app. Subaybayan ang mga bill, budget, at account nang malinaw. Walang ads, walang pagbenta ng data, tanging ang iyong pera sa ilalim ng iyong kontrol.",
+   "login.seo.title": "Mag-sign In | Hive Financial Manager — I-track ang GCash at Maya",
+   "login.seo.desc": "Mag-log in sa iyong Hive Financial Manager account. Secure, pribado, at offline-first na budget tracker para sa pamilyang Pilipino.",
+   "signup.seo.title": "Gumawa ng Account | Hive Financial Manager — Magsimula Nang Libre",
+   "signup.seo.desc": "Subaybayan ang iyong GCash, Maya, at mga bank account. Gumawa ng libreng Hive Financial Manager account ngayon.",
```

---

### Task Slice T16.SL2: Dynamic Helmet Tags on Login & Signup
Integrate `<Helmet>` in `LoginPage.tsx` and `SignupPage.tsx` to mount unique, localized title and description metadata dynamically.

#### Modify: [`finance_manager_web/src/pages/LoginPage.tsx`](file:///home/pproctor/Documents/python/finance_manager/finance_manager_web/src/pages/LoginPage.tsx)
```diff
  import { useSession } from "../state/SessionContext";
  import type { ReactNode } from "react";
+ import { Helmet } from "react-helmet-async";
  
  export function LoginPage(): ReactNode {
    const locale = useLocale();
...
    return (
      <section className="stack auth-shell auth-shell--login">
+       <Helmet>
+         <title>{tr("login.seo.title", locale) || "Sign In | Hive Financial Manager"}</title>
+         <meta name="description" content={tr("login.seo.desc", locale) || "Log in to your Hive Financial Manager account."} />
+         <link rel="canonical" href="https://thehivemanager.com/login" />
+       </Helmet>
        <h1 className="auth-shell__title">{tr("login.title", locale)}</h1>
```

#### Modify: [`finance_manager_web/src/pages/SignupPage.tsx`](file:///home/pproctor/Documents/python/finance_manager/finance_manager_web/src/pages/SignupPage.tsx)
```diff
  import { useSession } from "../state/SessionContext";
  import type { ReactNode } from "react";
+ import { Helmet } from "react-helmet-async";
  
  export function SignupPage(): ReactNode {
    const locale = useLocale();
...
    return (
      <section className="stack auth-shell auth-shell--signup">
+       <Helmet>
+         <title>{tr("signup.seo.title", locale) || "Create Account | Hive Financial Manager"}</title>
+         <meta name="description" content={tr("signup.seo.desc", locale) || "Create your free Hive Financial Manager account."} />
+         <link rel="canonical" href="https://thehivemanager.com/signup" />
+       </Helmet>
        <h1 className="auth-shell__title">{tr("signup.title", locale)}</h1>
```

---

## 4. Verification Plan

After Cursor Pro+ completes the code modifications, verification will follow:

### 1. Build and Lint Checks
Ensure the React bundle compiles cleanly and respects lint rules:
```bash
npm run lint
npm run build
```

### 2. Manual DOM Inspection
1. Run the local dev server and navigate to `/login` and `/signup`.
2. Inspect the `<head>` of the page using browser Developer Tools.
3. Confirm that `<title>` and `<meta name="description">` change dynamically according to the route.
4. Toggle the UI language (from English to Taglish) and verify the metadata translates correctly.
