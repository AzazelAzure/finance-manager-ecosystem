# T03 — Landing Footer + Cookie Banner Update

## Context

The landing page has no footer. The cookie banner (`CookieBanner.tsx`) currently has no link to the cookie policy and uses generic text. Both need updating to surface the legal pages created in T02.

## End State

- `LandingPage.tsx` renders a `<LegalFooter />` at the bottom with links to `/privacy`, `/terms`, `/cookies` and a copyright line
- `CookieBanner.tsx` updated: more informative text, "Cookie Policy" link to `/cookies`

## Slice Decomposition

| Slice | Title | V-Tier | Description |
|---|---|---|---|
| T03.SL1 | LegalFooter component | V3 | New component; integrated into LandingPage |
| T03.SL2 | CookieBanner update | V3 | Updated text + cookie policy link |

## T03.SL1 — LegalFooter Component

Create `src/components/LegalFooter.tsx` or co-locate in `src/components/landing/`:

```tsx
// Renders a simple footer row:
// "Privacy Policy | Terms of Service | Cookie Policy   © 2026 The Hive Financial Manager"
// Each item is a <Link> from react-router-dom (internal navigation)
// Style: centered, small text, muted color using design tokens
```

Add to `LandingPage.tsx`:
```tsx
import { LegalFooter } from "../components/LegalFooter";
// At the bottom of <main className="landing-page">:
<LegalFooter />
```

CSS target: reuse existing landing.css variables; footer should be clearly separated from the CTA section (margin-top, optional top border). Mobile: links stack or wrap naturally.

**Acceptance criteria:**
- [V3] Browser: Landing page (`/`) shows footer with three links
- [V3] Browser: All three footer links navigate to correct legal pages
- [V3] Browser: Footer is visible on mobile viewport (375px)

## T03.SL2 — CookieBanner Update

Update `CookieBanner.tsx`:

**Current text:**
```
We use cookies to remember this notice and to support your session. By continuing, you accept our use of essential cookies.
```

**Updated text:**
```
We use strictly necessary cookies and local storage to keep you signed in and remember your preferences.
No advertising or tracking cookies are used. See our [Cookie Policy] for details.
```

Where `[Cookie Policy]` is a `<Link to="/cookies">Cookie Policy</Link>` from react-router-dom.

Also update to mention that continuing implies acceptance of the Terms of Service — add a brief line:
```
By continuing, you agree to our [Terms of Service] and acknowledge our [Privacy Policy].
```

Keep the "Accept" button label. Do not add a "Reject" button — as stated in the Cookie Policy §7.1, all current storage is strictly necessary or functional; there is no meaningful reject action at this time.

**Acceptance criteria:**
- [V3] Browser: Cookie banner shows on first visit (new incognito session)
- [V3] Browser: "Cookie Policy" link in banner navigates to `/cookies`
- [V3] Browser: "Terms of Service" and "Privacy Policy" links in banner navigate to `/terms` and `/privacy`
- [V3] Browser: Clicking "Accept" dismisses the banner and does not re-show on refresh

## Evidence

- `evidence/T03.SL1_footer_screenshot.png` — landing page footer visible
- `evidence/T03.SL2_banner_screenshot.png` — updated cookie banner with links
