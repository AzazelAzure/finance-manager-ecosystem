# T01 — Design Token Layer

## End State
A single source-of-truth CSS variable file establishes all color, spacing, and typography tokens. Dark mode switches cleanly via CSS var swap. All monetary values use `tabular-nums` and no raw float arithmetic reaches the render layer.

**This is the foundational task — nothing in Stage 1 may start until T01 passes V1.**

## Acceptance Criteria
1. [V1] Token file exists and is imported in the main CSS entry point; `npm run build` passes
2. [V1] Toggling dark/light mode (via existing theme toggle) swaps CSS variables; no layout flash on reload in standalone PWA mode
3. [V1] `grep -r "toFixed\|parseFloat\|Math\.\(round\|floor\|ceil\)" src/` — any hits flagged; if monetary floats found, `currency.js` or `Dinero.js` installed and wrapping those values

## Scope Lock

### Files to create
- `src/styles/tokens.css` (or `src/styles/design-tokens.css`) — canonical token file

### Files to modify
- Main CSS entry (likely `src/index.css` or `src/main.css`) — add `@import './styles/tokens.css'`
- `tailwind.config.*` — extend theme to reference CSS var tokens (if Tailwind v3) OR use `@theme` directive (if upgrading to Tailwind v4); **check current Tailwind version first**
- Any component file with bare float money math — wrap with `currency.js` or `Dinero.js`

### Token spec (implement exactly these variable names)
```css
/* Base palette — OKLCH for perceptually even dark/light adaptation */
:root {
  --color-brand-primary: oklch(60% 0.18 260);    /* blue-purple anchor */
  --color-surface-base: #0f172a;                  /* slate-900 dark bg */
  --color-surface-card: #1e293b;                  /* slate-800 card */
  --color-surface-border: #334155;                /* slate-700 border */

  /* Semantic — budget pace (Copilot Money model) */
  --color-positive: oklch(62% 0.18 145);          /* green — on track */
  --color-warning: oklch(70% 0.18 60);            /* amber — within 20% over */
  --color-negative: oklch(60% 0.20 25);           /* red — over budget */
  --color-pending: oklch(65% 0.08 255);           /* muted blue-grey — uncleared */
  --color-neutral: oklch(55% 0.04 255);           /* grey — zero/unassigned */

  /* Spacing — 4px base grid */
  --spacing-1: 4px;
  --spacing-2: 8px;
  --spacing-3: 12px;
  --spacing-4: 16px;
  --spacing-6: 24px;
  --spacing-8: 32px;
  --spacing-12: 48px;
  --spacing-16: 64px;

  /* Type scale */
  --text-xs: 0.75rem;    /* 12px */
  --text-sm: 0.875rem;   /* 14px */
  --text-base: 1rem;     /* 16px */
  --text-lg: 1.25rem;    /* 20px */
  --text-xl: 1.5rem;     /* 24px */
  --text-2xl: 2rem;      /* 32px */
  --text-hero: 3rem;     /* 48px — hero balance number */

  /* Money display */
  --font-numeric: 'Geist Mono', 'SF Mono', ui-monospace, monospace;
  --font-feature-tabular: "tnum";  /* font-variant-numeric: tabular-nums */
}

/* Light mode overrides (if light mode toggled) */
[data-theme="light"] {
  --color-surface-base: #f8fafc;
  --color-surface-card: #ffffff;
  --color-surface-border: #e2e8f0;
}
```

## Technical Decisions (pre-locked)
- Variable names above are locked — do not rename; downstream tasks reference them
- If Tailwind is v3: use `theme.extend.colors` to reference vars as `var(--color-positive)` etc. Do NOT upgrade to Tailwind v4 in this slice — check version first; if already v4, use `@theme` directive
- For money math: `currency.js` is preferred (lighter, simpler API) over `Dinero.js` unless the codebase already has Dinero; install only one

## Slice Decomposition
| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T01.SL1 | Token file | V1 | Create `tokens.css` with spec above; import in main entry; build passes |
| T01.SL2 | Dark mode wiring | V1 | Verify CSS var swap works on theme toggle; no flash on PWA reload; `[V3]` screenshot dark and light states |
| T01.SL3 | Money type audit | V1 | Grep for float math on monetary values; apply `tabular-nums` class (`.money-value`) to all balance/amount displays; install `currency.js` if raw floats found |

## Evidence
- `evidence/T01.SL1_build_output.txt`
- `evidence/T01.SL2_dark_light_screenshot.png` — [V3] both modes visible
- `evidence/T01.SL3_float_grep.txt` — grep output; "no hits" or list of files fixed

## Anti-Patterns (do NOT do these)
- Do NOT hardcode `#0f172a` in component files — use `var(--color-surface-base)`
- Do NOT add `!important` to token overrides
- Do NOT install both `currency.js` and `Dinero.js`
