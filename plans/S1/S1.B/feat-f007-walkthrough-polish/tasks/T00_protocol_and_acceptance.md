# T00 — Protocol smoke + acceptance (F-007 polish)

## Slices

### T00.SL1 — Acceptance criteria (HitM-visible)

- [ ] [V0] Document in this file the **definition of done** for: (a) help-mode → linear tour without an extra button press after widget select, unless a11y requires an explicit confirm; (b) form modals — minimum step count ≥ 2 visible Joyride steps per primary modal type; (c) calendar — tour covers month nav + cell selection path.
- [ ] [V0] Link parent F-007 `runtime_handoff.md` BUG rows that this plan supersedes or extends.

### T00.SL2 — Tooling dry-run

- [ ] [V1] From parent repo, run `./scripts/sprint_verify.sh --dry-run --color blue --branch <this-branch> --repos web --evidence plans/S1/S1.B/feat-f007-walkthrough-polish/evidence/` and save stdout to `evidence/T00.SL2_sprint_verify_dryrun.log` (path in table below).

## Evidence

| Slice | Artifact |
|-------|----------|
| T00.SL2 | `evidence/T00.SL2_sprint_verify_dryrun.log` |
