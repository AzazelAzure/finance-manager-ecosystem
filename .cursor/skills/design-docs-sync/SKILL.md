---
name: design-docs-sync
description: Keep design_docs aligned with implementation changes by updating architecture, roadmap phases, and operational guidance. Use when behavior, contracts, rollout plans, or system design assumptions change.
---

# Design Docs Sync

## Target Areas

Prioritize updates in:

- `design_docs/api_docs/`
- `design_docs/cli_docs/`
- `design_docs/rust_docs/`
- `design_docs/40_System_Design/`
- `design_docs/00_*` (coding guidelines, encryption strategy, dashboard)

> **Scope (post-2026-06-30):** `design_docs/` is active working system design **only**.
> Roadmap/planning moved to `strategy/`; governance/ops contracts and release templates
> moved to `governance/`. Don't recreate those under `design_docs/`.

## Sync Routine

- [ ] Identify changed behavior, contracts, and scope boundaries.
- [ ] Map each change to the most specific existing design doc.
- [ ] Update current-state docs first, then roadmap/system docs as needed.
- [ ] Record phase impact, blockers, triggers, and follow-up requirements.
- [ ] Verify wording matches actual code behavior (no speculative claims).

## Delegation Defaults

- Use `explore` subagent to identify the best target docs.
- Use `generalPurpose` subagent to draft focused doc edits.
- Return updates via `shared-subagent-handoff` with explicit file list.

## Documentation Standards

- Keep sections concrete and implementation-linked.
- Prefer updates to existing docs over creating redundant files.
- Include cross-repo dependency notes where relevant.
