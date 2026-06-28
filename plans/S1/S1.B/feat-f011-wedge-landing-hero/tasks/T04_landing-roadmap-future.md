# T04 — Honest forward roadmap (post-June production batch)

> **Living-plan pass.** Authored 2026-06-28. The landing `Roadmap` section is stale: it
> still lists **Pay Cycles & Bills (F-004)** as upcoming even though F-004 shipped today,
> and it surfaces generic items rather than the real pipeline.
>
> **Ships together with [T03](./T03_landing-reflect-shipped.md)** on one web branch / PR /
> inactive-color deploy (same landing surface + same `i18n.ts`). T04 owns the **forward
> roadmap** surface only.

## End State

The landing `Roadmap` section reflects the **real** forward pipeline from
`strategy/priority_matrix_2026-06-28.md` and `governance/plan_registry.md` — nothing that
has already shipped is listed as "next/later", and the items shown match the actual backlog
ordering (Tier 1 → Tier 2). At most one "just shipped" proof card may anchor the timeline.

## Cross-reference (source of truth for "what's next")

| Capability | Plan | Matrix tier | Roadmap status |
|---|---|---|---|
| Pay cycles + bill realism | F-004 | Tier 0 (shipped) | `done` (anchor proof — the wedge, just shipped) |
| Recurring bill automation | F-009 | Tier 1 (July, P1) | `now` |
| Customizable dashboard | F-006 | Tier 1 (July, P2) | `next` |
| Predictive budgeting + smart tags | F-003 / F-002 | Tier 2 (Q3) | `later` |
| Family / household ledger | F-008 | Tier 2 (Q3) | `later` |

Do **not** list F-001 / F-005 / F-010 in the roadmap — they shipped and belong in
VersionHistory/FeatureShowcase (owned by T03).

## Acceptance Criteria

1. [V3] Roadmap items match the table above (statuses + ordering).
2. [V3] No shipped-and-promoted capability appears as `now`/`next`/`later`.
3. [V3] No internal codes (`F-0##`, `T##`) or VPS/color jargon visible to the public.
4. [V3] i18n: every new/changed `roadmap.*` key exists in both `en-US` and `tl-PH`.
5. [V1] `npm run build` + `tsc -b` clean; `vitest run` green.

## Scope Lock

### Files to modify
- `src/components/landing/Roadmap.tsx`
- `src/lib/i18n.ts` — `roadmap.*` keys only (en-US + tl-PH)
- `CHANGELOG.md`

### Files NOT to touch
- VersionHistory / FeatureShowcase / ValueProps / Hero → owned by **T03**
- Anything outside the landing roadmap surface

## Slices

### T04.SL1 — Roadmap component + keys
Rework `ROAD` array + `roadmap.*` keys to the pipeline table above. Evidence: [V3] screenshot of timeline.

### T04.SL2 — i18n parity + build
en-US + tl-PH parity; `npm run build` + `tsc -b` + `vitest run`. Evidence: [V1] build log.

## Notes

- Keep the roadmap **forward-looking**: the section header is "On the roadmap", so it should
  read as "what's coming", anchored by at most one just-shipped proof point.
- Re-run the relevant rows of `plans/S1/S1.B/wedge-consistency-audit/AUDIT_REPORT.md` after this pass.
- CPPRD: web `CHANGELOG.md` updated in the same change.
