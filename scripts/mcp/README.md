# HFM local MCP server

Typed [Model Context Protocol](https://modelcontextprotocol.io/) tools that wrap `scripts/` — agents call tools instead of constructing shell commands.

**Source of truth:** bash scripts stay authoritative; MCP only shells out to them.

## Prerequisites

- `uv` on PATH
- `bash`, `gh`, `khal`/`todo` only if you use tools that need them
- `~/.fm_workspace.conf` with `FM_PRIMARY_WORKSPACE` (or open this repo as the Cursor workspace so `run.sh` infers it)

## Install (one-time)

```bash
cd ~/Hive_Financial_Manager/HFM/scripts/mcp
uv sync
chmod +x run.sh
```

## Cursor IDE

Project config: `.cursor/mcp.json` (committed). After merge, **restart Cursor** or reload MCP servers in Settings → MCP.

Manual entry (if needed):

| Field | Value |
|-------|--------|
| Name | `hfm-scripts` |
| Command | `bash` |
| Args | `/home/pproctor/Hive_Financial_Manager/HFM/scripts/mcp/run.sh` |
| Env | `FM_PRIMARY_WORKSPACE=/home/pproctor/Hive_Financial_Manager/HFM` |

Worker clones (`WS-API`, `WS-WEB`) may use the same server with `FM_PRIMARY_WORKSPACE` pointing at **HFM** (admin checkout), not the worker tree.

## Claude Code

Add to Claude Code MCP settings (user or project):

```json
{
  "mcpServers": {
    "hfm-scripts": {
      "command": "bash",
      "args": ["/home/pproctor/Hive_Financial_Manager/HFM/scripts/mcp/run.sh"],
      "env": {
        "FM_PRIMARY_WORKSPACE": "/home/pproctor/Hive_Financial_Manager/HFM"
      }
    }
  }
}
```

## Tools (v0.2 — Tier 1–3 dev scripts + workspace/ops)

### Orientation (Tier 1)

| Tool | Script |
|------|--------|
| `session_brief` | bundled: repo health + plans + PRs + submodules |
| `repo_health` | `scripts/dev/repo_health.sh` |
| `plan_status` | `scripts/dev/plan_status.sh` |
| `open_prs` | `scripts/dev/open_prs.sh` |
| `submodule_status` | `scripts/dev/submodule_status.sh` |
| `handover` | `scripts/dev/handover.sh` |
| `workspace_brief` | sign-out sheet + queues + workspace identity |
| `ws_status` | `scripts/workspace/ws_status.sh` |
| `queue_status` | `scripts/workspace/queue_status.sh` |
| `plan_lookup` | `scripts/dev/plan_lookup.sh` |

### PR / CI / tests (Tier 1–2)

| Tool | Script |
|------|--------|
| `pr_readiness` | `scripts/dev/pr_readiness.sh` |
| `ci_status` | `scripts/dev/ci_status.sh` |
| `test_api` / `test_web` / `test_rust` | API pytest, web npm, rust `cargo test` |
| `submodule_sync` | `scripts/dev/submodule_sync.sh` (**write op**) |
| `branch_delta` | `scripts/dev/branch_delta.sh` |
| `stash_triage` | `scripts/dev/stash_triage.sh` |
| `dependabot_batch` | `scripts/dev/dependabot_batch.sh` |

### Runtime / VPS

| Tool | Script |
|------|--------|
| `local_stack_health` | `scripts/dev/local_stack_health.sh` |
| `celery_ready` | `scripts/dev/celery_ready.sh` |
| `env_check` | `scripts/dev/env_check.sh` |
| `vps_state` / `vps_freshness` | VPS SSH snapshot + SHA drift |
| `fm_docker_status` | `scripts/local-stack/fm_docker.sh status` |

### Workspace orchestration

| Tool | Script |
|------|--------|
| `ws_claim` / `ws_release` | workspace sign-out |
| `queue_push` / `queue_done` | FIFO enqueue / mark DONE or FAILED |
| `ws_dispatch` | worker dispatch (**default `dry_run=True`**) |
| `ws_review` | WS3 PR review (`action`: auto, approve, reject) |
| `vps_claim` / `vps_release` | VPS authority lock |

### Scaffolding (Tier 1–3)

| Tool | Script |
|------|--------|
| `anomaly_new` | `scripts/dev/anomaly_new.sh` |
| `changelog_entry` | `scripts/dev/changelog_entry.sh` (**CPPRD D step**) |
| `new_tp` / `new_plan` / `new_meeting_day` | TP, plan, and meeting-day scaffolds |

## Smoke test (no stdio server)

```bash
cd ~/Hive_Financial_Manager/HFM/scripts/mcp
uv sync
uv run python -c "from hfm_mcp.runner import run_script; print(run_script('scripts/dev/plan_lookup.sh', 'F009')[:400])"
```

## Related

- Tool catalog draft: `strategy/meetings/week27/meeting2026-07-01/tp-scripts-organization/common_commands.md`
- Gating: `governance/execution/workspace_protocol.md` §10, D8
- Inventory: `scripts/SCRIPTS.md`
