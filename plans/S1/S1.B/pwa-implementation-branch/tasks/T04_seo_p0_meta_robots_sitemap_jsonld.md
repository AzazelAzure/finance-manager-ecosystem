---
task_id: T04
status: pending
owner: unassigned
phase: P1b
breakpoint: BP_SEO_P0
last_verification: null
---

# T04 — SEO P0: meta, robots, sitemap, JSON-LD

## Objective

Ship **SEO P0** quick wins from [`../../distribution-channel-research/SEO_PRIORITY_MATRIX.md`](../../distribution-channel-research/SEO_PRIORITY_MATRIX.md) in parallel with PWA work, without blocking core PWA layers.

## Repo scope

- `finance_manager_web/` (`index.html`, `public/robots.txt`, `public/sitemap.xml`)

## Dependencies

- T00. Prefer completing **before** heavy T06–T07 SW changes; may merge with T03/T05 if one PR owns `index.html`.

## Checklist

- [ ] Fix `index.html` meta tags, Open Graph, **canonical** URL (Guide 02 §1.1).
- [ ] Add `public/robots.txt` — disallow `/app/`, allow public marketing/auth entry routes per guide.
- [ ] Add `public/sitemap.xml` — three public routes (adjust to actual public URLs in repo).
- [ ] Add JSON-LD (`SoftwareApplication` + `Organization`) per Guide 02 §2.
- [ ] Update matrix status column in source doc when done (optional CPPRD note in web CHANGELOG).

## Definition of done

- **BP_SEO_P0** PASS in `validation_gates.md`.
- Build includes new static files in deploy artifact.

## Verification

```bash
cd finance_manager_web && npm run build && npm run lint
```

## Risks

- Wrong canonical host — align with production hostname from deploy docs.
- `index.html` merge conflicts — follow `CROSS_AGENT_COORDINATION.md`.

## PR expectations

- Small focused PR; can ride with T05 if coordinated.
