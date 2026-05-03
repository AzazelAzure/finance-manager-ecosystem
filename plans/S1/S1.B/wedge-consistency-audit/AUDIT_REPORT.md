# Wedge consistency audit — report

**Status:** Draft — fill during audit execution.  
**Canonical wedge** (verbatim target for hero / first-line surfaces):

> **"The personal finance app that tells you what's actually safe to spend before payday — built for people living on thin margins, not people optimizing surplus."**

Source: [`00_strategic_context.md`](../../../cursor/strategic-roadmap-reframe-53be/00_strategic_context.md) §1.

| Audit date | Auditor | Web rev / deploy |
| ---------- | ------- | ---------------- |
| | | |

## 1) Summary

*(2–5 bullets: overall alignment, worst gaps, recommended sequencing for fixes.)*

## 2) Surface-by-surface findings

Use **✅** consistent, **⚠** partial, **✗** inconsistent. Copy **current** primary user-visible string (or screenshot ref) into “Evidence.”

| # | Category | Surface (path or URL) | en-US / locale | Evidence | Verdict | Suggested fix (if ⚠/✗) | Priority |
| - | -------- | --------------------- | -------------- | -------- | ------- | ---------------------- | -------- |
| 1 | Static — hero | `finance_manager_web/src/lib/i18n.ts` → `hero.*` | `en-US`, `tl-PH` | | | | |
| 2 | Static — value props | same → `value.*` | both | | | | |
| 3 | Static — showcase / preview / roadmap / CTA | same → keys under `showcase.*`, `preview.*`, `roadmap.*`, `cta.*` | both | | | | |
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
| | | | |

## 4) Automation follow-up

- [ ] Weekly grep / script (optional): search for **retired** phrases (“Average Joe,” “Finance Bro” as *marketing* persona, generic “budgeting app” hero without wedge anchor).
- [ ] Document script path in `finance_manager_web` or parent `scripts/` when implemented.

## 5) Signoff

- [ ] HitM read complete report.
- [ ] `README.md` completion criteria marked met (or explicit deferrals listed).
