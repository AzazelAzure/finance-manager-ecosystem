---
task_id: T16
status: pending
owner: unassigned
phase: P15
breakpoint: BP_SEO_P1
last_verification: null
---

# T16 — SEO P1 (post–PWA close): Search Console + react-helmet-async

## Objective

Execute **SEO P1** from [`../../distribution-channel-research/SEO_PRIORITY_MATRIX.md`](../../distribution-channel-research/SEO_PRIORITY_MATRIX.md) **only after** **BP_SPRINT_CLOSE** is PASS (PWA + P0 SEO + D4-exec complete per plan gates).

## Repo scope

- `finance_manager_web/` (`main.tsx`, `LandingPage.tsx`, `SignupPage.tsx`, `LoginPage.tsx` per matrix)
- External: Google Search Console (document verification method in runbook, no secrets in repo)

## Dependencies

- **HARD GATE:** `validation_gates.md` → **BP_SPRINT_CLOSE** = PASS; **BP_SEO_P1_START** cleared.
- T04 sitemap live in production for submission.

## Checklist

- [ ] Register Search Console property; verify domain (DNS or file — per HitM control).
- [ ] Submit `sitemap.xml`.
- [ ] Install `react-helmet-async`; per-route titles/descriptions per Guide 02 §3.
- [ ] Web CHANGELOG note.

## Definition of done

- **BP_SEO_P1** PASS.

## Verification

- Rich results test / URL inspection optional; `npm run build` + lint green.

## Risks

- Starting T16 early pollutes SEO data before stable public copy — enforce gate.

## PR expectations

- Separate PR after PWA sprint merge wave; label `SEO-P1` in title for review.
