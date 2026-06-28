# T05 — Auth Visual Polish + SEO Helmet

**Branch:** `cur/s1b/feat/ui-ux-design-system`  
**Date:** 2026-06-26

## SEO Pre-check

- `LoginPage.tsx` and `SignupPage.tsx` did not render `Helmet`.
- `src/lib/i18n.ts` did not contain `login.seo.*` / `signup.seo.*`.

## Actions Taken

- Added `Helmet` tags on:
  - `/login`
  - `/signup`
- Added canonical links:
  - `https://thehivemanager.com/login`
  - `https://thehivemanager.com/signup`
- Added required SEO title/description keys in both `en-US` and `tl-PH`.
- Added visual polish to both auth pages:
  - app mark / brand treatment
  - high-trust microcopy row
  - biometric unlock placeholder (disabled, non-functional by design)
  - signup step clarity line
  - tokenized auth card spacing/surface styles

## Verification

- `npm run build`: PASS.
- `npm run lint`: FAILS on existing baseline lint issues unrelated to T05.

## V3 Screenshot Status

Browser screenshots not captured in this pass. Visual implementation is present
in code and ready for HitM/browser verification.
