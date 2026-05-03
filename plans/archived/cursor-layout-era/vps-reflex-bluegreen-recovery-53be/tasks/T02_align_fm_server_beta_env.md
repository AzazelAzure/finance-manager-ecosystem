# T02 — Align `fm_server_beta` smoke env with production hostnames

**Status (2026-04-29):** **Done** — `check` passes on VPS with thehivemanager exports; block recorded in [`../runtime_handoff.md`](../runtime_handoff.md) and [`../PASSDOWN.md`](../PASSDOWN.md).

## Objective

[`scripts/fm_server_beta.sh`](../../../scripts/fm_server_beta.sh) defaults smoke hosts to `financemanager.local`. VPS beta uses **thehivemanager.com** hostnames — document required `FM_PUBLIC_APP_HOST`, `FM_PUBLIC_API_HOST`, `FM_PUBLIC_BASE_URL` (and any others discovered in script).

## Steps

1. Read smoke/probe logic in `fm_server_beta.sh`.
2. Run `./scripts/fm_server_beta.sh check` on VPS with env overrides; capture full output.
3. If check fails, classify: nginx syntax | missing mount | wrong port | DNS.

## Handoff output

- Exact export block or systemd env file snippet for VPS
- `check` pass/fail transcript
