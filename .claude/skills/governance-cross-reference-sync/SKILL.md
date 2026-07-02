---
name: governance-cross-reference-sync
description: Use when a governance change touches content that's mirrored or cross-cited across multiple files (e.g. Golden Rules existing in both design_docs/00_Coding_Guidelines.md and GEMINI.md, or any doc referencing a governance/ file by path). Confirms every mirror/citation gets updated together, not just the primary file.
---

# Governance Cross-Reference Sync

## Category

Phase skill (Phase 8 / close-adjacent, but also fires mid-session any time a governance edit has
known duplicates).

## Doctrine

- `governance/README.md` — the router; its own bucket index must stay accurate whenever a file
  moves or a new governance doc is added.
- `strategy/meetings/week27/meeting2026-07-02/tp-skill-generation/governance_folder_map.md` — the
  6-bucket structure this skill checks consistency against, and the record of the reference-
  integrity methodology (full-repo grep, not governance-folder-scoped, gitignore-blind tooling —
  see that file's "Correction" section for why a naive tool choice silently misses `strategy/`).

## Loads

- `status-verification-spotcheck` (imperative) — before declaring a cross-reference sync
  complete, re-grep rather than trust an earlier pass; this session found its own "verified zero
  remaining" claim was wrong once, due to a gitignore-aware `grep` alias silently skipping
  `strategy/`. Don't repeat that mistake — confirm which `grep` is actually running.

## Tools

None fixed — direct `grep`/`sed` against the repo. **Known gotcha, confirmed 2026-07-02:** if
`grep` resolves to a shell function/alias (e.g. `ugrep --ignore-files`), it silently respects
`.gitignore`, and `strategy/` in this repo is entirely gitignored. Verify with `type grep` before
trusting a "zero remaining references" result; use `/usr/bin/grep` explicitly if there's any
doubt.

## Procedure

1. Identify every known duplicate/mirror pair before editing (e.g. Golden Rules:
   `design_docs/00_Coding_Guidelines.md` + `GEMINI.md`; governance file moves: every citing file,
   not just files inside `governance/` itself).
2. Make the edit in all mirrors in the same pass — don't edit one and queue the other for later.
3. Run the reference-integrity check with a confirmed-gitignore-blind tool (`type grep` first).
4. Check for the subtler class of breakage beyond simple path-string swaps: relative markdown
   links (`](./...)`, `](../...)`) whose depth changes if a file itself moved — a bucket-prefix
   sed pass doesn't fix these, they need per-link resolution (see
   `governance_folder_map.md`'s worked example: 17 such links across 3 files after the
   2026-07-02 reorg).
5. Report what was checked and what was found, not just "done" — the specific files/counts, so a
   future reader can tell a real check happened.

## Handoff

`Skill(s) used: governance-cross-reference-sync, status-verification-spotcheck` in the decision
log or PR description, whichever this was invoked from.
