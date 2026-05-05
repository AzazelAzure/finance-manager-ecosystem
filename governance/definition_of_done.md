# Definition of done — feature rollouts & sprints (ecosystem)

**Status:** living governance (HitM + agents). **Related:** [`plan_template.md`](./plan_template.md) §1a (V-tiers), [`glossary.md`](./glossary.md) §12, [`sprint_queue_message_spec_v1.md`](./sprint_queue_message_spec_v1.md) (`#sprint-queue`), [`branching_guidelines.md`](./branching_guidelines.md), [`deployment_protocol.md`](./deployment_protocol.md).

This document ties together **interconnected** bars so “PASS” on a slice checklist does not silently contradict PWA, i18n, SEO, or beta expectations.

---

## 1) PWA — completeness and feature coupling

- The **Advanced PWA** implementation sprint is **not** treated as product-complete while **known PWA bugs and QoL issues** remain open on the canonical plan ([`plans/S1/S1.B/pwa-implementation-branch/README.md`](../plans/S1/S1.B/pwa-implementation-branch/README.md)) and [`governance/plan_registry.md`](./plan_registry.md) reflects that reality.
- **Every governed feature** that ships web UI must declare how it interacts with the PWA bar (install, offline, SW scope, outbox — see research hub [`plans/S1/S1.B/pwa-install-offline-sync-research/README.md`](../plans/S1/S1.B/pwa-install-offline-sync-research/README.md)).

### PWA scope class (mandatory in plan §2 Scope)

| Class | Meaning | Plan README must state |
|-------|---------|-------------------------|
| **A** | Does **not** break PWA; behavior is compatible **offline** within the agreed product window (or documented limits). | “PWA class **A**” + any test notes. |
| **B** | Does **not** break PWA shell/install, but capability is **online-only** (no offline parity). | “PWA class **B** — online-only” + user-visible expectation (settings, empty state, or marketing copy). |

Features that would **break** PWA (SW scope regressions, broken offline core ledger, etc.) are **blocked** until PWA owners resolve or explicitly gate.

---

## 2) Localization (i18n)

- **Default:** All user-visible strings introduced or changed by a feature **must** pass **localization tests** (repo i18n conventions / CI) before the plan moves to **completed** in `plan_registry.md`.
- **Shelved exception:** If product intentionally defers localization (example: **F-007** Joyride copy not yet wired to translation keys), the plan must record a **Shelved: i18n** row in §2 or §9 with **HitM signoff** and a **linked follow-up** task or plan id. **Shelved does not mean invisible** — it must be grep-friendly for the next sprint.

---

## 3) SEO — matrix and when to apply

- **Canonical matrix:** [`plans/S1/S1.B/distribution-channel-research/SEO_PRIORITY_MATRIX.md`](../plans/S1/S1.B/distribution-channel-research/SEO_PRIORITY_MATRIX.md) (and linked `SEO_GUIDE_*` files in that folder).
- **End of rollout (today’s bar):** Closing a feature that touches **public routes or indexable surfaces** includes confirming the **appropriate matrix tier** (P0 / P1 / …) and updating matrix **Status** or the plan evidence folder.
- **During the sprint (expectation shift):** New or heavily edited **public-facing** surfaces should **include applicable P0 matrix items** in the **same** PR train when they touch the listed files (meta, `robots.txt`, `sitemap`, structured data, etc.) — not only as a late add-on.

---

## 4) Beta transparency — F-011 (wedge / pipeline)

- **F-011** owns the **living** public story: landing, hero, value props, and **expanding beta-facing subpages** so testers see pipeline and truth ([`plans/S1/S1.B/feat-f011-wedge-landing-hero/README.md`](../plans/S1/S1.B/feat-f011-wedge-landing-hero/README.md)).
- Planned extensions (subpages): **About**, **Planned features / roadmap snapshot**, **Version / release notes** (what shipped + **notable bugfixes**), aligned with wedge audit and registry — details live in that plan’s task list as authored.

---

## 5) Sprint order — product, beta, infrastructure

- **Normative ordering** is **not** inferred from this file alone. HitM runs (or delegates) a **huddle** to lock stack rank: product needs, beta tester needs, infrastructure needs.
- **Huddle hub:** [`strategy/huddles/2026-05-22-feature-rollout-sprint-order/README.md`](../strategy/huddles/2026-05-22-feature-rollout-sprint-order/README.md) — capture inputs, proposed order, and `DECISIONS.md` / `ACTIONS.md` when locked.

---

## 5b) `#sprint-queue` (Cursor PA → cursor-agent)

When work is queued to **`#sprint-queue`**, every post **must** follow [`sprint_queue_message_spec_v1.md`](./sprint_queue_message_spec_v1.md) (`sprint-queue-v1`): **`@CursorPA`** line 1 (no space — `@Cursor PA` breaks the mention), **`Task Id:`** line 2 (stable intake id), fixed block order, tilde paths, and `BRANCH:` suffix `(already checked out)` / `(checkout required)`. **Do not** fork the spec into per-plan copies — link the governance file and keep plan-local files to **examples + slice order** only.

---

## 6) Checklist before marking a plan `completed`

- [ ] V-tiers and evidence per [`plan_template.md`](./plan_template.md) §1a.
- [ ] PWA class **A** or **B** documented; no unresolved PWA-breaking regressions.
- [ ] Localization satisfied **or** shelved with signed follow-up link.
- [ ] SEO matrix row(s) updated if public surfaces changed; P0 items in-PR where applicable.
- [ ] F-011 updated if hero/pipeline copy or beta subpages should reflect this release (or explicit waive in huddle).
- [ ] If `#sprint-queue` was used: messages matched [`sprint_queue_message_spec_v1.md`](./sprint_queue_message_spec_v1.md) (no ad-hoc field order).
- [ ] `plan_registry.md` and plan `README` metadata `updated:` field match reality.
