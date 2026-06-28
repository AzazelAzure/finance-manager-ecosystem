# Session Notes — TP16 (Human Relief) + Cluster C (Product Velocity)

**Date started:** 2026-05-06  
**Attendees:** HitM  
**Topics:** TP16, TP3, TP9, TP20, TP21  
**Status:** `in progress`

## Why these are combined

TP16 (human relief points) and Cluster C (product velocity) are two sides of the same coin: **what does HitM actually need to do, and how fast can things move given those constraints?** The answer to TP16 directly reshapes TP3 (feature scheduling), TP9 (efficiency), and TP21 (beta expansion).

## Decisions from prior sessions that constrain this discussion


| Decision                              | Source     | Impact here                                         |
| ------------------------------------- | ---------- | --------------------------------------------------- |
| S1.B timeline extended, accepted      | S1-D08     | No pressure to hit original May–Jul window          |
| Engineering hire deferred to S1.C+    | S1-D03     | HitM is the only technical operator for all of S1.B |
| Automation as engineering replacement | S1-D03     | Viable only if pipelines are robust enough          |
| No business loans                     | S1-D05     | Cannot buy capacity with debt                       |
| SMM family hire ~₱10k/mo post-baby    | S1-D06     | First capacity relief is marketing, not engineering |
| Baby due Jun 15                       | Constraint | ~5 weeks full velocity, then 30–50% reduction       |


---

## Decisions made this session


| Decision ID | Topic                                            | Decision                                                                                                                                                                                                 | Rationale                                                                                                                                           | Migrates to                                     |
| ----------- | ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| C-D01       | Planning baseline                                | **Conservative estimate (40–52 weeks, ~mid 2027)** adopted as S1.B planning baseline.                                                                                                                    | Baby adjustment + legal delays make this the honest timeline. HitM can absorb costs and time.                                                       | S1.B README, validation_gates.md                |
| C-D02       | Devops pause                                     | **All development stopped** during huddle sessions. Week of downtime accepted.                                                                                                                           | Stress relief from resolving direction is worth the pause. Broken systems and "where to go" ambiguity are the immediate problem, not code velocity. | —                                               |
| C-D03       | Definition of Done doctrine                      | **New DoD**: core functionality + SEO + i18n + PWA classification + guided walkthrough (post-F-007) + changelog. Applies to all post-huddle features.                                                    | Features shipped without these components create silent debt. DoD prevents shipping incomplete work.                                                | governance (new doctrine doc), plan_template.md |
| C-D04       | F-007 status                                     | **MUST-SHIP** (elevated from "should-ship"). First-time PFM users need guided help. Cannot risk losing testers.                                                                                          | User demographic is mostly first-time PFM users. "How to" support doesn't scale with HitM as sole operator.                                         | F-007 plan status                               |
| C-D05       | PWA fix status                                   | **MUST-SHIP** (elevated to Tier 0, non-negotiable). Fix network error + offline shell.                                                                                                                   | Offline mode is real value for demographic with spotty internet. Losing testers to broken offline is unacceptable.                                  | PWA implementation plan                         |
| C-D06       | F-007 pivot                                      | **Tentative: Option B** — freeze current WIP, pivot to F-011, return to guides post-F-011.                                                                                                               | Gets public surface live faster. Guides come back with more features to cover.                                                                      | F-007 plan, feature sequence                    |
| C-D07       | F-011 scope expansion                            | F-011 expanded from "landing hero" to **full public surface**: ToS, Privacy, changelog, feature roadmap page, founding member info.                                                                      | Beta testers and potential founders need to see development momentum and understand what they're testing toward.                                    | F-011 plan scope                                |
| C-D08       | Feature priority order                           | **Tier 0**: PWA fix + F-007 → **Tier 1**: F-011 → **Tier 2**: F-004, F-001, F-009, F-005 → **Tier 3**: F-012, F-013, F-010 → **Deferred**: F-002/3, F-006, F-008.                                        | Usability first, trust surface second, wedge features third. Deferred features are AI tier or complex models not needed for "worth paying for".     | feature execution plan index                    |
| C-D09       | DoD includes guides                              | Once F-007 guide system is complete, **all new user-facing features must include walkthrough steps** as part of DoD.                                                                                     | Consistency; prevents "guides exist but only cover old features" problem.                                                                           | governance DoD doctrine                         |
| C-D10       | PWA offline split (hypothesis)                   | **Current core functions** (transactions, calendar, sources, quick add, guides) = offline-capable. **Added tools** (AI, export, family sync, intake) = online-only default. Needs dedicated design work. | Principle: existing functions stay offline; new additions are online-only unless clear user value for offline.                                      | PWA research, D2 outbox contract                |
| C-D11       | AI babysitting is the emergency                  | **5–12 hrs/day** spent babysitting AI operations is the MAJOR stressor. Caused the emergency pre-huddle and this huddle. Everything else is manageable; this is not.                                     | Automation pipeline hardening is the single highest priority post-huddle.                                                                           | Session 5 (TP5/TP14), S1.B priorities           |
| C-D12       | SMM needs beta access + org briefing             | SMM family hire must be a beta user first, get in-person app walkthrough, org structure briefing, and dedicated AI automation setup before she can promote effectively.                                  | Can't promote what you don't understand. Some AI automation for her is already planned but poorly organized.                                        | TP2, TP24, SMM onboarding plan                  |
| C-D13       | One-feature-at-a-time is context, not structural | Constraint exists for feature clarity and context, not as a hard rule. Concurrent features possible with multiple workspaces IF automation + governance + handoffs are solidified.                       | Workspaces exist now; the blocker is reliable handoffs, not workspace count.                                                                        | Session 5, branching_guidelines.md              |
| C-D14       | Manual verification = visual spec check          | Smoke tests are automated. Manual verification is HitM visually checking if implementation matches specs and providing feedback. Feedback loop automation is still early dev.                            | The "babysitting" is not smoke tests — it's the prompt → review → correct → re-prompt iteration loop.                                               | Session 5 (TP5)                                 |


## Parking lot


| Item                                                     | Related TP | Reason deferred                                                                                                                                                   | Target session/time     |
| -------------------------------------------------------- | ---------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| Visual overhaul ("good" vs "professional")               | TP3, F-011 | Not decided; revisit when F-011 public surface is being built. May integrate or separate.                                                                         | During F-011 execution  |
| **Automation pipeline audit + hardening** (CRITICAL)     | TP5, TP14  | Requires deep dive into existing Slack/inbox/outbox/PA infrastructure. Must understand what's working vs just documented. **Highest priority remaining session.** | **Session 5**           |
| PWA offline/online feature split — dedicated design work | TP3, PWA   | Hypothesis captured; needs deeper architecture pass                                                                                                               | Pre-PWA implementation  |
| Parallel-safe feature classification (formal)            | TP3, TP9   | Flagged in feature table but not formally locked. Depends on automation governance being solid (C-D13).                                                           | Post Session 5          |
| DoD doctrine → governance doc creation                   | C-D03      | Need to create formal governance document from this decision                                                                                                      | Post-huddle             |
| Plan registry update frequency                           | TP9        | Weekly batch vs per-change — interacts with automation reporting pipeline                                                                                         | Session 5               |
| CPPRD tiering decision                                   | TP9        | Currently AI-automated; tiering depends on context window and drift potential analysis                                                                            | Session 5               |
| SMM AI automation setup (consolidate existing plans)     | TP2, TP19  | Some automation already planned but poorly organized; needs consolidation pass                                                                                    | Post-baby, pre-SMM-hire |


