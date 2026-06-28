# T01 — Archive Deprecated Vault Content

## End State

Archived-product and alpha-era docs no longer present as current. They are preserved (audit
trail intact) under the vault's archive convention, not deleted.

## Acceptance Criteria

1. [V1] `reflex_docs/` moved under the vault's historical/archive path (e.g. `_historical/reflex_docs/` or `.trash/` per existing convention — match whatever `20_Roadmap/_historical/` uses).
2. [V1] `10_Current_State/00_Alpha_Overview.md` and `10_Current_State/03_Resume_Checkpoint_2026-04-27.md` moved to the archive path.
3. [V1] Any vault index/links pointing at the moved files updated or flagged for T03's Dashboard fix.
4. [V1] Nothing deleted — `git mv` only.

## Scope Lock

- **Repo:** `design_docs` submodule, own branch.
- **Do NOT touch:** `40_System_Design/`, `api_docs/`, `cli_docs/`, `rust_docs/`, `Runtime_Signup_Sheet.md`.

## Notes

- `reflex` is `reflex:Archived` per AGENTS.md §5 — web is flagship. The folder is historical reference only.
- Keep `10_Current_State/02_Documentation_Sync_Protocol.md` in place (T03 updates it).
