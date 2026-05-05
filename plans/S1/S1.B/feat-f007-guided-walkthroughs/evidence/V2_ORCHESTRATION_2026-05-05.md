# F-007 — V2 evidence and orchestration (2026-05-05)

## Purpose

Slices were previously marked **V2** without attachable deploy/smoke logs. This note records the **expected V2 artifact** for each future PASS and satisfies **`ACTIONS.md` item #7** linkage: HitM V3 findings already live in [`../runtime_handoff.md`](../runtime_handoff.md).

## How to produce V2 evidence

From the ecosystem parent (local machine), after merging code to the target branch on the VPS:

```bash
./scripts/sprint_verify.sh \
  --color blue \
  --repos web,api \
  --branch cursor/s1b/feat/f007-guided-walkthroughs \
  --smoke \
  --evidence plans/S1/S1.B/feat-f007-guided-walkthroughs/evidence/
```

- Adjust `--color` to the **inactive** color you are validating (`fm_server_beta.sh status` on VPS).
- Optional: `--no-cache` after large dependency changes.
- Logs land under `evidence/` as `sprint_verify_<UTC>.log`.

Optional edge check (no SSH):

```bash
./scripts/jsdevtesting_stack_check.sh
```

## Slice log expectation

Append a row to `runtime_handoff.md` **Slice verification log** only when a `sprint_verify_*.log` path exists for that slice’s merge window.
