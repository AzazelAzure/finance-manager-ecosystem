# T02 — Legal Page Components + Routes

## Context

After T01 creates the content files and installs react-markdown, this task builds the three legal page components and wires them into the app router. All pages are public (no auth required), rendered inside `PublicShell`.

## End State

- `src/pages/legal/PrivacyPage.tsx`, `TermsPage.tsx`, `CookiesPage.tsx` — each renders its markdown file
- `src/layout/LegalPageShell.tsx` — shared wrapper with back link + constrained width
- Routes `/privacy`, `/terms`, `/cookies` added to `App.tsx` under `PublicShell`

## Slice Decomposition

| Slice | Title | V-Tier | Description |
|---|---|---|---|
| T02.SL1 | LegalPageShell wrapper | V1 | Shared layout: back-to-home link, page title slot, constrained width, markdown prose styles |
| T02.SL2 | Three page components | V1 | PrivacyPage, TermsPage, CookiesPage — each imports its markdown and renders via ReactMarkdown |
| T02.SL3 | App.tsx route wiring | V3 | Add three routes under PublicShell; browser-verify all three load |

## T02.SL1 — LegalPageShell

Create `src/layout/LegalPageShell.tsx`:

```tsx
// Props: title (string), children (ReactNode)
// Renders: back link "← Home" (Link to "/"), h1 with title,
//          constrained max-width container (e.g., max-w: 72ch or 800px),
//          children (the ReactMarkdown output)
```

CSS: add `.legal-page` styles to an appropriate existing CSS file (or a new `legal.css`). Target:
- Max width ~800px, centered
- `font-size` appropriate for body reading
- `h1, h2, h3` with clear hierarchy (can reuse design token sizes)
- `table` — bordered, readable on mobile
- `a` — standard link color from design tokens
- `code` — inline code block style (used in cookie policy for localStorage key names)

**Acceptance criteria:**
- [V1] TypeScript compiles without errors
- [V1] `LegalPageShell` accepts `title: string` and `children: ReactNode` props with correct types

## T02.SL2 — Three Page Components

Each component follows this pattern:

```tsx
// src/pages/legal/PrivacyPage.tsx
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import { Helmet } from "react-helmet-async";
import { LegalPageShell } from "../../layout/LegalPageShell";
import privacyContent from "../../content/legal/privacy_policy.md?raw";

export function PrivacyPage(): ReactNode {
  return (
    <LegalPageShell title="Privacy Policy">
      <Helmet>
        <title>Privacy Policy | The Hive Financial Manager</title>
        <meta name="robots" content="noindex" />
      </Helmet>
      <ReactMarkdown remarkPlugins={[remarkGfm]}>{privacyContent}</ReactMarkdown>
    </LegalPageShell>
  );
}
```

**Note on `?raw` import:** Vite supports `import content from "./file.md?raw"` for raw string import. Confirm this works with current Vite config. If not, use a static string export approach or `import.meta.glob`.

**Acceptance criteria:**
- [V1] All three components compile without TypeScript errors
- [V1] `?raw` import works in Vite build (check `vite.config.ts` — if `assetsInclude` needs updating for `.md`, add it)
- [V1] `noindex` meta is present in Helmet for each page

## T02.SL3 — App.tsx Route Wiring

Add to `App.tsx` inside the `<Route element={<PublicShell />}>` block:

```tsx
import { PrivacyPage } from "./pages/legal/PrivacyPage";
import { TermsPage } from "./pages/legal/TermsPage";
import { CookiesPage } from "./pages/legal/CookiesPage";

// Inside <Route element={<PublicShell />}>:
<Route path="/privacy" element={<PrivacyPage />} />
<Route path="/terms" element={<TermsPage />} />
<Route path="/cookies" element={<CookiesPage />} />
```

**Acceptance criteria:**
- [V3] Browser: `/privacy` loads and renders Privacy Policy text without errors
- [V3] Browser: `/terms` loads and renders Terms of Service text without errors
- [V3] Browser: `/cookies` loads and renders Cookie Policy text without errors
- [V3] Browser: All three accessible in incognito (no redirect to login)
- [V3] Browser: Back link "← Home" navigates to `/`

## Evidence

- `evidence/T02.SL3_privacy_screenshot.png` — browser screenshot of /privacy
- `evidence/T02.SL3_terms_screenshot.png` — browser screenshot of /terms
- `evidence/T02.SL3_cookies_screenshot.png` — browser screenshot of /cookies
