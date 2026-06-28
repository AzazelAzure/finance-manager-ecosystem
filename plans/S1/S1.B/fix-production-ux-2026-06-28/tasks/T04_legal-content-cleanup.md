# T04 — Legal Page Content Cleanup

## End State

The Terms of Service, Privacy Policy, and Cookie Policy pages contain no internal feature codes, plan IDs, or technical nomenclature that would be meaningless to a user. All references to app features use plain-language descriptions.

## Acceptance Criteria

1. [V1] `grep -rn "F-0[0-9]\|PLAN_\|T0[0-9]\|SL[0-9]\|cur/s1b" src/pages/legal/` (or equivalent legal content path) returns no matches
2. [V3] ToS page renders in browser — no internal codes visible
3. [V3] Privacy Policy page renders in browser — no internal codes visible
4. [V1] `npm run build` passes with zero errors

## Scope Lock

### Files to modify
- Legal page content files (markdown, JSX, or constants — wherever ToS/Privacy/Cookie copy lives)
- No structural or layout changes

### Files NOT to touch
- Legal page route/component structure
- Cookie banner
- Any non-legal page content

## Slices

### T04.SL1 — Find and replace all internal codes
Grep for and replace the following patterns in legal content:

| Find | Replace with |
|---|---|
| `F-007` | "our in-app guided tour feature" |
| Any other `F-0##` pattern | the feature's plain-language name (look up in `governance/glossary.md` or plan registry) |
| Any `PLAN_*` reference | omit or replace with plain description |
| Any `T0##`, `SL#`, `cur/s1b` | omit entirely — these are internal task references with no user-facing meaning |

If you find a reference you cannot confidently replace with plain language, **leave a `<!-- TODO: legal copy review -->` comment and flag it in the PR description**. Do not guess at legal language.

Evidence: [V1] grep returns zero matches after fix

### T04.SL2 — Read-through
- Read the full content of each legal page as a user would
- Flag any other jargon or internal language found beyond the grep patterns (e.g. "admin dashboard", "API endpoint", internal product codenames)
- Fix or flag per the same rule above

Evidence: [V3] screenshot of each legal page in browser confirming clean copy

## Notes

- `legal_impact: true` on this plan — coordinate with any open legal compliance reports before ship
- Do not make substantive legal changes to policy meaning — copy edits only (internal codes → plain language). If a sentence requires rewriting for meaning, flag for HitM review.
