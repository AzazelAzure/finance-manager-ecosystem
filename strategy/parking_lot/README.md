# Parking Lot

Postponed items that are **not yet plans** but must not be lost. Per D6 decision (2026-06-29):
**one file per parked item** — each item may be iterated on multiple times, so per-issue files
keep context clean (accepting a little extra clutter).

## Conventions

- Filename: `<short-kebab-slug>.md`
- Each file has frontmatter: `parked` (date), `revisit_when` (trigger), `owner`, `status`
  (`parked` → `active` → `promoted`/`dropped`).
- When a parked item becomes real work, it graduates to a `plans/` plan or a `strategy/` artifact
  and its file here is set `status: promoted` with a pointer (don't delete — keep the trail).
- Distinct from `strategy/anomalies/` (detected, in-scope-of-some-agent issues) and
  `strategy/risk_register.md` (anticipated risks). Parking lot = deliberate "later," not a problem.

## Current items

See files in this directory. Index is intentionally not duplicated here (avoid drift) — list
with `ls` or rely on `strategy/README.md`.
