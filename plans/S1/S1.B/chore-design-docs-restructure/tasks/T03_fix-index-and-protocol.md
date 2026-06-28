# T03 — Fix Index + Sync Protocol

## End State

`00_Dashboard.md` reflects the post-restructure reality with no dead links. The Documentation
Sync Protocol describes the new boundary. Loose top-level files are triaged.

## Acceptance Criteria

1. [V1] `00_Dashboard.md` updated: remove links to nonexistent `30_Security/` and `Versioning_and_Contracts`/`Dependency_Management` files; repoint moved `reflex_docs`/alpha/roadmap links to their archive paths; reflect that roadmap canonical = `strategy/strategic-roadmap-reframe`.
2. [V1] `10_Current_State/02_Documentation_Sync_Protocol.md` updated to the boundary set in `strategy/doc_structure_consolidation_proposal_2026-06-29.md` (design_docs = how-it-works; roadmap = strategy; plan ops = governance; new `strategy/` homes referenced).
3. [V1] Loose top-level triage: keep durable specs (`00_Coding_Guidelines`, `00_Encryption_Strategy`, `01_Business_Vision`, `02_Future_Risks`, `03_Localization_Strategy`); for `50_Research_Backlog.md`, either move to align with `strategy/research/` or leave a pointer — HitM's call, default to leaving a pointer note.
4. [V1] No dead links remain in `00_Dashboard.md` (spot-check each).

## Scope Lock

- **Repo:** `design_docs` submodule, own branch.
- Runs **after** T01 + T02 (their moves determine the correct link targets).

## Notes

- The Dashboard is an Obsidian vault index (`[[wikilinks]]`); keep that format.
- After this lands, the parent repo bumps the submodule pointer (CPPR) and checks off the Cursor item in the proposal's §5 execution split.
- Downstream (NOT this task): the design-doc sweep automation prompt, authored against this now-settled boundary.
