# Scripts inventory

Authoritative map after taxonomy reorg (2026-07-01). See `strategy/meetings/week27/meeting2026-07-01/tp-scripts-organization/taxonomy_proposal.md` and `combined_commands_index.md`.

**Agent default:** start governed sessions with `./scripts/dev/session_brief.sh` — not raw multi-repo `git status`.

## Buckets

| Bucket | Purpose |
|---|---|
| `scripts/ops/` | VPS lifecycle, deploy verify, backups, release bundles |
| `scripts/local-stack/` | Local Podman/Docker compose + non-container API process |
| `scripts/dev/` | Agent orientation, PR/merge checks, scaffolding generators |
| `scripts/db/` | SQLite ↔ Postgres migration and credential setup |
| `scripts/workspace/` | Multi-workspace sign-out sheet + FIFO queues + dispatch |
| `scripts/security/` | Local security audit tooling |
| `scripts/local/` | Cron installers and personal automation |
| `scripts/lib/` | Shared libraries (`lib_repos.sh`, `vps_env.sh`) |
| `scripts/ci/` | Reserved for CI-adjacent helpers (empty) |
| `scripts/archived/` | Deprecated Slack bridge, orchestrator, one-time migrations |
| `scripts/` (root) | Cross-repo git helpers, doc context, workspace file sync |

## ops/

| Script | What | Who |
|---|---|---|
| `sprint_verify.sh` | SSH VPS rebuild inactive color + optional smoke | Cursor, HitM |
| `vps_state.sh` | Live VPS snapshot (SSH, timestamped) | HitM, Antigravity, automations |
| `fm_server_beta.sh` | Blue-green deploy/smoke/switch/rollback | HitM (VPS) |
| `pull_backup.sh` | Daily pg_dump pull to `~/fm_backups/` (via Podman exec on VPS) | Cron via `local/setup_backup_cron.sh` |
| `tag_release.sh` | Tag release across repos in `repos.txt` | HitM |
| `bootstrap_env.sh` | Server env template copy/validate | Deploy |
| `create_runtime_bundle.sh` | Lean VPS runtime tarball | Deploy |
| `push_runtime_bundle.sh` | Upload/extract bundle over SSH | Deploy |
| `install_prereqs.sh` | Host prerequisite check | Deploy |
| `render_env_template.sh` | Render `deploy/server.env.example` | Deploy |
| `verify_install.sh` | Checkout layout + optional health probe | Deploy |
| `verify_release_manifest.sh` | Validate `RELEASE_MANIFEST.txt` | Deploy |

## local-stack/

| Script | What |
|---|---|
| `fm_docker.sh` | `docker-compose.yml` lifecycle (`start\|stop\|restart\|rebuild\|status\|clean`) |
| `fm_services.sh` | Local Django API process lifecycle |

## dev/

| Script | What |
|---|---|
| `session_brief.sh` | **Session entrypoint** — repo health + plans + PRs + submodules |
| `repo_health.sh` | Per-repo branch/HEAD/dirty |
| `plan_status.sh` / `plan_lookup.sh` | Plan registry orientation |
| `open_prs.sh` | Open PRs across parent/api/web |
| `handover.sh` | Generate handover prompt for a plan |
| `submodule_status.sh` | Submodule pin drift |
| `vps_freshness.sh` | Local vs VPS API/Web SHA compare |
| `pr_readiness.sh` | PR mergeable / checks / review snapshot |
| `workspace_brief.sh` | Sign-out sheet + FIFO queues + workspace identity |
| `local_stack_health.sh` | Containers + local `:8443` probes (correct Host headers) |
| `anomaly_new.sh` | Scaffold `strategy/anomalies/` log from template |
| `new_tp.sh` | Scaffold `strategy/meetings/.../tp-<slug>/` folder |
| `new_plan.sh` | Scaffold `plans/<Phase>/<Stage>/<status>/<slug>/` per plan_template |
| `changelog_entry.sh` | Insert `[Unreleased]` block in parent/api/web CHANGELOG |
| `new_meeting_day.sh` | Scaffold `strategy/meetings/week<N>/meeting<date>/` |
| `branch_delta.sh` | Ahead/behind vs `origin/main` for parent/api/web |
| `stash_triage.sh` | List git stashes across parent/api/web |
| `dependabot_batch.sh` | Open Dependabot PRs (api/web) |
| `celery_ready.sh` | Local Podman Celery worker/beat presence |
| `env_check.sh` | Verify `.env` keys against `.env.example` |
| `test_rust.sh` | `cargo test` in `finance_manager_rust_tools` |
| `test_api.sh` | `uv run pytest` wrapper for API repo |
| `test_web.sh` | `npm run build\|lint\|test` with log capture |
| `submodule_sync.sh` | Fetch + checkout submodules to parent-pinned SHAs (write op) |
| `ci_status.sh` | Latest GitHub Actions runs per repo |

## db/

| Script | What |
|---|---|
| `db_export.sh` / `db_import.sh` / `db_migrate.sh` | SQLite dump → Postgres import pipeline |
| `db_setup_postgres.sh` / `setup_db_creds.sh` | Credential generation and env wiring |
| `db_dumpdata_django.sh` | Django `dumpdata` to JSON fixture |

## workspace/

| Script | What |
|---|---|
| `ws_status.sh` / `ws_claim.sh` / `ws_release.sh` | Sign-out sheet |
| `vps_claim.sh` / `vps_release.sh` | VPS authority lock |
| `queue_push.sh` … `queue_status.sh` | Per-repo FIFO task queues |
| `review_push.sh` … `review_status.sh` | WS3 review FIFO queue |
| `ws_dispatch.sh` / `ws_review.sh` | Dispatch task to worker + PR review loop |

## Root cross-cutters

| Script | What |
|---|---|
| `status.sh` / `git_sync.sh` / `feature_branch.sh` | Multi-repo git hygiene (`repos.txt`) |
| `check_repos.sh` / `check_plan_stalls.sh` | Validation helpers |
| `gather_doc_context.sh` | Daily automation context file |
| `sync_agent_files_to_workspaces.sh` | Mirror gitignored agent files to WS clones |
| `jsdevtesting_stack_check.sh` | Staging HTTPS smoke (jsdevtesting hostnames) |

## server/ (compat forwarders)

| Script | What |
|---|---|
| `pull_backup.sh` | Forwards to `scripts/ops/pull_backup.sh` (pre-reorg crontab paths) |

## mcp/

| Artifact | What |
|---|---|
| `scripts/mcp/run.sh` | Start stdio MCP server for Cursor / Claude Code |
| `hfm_mcp/server.py` | FastMCP tool definitions — **39 tools** wrapping Tier 1–3 `scripts/dev`, `workspace`, `ops` |
| `README.md` | IDE setup, tool catalog, smoke test |

Project MCP config: `.cursor/mcp.json` → server name `hfm-scripts`.

## Environment

VPS SSH scripts read allowlisted keys from repo-root `.env`: `FM_SPRINT_SSH`, `VPS_ORIGIN_IP`, `FM_SPRINT_REMOTE_ROOT` (see `scripts/lib/vps_env.sh`, `scripts/ops/vps_state.sh`).

## Related

- Build queue: `strategy/meetings/week27/meeting2026-07-01/tp-scripts-organization/combined_commands_index.md`
- Workspace protocol: `governance/execution/workspace_protocol.md`
