# Validation gates — Reflex dashboard UI regression

Use these as **hard stops** before marking orchestration complete. Record pass/fail and viewport in PR or plan notes.

## Gate V1 — Viewport matrix (shell)

| Viewport | Expectation |
|----------|-------------|
| **≥1280px** | Collapsed vertical rail visible; hover expands labels; main content offset from rail; **no** horizontal nav bar replacing rail unless explicitly designed. |
| **1024px** | If `@media (max-width: 1200px)` applies: top/sidebar hybrid acceptable; **all** nav targets visible without being covered by `protected-header`. |
| **768px** | Horizontal nav lane (if used): **first tap** reaches each route; sticky header does **not** occlude active nav row (check `z-index` + `padding-top` on scroll container). |
| **390px** | Same as 768; language selector still usable; no double scrollbars unless table drill requires horizontal scroll. |

**Pass criteria:** All four rows pass on **Chrome** (or primary beta browser) + one **Firefox** or **Safari** spot-check.

## Gate V2 — Charts (dashboard)

| Check | Pass |
|-------|------|
| Expense-by-category pie (or primary category chart) shows **visible sector** when API returns non-empty `expense_by_category` / mapped series. |
| Expense-by-tag chart shows **bars or equivalent** when tag series non-empty. |
| At least one **time-series** (spend/income/flow) renders when corresponding series non-empty. |
| When series **intentionally** empty: card shows **empty state** copy, not a blank infinite canvas. |

**Diagnostics on failure:** In devtools, confirm `.recharts-responsive-container` **computed height > 0** and parent not `display: none` / `overflow: hidden` clipping to zero.

## Gate V3 — Build / runtime

- [ ] `uv run reflex export --no-zip --env prod` (or project-standard export) succeeds from clean tree.
- [ ] Docker image build for Reflex succeeds with current `Dockerfile` (`REFLEX_TRANSPORT` and export-time env unchanged unless this plan explicitly changes them).
- [ ] VPS smoke: login → dashboard load **without** new console errors attributable to this change set.

## Gate V4 — Docs

- [ ] `finance_manager_reflex/CHANGELOG.md` has an **[Unreleased]** entry describing shell and/or chart fixes.
- [ ] If breakpoint behavior is materially new for operators, one design_doc or deploy note cross-link (optional, orchestrator decides).
