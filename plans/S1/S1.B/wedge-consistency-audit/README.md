---
plan_id: PLAN_AUDIT_WEDGE_CONSISTENCY_2026-04-30
status: draft
priority: P2
created: 2026-04-30
updated: 2026-05-21
owner: pproctor

plan_root: plans/S1/S1.B/wedge-consistency-audit/
intended_branch: cursor/s1b/wedge-consistency-audit
parent_plan: plans/S1/S1.B/
target_repos:
  - finance_manager_web
  - design_docs

strategic_phase: S1
strategic_link: plans/cursor/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md

depends_on: []
blocks: []
parallel_safe_with:
  - PLAN_RESEARCH_ENTITY_FORMATION_2026-04-30
  - PLAN_RESEARCH_PAYMENT_PROVIDER_2026-04-30
  - PLAN_RESEARCH_AI_ECONOMICS_2026-04-30
  - PLAN_RESEARCH_DISTRIBUTION_CHANNEL_2026-04-30
  - PLAN_OPS_DRIFT_CLEANUP_2026-04-30
  - PLAN_RESEARCH_PWA_INSTALL_OFFLINE_SYNC_2026-05-01
conflicts_with: []

slack_gates:
  pre_execution: none
  pre_merge: required
  pre_close: optional

deployment:
  required: false

standalone: true
standalone_notes: ""
---

# S1.B Sub-Plan — Wedge Consistency Audit

## 0) Strategic Inheritance

- **Wedge respected:** this audit **is** the wedge-consistency mechanism for public-facing copy.
- **Locked decisions touched:** [`00_strategic_context.md`](../../../cursor/strategic-roadmap-reframe-53be/00_strategic_context.md) **§1** (canonical wedge sentence) — every in-scope surface should **anchor** on it or explicit thin-margin / safe-to-spend language aligned to §2 persona.
- **Cost cap impact:** none (HitM time + light agent cycles).
- **Validation gates affected:** [`validation_gates.md`](../../../cursor/strategic-roadmap-reframe-53be/validation_gates.md) S1.B exit — wedge audit **complete** (paired in phase doc with **landing-page polish landed**; polish is **W3**, audit can **finish first** and hand fixes to W3).

## 0.3) Canonical wedge (verbatim — audit target)

From **`00_strategic_context.md` §1** (do not paraphrase for “hero” verdict without HitM exception):

> **"The personal finance app that tells you what's actually safe to spend before payday — built for people living on thin margins, not people optimizing surplus."**

**Thematic alignment** (acceptable where verbatim line is too long, e.g. a KPI label): copy must clearly evoke **safe-to-spend before payday** and **thin margins**, not generic budgeting / surplus optimization. When in doubt, flag **⚠** and propose text for HitM.

## 0.4) Sequencing vs other S1.B work

