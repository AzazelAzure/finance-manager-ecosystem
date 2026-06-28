# T03 — Dashboard Hero Number and Chart Tokens

## End State
The dashboard leads with one dominant number (safe-to-spend balance or net balance) that is visually larger than all other elements. All spacing follows the 4px grid from T01 tokens. Recharts charts use semantic color variables so budget pace is encoded as green → amber → red — not arbitrary or hardcoded colors.

## Acceptance Criteria
1. [V3] Screenshot: balance/safe-to-spend figure is the largest visible text element on the dashboard; nothing else competes for visual dominance
2. [V1] No hardcoded hex strings in `DashboardPage.tsx` chart color props; all chart colors reference `var(--color-positive)`, `var(--color-warning)`, `var(--color-negative)`, or `var(--color-neutral)`
3. [V1] `npm run build` passes; `npm run lint` clean

## Scope Lock

### Files to modify
- `src/pages/DashboardPage.tsx` — hero number promotion; spacing grid application; chart color refactor
- Any Recharts `<BarChart>`, `<LineChart>`, `<PieChart>` config files or components referenced from DashboardPage

### Files NOT to touch
- `TourProvider.tsx`, `HelpModeWrapper`, `OnboardingSandbox.tsx`, `GlobalOnboardingTour.tsx` — F-007 domain
- `ProtectedShell.tsx` — F-007 domain; do not modify

### Hero number implementation pattern
The leading balance element should have:
```tsx
<p className="text-[var(--text-hero)] font-bold tabular-nums font-[var(--font-numeric)] leading-none">
  {displayBalance}
</p>
```
All other data (income, expenses, sub-balances) use `--text-lg` or smaller and lower `font-weight`.

### Recharts color pattern
Replace any `fill="#10b981"` or `stroke="green"` style with:
```tsx
fill="var(--color-positive)"
stroke="var(--color-positive)"
```
For budget pace encoding (if a spending bar chart exists):
- Under budget pace: `var(--color-positive)`
- Within 20% of limit: `var(--color-warning)`
- Over limit: `var(--color-negative)`

If budget pace logic does not yet exist in the chart, add a `getBarColor(spent, budget)` helper and apply it to the bar `Cell` fill.

## Slice Decomposition
| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T03.SL1 | Hero number promotion | V3 | Apply `--text-hero` + `tabular-nums` to balance element; enforce spacing grid on card gaps; [V3] screenshot captured |
| T03.SL2 | Recharts token integration | V1 | Replace all hardcoded chart colors with CSS var references; add `getBarColor()` helper for budget pace if applicable; build + lint pass |

## Evidence
- `evidence/T03.SL1_dashboard_hero.png` — [V3] full dashboard screenshot, dark mode
- `evidence/T03.SL2_chart_color_grep.txt` — grep output confirming no hardcoded hex in chart props
- `evidence/T03.SL2_build_output.txt`

## Anti-Patterns (do NOT do these)
- Do NOT use inline `style={{ fontSize: '48px' }}` — use the token class
- Do NOT apply `--text-hero` to more than one element per screen
- Do NOT add chart animations in this task — that is T06 scope
