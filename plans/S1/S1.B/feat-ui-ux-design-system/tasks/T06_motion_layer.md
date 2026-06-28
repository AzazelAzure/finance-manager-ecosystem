# T06 — Motion Layer (LazyMotion + Micro-interactions)

## End State
`motion` package (formerly Framer Motion) is installed and wrapped in `LazyMotion` so only the features actually used are loaded. `prefers-reduced-motion` disables all animations. At least one meaningful micro-interaction is live on the dashboard (budget pace dial or balance number transition). Total bundle size increase from motion is ≤50KB gzipped.

## Acceptance Criteria
1. [V1] `npm run build -- --report` (or equivalent Vite bundle analysis): motion contribution ≤50KB gzipped
2. [V1] With `prefers-reduced-motion: reduce` set (Chrome DevTools → Rendering tab), zero animations play; app is fully functional
3. [V3] Dashboard: at least one animated element (balance update fade-in OR budget bar fill animation); animation plays on fresh load; [V3] screen recording captured
4. [V1] `npm run build` passes; no console errors

## Scope Lock

### Package
```bash
npm install motion
```
Use `motion` (the standalone package), NOT `framer-motion` legacy — same API, smaller bundle.

### LazyMotion setup
```tsx
// src/main.tsx or src/App.tsx
import { LazyMotion, domAnimation } from "motion/react";

// Wrap the app root:
<LazyMotion features={domAnimation} strict>
  <App />
</LazyMotion>
```
Then in components, import from `motion/react` (not `framer-motion`):
```tsx
import { m } from "motion/react";
// use <m.div> instead of <motion.div>
```

### Reduced motion gating
Every animation component must check `useReducedMotion()`:
```tsx
import { useReducedMotion } from "motion/react";
const shouldReduce = useReducedMotion();
// pass to animate: shouldReduce ? {} : { scale: [1, 1.05, 1] }
```

### Required micro-interactions (implement at least one from this list)
- **Balance number fade-in:** when the dashboard balance value loads or updates, animate from `opacity: 0` to `opacity: 1` over 300ms
- **Budget bar fill:** if a budget progress bar exists on the dashboard, animate its width from 0 to actual value on mount (500ms, ease-out)
- **Card entrance:** stagger dashboard cards with 50ms delay and `y: 8 → 0` on initial render

### Optional (do if time allows, not required for PASS)
- Swipe-to-review gesture on transaction list items (requires `useMotionValue` + drag)
- Goal creation confetti (requires `AnimatePresence` + particles)

### Files to modify
- `src/main.tsx` or `src/App.tsx` — `LazyMotion` wrapper
- `src/pages/DashboardPage.tsx` — add at least one animation
- Any component where entrance animation is added

### Files NOT to touch
- Joyride/tour components — they have their own animation model
- Auth pages — motion on auth is not required for this task

## Slice Decomposition
| Slice | Title | V-Tier | Description |
|-------|-------|--------|-------------|
| T06.SL1 | LazyMotion install + reduced-motion gating | V1 | Install `motion`; wrap root in `LazyMotion`; `useReducedMotion()` applied; bundle size verified; build passes |
| T06.SL2 | Dashboard micro-interaction | V3 | At least one animation live on dashboard; plays on fresh load; disabled under `prefers-reduced-motion`; screen recording captured |

## Evidence
- `evidence/T06.SL1_bundle_size.txt` — output of bundle analysis showing motion contribution
- `evidence/T06.SL1_reduced_motion_build.txt` — build log
- `evidence/T06.SL2_dashboard_animation.webm` or `.gif` — [V3] recording of animation

## Anti-Patterns (do NOT do these)
- Do NOT import `import { motion } from "framer-motion"` — use `motion/react` + `LazyMotion`
- Do NOT animate on every interaction (only purposeful moments: load, update, completion)
- Do NOT add animations that block the main thread >16ms — use `transform` and `opacity` only (GPU-composited); never animate `height`, `width`, `margin`, `padding` with JS
- Do NOT exceed 50KB gzipped motion contribution; if you do, remove optional animations first
