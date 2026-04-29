# T01 — Foundations: shell, theme tokens, breakpoints, router, primitives

**Phase:** P1 — Foundations (paired with **T02**)  
**Skill:** `feature-implementation-loop` (`generalPurpose`)  
**Branch:** `feat/web-foundations` (in `finance_manager_web/`)  
**Repo scope:** `finance_manager_web/` (primary), `finance_manager/` (submodule
bump in a paired ecosystem PR)

## Objective

Lay the structural foundations every later phase depends on, **without**
breaking the existing `/login` + `/dashboard` flow.

## Implementation checklist

### Routing
- [ ] Restructure routes:
  - `/` (public splash placeholder — wired in T03)
  - `/login` (public, kept)
  - `/signup` (public placeholder — wired in T04)
  - `/app` (`<ProtectedShell>` parent route) with `<Outlet/>`
  - Move existing `/dashboard` to `/app/dashboard`
  - Catch-all `*` → `Navigate` to `/app/dashboard` if token else `/`
- [ ] `<ProtectedRoute>` wraps `/app/*` not individual routes.

### Layout shells (`src/layout/`)
- [ ] `PublicShell.tsx` — header (brand + locale slot — actual locale picker in
  T03), `<Outlet/>`, minimal footer.
- [ ] `ProtectedShell.tsx` — left sidebar (≥ `--bp-md`), sticky horizontal
  scroll strip (< `--bp-md`); top sticky glass header with page title; bottom
  Logout. **Cookie banner** mounted at root.
- [ ] Sidebar items list (icons via `lucide-react` — add as dep): Dashboard,
  Transactions, Calendar, Upcoming, Data, Profile. Active item driven by
  current route (no Reflex-style `active_route` quirk).

### Theme + tokens (`src/styles/`)
- [ ] `tokens.css` — define **all** color / spacing / radius / font / shadow
  vars in `:root` and `[data-theme="dark"]`. No literal hex in component code
  thereafter.
- [ ] Replace inline hex in `index.css` with token references.
- [ ] Self-host Inter via `@font-face` from `public/fonts/`.
- [ ] Add `data-theme` toggle util (no UI in T01; theme switcher ships in T14).

### Breakpoints
- [ ] Add `src/lib/breakpoints.ts` exporting `BP = { sm: 640, md: 900, lg:
      1200, xl: 1440 }` and a `useBreakpoint()` hook (matchMedia under the
      hood).
- [ ] `tokens.css` mirrors the same values as `--bp-sm/md/lg/xl`.

### Shared primitives (`src/components/`)
- [ ] `Card.tsx`, `KPI.tsx`, `Button.tsx` (variants: primary/secondary/ghost),
  `IconButton.tsx`, `Skeleton.tsx`, `EmptyState.tsx`, `ErrorState.tsx`,
  `SuccessState.tsx`, `LoadingState.tsx`, `Badge.tsx`, `Tabs.tsx`, `Modal.tsx`
  (focus-trap, ESC, click-outside).
- [ ] `ChartFrame.tsx` — wraps `<ResponsiveContainer/>`, applies theme colors,
  shows `<Skeleton/>` on loading and `<EmptyState/>` when no data.
- [ ] `DataTable.tsx` — column config, sticky header, `mobileCollapse`
  (renders stacked card per row below `--bp-md`), sortable hooks (no external
  table dep).
- [ ] `Form/` — `Form.tsx` (`react-hook-form` integration), `Field.tsx`,
  `Input.tsx`, `Select.tsx`, `Checkbox.tsx`, `Textarea.tsx`, `DateInput.tsx`,
  `CurrencyInput.tsx` (number+currency code pair), `TagInput.tsx`. All wired
  to **zod resolvers**.
- [ ] `CookieBanner.tsx` — first-visit banner, accept stores
  `fm_cookie_consent=1` cookie 1y.

### State / data
- [ ] `src/lib/queryClient.ts` with defaults: `staleTime: 30_000`, `gcTime:
      600_000`, `retry: 1`, `refetchOnWindowFocus: false`.
- [ ] Move dashboard query to `src/api/snapshot.ts`; introduce
  `src/api/profile.ts`, `src/api/transactions.ts`, etc. (empty modules ready for
  later phases — keep T01 small).

## Definition of done

- [ ] `npm run build` green.
- [ ] `npm run lint` green.
- [ ] Existing `/dashboard` content reachable at `/app/dashboard` and renders
  the snapshot.
- [ ] Sidebar visible at ≥ 900 px; horizontal strip below 900 px; nothing
  overflows or breaks at 320 / 640 / 900 / 1200 / 1440 px.
- [ ] CookieBanner shows on first load, hides after accept (cookie set).
- [ ] Light + dark theme tokens both compile (no UI to switch yet, but
  `<html data-theme="dark">` set manually in DevTools renders the dashboard
  cleanly).

## Verification

```bash
cd finance_manager_web
npm ci
npm run lint && npm run build
npm run dev   # click through /, /login, /app/dashboard at multiple widths
```

## PR

- Branch `feat/web-foundations` → `main` (web).
- Title: `feat(foundations): layout shells, theme tokens, breakpoints,
  primitives`.
- PR body: list of new directories + screenshots at 4 viewport widths.
- Pair PR in ecosystem parent: branch `feat/web-foundations-bump` bumping the
  submodule pointer.

## Risks

- Lucide icons add ~30 kB tree-shaken. Acceptable; alternative is per-icon
  imports already.
- Self-host Inter increases initial assets ~100 kB but removes CDN runtime
  dependency.
