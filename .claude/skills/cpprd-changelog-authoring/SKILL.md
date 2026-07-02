---
name: cpprd-changelog-authoring
description: Use when filling CHANGELOG.md [Unreleased] stub entries or authoring new entries for governance-only changes at the parent-repo level. Ensures both the "insert block" step and the "fill content" step actually complete — a stub left unfilled is the documented failure mode this skill exists to close.
---

# CPPRD Changelog Authoring

CPPRD = Commit, Push, PR, **Document** (`deploy/CPPR_AND_CPPRD.md`) — distinct from CPPR+D
(Commit, Push, PR, Merge, **Deploy**, `governance/deployment/deployment_protocol.md`). This skill is the
"D" in CPPRD.

## Doctrine

- `deploy/CPPR_AND_CPPRD.md` — changelog/documentation bar.

## Loads

None required, but if the entry is for a change whose completeness is itself in question, load
`status-verification-spotcheck` first — don't write a changelog entry describing something as
done if that's the exact claim under doubt.

## Tools

- `changelog_entry` — MCP tool. **Known gap (RCA'd 2026-07-02):** this tool does "insert block"
  as a complete action, with no forcing function for the "fill content" half — that's how 6
  stub `(fill bullets)` entries sat unfilled for 24+ hours undetected. Treat insertion and
  content-authoring as two explicit, separately-verified steps every time.

## Procedure

1. Identify what actually shipped (PR, plan, or governance change) that needs a changelog entry.
2. Insert the block via `changelog_entry` if one doesn't exist yet.
3. **Write real content immediately, in the same pass** — do not leave a stub `(fill bullets)`
   placeholder for a later session to find. Match the existing entry style in that repo's
   `CHANGELOG.md` (check 2-3 recent entries for tone/format before writing).
4. Before finishing: re-read the full `[Unreleased]` section for that repo and confirm no other
   entry is still a stub — this is the check that was missing when the gap was found.
5. Target the correct `CHANGELOG.md`: subrepo (API/Web/CLI/Rust) for code changes, parent for
   governance-only changes.

## Handoff

`Skill(s) used: cpprd-changelog-authoring` in the meeting decision log or PR handoff, whichever
this was invoked from.
