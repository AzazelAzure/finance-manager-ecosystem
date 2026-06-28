# UI/UX Research Brief — Hive Financial Manager (thehivemanager.com)

**Prepared for:** Solo developer + AI coding agents (Claude Code, Cursor)
**Stack context:** React PWA · dark mode base `#0f172a` (deep blue/purple) · off-white light mode · target Philippine market · eventual PC/Android/iOS parity · optional Rust/WASM
**Date:** June 25, 2026

---

## TL;DR

- **The single biggest lever on "does this look like a real product or a side project" is restraint plus precision: a strict 4px/8px spacing grid, one tabular-figure typeface for all money, a semantic color system where green/amber/red mean budget *pace* (not decoration), and sub-200ms interaction responsiveness.** Build the design system first (tokens in CSS variables), then screens — using shadcn/ui + Radix + Tailwind v4 + Recharts as the spine, and Motion (formerly Framer Motion) only for purposeful micro-interactions.
- **For the Philippine market, performance IS the UX:** median mobile download speed is 35.56 Mbps (roughly half the global average), and a large share of users are on mid/low-end Android. Budget for ≤200KB initial JS, offline-first via service worker + IndexedDB (Dexie), a manual-entry-first onboarding (don't force bank linking), and a sub-2.5s LCP on a throttled mid-tier phone. This is where most "professional-looking" Western fintech UIs actually fall down locally.
- **WASM/Rust is worth it for exactly one thing at your stage — a precise money/calculation engine** (integer-cents math, budget projections, amortization) compiled with wasm-pack/wasm-bindgen — and over-engineering for almost everything else (DOM, routing, simple aggregation). Realistically you can ship a world-class product without WASM at all; treat it as a v2 performance/correctness investment, not a v1 requirement.

---

## Key Findings

1. **Professional fintech UI is a trust-architecture problem, not a decoration problem.** The benchmark for data-dense financial UI is the Bloomberg Terminal principle — "every pixel is accountable" — not a friendly consumer toy. Users decide whether to trust a money app in the first seconds, based on typography weight, spacing consistency, color precision, and micro-interaction quality.
2. **Copilot Money is the design north star** (Apple Design Award *finalist* 2024, Interaction category — a finalist, not winner; the Interaction winners were Crouton and Rytmos). Its signature is adaptive, data-driven color (green→orange→red encoding budget pace) and animated budget dials. Monarch Money is the best model for a *customizable widget dashboard*; Rocket Money for an *at-a-glance balance strip + cards* hierarchy; YNAB for a *rigorously documented semantic color system* with accessibility fixes.
3. **The modern React fintech stack has consolidated:** shadcn/ui (copy-in components you own) on Radix UI primitives (accessibility/behavior) styled with Tailwind CSS v4 (OKLCH color tokens), charts via Recharts (shadcn's default; good to ~1,000 points) or ECharts/Lightweight Charts for heavy/financial data, animation via Motion, server state via TanStack Query, client state via Zustand.
4. **PWA in 2025/2026 is genuinely viable but has a hard iOS ceiling.** Push notifications work on iOS 16.4+ *only* if installed to home screen; no Background Sync on iOS; storage can be evicted. Capacitor is the pragmatic bridge to App Store/Play Store with the same codebase; Tauri 2.0 is the lighter option especially for desktop.
5. **Money math must never touch floating point.** Store integer minor units (centavos), use a dedicated money type (currency.js / Dinero.js in JS, or rust_decimal/currency_rs if you go WASM). This is non-negotiable for a finance app and is a common amateur failure.
6. **Philippine context creates specific design obligations:** GCash (over 94 million users in a nation of ~112 million) and Maya define user expectations; QR Ph is the national standard; the Data Privacy Act (RA 10173) + National Privacy Commission impose 72-hour breach notification, DPO appointment, and privacy-by-design even on a non-regulated personal-finance tool that processes sensitive data.

---

## Details

### 1. Modern UI Design Principles for Finance Apps

**What separates pro from amateur:**

- **Visual hierarchy by importance, not decoration.** The primary number on any screen (balance, net worth, "safe to spend") gets the most visual weight — large size, tabular figures, generous surrounding whitespace. Everything else recedes. Copilot, Monarch, and Rocket Money all lead each screen with one dominant number.
- **A strict spacing system.** Use a 4px base unit (Tailwind's default scale: 4/8/12/16/24/32...). Inconsistent spacing is the #1 tell of amateur work. Define spacing tokens and never hand-pick arbitrary pixel values. Card padding, gaps between list rows, and section margins should each have a single canonical value.
- **Typography: one family, tabular figures for money.** Use a clean geometric/grotesque sans (Inter, Plus Jakarta Sans, or the platform system font SF Pro/Roboto) and — critically — enable `font-variant-numeric: tabular-nums` (or a monospaced numeric like Geist Mono / SF Mono) for ALL monetary values so digits align vertically in columns and don't "jitter" when updating. Note: the "Plus Jakarta Sans + Geist Mono" pairing is used by Robinhood-inspired React templates (Colorlib's "Vault"/"Fortress"), not by Copilot/Monarch themselves — but it is an excellent, proven pairing to adopt. Limit to 2 weights + 1 numeric treatment. Type scale: roughly 12/14/16/20/24/32/48 with 1.4–1.5 line height for body.
- **Color in financial contexts carries semantic weight.** Red is a *signal* (overspend, negative, action needed), not an accent. Build a semantic token layer: `--color-positive`, `--color-warning`, `--color-negative`, `--color-pending`, mapped to your base palette. YNAB's documented system is the model: green = on track, yellow = underfunded, red = cash overspending (immediate action), gray = neutral/zero; solid vs striped fills distinguish "assigned" from "spent." Copilot's dashboard lines: green if under ideal pace, light orange if within 20% of ideal, dark orange if >20% over ideal, red if over budget. **Never rely on color alone** — pair with icons, +/- signs, and labels (color-blindness + accessibility).
- **Data density vs. whitespace — be legible, not "simple."** Don't hide numbers behind cartoonish visuals; finance users came for data. Group related figures, give the hero number room, and use whitespace to separate action zones. Monarch's refresh deliberately *condensed* transaction row height to fit more rows on screen while improving contrast — density done right.
- **Dark mode is a first-class mode, not an inversion.** With base `#0f172a` (slate-900), build elevation via subtly lighter surface tokens (`#1e293b` card, `#334155` borders), use OKLCH for perceptually even tints, and tune chart/badge contrast specifically for dark backgrounds. Tailwind v4 + shadcn ship OKLCH tokens that switch via CSS variables with zero flash (pair with `next-themes` or a small theme provider).

### 2. Visual Benchmarks & Inspiration (concrete specifics)

**Copilot Money** — widely regarded as the best-designed budgeting UI. Native Swift/SwiftUI iOS app (so it inherits SF Pro; exact custom typeface unconfirmed). Tab structure: Dashboard, Transactions, Investments, Accounts, Categories, Recurrings, Goals. Dashboard is a "big-picture overview" of spending, income, recent transactions, monthly progress, upcoming recurrings, trending categories. Transaction feed uses emoji-style category icons (🍿 Entertainment, 🥑 Groceries, ☕️ Coffee) with a "Mark as reviewed" action and budget rollover. Praised micro-interactions: animated budget dials, smooth Face ID success confirmation, Swift Charts-powered Cash Flow. Onboarding is **manual-first** ("Take Copilot for a spin before you connect a single account") — an explicit, low-friction trust-builder — followed by contextual tooltips and a *soft* paywall with Editors' Choice badge + testimonials + clear trial timeline. iOS 26 "Liquid Glass" refresh improved both light and dark modes.

**Monarch Money** — best model for a **customizable drag-and-drop widget dashboard**. Cards: Getting started guide, Credit score, Budget, Net worth, Recurring transactions, Spending trend, Transactions, Investments, Advice — each removable/reorderable via a "Customize" button, independently configured on web vs mobile. Brand refresh retired the old navy-tinted "Navy Mode" dark theme for a neutral darker one, improved contrast, and condensed transaction rows. Micro-interactions: **confetti after creating a goal**, **swipe-to-review** transactions, interactive Sankey diagram reports where clicking a chart filters the transaction list inline. Uses a *hard* paywall with 7-day trial and a visual timeline of reminder/trial-end dates.

**Rocket Money** — model for **at-a-glance hierarchy**: "balance strip → Recurring tab → spending card → budget card," bottom nav (Budgets, Bills, Subscriptions, Goals). Functional rather than visually refined (vs Copilot), but the **iOS home-screen widget showing month-to-date spending** is singled out as a behavior-changing design choice. Full Dark Mode (System/Light/Dark) on iOS + Android. Onboarding asks financial-goal questions before linking accounts via Plaid.

**YNAB** — model for a **rigorous, documented, accessible semantic color system**. Budget "pills": green = on track, yellow = underfunded, red = cash overspending, gray = zero/neutral; solid colors = money assigned, striped = money spent. Register icons: green/gray "C" = cleared/uncleared, blue = needs approval, yellow = category needed. Notably, YNAB *fixed* WCAG contrast failures (white-on-orange was 2.54:1, white-on-green 3.31:1 vs the 4.5:1 requirement) by muting backgrounds, increasing contrast, and enlarging the negative sign so users don't depend on color alone — a directly copyable accessibility lesson. Offers redesigned default theme + classic + dark mode, with a two-layer semantic color system (base palette → semantic aliases) so colors adapt correctly to dark mode.

**What makes them all feel premium:** consistent type and spacing that look like "one team built this," one dominant number per screen, purposeful micro-interactions (not gratuitous motion), color that means something, and onboarding that delivers value before demanding bank credentials.

### 3. React-Specific Implementation

**Recommended core stack (opinionated):**

| Layer | Pick | Why | Caveat |
|---|---|---|---|
| Components | **shadcn/ui** | Copy-in code you fully own, no runtime dep lock-in, Tailwind-native, built on Radix; ~50KB-class bundles vs 200KB+ for Tremor/MUI | You maintain the code; keep a `components/ui/overrides` folder for heavy customization |
| Primitives | **Radix UI** | Battle-tested accessibility (ARIA, keyboard nav, focus mgmt) under shadcn | Pin versions; major bumps can change prop contracts |
| Styling | **Tailwind CSS v4** | OKLCH tokens, `@theme` directive, zero-flash dark mode via CSS vars | v4 migration differs from v3; use `tw-animate-css` |
| Charts | **Recharts** (default) | shadcn's chart layer is built on it; simple component API; SSR-friendly SVG; ~50KB gzipped | SVG frame rates drop past ~1,000 points — switch to **Apache ECharts** (Canvas/WebGL, 100k+ points) or **Lightweight Charts** for candlesticks if you add investments |
| Animation | **Motion** (formerly Framer Motion) | Declarative, layout animations, gestures, `AnimatePresence`; MIT license (irrevocable) | ~34–46KB gzipped (≈23% of a 200KB JS budget); use `LazyMotion` and respect `prefers-reduced-motion`. For lowest-end devices consider CSS-first or the lighter Motion core |
| Server state | **TanStack Query** | Caching, dedup, retries, optimistic updates, `refetchOnReconnect` (key for spotty PH networks) | Never duplicate server data into Zustand |
| Client state | **Zustand** | Minimal boilerplate, fast, scalable | Keep stores small/focused |
| Local DB / offline | **Dexie.js** (IndexedDB) | Promise API, `useLiveQuery` auto-rerenders UI on data change | Mind storage quotas |

**Honest pros/cons of the headline tools:**
- *shadcn/ui*: Pro — total ownership, lean, AI-agent-friendly (there's an official shadcn MCP/CLI agents can drive). Con — it's a scaffold, not a maintained library; updates are manual re-adds.
- *Recharts*: Pro — easiest path, integrates with shadcn theming/dark mode automatically. Con — SVG performance ceiling; for large transaction histories or real-time tickers you'll outgrow it.
- *Motion*: Pro — best DX, the de-facto standard (3.6M weekly downloads). Con — bundle weight matters on low-end Android; budget it.

**Non-React alternatives worth knowing (keep React primary):** SolidJS/Svelte are lighter-weight if you ever rebuild, but React's ecosystem (shadcn, Radix, the entire fintech template market) is the pragmatic choice for a solo dev who wants to "meet or exceed" the incumbents fast. There are open-source shadcn fintech dashboards (e.g., a Next.js + shadcn fintech dashboard with 11 pages, spending heatmap, animated SVG progress rings, budget projection) you can study directly.

### 4. WASM/Rust Integration for PWA Performance

**The honest framing:** WASM gives *consistent, predictable* compute performance (no JIT "falling off the fast path"), with documented 2–6x (image), 5–50x (CPU-heavy), but **minimal or negative gains for small inputs/IO-bound/DOM work**. One systematic study found WASM ~8–27x faster for extra-small/small inputs but *slower* than JS for some medium+ inputs, and it uses significantly more memory. WASM cannot touch the DOM directly. So:

**Realistic WASM use cases for a personal finance app (worth it):**
- **Money/calculation engine** — integer-cents arithmetic, rounding rules per currency, multi-step budget math where correctness + determinism matter (use `rust_decimal` or `currency_rs`).
- **Budget projections / forecasts** — amortization schedules, compound interest, "what-if" scenario simulations over many months.
- **Bulk transaction processing** — categorization passes, dedup, aggregation over large imported histories (only if you actually have large datasets; otherwise JS is fine).

**Over-engineering (don't):** DOM/UI, routing, simple sums, anything IO-bound, small one-off calculations. The serialization cost across the JS↔WASM boundary can erase gains for small/frequent calls.

**Toolchain:** Write a Rust `lib` crate (`crate-type = ["cdylib"]`), annotate exports with `#[wasm_bindgen]`, build with **wasm-pack** (`wasm-pack build --target bundler` for Vite/webpack; `--target web` if bundler-free). wasm-bindgen generates JS glue + TypeScript types (augment with `serde-wasm-bindgen`/Tsify for rich types). Initialize asynchronously (`await init()`), and consider running it in a Web Worker so heavy math never blocks the main thread (protects your INP score). Brotli/gzip the `.wasm`; mind that modules can be 1–10MB+ before compression.

**Verdict for v1:** Ship without WASM. Use `currency.js`/`Dinero.js` for money in JS. Introduce a Rust/WASM engine in v2 if/when (a) projection math gets complex, (b) you process large histories, or (c) you want a single shared calculation core across web/native to guarantee identical results.

### 5. Cross-Platform Parity Strategy

**PWA capabilities you can rely on (2025/2026):**
- Installability (add to home screen) via manifest; app-like standalone navigation.
- Offline support via service worker (Workbox) + IndexedDB (Dexie) — cache-first for app shell, network-first for user/account data, stale-while-revalidate for semi-static feeds.
- Push notifications: Android/desktop fully; **iOS 16.4+ only when installed to home screen**, requires VAPID keys.
- Background Sync (queue offline writes, replay on reconnect): Android/Chromium yes; **not on iOS Safari** — implement a manual reconcile-on-launch fallback.

**Where PWA hits its ceiling:** iOS lacks Background Sync, has aggressive cache eviction, no automatic install prompt, and historically unstable PWA support (Apple briefly threatened to gut EU PWAs under DMA in iOS 17.4, then reversed). App Store discovery/trust is also lost if you stay pure-PWA.

**The bridge — recommended path:**
1. **Build the PWA first** (web + installable) — covers PC and Android excellently, instant updates, one codebase.
2. **Wrap with Capacitor** for App Store + Play Store presence using the *same* React build (`npx cap add ios/android`), gaining native push, biometrics, secure storage, and store distribution. Capacitor has first-class PWA support — same plugin APIs run on web and native.
3. **Consider Tauri 2.0** for a lighter desktop binary if you want a true desktop app beyond the installable PWA.

**Feel native via:** platform-aware navigation (bottom tab bar on mobile, sidebar on desktop — the shadcn "sidebar on desktop, Sheet drawer on mobile" pattern), respect safe areas/notches, native-feeling transitions (Motion), biometric unlock (Capacitor), haptics on key confirmations, and skeleton loaders instead of spinners.

### 6. Login, Splash, and Onboarding Patterns

**World-class login (finance):**
- Minimal, high-contrast, single-column. Logo + one-line trust microcopy ("Your data is encrypted end-to-end"). Visible biometric option (Face ID / fingerprint) as the *primary* returning-user path; PIN/passkey fallback.
- **Passkeys/biometrics over passwords** (WebAuthn/FIDO): phishing-resistant, lower friction. Treat account recovery as a first-class, transparent flow (time estimates, clear outcomes) — not an afterthought.
- Friction belongs on *high-stakes* actions (adding a payee, large transfers, changing recovery), never on checking a balance or logging in. Biometric enrollment should be one explanation + one tap, not a multi-screen ceremony.

**Splash:** brand mark on `#0f172a`, fast, with a subtle entrance animation; preload the LCP element and critical CSS so the first real screen paints fast.

**Onboarding (the make-or-break):**
- **Manual/value-first, bank-linking-later** (Copilot's model). Forcing Plaid/bank credentials on screen one is a leading drop-off cause; Signicat's "The Battle to Onboard 2022" report (7,600 consumers across 14 European markets) found **68% of consumers had abandoned a financial application in the past year** (up from 63% in 2020 and 40% in 2016), with an average abandonment time of 18 minutes 53 seconds. Let users see the dashboard with manual or sample data first.
- **Progressive disclosure + save-state.** Break setup into short, single-purpose steps each fitting one screen action; show a step counter/progress bar; preserve every completed field so an interrupted user resumes with "Welcome back. You're almost done."
- **Trust signals throughout:** explain *why* each piece of data is requested ("We verify your identity to protect your account"), show security cues at security moments (OTP/biometric), avoid dark patterns, make fees/permissions explicit.
- **Micro-interactions:** smooth transitions, real-time inline validation, specific error messages with recovery ("Try again or enter your PIN"), and small celebratory moments (Monarch's goal-creation confetti) tied to real financial wins — not empty gamification. Consistency across every screen ("same team built this") is itself the first trust signal; research (Lindgaard et al.) shows users form an opinion about an interface within ~50ms of seeing it.

### 7. Performance & Accessibility Baselines

**Targets a professional fintech app should hit (measured at the 75th percentile of real users, on a throttled mid-tier Android given the PH market):**
- **LCP ≤ 2.5s** (good); aim for alert thresholds at ~2.0s.
- **INP ≤ 200ms** (good) — the hardest CWV; ~43% of sites fail it. Defer non-critical JS, break long tasks, offload heavy math to a Web Worker/WASM.
- **CLS ≤ 0.1** — reserve space for images/charts/dynamic content; set explicit dimensions.
- **Lighthouse:** Performance ≥ 90, Accessibility ≥ 95, Best Practices and SEO ≥ 90. Wire **Lighthouse CI** into the build to fail PRs that regress (e.g., `largest-contentful-paint maxNumericValue 2500`, `cumulative-layout-shift 0.1`, `performance minScore 0.9`).
- **Initial JS ≤ ~200KB gzipped** (Google's guidance) — every dependency competes for this budget.

**WCAG: target 2.2 AA** (the practical 2026 baseline; the EU's European Accessibility Act took effect June 28, 2025 for financial services and signals where the whole industry is going). Concretely: 4.5:1 contrast for normal text (learn from YNAB's pill-contrast fix), never color-alone signaling (pair with icons/labels/signs), full keyboard operability for auth/KYC/payment flows, labeled inputs, text alternatives/summaries for charts, and respect `prefers-reduced-motion`.

**Practical steps in React:** code-split by route, lazy-load charts and heavy components, use `fetchpriority="high"` + WebP/AVIF for any hero imagery, inline critical CSS, preconnect to APIs, virtualize long transaction lists, memoize expensive renders, and use real-user monitoring (web-vitals lib → analytics) since CrUX field data — not lab Lighthouse — drives the real verdict.

### 8. Competitive Edge for Emerging Markets (Philippines)

**The market reality:** GCash (over 94 million users in a nation of ~112 million — nearly the entire adult population; profitable, with ~US$115M net income in 2023) and Maya (a BSP-licensed digital bank) set the baseline expectation. GCash is feature-rich but "can feel cluttered/overwhelming"; Maya feels "more streamlined." Filipinos spend ~8h52m/day online (3rd globally) and access the internet overwhelmingly via phones (98.5%). **Median mobile download speed is 35.56 Mbps** per DataReportal's *Digital 2025: The Philippines* (Ookla data) — up 28.1% year-on-year but still roughly half the global average and ranking the country ~65th worldwide for mobile speed — and consistency is weak outside metro areas (7,600 islands). Mid- and low-end Android dominates.

**What this means for your UI/performance (differs from US-centric design):**
- **Performance is a feature, not a polish item.** Aggressive code-splitting, ≤200KB JS, WebP/AVIF, skeleton states, and *offline-first* are competitive differentiators here, not nice-to-haves. Test on a throttled mid-tier Android over a simulated 3G/slow-4G profile, not your dev machine.
- **Offline-first + reconnect resilience.** Service worker app-shell caching + IndexedDB local source of truth + queue-and-replay writes (Workbox Background Sync on Android; manual reconcile fallback on iOS). TanStack Query's `refetchOnReconnect` matters when connections drop mid-session.
- **Peso-native everything.** Format `₱` with correct grouping, integer-centavo math, and locale-aware number display from day one.
- **Speak the ecosystem.** Users live inside GCash/Maya and QR Ph (the BSP-mandated national QR standard). Even as a personal-finance *manager* (not a wallet), supporting manual import/logging of GCash/Maya transactions, QR-code awareness, and familiar category language ("load," "bills," "padala/remittance") will feel native to Filipinos.
- **Trust + low data anxiety.** Lighter graphics reduce both load time and data cost (data is a real budget line for many users). Make the value visible before asking for sensitive data, given lower baseline trust in newer apps.
- **Lower-friction auth.** Biometric/PIN unlock is well-understood (GCash/Maya use it); SMS/OTP is culturally familiar (GCash grew from SMS). Design for one-handed, thumb-reachable bottom navigation.

**Regulatory note (do not skip):** Even a non-regulated personal-finance tool that processes sensitive financial data falls under the **Data Privacy Act (RA 10173)** and the **National Privacy Commission**: appoint a Data Protection Officer, run a Privacy Impact Assessment, practice privacy-by-design and data minimization, publish a clear privacy notice + retention policy, and be able to notify NPC + affected users **within 72 hours of a breach**. Penalties run to multi-million-peso fines and imprisonment for willful violations; the NPC has actively fined fintech apps. If Hive ever touches payments/e-money/remittance/lending, BSP licensing is triggered — keep it a pure read/track/manage tool to stay out of that perimeter.

---

## Recommendations

**Stage 0 — Foundations (before any screen):**
1. Define design tokens in CSS variables: base `#0f172a`, surface/border elevation tints (OKLCH), semantic colors (`positive/warning/negative/pending`), a 4px spacing scale, and a type scale with `tabular-nums` for all money. Pick one sans (Inter or Plus Jakarta Sans) + a numeric treatment.
2. Scaffold with Vite + React + TypeScript + Tailwind v4 + shadcn/ui (init with `new-york` style, OKLCH, CSS variables). Add Radix-based components as needed. Wire dark/light via CSS-variable theme provider.
3. Money type from day one: integer centavos + `currency.js`/`Dinero.js`. Never use floats.
4. Set up Lighthouse CI with the thresholds above so quality can't silently regress.

**Stage 1 — Core product (PWA, web + Android focus):**
5. Build the dashboard with one dominant number, shadcn cards, Recharts charts themed to dark mode. Sidebar-on-desktop / bottom-tabs + Sheet-on-mobile navigation.
6. Implement offline-first (Workbox service worker + Dexie + TanStack Query with `refetchOnReconnect`). Manual-entry-first onboarding with progress + save-state.
7. Login with biometric/passkey primary path, transparent recovery, friction only on high-stakes actions.
8. Add Motion micro-interactions sparingly (budget dials, swipe-to-review, success confirmations); gate behind `prefers-reduced-motion` and `LazyMotion`.

**Stage 2 — Parity + polish:**
9. Wrap with Capacitor for iOS/Android store presence, native push (iOS 16.4+ caveat), biometrics, secure storage. Optionally Tauri 2.0 for desktop.
10. Add RUM (web-vitals → analytics); monitor CrUX-style field data on real PH devices/networks.

**Stage 3 — Optional performance/correctness depth:**
11. If projection math or large-history processing becomes a bottleneck, introduce a Rust/WASM money+forecast engine (wasm-pack, in a Web Worker) as a single shared calculation core.

**Thresholds that change the plan:**
- If field LCP > 2.5s or INP > 200ms on mid-tier Android → stop feature work, fix performance (split bundles, worker-offload, lighten Motion).
- If transaction charts exceed ~1,000 points or you add investment/candlestick views → migrate those charts from Recharts to ECharts/Lightweight Charts.
- If you add any payment/e-money/remittance/lending feature → trigger BSP licensing review *before* building.
- If onboarding completion < ~50% → push more value before bank-linking and shorten steps.

---

## Caveats

- **No official typeface or hex codes are confirmed** for Copilot, Monarch, Rocket Money, or YNAB — companies don't publish them. Copilot is a native SwiftUI app (so likely SF Pro). The "Plus Jakarta Sans + Geist Mono" pairing comes from Robinhood-inspired React templates, not these four apps — adopt it as a strong choice, don't attribute it to them.
- **Copilot's 2024 Apple Design Award was a *finalist*, not a win** (Interaction winners: Crouton and Rytmos).
- **GCash's reported daily-transaction volume could not be corroborated** from an authoritative source and is omitted; the 94M-user and $5B-valuation figures are confirmed (the latter via GCash's own October 2024 20th-anniversary release, following an ~$800M Ayala/MUFG injection that doubled its 2021 $2B valuation).
- **WASM performance claims are workload-dependent** and sometimes worse than JS for medium inputs or small frequent calls; benchmark your specific use case before committing. Treat WASM as v2, not v1.
- **PWA iOS support has been politically volatile** (Apple's 2024 DMA reversal) and lacks Background Sync; plan fallbacks and don't assume parity with Android.
- **Philippine speed/device figures are medians/averages** (Ookla/DataReportal/Opensignal, early–mid 2025) and vary widely by region, operator (DITO/Globe/Smart), and urban vs. rural; design for the slow tail, not the average.
- **Regulatory guidance here is orientation, not legal advice** — confirm DPA/NPC obligations and any BSP perimeter questions with Philippine counsel before launch.
- Several design-detail sources (ScreensDesign, app-review blogs, Dribbble) are secondary/editorial; Dribbble "Rocket Money" shots are fan concepts, not the shipped app.