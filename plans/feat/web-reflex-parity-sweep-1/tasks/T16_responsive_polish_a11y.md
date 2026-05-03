# T16 — Responsive polish, a11y, skeletons, three-state cards

**Phase:** P7 — Polish + hardening  
**Skill:** `feature-implementation-loop` then `code-review-risk-triage`  
**Branch:** `feat/web-polish-hardening`

## Objective

Sweep every page for the small things that make the app feel finished and
accessible.

## Implementation checklist

### Skeletons
- [ ] Dashboard widget skeletons (KPI tile, chart area, table rows).
- [ ] Transactions table row skeletons.
- [ ] Upcoming list skeletons.
- [ ] Data hub card skeletons.

### Three-state cards
- [ ] Every fetch path uses `<EmptyState/>` (no data), `<ErrorState/>` (fetch
      failure with Retry), `<SuccessState/>` (after a destructive mutation).

### Toasts
- [ ] Add a tiny `<Toast/>` system (no extra dep): success / error / info; 4 s
      auto-dismiss; top-right on desktop, top-center on mobile. Wire to all
      mutations.

### Responsive sweep
- [ ] Walk every page at 320 / 375 / 414 / 640 / 768 / 900 / 1024 / 1200 /
      1440 / 1920 px and fix any overflow / collision / unreachable button.
- [ ] Tables: confirm all collapse to stacked cards below `--bp-md`.
- [ ] Charts: confirm all reflow without clipping.
- [ ] Sidebar at < `--bp-md`: scroll strip is reachable from the top of every
      page; no z-index battle with sticky headers.

### A11y sweep
- [ ] Every input has `<label htmlFor=…>` + matching `id`.
- [ ] Every modal has `role="dialog"`, `aria-modal="true"`, focus trap,
      labelled by its title.
- [ ] Every chart has an `aria-label` and a screen-reader-only `<table>`
      fallback (recharts `Customized` element).
- [ ] Color contrast: run Lighthouse / axe-core; fix any AA failures.
- [ ] Keyboard-only walk-through of every primary flow (login, add tx, edit
      tx, delete tx, add bill, add source, change preferences) — no traps.

### Micro-animations
- [ ] Pie slice scale-on-hover.
- [ ] KPI tile fade-in on first paint.
- [ ] Sidebar hover-expand.
- [ ] Honor `prefers-reduced-motion` everywhere.

## Definition of done

- [ ] Lighthouse a11y ≥ 90 on `/`, `/login`, `/app/dashboard`,
      `/app/transactions`, `/app/upcoming-expenses`.
- [ ] Manual responsive matrix (10 widths × all primary pages) passes.
- [ ] Toasts appear on all create/update/delete flows.

## Verification

Lighthouse runs (paste numbers in `validation_gates.md` BP7 entry); axe-core
DevTools clean.
