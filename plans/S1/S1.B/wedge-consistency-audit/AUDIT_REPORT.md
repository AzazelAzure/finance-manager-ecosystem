# Wedge consistency audit — report

**Status:** Partial — F-011 T03+T04 pass rows filled 2026-06-28; full audit execution still open.  
**Canonical wedge** (verbatim target for hero / first-line surfaces):

> **"The personal finance app that tells you what's actually safe to spend before payday — built for people living on thin margins, not people optimizing surplus."**

Source: [`00_strategic_context.md`](../../../../strategy/strategic-roadmap-reframe-53be/00_strategic_context.md) §1.

| Audit date | Auditor | Web rev / deploy |
| ---------- | ------- | ---------------- |
| 2026-06-28 | Cursor (F-011 T03+T04) | Web `8c117ee` (PR #90); active green VPS |

## 1) Summary

- **F-011 T03+T04 pass (2026-06-28):** Landing hero, value props, showcase, roadmap, and version history now reflect shipped F-001/F-004/F-005/F-010 and honest forward pipeline (F-009/F-006/F-003/F-008). HitM V3 approved; promoted active green.
- **Wedge anchor present:** Hero body and `value.clarity.*` lead with pay-cycle-aware safe-to-spend language in en-US and tl-PH.
- **Remaining gaps:** Public chrome (manifest/OG), auth surfaces, onboarding, app-shell KPI strings, and design-vault excerpt rows not re-audited this pass.
- **Recommended next:** Re-run rows 4–12 before S1.C entry; weekly grep for retired marketing phrases (§4).

## 2) Surface-by-surface findings

Use **✅** consistent, **⚠** partial, **✗** inconsistent. Copy **current** primary user-visible string (or screenshot ref) into “Evidence.”

| # | Category | Surface (path or URL) | en-US / locale | Evidence | Verdict | Suggested fix (if ⚠/✗) | Priority |
| - | -------- | --------------------- | -------------- | -------- | ------- | ---------------------- | -------- |
| 1 | Static — hero | `finance_manager_web/src/lib/i18n.ts` → `hero.*` | `en-US`, `tl-PH` | en: "See what's actually safe to spend before payday — with balance trends, savings goals, real pay cycles…" tl: "Tingnan kung magkano ang talagang ligtas gastusin bago ang sweldo…" | ✅ | — | — |
| 2 | Static — value props | same → `value.*` | both | en `value.clarity.title`: "Safe to spend, before payday"; `value.bills.*` references pay cycle + partial payments | ✅ | — | — |
| 3 | Static — showcase / preview / roadmap / CTA | same → `showcase.*`, `preview.*`, `roadmap.*`, `history.*` | both | Showcase: Goals tab + STS/balance blurbs. Roadmap: pay cycles `done`, F-009 `now`. History: v1.3 "Money, with Realism" entry. No internal F-0## codes. | ✅ | — | — |
| 4 | Public chrome | `PublicShell.tsx` footer + brand strings; `index.html` `<title>` | | | | | |
| 5 | Auth surfaces | `login.*`, `signup.*` in `i18n.ts` | both | | | | |
| 6 | App shell — first KPI | Dashboard primary KPI / subtitle strings (`dashboard.*` in `i18n.ts` + components) | both | | | | |
| 7 | Onboarding | Onboarding copy keys in `i18n.ts` + routed pages | both | | | | |
| 8 | Settings / about / guide | As present in web repo | both | | | | |
| 9 | PWA / install | Web manifest name/description (`vite.config` / `public/manifest*.json` if any); install prompts | | | | | |
| 10 | Legal / policy | ToS, Privacy, Refund — repo paths when live | | | | | |
| 11 | Design vault | `design_docs/01_Business_Vision.md` wedge alignment (excerpt only if drift) | | | | | |
| 12 | Social / store | FB about, store listings — when published | | | | | |

## 3) P0 vs P1 fix list

**P0** — must resolve before S1.C entry (or before public wedge-dependent launch, whichever is sooner).  
**P1** — queue for W3 landing polish or S1.C copy pass.

| ID | Surface | Priority | Owner repo |
| -- | ------- | -------- | ---------- |
| W-AUDIT-01 | Rows 4–12 (chrome, auth, app shell, onboarding, PWA, legal excerpt) | P1 | web + design_docs |
| W-AUDIT-02 | Brand icon pack (`resources/hfm_icon_web/`) wired to favicon/manifest/OG | P1 | web (F-011 future task) |

## 4) Automation follow-up

- [ ] Weekly grep / script (optional): search for **retired** phrases (“Average Joe,” “Finance Bro” as *marketing* persona, generic “budgeting app” hero without wedge anchor).
- [ ] Document script path in `finance_manager_web` or parent `scripts/` when implemented.

## 5) Signoff

- [ ] HitM read complete report.
- [x] F-011 T03+T04 pass rows (1–3) marked ✅ with evidence (PR #90, VPS active green).
- [ ] `README.md` completion criteria marked met for full audit (or explicit deferrals listed).
