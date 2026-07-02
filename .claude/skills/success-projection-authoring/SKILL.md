---
name: success-projection-authoring
description: Use to author or re-score the long-term success/profitability projection — forward-looking burn baseline, revenue ladder, probability bands, and needle-moving variables. Triggered at gate checkpoints, quarterly self-reviews, or any 10x-order change in active user base.
---

# Success Projection Authoring

## Category

Strategic-cadence skill — single-owner (Claude, with HitM as the ultimate authority on
judgment calls), but tied to strategic/business cadence rather than a `deploy_lifecycle.md`
phase. Doesn't fit the existing 3-category taxonomy cleanly; noted in `skill_architecture.md` as
a taxonomy extension rather than forced into Phase/tool-mechanism/doctrine.

## Doctrine

- `strategy/projections/README.md` — the projection/quarterly-review/success-projection cluster
  relationship ("interconnected... when one moves, note the cross-impact in the other").
- `strategy/projections/success_projection_2026-06.md` — the living baseline; **structural
  precedent, not a template to overwrite** — new versions are dated siblings
  (`success_projection_<YYYY-MM>.md`), preserving prior baselines so trend-over-time stays
  visible, matching how `quarterly_reviews/` is already dated-per-quarter.
- `strategy/strategic-roadmap-reframe-53be/validation_gates.md` — phase gates the re-score
  triggers tie to.
- `strategy/current_status.md` §14 — cross-referenced from the projection's own header.
- `AGENTS.md` §4 — quarterly cadence definition.

## Loads

- `quarterly-review-authoring` (imperative, conditional) — if this projection refresh surfaces a
  material shift, check whether it should also trigger a quarterly review refresh per the
  cluster's bidirectional relationship ("A quarterly review should trigger a projection refresh,
  and vice-versa").
- `status-verification-spotcheck` (imperative) — before updating the re-score worksheet with
  "actual" metrics, verify them against live sources (plan registry, actual MRR/user counts if
  tracked) rather than carrying forward assumed figures.

## Tools

None fixed — this is synthesis/analysis work over existing docs and whatever live metrics HitM
provides, not a wrapped script or MCP call.

## Procedure

1. Re-read the current baseline in full (burn, revenue ladder, probability bands, the four
   needle-moving variables) before changing anything — this is a re-score, not a rewrite from
   scratch.
2. Pull actual data since the last baseline: active users, paying users, net MRR, invite growth
   coefficient, OTP-vs-subscription take-up — whatever's genuinely known today. Where data isn't
   available, say so explicitly rather than estimating silently.
3. Re-score the probability bands with an explicit delta from the previous baseline (up/down/flat
   per outcome tier), not just new numbers — the point of the document is tracking *shift*, not a
   fresh snapshot each time.
4. Re-examine the "dominant strategic fact" and "needle-moving variables" sections against
   current reality — these can change if a variable resolved (e.g., an entity decision made, a
   channel tested) or a new one emerged.
5. Fill the re-score worksheet's actual-vs-baseline columns.
6. Write the new version as a dated sibling file, not an overwrite — update
   `strategy/projections/README.md`'s table to point at the new current version, note the
   superseded one stays for historical trend reference.
7. Flag cross-impact to `quarterly-review-authoring` if this refresh surfaces something material
   enough to affect the next quarterly review's Part 2/4.

## Handoff

`Skill(s) used: success-projection-authoring` plus any loaded skills, in the meeting decision
log or wherever this was invoked from. If a quarterly-review cross-trigger fired, name it
explicitly: `Skill(s) to load: quarterly-review-authoring`.
