# Huddle — Feature rollout sprint order (product · beta · infra)

**Date:** 2026-05-22 (scheduled / in progress)  
**Owner:** HitM  
**Goal:** Lock a **single stack-ranked sprint order** for F-* and infra work so agents, registry, and Cursor automation do not infer conflicting priorities.

## Why now

- **PWA** remains open with bugs/QoL gaps — “complete” is blocked until those are honest in registry + plan state.
- **Definition of done** now spans PWA class **A/B**, **localization**, **SEO matrix**, and **F-011** beta surfaces — see [`governance/definition_of_done.md`](../../../governance/definition_of_done.md).
- **F-007** polish and other features need a **HitM-verified base bar** before parallel agents treat slices as contractual.

## Inputs (prepare before session)

1. **Product** — revenue / wedge / onboarding priorities (which F-* unblock others).
2. **Beta** — tester pain from support + `feat-f011` pipeline visibility gaps.
3. **Infrastructure** — VPS, intake (F-012/F-013), anything blocking deploy or trust.

## Artifacts

| File | Purpose |
|------|---------|
| [`TALKING_POINTS.md`](./TALKING_POINTS.md) | Agenda + prompts |
| [`DECISIONS.md`](./DECISIONS.md) | Locked ordering + rationale (fill during/after huddle) |
| [`ACTIONS.md`](./ACTIONS.md) | Concrete follow-ups (registry rows, plan status bumps) |

## Output (success criteria)

- A **numbered sprint order** (e.g. next 3–6 execution windows) written into `DECISIONS.md`.
- `governance/plan_registry.md` and affected plan READMEs updated to match (or explicit `blocks` / `depends_on` edges).
- Link from [`glossary.md`](../../../governance/glossary.md) §12 — already points here for sprint ordering.

## Links

- [`governance/definition_of_done.md`](../../../governance/definition_of_done.md)
- [`plans/S1/S1.B/distribution-channel-research/SEO_PRIORITY_MATRIX.md`](../../../plans/S1/S1.B/distribution-channel-research/SEO_PRIORITY_MATRIX.md)
- [`plans/S1/S1.B/pwa-implementation-branch/README.md`](../../../plans/S1/S1.B/pwa-implementation-branch/README.md)
- [`plans/S1/S1.B/feat-f011-wedge-landing-hero/README.md`](../../../plans/S1/S1.B/feat-f011-wedge-landing-hero/README.md)
