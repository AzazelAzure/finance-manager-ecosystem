# T17 — Tests, lint, perf, final smoke

**Phase:** P7 — Polish + hardening  
**Skill:** `ci-test-triage` + `code-review-risk-triage`  
**Branch:** `feat/web-polish-hardening` (paired w/ T16)

## Objective

Lock the sweep with a baseline of automated checks and a documented VPS smoke.

## Implementation checklist

### Tests
- [ ] Add **vitest** + **@testing-library/react** + **jsdom**.
- [ ] `auth.refresh.test.ts` — proves the axios interceptor refreshes on 401
      and retries the original request once, then logs out on second 401.
- [ ] `breakpoints.snapshot.test.tsx` — renders `<ProtectedShell/>` at 320 and
      1280 px and asserts the sidebar / horizontal nav strip swap.
- [ ] `currency.format.test.ts` — base currency formatter (parity with
      Reflex).
- [ ] One smoke test per major page that asserts the page header renders
      under a mock auth + mock API client.

### Lint + types
- [ ] `npm run lint` clean.
- [ ] `tsc -b` clean with `strict: true` enabled in `tsconfig.app.json`
      (verify it's already on; if not, turn on and fix).
- [ ] No unused dependencies in `package.json` (drop `clsx` /
      `tailwind-merge` if not actually used; or keep with a one-line note).

### Perf
- [ ] Bundle audit: `vite build --mode production` then check sizes. Main JS
      gzip target ≤ **350 kB**. If over, code-split routes via `lazy()` /
      Suspense for `/app/transactions/*` and `/app/upcoming-expenses/*`.
- [ ] Image audit: SVG only; no large rasters.
- [ ] Dashboard filter UX polish: evaluate optional **smart/live reload** while
      selections change (without regressing React Query dedupe / API load).
- [ ] Dashboard drill polish: confirm expected interaction contract for
      category/tag slices (keep redirect-to-transactions vs in-place filtering),
      then implement the chosen behavior consistently with callouts.

### CI
- [ ] Add a minimal GitHub Actions workflow `web-ci.yml` running `npm ci`,
      `npm run lint`, `npm run build`, `npm test` on push to `main` and PRs.

### VPS smoke (final)
- [ ] After merge, on VPS: pull, rebuild `web-blue` / `web-green`, smoke
      every BP1–BP6 test list. Document timestamps + results in
      `runtime_handoff.md` per-phase smoke log.

## Definition of done

- [ ] Vitest suite runs and passes locally and in CI.
- [ ] Lighthouse perf mobile ≥ 80 on `/` and `/app/dashboard`.
- [ ] All BP gates marked **PASS** in `validation_gates.md`.
- [ ] BP3 dashboard polish follow-ups above are either shipped or explicitly
      deferred with rationale.

## Verification

Run all CI commands locally, then in GHA. Lighthouse mobile run on the public
URLs.
