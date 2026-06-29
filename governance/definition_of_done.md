# Definition of done — feature rollouts & sprints (ecosystem)

**Status:** living governance (HitM + agents). **Related:** [`plan_template.md`](./plan_template.md) §1a (V-tiers), [`glossary.md`](./glossary.md) §12, [`branching_guidelines.md`](./branching_guidelines.md), [`deployment_protocol.md`](./deployment_protocol.md).

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

## 5) Privacy & data security gate

**Added 2026-06-30 — F-010 RCA.** Root cause: a public bearer-URL share endpoint shipped through a normal feature PR without any privacy review, because no DoD gate required one.

### 5a. Unauthenticated access + financial data — mandatory HitM risk-acceptance

Any plan that introduces or modifies an endpoint using `AllowAny` (or equivalent unauthenticated permission class) **and** that endpoint returns, accepts, or proxies user financial data **must**:

1. Include an explicit **HitM risk-acceptance note** in the plan's `README.md` §2 Scope or §6 Verification Gates, signed by HitM before executor starts implementation.
2. Log an **audit entry** in the plan's `DECISION_LOG.md` (or parent audit log) recording the decision, the exposure surface, and the mitigations in place.
3. Have this audit entry **present at pre-merge gate** — the PR cannot be approved without it.

**What counts as financial data:** account balances, transactions, savings goals, upcoming expenses, STS values, export archives, or any derived aggregate from those fields.

**What this does NOT block:** unauthenticated public routes that return no user data (landing page, legal pages, health checks, static assets).

### 5b. New data collection, storage, or sharing features

Any plan that:
- Adds a new data collection mechanism (telemetry, analytics, logging expansion)
- Adds a new storage category (new IndexedDB store, new cookie, new DB table holding PII)
- Adds or changes any data-sharing or export surface

Must update `strategy/analytics_and_data_sharing_overview.md` §8 Known Gaps **before the plan closes**, and flag `privacy_policy: true` in the plan YAML metadata (which triggers the legal workflow per `plan_template.md` §2 legal impact rule).

### 5c. Checklist additions

These are added to §7 below:

- [ ] If any endpoint uses `AllowAny` and touches user financial data: HitM risk-acceptance note present in plan + audit entry in DECISION_LOG.
- [ ] If plan adds/changes data collection, storage, or sharing: `analytics_and_data_sharing_overview.md` updated; `privacy_policy: true` set in plan YAML.

---

## 6) Sprint order — product, beta, infrastructure

- **Normative ordering** is **not** inferred from this file alone. HitM runs (or delegates) a **huddle** to lock stack rank: product needs, beta tester needs, infrastructure needs.
- **Huddle hub:** [`strategy/huddles/2026-05-22-feature-rollout-sprint-order/README.md`](../strategy/huddles/2026-05-22-feature-rollout-sprint-order/README.md) — capture inputs, proposed order, and `DECISIONS.md` / `ACTIONS.md` when locked.

---

## 7) Checklist before marking a plan `completed`

- [ ] V-tiers and evidence per [`plan_template.md`](./plan_template.md) §1a.
- [ ] PWA class **A** or **B** documented; no unresolved PWA-breaking regressions.
- [ ] Localization satisfied **or** shelved with signed follow-up link.
- [ ] SEO matrix row(s) updated if public surfaces changed; P0 items in-PR where applicable.
- [ ] F-011 updated if hero/pipeline copy or beta subpages should reflect this release (or explicit waive in huddle).
- [ ] If any `AllowAny` endpoint touches user financial data: HitM risk-acceptance note + audit entry present (§5a).
- [ ] If plan adds/changes data collection, storage, or sharing: `analytics_and_data_sharing_overview.md` updated; `privacy_policy: true` set in plan YAML (§5b).
- [ ] `plan_registry.md` and plan `README` metadata `updated:` field match reality.
