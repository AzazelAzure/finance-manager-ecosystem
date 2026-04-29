# T01 — Protected shell navigation (wide + narrow)

## Objective
Restore correct **navigation chrome** for `protected_app_shell`: vertical rail + hover expansion on wide screens, and a **reachable** nav pattern on narrow screens without controls disappearing **behind** the sticky header.

## Scope boundary
- **In:** `finance_manager_reflex/app/shell.py`, `finance_manager_reflex/assets/index.css`, minimal edits to `finance_manager_reflex/ui/primitives.py` only if required for header/wrapper.
- **Out:** Transaction page internals, API contracts, proxy/nginx.

## Definition of done
- [ ] Wide (≥1280px): Sidebar behavior matches product intent (collapsed rail + hover labels); no accidental switch to “mobile top bar only” unless spec’d.
- [ ] Narrow (≤900px): Nav items usable; **no** overlap where `protected-header` covers the horizontal nav row during scroll or at rest.
- [ ] `validation_gates.md` **Gate V1** passes.

## Implementation hints (non-prescriptive)
- Compare **DOM order** in `shell.py` (`rx.hstack(sidebar, main_content)`) vs CSS `@media` that changes `position`/`flex-direction`; consider `scroll-padding-top` on the scroll parent if header is sticky.
- Resolve **stacking contexts**: sidebar `z-index` vs header `z-index`; avoid arbitrary numbers without documenting why.
- Prefer **one breakpoint strategy** (e.g. align 1200 vs 900 rules) to reduce conflicting `position: static` / `sticky` toggles.

## Verification
1. Local: `reflex run --env dev` (or project standard) + browser resize through Gate V1 matrix.  
2. Optional: build prod image and spot-check one VPS URL.

## Risks / follow-ups
- **Touch vs hover:** hover expansion may be wrong for touch-first wide tablets; document if a separate breakpoint is needed.
- **i18n:** longer `tl-PH` labels must not overflow nav lane; truncate or allow wrap per design.

## Branch / PR
- Reflex: `fix/reflex-dashboard-ui-regression` → PR to default branch per `git-repo-workflow.md`.