| Question | Answer |
| -------- | ------ |
| Blocks **PWA** implementation? | **No** — run in parallel ([`../pwa-install-offline-sync-research/README.md`](../pwa-install-offline-sync-research/README.md)). PWA install strings / manifest copy should appear as **extra rows** in [AUDIT_REPORT.md](./AUDIT_REPORT.md) when those assets exist. |
| Blocks **payment** research? | **No**. |
| Replaces **W3** landing polish? | **No.** Audit **lists** gaps; **W3** (and follow-up web PRs) **implements** hero/value-prop changes. Exit gate still requires polish **landed** after findings are triaged. |
| Live checks | Production: **`https://thehivemanager.com/`**. Stack-shaped verification: dev VPS **HTTPS :8443`** (blue/green proxy) per [`AGENTS.md`](../../../../AGENTS.md) — use when comparing deploy-shaped build vs local Vite-only. |

## 0.5) Artifact index

**One-page index:** [RESEARCH_ARTIFACTS.md](./RESEARCH_ARTIFACTS.md)  
**Working report:** [AUDIT_REPORT.md](./AUDIT_REPORT.md) — fill §2 table during the sweep; signoff in §5.

## 0.6) Surface → code map (flagship `web`)

Most user-visible strings for landing + app chrome live in **`finance_manager_web/src/lib/i18n.ts`** under **`en-US`** and **`tl-PH`**. Audit **both** locales for each key in scope.

| Category | Where to look |
| -------- | ------------- |
| Landing hero, value props, showcase, preview, roadmap, CTA | `Hero.tsx`, `ValueProps.tsx`, `FeatureShowcase.tsx`, `LivePreview.tsx`, `Roadmap.tsx`, `CTASection.tsx` — strings via `tr(..., locale)` → **`i18n.ts`** |
| Public header / footer | `PublicShell.tsx` (`public-footer`, brand line); **`index.html`** `<title>` |
| Login / signup | `i18n.ts` `login.*`, `signup.*` |
| Dashboard first screen / KPIs | `i18n.ts` `dashboard.*` + dashboard route components |
| Onboarding, settings, guide | `i18n.ts` keys + matching pages under `src/` |
| PWA name / description | Vite PWA config / manifest when present (add row to audit report if not yet in repo) |
| **Brand / maskable / favicon assets** | **`finance_manager_web/public/`** + manifest; **canonical exports** in ecosystem **`resources/hfm_icon_web/`** (cropped + transparent PNGs). **Ownership:** HitM; generated via **Google Gemini** image — no stock clearance. **Implementation plan:** [`../feat-f011-wedge-landing-hero/README.md`](../feat-f011-wedge-landing-hero/README.md) (F-011 / W3 polish). |
| Legal | ToS / Privacy / Refund pages or static assets when live in `web` |

**Design vault (optional row):** `design_docs/01_Business_Vision.md` — excerpt only if it **diverges** from §1 wedge; vault changes use **design_docs** submodule CPPRD.

## 1) Objective

Produce a **complete, signed audit** that:

1. Classifies each in-scope surface as **✅ / ⚠ / ✗** against §0.3–0.4 rules.
2. Supplies **concrete replacement copy** (or wireframe note) for every **⚠** and **✗**.
3. Triage fixes **P0** (before S1.C / public wedge-dependent messaging) vs **P1** (polish queue).

Per huddle Topic 7 Q7.3: baseline human+agent audit in S1.B; optional **automated grep** later ([`AUDIT_REPORT.md`](./AUDIT_REPORT.md) §4).

## 2) Scope

### In scope

| Category | Surfaces |
| -------- | -------- |
| **Static product surfaces** | Landing hero, sub-hero, value props, dashboard primary KPI / above-the-fold copy, onboarding, settings/about/guide, public footer |
| **Public chrome** | `index.html` title, meta description if user-facing |
| **Public-facing docs** | Repo READMEs meant for prospects; ToS; Privacy; Refund — when published |
| **PWA / install copy** | Manifest / install UI strings when shipped |
| **Social / store** | FB business about + pinned framing; app store first line — **when published** (N/A rows OK) |

### Consistency rules (locked)

- **✅ Consistent:** Leads with the **verbatim** wedge sentence **or** clearly equivalent **safe-to-spend + thin margins** positioning tied to §2 persona.
- **⚠ Partial:** Mostly on-wedge but buried, diluted, or mixed with generic “finance clarity” without survival-math anchor.
- **✗ Inconsistent:** Generic “budgeting” / “plan with confidence” / surplus framing; **retired** “Average Joe vs Finance Bro” **marketing** persona; surplus-optimization vibe.

### Out of scope

- **Visual** redesign / layout polish (W3 owns landing polish **implementation**).
- **New** feature copy beyond alignment fixes (separate tasks).
- Changing **`00_strategic_context.md` §1** sentence itself (that is strategy governance, not this audit).

## 3) Method

1. Read §1–§2 in `00_strategic_context.md`.
2. Walk **`i18n.ts`** keys for both **`en-US`** and **`tl-PH`** for every row in [AUDIT_REPORT.md](./AUDIT_REPORT.md) §2.
3. Spot-check **live** production URL; optionally `:8443` deploy for parity.
4. Record verdicts + suggested fixes; triage P0/P1 in §3 of the report.
5. HitM signoff in [AUDIT_REPORT.md](./AUDIT_REPORT.md) §5.

## 4) Deliverables

| Deliverable | Location |
| ----------- | -------- |
| Completed audit table + P0/P1 list + signoff | [AUDIT_REPORT.md](./AUDIT_REPORT.md) |
| Optional: excerpt or link from `design_docs` | Only if vault narrative must change; submodule PR per [`git-repo-workflow`](../../../../.cursor/rules/git-repo-workflow.mdc) |
| Optional automation | Script or CI note per report §4 — **explicit defer** is acceptable |

## 5) Verification Gates

- [ ] [AUDIT_REPORT.md](./AUDIT_REPORT.md) §2 covers **all** §2 scope rows (mark N/A with reason where appropriate).
- [ ] Every **✗** and **⚠** has a **suggested fix** (or explicit HitM waiver).
- [ ] HitM checked §5 signoff boxes (or listed deferrals with owner).

## 6) Documentation Sync Required

- Keep this plan’s **`status`** in YAML aligned with reality (`draft` → note completion date in `updated` when done).
- If `design_docs` changes: submodule pin + vault `CHANGELOG` per CPPRD.
- Web copy fixes: **`finance_manager_web`** own repo `CHANGELOG` + PR (not parent-only).

## 7) Strategic Phase Impact

- **S1.B exit:** wedge consistency audit **complete** per `validation_gates.md` (with landing polish **landed** separately via W3).
- Sets baseline for optional **weekly** grep / re-audit in S1.C+ ([`AUDIT_REPORT.md`](./AUDIT_REPORT.md) §4).

## 8) Risks

| Risk | Mitigation |
| ---- | ---------- |
| Audit passes but W3 does not schedule fixes | P0 list is explicit input to W3 backlog |
| `tl-PH` lags `en-US` | Audit both; do not sign off until PH locale is **intentionally** aligned or waived |
| Scope creep into redesign | Treat visual-only changes as out of scope unless copy changes |

## Estimated Effort

- **HitM:** ~1 hour review + signoff after report is drafted.
- **Agent:** ~2–4 hours first-pass sweep + report fill (slip-in **~1 hour** possible if limiting to landing + dashboard KPI only — record **reduced scope** in audit header).
