# T05 — Login/Signup Visual Polish and SEO Helmet Tags

## End State
LoginPage and SignupPage are visually polished: high-contrast, single-column, trust microcopy present, biometric call-to-action placeholder in the layout. Both pages have Helmet dynamic title + meta description tags (T16.SL1/SL2 from `SEO_PASSTHROUGH_PASSDOWN.md`) — either already shipped by the SEO agent or implemented here if not.

## Pre-step (check before starting)
**Check if SEO slices are already shipped:**
```bash
grep -n "react-helmet-async\|Helmet" src/pages/LoginPage.tsx src/pages/SignupPage.tsx
grep -n "login.seo.title\|signup.seo.title" src/lib/i18n.ts
```
- If Helmet tags present and i18n keys exist → T05.SL2 is already done; skip it, mark PASS with V0
- If not present → implement T05.SL2 per the passdown spec

## Acceptance Criteria
1. [V3] LoginPage: logo or app name + one-line trust microcopy visible above the form ("Your data stays on your device" or equivalent); form is single-column, high contrast; dark mode renders correctly
2. [V3] SignupPage: equivalent visual standard; progress indicator or single-step clarity
3. [V1] If SEO not yet shipped: `<title>` and `<meta name="description">` update dynamically on /login and /signup route; confirmed in browser DevTools
4. [V1] `npm run build` passes; `npm run lint` clean

## Scope Lock

### Files to modify
- `src/pages/LoginPage.tsx` — layout polish + Helmet (if not yet shipped)
- `src/pages/SignupPage.tsx` — layout polish + Helmet (if not yet shipped)
- `src/lib/i18n.ts` — add SEO keys if not yet present (spec below)

### SEO i18n keys to add (from `SEO_PASSTHROUGH_PASSDOWN.md` T16.SL1)
```ts
"en-US": {
  "login.seo.title": "Sign In | Hive Financial Manager — Track GCash & Maya",
  "login.seo.desc": "Log in to your Hive Financial Manager account. Secure, private, and offline-first personal budgeting for Filipino households.",
  "signup.seo.title": "Create Account | Hive Financial Manager — Start Budgeting Free",
  "signup.seo.desc": "Start tracking your GCash, Maya, and bank expenses. Sign up for a free Hive Financial Manager account today.",
}
"tl-PH": {
  "login.seo.title": "Mag-sign In | Hive Financial Manager — I-track ang GCash at Maya",
  "login.seo.desc": "Mag-log in sa iyong Hive Financial Manager account. Secure, pribado, at offline-first na budget tracker para sa pamilyang Pilipino.",
  "signup.seo.title": "Gumawa ng Account | Hive Financial Manager — Magsimula Nang Libre",
  "signup.seo.desc": "Subaybayan ang iyong GCash, Maya, at mga bank account. Gumawa ng libreng Hive Financial Manager account ngayon.",
}
```

### Helmet implementation pattern (T16.SL2)
```tsx
import { Helmet } from "react-helmet-async";
// inside LoginPage return:
<Helmet>
  <title>{tr("login.seo.title", locale) || "Sign In | Hive Financial Manager"}</title>
  <meta name="description" content={tr("login.seo.desc", locale) || "Log in to your Hive Financial Manager account."} />
  <link rel="canonical" href="https://thehivemanager.com/login" />
</Helmet>
```

### Visual polish targets
- Trust microcopy line: 12–14px, muted color (`var(--color-neutral)`), centered above the form card
- Form card: `var(--color-surface-card)` background, `var(--spacing-6)` padding
- Primary CTA button: `var(--color-positive)` or `var(--color-brand-primary)` background; high contrast label
- Biometric CTA: add a `<button>` or `<div>` placeholder with fingerprint/face icon (non-functional is OK; note it as a future gate)

### Files NOT to touch
- Any auth logic / JWT handling — visual-only changes
- `TourProvider.tsx` or tour components

## Slice Decomposition
| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T05.SL1 | Auth page visual polish | V3 | LoginPage + SignupPage layout: single-column, trust microcopy, token colors, biometric placeholder; screenshot both in dark mode |
| T05.SL2 | SEO Helmet tags | V1 | i18n keys + Helmet on Login/Signup (skip if already shipped by SEO agent); DevTools head inspection confirms dynamic title |

## Evidence
- `evidence/T05.SL1_login_dark.png` — [V3] LoginPage dark mode
- `evidence/T05.SL1_signup_dark.png` — [V3] SignupPage dark mode
- `evidence/T05.SL2_helmet_devtools.png` or `T05.SL2_skip_already_shipped.txt`

## Anti-Patterns (do NOT do these)
- Do NOT add a Plaid / bank-linking prompt on these pages — manual-first onboarding is locked
- Do NOT add a multi-step wizard to login; single-column only
