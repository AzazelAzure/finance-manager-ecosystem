---
logged: 2026-06-28
agent: cursor
plan_context: PLAN_CROSS_CI_CD_2026-06-27 / fm_server_beta.sh secret-redaction fix (PR #72)
status: dispatched
dispatched_to: Cursor chore — fm_server_beta.sh nginx check
dispatched_on: 2026-06-29
severity_guess: low
---

> **2026-06-29 dispatch (D3):** HitM decision — fix it properly (option A): mount
> `00-resolver.conf` into the throwaway check container, or point `check` at the live proxy via
> `exec -T proxy nginx -t`. First confirm whether `00-resolver.conf` is committed to the repo or
> generated at runtime — that determines the fix path. Small Cursor chore; Cursor codes locally
> (credit exhaustion is cloud-automations only, not local coding).

## What was found

`scripts/fm_server_beta.sh check` always fails its nginx validation step on the
VPS. The standalone `nginx -t` test container errors with:

```
[emerg] open() "/etc/nginx/conf.d/00-resolver.conf" failed (2: No such file or directory) in /etc/nginx/nginx.conf:30
nginx: configuration file /etc/nginx/nginx.conf test failed
```

`check` returns exit 1 even though the live proxy is healthy and serving traffic.
The "compose config: ok" portion passes; only the nginx syntax check fails. The
root cause is that `proxy/nginx.bluegreen.conf` includes `00-resolver.conf` (a
runtime resolver include present inside the real proxy container), but the
ad-hoc `nginx -t` validation container in `check_cmd` only mounts
`nginx.bluegreen.conf`, `active_color.conf`, and `certs/` — not the resolver
include — so the `include` directive resolves to a missing file.

## Where

`scripts/fm_server_beta.sh` — `check_cmd()`, the `"$RUNTIME_BIN" run --rm ... nginx:alpine nginx -t` block (the `-v` mounts omit `00-resolver.conf`). Referenced include is at `proxy/nginx.bluegreen.conf:30`.

VPS: `~/finance_manager` (manually-synced copy).

## What agent was doing

Verifying the `fm_server_beta.sh` secret-redaction fix (PR #72) on the VPS. Ran
`check` after `smoke` to confirm the `config`-path redaction; `check` surfaced
this pre-existing nginx validation failure (unrelated to the redaction change).

## Why outside scope

PR #72 is scoped strictly to secret redaction in compose output; fixing the
`check` command's nginx test harness (mounting the resolver include, or pointing
the test at the real proxy container's effective config) is a separate concern.

## Possible owner

Cursor / VPS deploy tooling (next blue-green maintenance pass or a small
follow-up chore on `fm_server_beta.sh`).

## Notes

Likely fix options: (a) add `-v "$BASE_DIR/proxy/00-resolver.conf:/etc/nginx/conf.d/00-resolver.conf:ro,z"` to the `check_cmd` nginx run (if that file exists in-repo), or (b) make the resolver `include` optional / generated, or (c) validate via `compose_cmd exec -T proxy nginx -t` against the running proxy instead of a throwaway container. Confirm whether `00-resolver.conf` is committed in `proxy/` or only created at container runtime before choosing.
