# T02 — shadcn/ui Audit and Scaffold

## End State
shadcn/ui is initialized (or confirmed already present) with the `new-york` style and OKLCH CSS variable tokens. Card, Button, and Input primitives are wired to the token layer from T01. Existing app layout renders without visual regression.

## Acceptance Criteria
1. [V1] `components/ui/` directory exists and contains shadcn-managed components; `npm run build` passes
2. [V1] `Button`, `Card`, `Input` components reference `--color-*` tokens (or shadcn's `--primary`, `--card`, etc. mapped to the same vars) rather than hardcoded colors
3. [V3] Visual regression check: dashboard and auth pages render with no broken styles; screenshot captured

## Scope Lock

### Pre-step (read first)
- Check `package.json` for `@shadcn/ui` or `shadcn` in devDependencies
- Check if `components/ui/` already has shadcn files
- Check if `components.json` exists at repo root

### If shadcn NOT present
Run: `npx shadcn@latest init` and select:
- Style: `new-york`
- Base color: `slate` (maps to `#0f172a` base)
- CSS variables: `yes`
- Do NOT overwrite files that have custom logic — review each conflict

### If shadcn IS present
- Check if `components.json` uses CSS variables mode (`"cssVariables": true`)
- If not, migrate manually (the shadcn migration guide covers this)

### Files to modify
- `src/components/ui/card.tsx` (or equivalent) — ensure `className` uses `bg-card` token, not hardcoded slate
- `src/components/ui/button.tsx` — ensure primary variant uses `bg-primary` token
- `src/components/ui/input.tsx` — ensure border uses `border-input` token
- `globals.css` or `index.css` — add shadcn CSS variable block if init doesn't add it

### Files NOT to touch
- `TourProvider.tsx`, `HelpModeWrapper` — F-007 domain
- `ProtectedShell.tsx` — F-007 owns this file; read-only if needed for context only

## Slice Decomposition
| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T02.SL1 | shadcn audit + init | V1 | Check existing state; init if needed; resolve any conflicts; build passes |
| T02.SL2 | Primitive token wiring | V3 | Card, Button, Input use token vars; visual check on dashboard + auth pages |

## Evidence
- `evidence/T02.SL1_build_output.txt`
- `evidence/T02.SL2_visual_check.png` — [V3] dashboard screenshot showing token colors applied

## Clarifying Questions (ask HitM before proceeding if unclear)
1. Are there existing custom components in `components/ui/` that must be preserved exactly (i.e., shadcn should not overwrite them)?
2. Is the current Tailwind version v3 or v4? (Determines whether to use `extend.colors` or `@theme` directive)
