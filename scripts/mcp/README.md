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

## Tools (v0.1)

| Tool | Script |
|------|--------|
| `session_brief` | `scripts/dev/session_brief.sh` |
| `workspace_brief` | `scripts/dev/workspace_brief.sh` |
| `ws_status` | `scripts/workspace/ws_status.sh` |
| `queue_status` | `scripts/workspace/queue_status.sh` |
| `plan_lookup` | `scripts/dev/plan_lookup.sh` |
| `pr_readiness` | `scripts/dev/pr_readiness.sh` |
| `ci_status` | `scripts/dev/ci_status.sh` |
| `test_api` / `test_web` | `scripts/dev/test_api.sh`, `test_web.sh` |
| `local_stack_health` | `scripts/dev/local_stack_health.sh` |
| `vps_state` / `vps_freshness` | `scripts/ops/vps_state.sh`, `scripts/dev/vps_freshness.sh` |
| `fm_docker_status` | `scripts/local-stack/fm_docker.sh status` |
| `ws_claim` / `ws_release` | workspace sign-out |
| `queue_push` | FIFO enqueue |
| `ws_dispatch` | worker dispatch (**default `dry_run=True`**) |
| `vps_claim` / `vps_release` | VPS authority lock |
| `anomaly_new` | anomaly scaffold |

## Smoke test (no stdio server)

```bash
cd ~/Hive_Financial_Manager/HFM/scripts/mcp
uv sync
uv run python -c "from hfm_mcp.runner import run_script; print(run_script('scripts/dev/plan_lookup.sh', 'F009')[:400])"
```

## Related

- Tool catalog draft: `strategy/meetings/week27/meeting2026-07-01/tp-scripts-organization/common_commands.md`
- Gating: `governance/workspace_protocol.md` §10, D8
- Inventory: `scripts/SCRIPTS.md`
