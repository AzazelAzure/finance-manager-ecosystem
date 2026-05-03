---
task_id: T06
status: pending
owner: unassigned
phase: P5
breakpoint: BP_SW_CACHE
last_verification: null
---

# T06 — Service worker: shell + Vite-safe cache policy

## Objective

Register a service worker with caching that **does not** strand users on stale HTML referencing missing hashed chunks (research README §3.1): network-first or SWR for **HTML document**; immutable/long-cache for fingerprinted `assets/*`; `activate` cleans obsolete cache names.

## Repo scope

- `finance_manager_web/` (Vite PWA plugin or custom SW — match repo conventions)

## Dependencies

- T05 manifest path stable.

## Checklist

- [ ] SW scope matches app origin; no cross-origin mistakes.
- [ ] Precache vs runtime cache split documented.
- [ ] Second visit: core shell loads with DevTools **offline** after warm-up (per §6 tier expectation).
- [ ] No auth token leakage into inappropriate caches.

## Definition of done

- **BP_SW_CACHE** PASS.

## Verification

```bash
cd finance_manager_web && npm run build && npm run preview
# Manual: Application tab → SW + offline
```

## Risks

- Over-caching API JSON — default network for API paths unless explicitly designed otherwise.

## PR expectations

- Include brief comment or doc file on cache strategy for operators.
