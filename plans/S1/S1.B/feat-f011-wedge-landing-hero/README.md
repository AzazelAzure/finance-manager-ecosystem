---
plan_id: PLAN_CROSS_WEDGE_MARKETING_F011_2026-05-05
status: draft
priority: P2
created: 2026-05-05
updated: 2026-05-21
owner: pproctor

plan_root: plans/S1/S1.B/feat-f011-wedge-landing-hero/
intended_branch: cursor/s1b/feat/f011-wedge-landing-hero
parent_plan: plans/S1/S1.B/

target_repos:
  - finance_manager_web

strategic_phase: S1
strategic_link: strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with: []
conflicts_with: []

slack_gates:
  pre_execution: none
  pre_merge: required
  pre_close: optional

deployment:
  required: true
  target_services: [js]
  bundle_required: true
  rollback_plan_id: null
  smoke_targets:
    - GET / (public landing)
    - i18n keys for hero/value props render
  notes: **Living plan:** re-open or add tasks whenever **material F-*** features ship — hero feature bullets and showcase must expand so marketing stays honest (H-W3-1). Wedge audit: `wedge-consistency-audit/AUDIT_REPORT.md`. **Brand pack:** ecosystem `resources/hfm_icon_web/` (cropped + transparent PNGs, multi-size); HitM-owned (Gemini image generation); wire into web favicon, manifest, OG, public shell.

standalone: true
standalone_notes: ""
---

# F-011 — Wedge-aligned landing & hero (living surfaces)

**Feature idea:** [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) (F-011). **Huddle:** H-W3-1 (Topic 7).

## Task and slice IDs

Per [`governance/plan_template.md`](../../../../governance/plan_template.md) **§1a Task slices (T##.SL#)** and [`governance/branching_guidelines.md`](../../../../governance/branching_guidelines.md): decompose execution into **tasks** (`T##`, with task branch `…/t##-<slug>` when shipping code) and **slices** (`T##.SL#`). **`SL`** avoids collision with Phase/Stage **S** notation (`S1`, `S1.B`). Default one slice per **web route/page** or per **API model/viewset seam**; do not assign whole-product scope to a single agent pass unless the touched surface is trivially small. Executors must **ask clarifying questions** when acceptance criteria or contracts are underspecified instead of guessing.

## 0) Strategic Inheritance

- **Wedge respected:** yes — canonical sentence in `design_docs/01_Business_Vision.md`.
- **Locked decisions touched:** public marketing copy only unless pricing blocks added.
- **Cost cap impact:** none.
- **Validation gates affected:** wedge consistency audit P0/P1 rows.

## 1) Objective

Keep **landing**, **hero**, **value props**, and **feature showcase** aligned with shipped reality as F-001+ capabilities grow; avoid stale “coming soon” or missing hero proof for shipped work.

## 2) Scope

### In scope

- Copy + layout updates in `finance_manager_web` public shell / i18n; optional screenshots.
- Process: after each major feature plan closes, add a **pass** task here or bump `updated` and run audit checklist rows.
- **Brand icons (HitM asset drop):** canonical raster set lives in the **ecosystem parent repo** at **`resources/hfm_icon_web/`** (transparent + trimmed variants, square master, 16–512px exports). Icons were produced with **Google Gemini** image generation; **no third-party stock rights** — HitM-owned. Implementation: copy or pipeline into `finance_manager_web` (`public/`, favicon, **PWA manifest** icons, Apple touch, OG / social preview as needed) and update wedge audit **Public chrome** / **PWA** rows. Add a task (e.g. `tasks/Txx_brand_icons_web.md`) when scheduling the pass.

### Out of scope

- Paid ads landing pages; separate marketing site repo (unless later unified).

## 3) Source Evidence

- [`../../FEATURE_IDEAS.md`](../../FEATURE_IDEAS.md) §F-011.
- [`../wedge-consistency-audit/AUDIT_REPORT.md`](../wedge-consistency-audit/AUDIT_REPORT.md).

## 4) Phase Plan or Task List

Rolling: link to child tasks `tasks/Txx_post_f00y_ship.md` as features land (author per release).

## 5) Execution Order

After dependent feature **merge to main** + smoke, schedule hero pass within same release train or next (HitM call).

## 6) Verification Gates

- Wedge audit table updated for static surfaces touched.
- No contradiction between hero bullets and actual app routes.

## 7) Documentation Sync Required

- Web changelog for user-visible copy; optional `design_docs` excerpt refresh.

## 8) Strategic Phase Impact

Plan may stay `draft` indefinitely as **living**; mark `completed` only for discrete named passes if desired, or use `updated` field as heartbeat.

## 9) Completion Criteria

- Per pass: audit rows for edited surfaces marked ✅ with evidence link.

## 10) Risks and Rollback

| Risk | Trigger | Rollback | Owner |
| ---- | ------- | -------- | ----- |
| Overclaim in hero | feature slipped | Revert copy commit | web |
