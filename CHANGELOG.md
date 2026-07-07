# Changelog — finance-manager-ecosystem (parent)

Notable changes to this **parent** repository: submodule pins, `governance/`, `plans/`, `deploy/`, and cross-cutting docs. Product changelogs live in each component repository.

## [Unreleased]
### 2026-07-07 — GH Actions PR checks + static scripts (OPS-REVAMP-T04) (Cursor)

- **`.github/workflows/hfm-pr-checks.yml`:** PR body contract, CHANGELOG stub check, branch prefix, file classification jobs.
- **`scripts/dev/pr_body_contract.sh`**, **`changelog_check.sh`**, **`changed_file_classify.sh`:** static gates moved out of Codex semantic path.
### 2026-07-07 — Pipeline gate rules D2/D3 (OPS-REVAMP-T02) (Cursor)

- **`.cursor/rules/sprint-task-specification.mdc`:** mandatory WS3 drain final gate (D2).
- **`AGENTS.md`:** pipeline gate discipline — review.queue PENDING blocks queue_done and deploy (D3).
### 2026-07-07 — D1 codex-review pending label mechanism (OPS-REVAMP-T01) (Cursor)

- **`.github/workflows/codex-review-label.yml`:** auto-add `codex-review:pending` on PR open/reopen/sync.
- **`scripts/lib/codex_review_label.sh`:** shared add/remove/check helpers.
- **`scripts/workspace/review_push.sh`:** belt-and-suspenders label on enqueue.
- **`scripts/workspace/ws_review.sh` / `scripts/ops/codex_review.sh`:** remove label on verdict; fail-closed if label missing on live runs.
- **`scripts/workspace/review_queue_pr_guard.sh`:** cross-check queue vs GitHub label vs merge state (P7 desync detection).
### 2026-07-07 — Local admin backup cron (LOCAL-ADMIN-BACKUP-T01) (Cursor)

- **`scripts/ops/backup_admin.sh`:** daily tar of gitignored `strategy/`, `governance/plans/`, `scripts/workspace/` queues, `.cursor/skills/`, `.claude/skills/` → `~/fm_admin_backups/` (30-day retention).
- **`scripts/local/setup_admin_backup_cron.sh`:** prints 2am cron line (complements 6am `pull_backup.sh` VPS DB backup).
### 2026-07-07 — Dependabot three-tier review chain (T5-DEPENDABOT) (Cursor)

- **`scripts/ops/dependabot_check.sh`:** tier-1 Dependabot triage — semver major bumps and security-sensitive packages escalate to Codex; routine patch/minor may APPROVE; critical/high CVE → NEEDS_HITM.
- **`scripts/workspace/ws_review.sh`:** `--auto` routes `dependabot/*` head branches through tier-1 → `codex_review.sh --mode dependabot` → operator gate.
- **`scripts/ops/codex_review.sh`:** full `--mode dependabot` review criteria (replaces T2A stub).
### 2026-07-07 — Codex review KB8 revised routing (T2A-REVISED) (Cursor)

- **`scripts/ops/codex_review.sh`:** replace blanket `pr_checks_need_hitm` with `classify_pr_readiness_gate` — code/test/lint failures and CONFLICTING/DIRTY → `REQUEST_CHANGES`; deploy/smoke/infra/KB8-intentional → `NEEDS_HITM`; PENDING/IN_PROGRESS no longer force operator gate.
- **Known-bad T3:** detect `[KNOWN-BAD TEST]` + `kb8-known-bad-test.yml` in diff when PR is closed (no live KB8 check rollup).
- **`--mode dependabot`:** criteria stub added (full `dependabot_check.sh` chain deferred to T5).
### 2026-07-06 — Codex review dry-run temp-dir cleanup (T2B) (Cursor)

- **`scripts/ops/codex_review.sh`:** `cleanup_work` guard replaces quoted EXIT trap so `set -u` never trips on unbound `work`; dry-run preserves temp dir via `preserve_work` flag.
### 2026-07-06 — Codex review KB8 NEEDS_HITM gate (T2A) (Cursor)

- **`scripts/ops/codex_review.sh`:** failing/pending CI checks short-circuit to `NEEDS_HITM` before Codex invocation; prompt rules updated so KB8 never maps to `REQUEST_CHANGES`.
### 2026-07-06 — Add codex_review.sh PR reviewer wrapper (T1) (Cursor)

- **`scripts/ops/codex_review.sh`:** Codex CLI PR reviewer wrapper — assembles context from `gh pr diff/view`, `pr_readiness.sh`, and `plan_lookup.sh`; invokes `codex exec --sandbox read-only` via stdin temp file; parses `VERDICT` / `CONFIDENCE` / `CONTEXT_LOADED`; acts on APPROVE (squash merge when gate passes), REQUEST_CHANGES (comment only), or NEEDS_HITM (operator note); appends audit lines to `logs/codex_review_log.jsonl`.
- **`logs/.gitkeep`:** ensure `logs/` exists for review audit trail (jsonl gitignored).
### 2026-07-06 — Parent governance sync: WS-PARENT wording, VPS cutover log, submodule pins (Claude)

- **`AGENTS.md`:** documented `parent.queue`/`review.queue` FIFOs, `ws_dispatch.sh` `api`/`web`/`parent` routing, and auto-continue through CPPRD → `review_push.sh` → WS3 on green implementation.
- **`governance/deployment/Runtime_Signup_Sheet.md`:** logged 2026-07-06 queue-drain blue promotion (active green → blue, HitM-verified, rollback color green warm).
- **Submodule pins:** `finance_manager_api` `dc7092a` → `2a19c8f`, `finance_manager_web` `cb6da26` → `f7f3632` (both already-merged `origin/main` heads; parent pin was stale).
### 2026-07-06 — Parent dispatch dirty-worktree gate (T07) (Cursor)

- **`scripts/workspace/ws_dispatch.sh`:** refuse `parent` dispatch when the primary checkout has uncommitted changes; add `--force-dirty` override for HitM-confirmed safe cases; `--dry-run` unchanged.
- **`governance/execution/workspace_protocol.md`:** document the gate (replaces advisory-only collision note in §5).
### 2026-07-06 — Worker checkout orientation in pickup-and-claim (Cursor)


- Extend `pickup-and-claim` with worker checkout ritual (WS-API/WS-WEB/HFM paths, branch hygiene) instead of a separate thin skill.
### 2026-07-06 — Harden inactive rebuild: proxy-safe sequencing + sprint_verify VPS script path (Cursor)

- **`scripts/ops/fm_server_beta.sh`:** `rebuild-color` no longer stops/recreates the proxy before inactive API health is confirmed; tags last-known-good images and rolls back app containers on compose-up or health-check failure (proxy keeps serving active color).
- **`scripts/ops/sprint_verify.sh`:** default `FM_SPRINT_FM_SCRIPT` is now `scripts/fm_server_beta.sh` (VPS path under `~/finance_manager/scripts/`, not `scripts/ops/`).
- **`AGENTS.md`:** document VPS vs parent-repo `fm_server_beta.sh` paths and `FM_SPRINT_FM_SCRIPT` default.
### 2026-07-06 — Fix security audit suite: bandit 1.9.4 + stop env-poisoning in lib_anomaly_write (Cursor)

- **`scripts/security/TOOL_VERSIONS`:** bump `bandit` to **1.9.4** — fixes Python 3.14 `ast.Num` crash that prevented real findings.
- **`scripts/security/lib_anomaly_write.sh`:** pass large tool output to embedded Python via temp files instead of `export` env vars — stops the env-poisoning cascade (`Argument list too long` / gitleaks false skips) for the rest of `run_audit.sh`.
- **Verified:** `./scripts/security/run_audit.sh` completes end-to-end (bandit findings, pip-audit, npm audit, gitleaks on all three repos, semgrep).
### 2026-07-01 — Payment-source governance hardening + F009 T00 investigation (Cursor)
### 2026-07-06 — dependabot-batch-triage Cursor skill (Cursor)


- (fill bullets)
### 2026-07-06 — Harden inactive rebuild: proxy-safe sequencing + sprint_verify VPS script path (Cursor)

- **`scripts/ops/fm_server_beta.sh`:** `rebuild-color` no longer stops/recreates the proxy before inactive API health is confirmed; tags last-known-good images and rolls back app containers on compose-up or health-check failure (proxy keeps serving active color).
- **`scripts/ops/sprint_verify.sh`:** default `FM_SPRINT_FM_SCRIPT` is now `scripts/fm_server_beta.sh` (VPS path under `~/finance_manager/scripts/`, not `scripts/ops/`).
- **`AGENTS.md`:** document VPS vs parent-repo `fm_server_beta.sh` paths and `FM_SPRINT_FM_SCRIPT` default.
### 2026-07-06 — Fix security audit suite: bandit 1.9.4 + stop env-poisoning in lib_anomaly_write (Cursor)

- **`scripts/security/TOOL_VERSIONS`:** bump `bandit` to **1.9.4** — fixes Python 3.14 `ast.Num` crash that prevented real findings.
- **`scripts/security/lib_anomaly_write.sh`:** pass large tool output to embedded Python via temp files instead of `export` env vars — stops the env-poisoning cascade (`Argument list too long` / gitleaks false skips) for the rest of `run_audit.sh`.
- **Verified:** `./scripts/security/run_audit.sh` completes end-to-end (bandit findings, pip-audit, npm audit, gitleaks on all three repos, semgrep).
### 2026-07-01 — Payment-source governance hardening + F009 T00 investigation (Cursor)
### 2026-07-06 — schedule_skill_gap weekly cron installer (Cursor)


- Add  ( for weekly transcript scan reports); update  Scheduling section.
### 2026-07-06 — Harden inactive rebuild: proxy-safe sequencing + sprint_verify VPS script path (Cursor)

- **`scripts/ops/fm_server_beta.sh`:** `rebuild-color` no longer stops/recreates the proxy before inactive API health is confirmed; tags last-known-good images and rolls back app containers on compose-up or health-check failure (proxy keeps serving active color).
- **`scripts/ops/sprint_verify.sh`:** default `FM_SPRINT_FM_SCRIPT` is now `scripts/fm_server_beta.sh` (VPS path under `~/finance_manager/scripts/`, not `scripts/ops/`).
- **`AGENTS.md`:** document VPS vs parent-repo `fm_server_beta.sh` paths and `FM_SPRINT_FM_SCRIPT` default.
### 2026-07-06 — Fix security audit suite: bandit 1.9.4 + stop env-poisoning in lib_anomaly_write (Cursor)

- **`scripts/security/TOOL_VERSIONS`:** bump `bandit` to **1.9.4** — fixes Python 3.14 `ast.Num` crash that prevented real findings.
- **`scripts/security/lib_anomaly_write.sh`:** pass large tool output to embedded Python via temp files instead of `export` env vars — stops the env-poisoning cascade (`Argument list too long` / gitleaks false skips) for the rest of `run_audit.sh`.
- **Verified:** `./scripts/security/run_audit.sh` completes end-to-end (bandit findings, pip-audit, npm audit, gitleaks on all three repos, semgrep).
### 2026-07-01 — Payment-source governance hardening + F009 T00 investigation (Cursor)
### 2026-07-06 — transcript_pattern_scan dev script (Cursor)


- Add `scripts/dev/transcript_pattern_scan.sh` to scan Cursor agent transcripts for recurring friction patterns (replaces inline PYEOF parsers).
### 2026-07-06 — Harden inactive rebuild: proxy-safe sequencing + sprint_verify VPS script path (Cursor)

- **`scripts/ops/fm_server_beta.sh`:** `rebuild-color` no longer stops/recreates the proxy before inactive API health is confirmed; tags last-known-good images and rolls back app containers on compose-up or health-check failure (proxy keeps serving active color).
- **`scripts/ops/sprint_verify.sh`:** default `FM_SPRINT_FM_SCRIPT` is now `scripts/fm_server_beta.sh` (VPS path under `~/finance_manager/scripts/`, not `scripts/ops/`).
- **`AGENTS.md`:** document VPS vs parent-repo `fm_server_beta.sh` paths and `FM_SPRINT_FM_SCRIPT` default.
### 2026-07-06 — Fix security audit suite: bandit 1.9.4 + stop env-poisoning in lib_anomaly_write (Cursor)

- **`scripts/security/TOOL_VERSIONS`:** bump `bandit` to **1.9.4** — fixes Python 3.14 `ast.Num` crash that prevented real findings.
- **`scripts/security/lib_anomaly_write.sh`:** pass large tool output to embedded Python via temp files instead of `export` env vars — stops the env-poisoning cascade (`Argument list too long` / gitleaks false skips) for the rest of `run_audit.sh`.
- **Verified:** `./scripts/security/run_audit.sh` completes end-to-end (bandit findings, pip-audit, npm audit, gitleaks on all three repos, semgrep).
### 2026-07-01 — Payment-source governance hardening + F009 T00 investigation (Cursor)
### 2026-07-06 — Review-queue auto-enqueue for WS3 handoff (Cursor)



- (fill bullets)
### 2026-07-06 — Harden inactive rebuild: proxy-safe sequencing + sprint_verify VPS script path (Cursor)

- **`scripts/ops/fm_server_beta.sh`:** `rebuild-color` no longer stops/recreates the proxy before inactive API health is confirmed; tags last-known-good images and rolls back app containers on compose-up or health-check failure (proxy keeps serving active color).
- **`scripts/ops/sprint_verify.sh`:** default `FM_SPRINT_FM_SCRIPT` is now `scripts/fm_server_beta.sh` (VPS path under `~/finance_manager/scripts/`, not `scripts/ops/`).
- **`AGENTS.md`:** document VPS vs parent-repo `fm_server_beta.sh` paths and `FM_SPRINT_FM_SCRIPT` default.
### 2026-07-06 — Fix security audit suite: bandit 1.9.4 + stop env-poisoning in lib_anomaly_write (Cursor)

- **`scripts/security/TOOL_VERSIONS`:** bump `bandit` to **1.9.4** — fixes Python 3.14 `ast.Num` crash that prevented real findings.
- **`scripts/security/lib_anomaly_write.sh`:** pass large tool output to embedded Python via temp files instead of `export` env vars — stops the env-poisoning cascade (`Argument list too long` / gitleaks false skips) for the rest of `run_audit.sh`.
- **Verified:** `./scripts/security/run_audit.sh` completes end-to-end (bandit findings, pip-audit, npm audit, gitleaks on all three repos, semgrep).
### 2026-07-01 — Payment-source governance hardening + F009 T00 investigation (Cursor)
### 2026-07-06 — Anomaly-filing enforcement gate in orchestration handoffs (Cursor)



- (fill bullets)
### 2026-07-06 — Harden inactive rebuild: proxy-safe sequencing + sprint_verify VPS script path (Cursor)

- **`scripts/ops/fm_server_beta.sh`:** `rebuild-color` no longer stops/recreates the proxy before inactive API health is confirmed; tags last-known-good images and rolls back app containers on compose-up or health-check failure (proxy keeps serving active color).
- **`scripts/ops/sprint_verify.sh`:** default `FM_SPRINT_FM_SCRIPT` is now `scripts/fm_server_beta.sh` (VPS path under `~/finance_manager/scripts/`, not `scripts/ops/`).
- **`AGENTS.md`:** document VPS vs parent-repo `fm_server_beta.sh` paths and `FM_SPRINT_FM_SCRIPT` default.
### 2026-07-06 — Fix security audit suite: bandit 1.9.4 + stop env-poisoning in lib_anomaly_write (Cursor)

- **`scripts/security/TOOL_VERSIONS`:** bump `bandit` to **1.9.4** — fixes Python 3.14 `ast.Num` crash that prevented real findings.
- **`scripts/security/lib_anomaly_write.sh`:** pass large tool output to embedded Python via temp files instead of `export` env vars — stops the env-poisoning cascade (`Argument list too long` / gitleaks false skips) for the rest of `run_audit.sh`.
- **Verified:** `./scripts/security/run_audit.sh` completes end-to-end (bandit findings, pip-audit, npm audit, gitleaks on all three repos, semgrep).
### 2026-07-01 — Payment-source governance hardening + F009 T00 investigation (Cursor)
### 2026-07-06 — test_api.sh exports local pytest env defaults (Cursor)


- **`scripts/dev/test_api.sh`:** export `SECRET_KEY`, `DEBUG`, and `REDIS_URL` when unset so `test_api` MCP and direct invocation match agent session defaults without per-run boilerplate.
### 2026-07-06 — Harden inactive rebuild: proxy-safe sequencing + sprint_verify VPS script path (Cursor)

- **`scripts/ops/fm_server_beta.sh`:** `rebuild-color` no longer stops/recreates the proxy before inactive API health is confirmed; tags last-known-good images and rolls back app containers on compose-up or health-check failure (proxy keeps serving active color).
- **`scripts/ops/sprint_verify.sh`:** default `FM_SPRINT_FM_SCRIPT` is now `scripts/fm_server_beta.sh` (VPS path under `~/finance_manager/scripts/`, not `scripts/ops/`).
- **`AGENTS.md`:** document VPS vs parent-repo `fm_server_beta.sh` paths and `FM_SPRINT_FM_SCRIPT` default.
### 2026-07-06 — Fix security audit suite: bandit 1.9.4 + stop env-poisoning in lib_anomaly_write (Cursor)

- **`scripts/security/TOOL_VERSIONS`:** bump `bandit` to **1.9.4** — fixes Python 3.14 `ast.Num` crash that prevented real findings.
- **`scripts/security/lib_anomaly_write.sh`:** pass large tool output to embedded Python via temp files instead of `export` env vars — stops the env-poisoning cascade (`Argument list too long` / gitleaks false skips) for the rest of `run_audit.sh`.
- **Verified:** `./scripts/security/run_audit.sh` completes end-to-end (bandit findings, pip-audit, npm audit, gitleaks on all three repos, semgrep).
### 2026-07-01 — Payment-source governance hardening + F009 T00 investigation (Cursor)
### 2026-07-06 — WS-PARENT queue + real-task dispatch briefs in ws_dispatch.sh (Cursor)

- **`scripts/workspace/ws_dispatch.sh`:** add `parent` repo routing (`HFM` in-place checkout); resolve `plans/.../tasks/T##_*.md` from queue `PLAN_ID`/`TASK_ID` and embed verbatim in cursor-mode brief (no silent smoke fallback); README `plan_id` fallback when directory slug diverges from `PLAN_ID`.
- **`governance/execution/workspace_protocol.md`:** document `parent.queue`, in-place dispatch risk, and real-brief generation (§4–§5).
- **`scripts/mcp/hfm_mcp/server.py`:** `queue_push` docstring includes `parent`.
- **Verified:** `ws_dispatch.sh api --dry-run` resolves `SECURITY-AUDIT-FIXES-T04`; `ws_dispatch.sh parent --dry-run` routes to `HFM`.
### 2026-07-06 — Harden inactive rebuild: proxy-safe sequencing + sprint_verify VPS script path (Cursor)

- **`scripts/ops/fm_server_beta.sh`:** `rebuild-color` no longer stops/recreates the proxy before inactive API health is confirmed; tags last-known-good images and rolls back app containers on compose-up or health-check failure (proxy keeps serving active color).
- **`scripts/ops/sprint_verify.sh`:** default `FM_SPRINT_FM_SCRIPT` is now `scripts/fm_server_beta.sh` (VPS path under `~/finance_manager/scripts/`, not `scripts/ops/`).
- **`AGENTS.md`:** document VPS vs parent-repo `fm_server_beta.sh` paths and `FM_SPRINT_FM_SCRIPT` default.
### 2026-07-06 — Fix security audit suite: bandit 1.9.4 + stop env-poisoning in lib_anomaly_write (Cursor)

- **`scripts/security/TOOL_VERSIONS`:** bump `bandit` to **1.9.4** — fixes Python 3.14 `ast.Num` crash that prevented real findings.
- **`scripts/security/lib_anomaly_write.sh`:** pass large tool output to embedded Python via temp files instead of `export` env vars — stops the env-poisoning cascade (`Argument list too long` / gitleaks false skips) for the rest of `run_audit.sh`.
- **Verified:** `./scripts/security/run_audit.sh` completes end-to-end (bandit findings, pip-audit, npm audit, gitleaks on all three repos, semgrep).
### 2026-07-01 — Payment-source governance hardening + F009 T00 investigation (Cursor)

- **`AGENTS.md` / `.cursor/rules/api-architecture.mdc`:** documented the `source_id` stable-linkage pattern (`PaymentSource.source_id` stored in `Transaction.source`, `BalanceSnapshot.source`, `SavingsGoal.source`, `AppProfile.spend_accounts`; API exposes display names at the boundary); added a DB query budget rule (hard cap **15 queries/call**, target **<10**).
- **`governance/plans/plan_template.md`:** added a pre-`ready` checklist item requiring explicit justification for any new FK to `PaymentSource`/`Category`/`UpcomingExpense` instead of the stable-id CharField convention.
- **F-009 `DESIGN.md`:** resolved trigger model (frontend-driven check + normal `POST /finance/transactions/`, not a Celery-beat scheduler), corrected `auto_deduct` field location (`UpcomingExpense`, not `Transaction`), and surfaced a previously-unscoped gap — `UpcomingExpense` has no `PaymentSource` link today, needs a new field.
- **F-009 T00 functional investigation report:** confirmed the linkage gap, validated the bill→transaction progression path F-009 will ride unmodified, found the frontend's `todayIso()` is browser-local (not profile-timezone-aware), and confirmed the PWA outbox path needs no auto-deduct-specific handling. Sorted findings into repurpose/extend/build-new.

### 2026-07-01 — Payment source linkage: stable source_id across four surfaces (Cursor)

- **API PR [#82](https://github.com/AzazelAzure/finance-manager-api/pull/82):** reverted `SavingsGoal.source` from a real FK to a `CharField(max_length=20)` storing the new stable **`PaymentSource.source_id`**, matching the existing `Transaction.source`/`BalanceSnapshot.source` string-linkage convention.
- Migrated `Transaction.source`, `BalanceSnapshot.source`, and `AppProfile.spend_accounts` to `source_id` storage (migration `0019`); PaymentSource renames no longer orphan links.
- API serializers continue to expose display **names** at the boundary — no client-facing contract change.
- Side task: DB query-count audit sweep on inactive color only (15-query cap, <10 target).

### 2026-07-01 — Web dependabot batch: react-dom, react-is, react-query, vite plugin (eslint held) (Cursor)

- **Web PR [#106](https://github.com/AzazelAzure/finance-manager-web/pull/106):** batched `react-dom`, `@vitejs/plugin-react`, `react-is`, and `@tanstack/react-query` bumps in one `npm` pass.
- Held `eslint` back at 10.2.1 — `main` already carries 13 unresolved lint errors that would block CI if the parser were upgraded in the same batch.

### 2026-07-01 — API dependabot batch: tzdata, coverage, pytest, cryptography, setuptools (Cursor)

- **API PR [#81](https://github.com/AzazelAzure/finance-manager-api/pull/81):** batched `tzdata`, `cryptography`, `coverage`, `setuptools`, and `pytest` bumps in a single `uv lock` pass instead of five sequential merges.

### 2026-07-01 — Support tests: eager Celery in conftest (no local Redis) (Cursor)

- **API PR [#80](https://github.com/AzazelAzure/finance-manager-api/pull/80):** added an autouse `conftest.py` fixture setting `CELERY_TASK_ALWAYS_EAGER`, removing the local live-Redis dependency for 24 support-ticket test cases.

### 2026-07-01 — Bill-tx linkage: cadence-aware due-date reversal on tx edit/delete (Cursor)

- **API PR [#79](https://github.com/AzazelAzure/finance-manager-api/pull/79):** fixed `Updater._handle_tx_update` so editing or deleting a transaction correctly reverses/re-advances the linked bill's due date for non-monthly cadences (previously only monthly bills reversed correctly post-recurrence-engine). Unblocks F-003 predictive-budgeting work.

### 2026-07-01 — VPS backup + sprint_verify smoke fixes (Cursor)

- **`scripts/ops/pull_backup.sh`:** run `pg_dump` via Podman/docker exec in VPS `fm-beta_db_1`; use `env` for remote var passthrough; min-size + pg_dump header guards; verified **478K** backup 2026-07-01.
- **`scripts/server/pull_backup.sh`:** compat forwarder for crontab paths pre scripts/ops reorg.
- **`scripts/ops/sprint_verify.sh`:** `env … bash -s` remote block (fixes OpenSSH smoke skip); fail-loud if `--smoke` without `SPRINT_VERIFY_SMOKE_COMPLETE` / `Smoke checks passed` in evidence log.
- **Docs:** `scripts/SCRIPTS.md`, `setup_backup_cron.sh`; meeting anomaly matrix + dispatch updated.
### 2026-07-01 — MCP Tier 1–3 dev tool catalog (Cursor)

- **Tier 3 scripts (new):** `new_meeting_day.sh`, `branch_delta.sh`, `stash_triage.sh`, `dependabot_batch.sh`, `celery_ready.sh`, `env_check.sh`, `test_rust.sh`.
- **`scripts/mcp/hfm_mcp/server.py`:** MCP wrappers for all Tier 1–3 dev scripts from `combined_commands_index.md` §4 (39 tools total): orientation (`repo_health`, `plan_status`, `open_prs`, `submodule_status`, `handover`), CPPRD (`changelog_entry`), scaffolding (`new_tp`, `new_plan`, `new_meeting_day`), tests/sync (`submodule_sync`, `test_rust`), triage (`branch_delta`, `stash_triage`, `dependabot_batch`, `celery_ready`, `env_check`).
- **Docs:** `scripts/mcp/README.md` v0.2 catalog; `scripts/SCRIPTS.md`; `.cursor/rules/scripts-orientation.mdc` — CPPRD → `changelog_entry`.

### 2026-07-01 — MCP: `queue_done` and `ws_review` tools (Cursor)

- **`scripts/mcp/hfm_mcp/server.py`:** add typed MCP wrappers for `queue_done.sh` (mark queue entry DONE/FAILED) and `ws_review.sh` (WS3 PR review: auto, approve, reject) so orchestration from HFM can complete the dispatch→review loop without raw shell.
- **`scripts/mcp/README.md`:** tool catalog updated (22 tools).

### 2026-07-01 — Scripts taxonomy reorg + Tier 1 dev tooling (Cursor)

- **`scripts/` taxonomy:** new buckets `ops/` (VPS + absorbed `server/`), `local-stack/` (`fm_docker`, `fm_services`), `db/`, `lib/` (`lib_repos.sh`, `vps_env.sh`); archived `hive_worker.py`, `sprint_pipeline_emit_ready.py`, `migrate_hfm_layout.sh`, deprecated systemd unit.
- **Fixes:** `scripts/ops/pull_backup.sh` and `scripts/dev/vps_freshness.sh` use `scripts/lib/vps_env.sh` (`.env` allowlist) instead of scrubbed SSH placeholders.
- **New dev scripts:** `pr_readiness.sh`, `workspace_brief.sh`, `local_stack_health.sh`, `anomaly_new.sh`, `new_tp.sh`, `new_plan.sh`, `changelog_entry.sh`, `test_api.sh`, `test_web.sh`, `submodule_sync.sh`, `ci_status.sh`.
- **`scripts/workspace/ws_dispatch.sh`:** injects live `AGENTS.md` governance excerpt into per-repo worker task briefs.
- **Docs/rules:** `scripts/SCRIPTS.md`, `.cursor/rules/scripts-orientation.mdc`; path updates across `governance/`, `deploy/`, `AGENTS.md`, container rules.
- **Local MCP server:** `scripts/mcp/` (FastMCP, `uv sync`), 20 typed tools wrapping dev/workspace/ops scripts; `.cursor/mcp.json` for Cursor; setup in `scripts/mcp/README.md`.

### 2026-07-01 — Gate F-006/F-009 pilot + MCP spec on tp-scripts-organization (Claude Code, admin)

- **`governance/execution/workspace_protocol.md` §10:** HitM reversed the original build order — the local MCP server (tool-wrap for `scripts/workspace/*.sh`) now must be built *before* the full live F-006/F-009 pilot, not after. Both steps are gated on `strategy/meetings/week27/meeting2026-07-01/tp-scripts-organization/` completing (script taxonomy + inventory, then the MCP wrap). Rationale: the live pilot should exercise the interface agents will actually use (typed MCP calls) rather than validate a raw-shell interface that gets replaced immediately after.
- **`tp-workspace-setup/decisions.md`:** logged as D8. **`tp-workspace-setup/README.md`:** sequence steps 8–9 marked gated; added step 7.5 documenting the already-run smoke pilot as unplanned-but-validating (not a substitute for the real pilot).
- **`tp-scripts-organization/notes.md`:** priority raised from "come back after rust-calc" to active-priority gating dependency; flagged that its MCP scope should cover the actual `ws_dispatch.sh`/`ws_review.sh` interface (discovered during `workspace_protocol.md` authoring), not just the shorter list in the original draft.

### 2026-07-01 — `governance/execution/workspace_protocol.md` authored; TP sequence step 7 closed (Claude Code, admin)

- **New `governance/execution/workspace_protocol.md`:** documents the live multi-workspace checkout/dispatch/review/VPS-authority system as actually implemented — verified against real lockfile/queue state and script source, not just the original design docs. Covers filesystem layout, the `ws_claim`/`ws_release`/`ws_status` checkout model, the `workspace.lock` sign-out sheet, FIFO `*.queue` dispatch, and VPS authority (used alongside `governance/deployment/Runtime_Signup_Sheet.md`, not replacing it).
- **Documented divergences from the original design** (doc §7): `ws_dispatch.sh` and `ws_review.sh` were built beyond the originally scoped Tier 1 script list; no `review.queue` file exists (design gap — `ws_review.sh` takes a PR number directly); per-repo worker occupancy (`WS-API`/`WS-WEB`) is tracked indirectly via the orchestrating `WS1`/`WS2` claim, not its own lockfile row.
- **Discovered and logged an anomaly, not fixed inline:** `ws_dispatch.sh`/`ws_review.sh` already ran a full smoke pilot today (2026-07-01) against the real `finance_manager_api` (PRs #74–#78 merged) and `finance_manager_web` (PRs #104–#105 merged) repos, including a verified concurrency-lock stress test. Left `smoke_test/*.txt` artifacts on both repos' `main` and one reject-path test PR that merged instead of being rejected. See `strategy/anomalies/2026-07-01_tp-workspace-setup_smoke-pilot-artifacts-and-reject-merge.md`.
- **`AGENTS.md` §3 + `governance/README.md`:** linked the new doc. **`governance/archived/agent_workspace_isolation.md`:** marked superseded (stale pre-migration paths/roles), kept for history.
- **TP sequence step 7 (`strategy/meetings/week27/meeting2026-07-01/tp-workspace-setup/README.md`) now complete.** Steps 8 (F-006/F-009 real pilot) and 9 (MCP server spec) remain open.

### 2026-07-01 — Workspace-migration governance closeout + AGPL rollout completion (Claude Code, admin)

- **`tp-workspace-setup` filesystem move + sync closed:** filesystem centralization to `~/Hive_Financial_Manager/{HFM,WS1,WS2,WS3,WS-API,WS-WEB}` confirmed complete; all 7 design decisions (D1–D7) resolved per `strategy/meetings/week27/meeting2026-07-01/tp-workspace-setup/decisions.md`. **Governance doc authoring (`governance/execution/workspace_protocol.md`) and the F-006/F-009 queue pilot remain open** — TP not fully closed, see updated TP README sequence.
- **`governance/reference/glossary.md` §14 added:** internal project vocabulary — HFM (Hive Financial Manager), HitM, three-tool model, Workspace, Sign-out sheet, VPS authority.
- **New `scripts/workspace/` tooling:** `ws_claim.sh`/`ws_release.sh`/`ws_status.sh`/`ws_dispatch.sh`/`ws_review.sh` (workspace sign-out + dispatch) and `queue_push.sh`/`queue_pop.sh`/`queue_status.sh`/`queue_done.sh`/`vps_claim.sh`/`vps_release.sh` (FIFO work queue + VPS authority lock), per D3 (simple lockfile) and D4 (advisory claim, hard-block on VPS) resolutions.
- **`scripts/local/migrate_hfm_layout.sh`:** three-phase migration script (agent workspaces → primary repo → crontab/conf) used to execute the filesystem move; retained for reference.
- **`scripts/sync_agent_files_to_workspaces.sh`:** mirrors gitignored governance/strategy bundle (`strategy/`, `plans/`, `.cursor/`, `.claude/`, agent doc files) from primary `HFM` workspace to `WS1`/`WS2`/`WS3`, since those paths are scrubbed from GitHub history. Live sync run against all three workspaces as part of this closeout; spot-checked WS1.
- **`.gitignore`:** added `.fm_workspace.conf` (per-workspace primary-path pointer, machine-local).
- **`AGENTS.md` Learned Workspace Facts:** expanded API architecture note (service-oriented, flat routes, no routers) and VPS health-check secret sourcing note.
- **AGPL-3.0-or-later rollout completed:** added `LICENSE` + README pointer to the three remaining repos — `finance_manager_android` (`6491acc`), `finance_manager_rust_middleware` (`6d8846e`), `finance_manager_web` (`03e09c4`, also `package.json` `license` field). All 8 ecosystem repos now carry `AGPL-3.0-or-later`.
- **`docs/SPDX_COMPLIANCE.md` + parent `README.md`:** updated to list all repos (ecosystem root, api, cli, web, android, rust_tools, rust_middleware, reflex) under the single license policy with a per-repo `LICENSE` path table.
- **Submodule pointer bumps:** `finance_manager_android` → `6491acc`, `finance_manager_rust_middleware` → `6d8846e`, `finance_manager_web` → `03e09c4`. `design_docs` left untouched (unrelated in-flight terminology cleanup, not part of this closeout).

### 2026-06-30 — Healthcheck secretization + local VPS env loading (Cursor)

- **`.github/workflows/health-check.yml`:** Replace scrubbed committed VPS origin value with `secrets.VPS_ORIGIN_IP` and add a clear validation step for missing/placeheld/SSH-target values before curl checks run.
- **`scripts/ops/vps_state.sh` + `scripts/ops/sprint_verify.sh`:** Load allowlisted VPS ops variables from repo-root `.env` (`VPS_ORIGIN_IP`, `FM_SPRINT_SSH`, remote root/timeouts/project options) without sourcing arbitrary shell code; document local usage in `.env.example`.

### 2026-06-30 — design_docs cleanup follow-ups + API/Web docs (Cursor)

- **Submodule pointer bumps** (all to merged `main`):
  - `design_docs` → `e3da618`: sub-repo README dead-ref cleanup vault nav (#23), full `api_docs/` rewrite (#24), and new `web_docs/` flagship SPA section (#25).
  - `finance_manager_api` → `4a29bde` (#73), `finance_manager_cli` → `95a3589` (#2), `finance_manager_reflex` → `e4de43c` (#15), `finance_manager_web` → `07f97ca` (#103): repoint/reword dead `design_docs/30_Releases` + `20_Roadmap` README refs to parent `governance/` after the scope cleanup.
- **Handoff `strategy/cursor_handoff_design_docs_cleanup.md` complete:** Task 1 (sub-repo README refs), Task 2 (`design_docs` README + `00_Dashboard` rework + `api_docs` `file://` link hygiene), plus comprehensive `api_docs/` and new `web_docs/` documentation aligned to tight-beta implementation.

### 2026-06-30 — Repo publication + design_docs scope cleanup (Claude, admin)

- **All 9 ecosystem repos made public.** Scrubbed business/strategy artifacts and a VPS IP from parent + `design_docs` history before publication; rewrote parent `README` as a portfolio-facing landing page.
- **`design_docs` rescoped to active working system design only.** Relocated holdovers from earlier orchestration iterations:
  - → `governance/`: `Runtime_Signup_Sheet`, Git/Runtime owner handoff templates, `Documentation_Sync_Protocol`, and the server-runtime / inter-agent-relay / beta-incident-triage contracts. All references repointed (AGENTS.md, `governance/*`, `.cursor/` rules+skills, `scripts/gather_doc_context.sh`).
  - → private `strategy/`: future risks, research backlog, licensing strategy, full `20_Roadmap`, localization strategy, bounty sandbox + security disclosure drafts. Business-sensitive subset history-scrubbed from public `design_docs`.
  - Deleted: deprecated Slack-bridge doc, hive orchestration protocol, `30_Releases/_historical/*`, archived `reflex_docs`, alpha overview, stale resume checkpoint.
- **Follow-ups handed to Cursor** (`strategy/cursor_handoff_design_docs_cleanup.md`): repoint dead refs in sub-repo READMEs, author a `design_docs` README, rework `00_Dashboard` links, and fix ~21 absolute-`file://` local-path links in `api_docs/`.

### 2026-06-30 — Web #97 green promotion + runtime signup (Cursor)

- Bump `design_docs` submodule: `Runtime_Signup_Sheet.md` logs inactive-green restage on `main` (API `9938614`, Web `9436e3b`) and active color flip **blue → green** after Web PR #97 (Profile tab fix + ErrorBoundary). VPS post-switch smoke passed (captured 2026-06-30T07:24+08).

### 2026-06-30 — SEO audit and strategic refinement (Antigravity, admin)

- **`plans/S1/S1.B/distribution-channel-research/`:** Created `SEO_PASSTHROUGH_PASSDOWN.md` containing the SEO audit findings, custom React 19 + Vite 8 SSG proposal, font preloading / Core Web Vitals analysis, and Speculation Rules constraint analysis. Updated `SEO_PRIORITY_MATRIX.md` to mark `react-helmet-async` as **DONE**, add the font preloading task under P1, refine the prerendering task to a custom React 19 script, and link the new passthrough document.

### 2026-06-29 — Midday touch-up + RCA standard adopted (Claude Code, admin)

- **RCA promoted to a standard:** `governance/reference/glossary.md` §13 (Incident & RCA vocabulary — RCA required for S0/S1) + new `governance/incident/rca_template.md` (generalized from Cursor's F-010 RCA, cited as the canonical example).
- **Midday touch-up doc** (`strategy/meetings/midday_touchup_2026-06-29.md`): F-010 RCA dispositioned (shared-blame analysis; real intent was data-portability, not a public/invite link), Topics 2–6 reorientation (single critical path = redeploy blue → checklist → flip, now done).
- **Tomorrow seeded:** `strategy/meetings/admin_meeting_seed_2026-06-30.md` carries forward F-009/F-006 dispatch, the rust-tools planning session, and the F-010 §1.5 forward items (DoD privacy gate, FEATURE_IDEAS sweep, data-portability + invite-link features).

### 2026-06-29 — F-010 share-link exposure RCA + shutdown coordination (Cursor)

- **RCA:** `strategy/audits/2026-06-29_share-link-exposure_rca.md` — exhaustive trace of F-010 public bearer-URL share feature from plan spec through PRs #59/#86, production flip (2026-06-28 12:32 +08), ~24h exposure window, and 2026-06-29 disable (API #66, Web #92). Root cause: privacy-by-design spec (`AllowAny` full transaction JSON), not cross-user IDOR.
- **Follow-up stub:** `plans/S1/S1.B/feat-f010-export-sharing/HARDENING_FOLLOWUP_STUB.md` — minimum bar if sharing is ever revived.

### 2026-06-29 — D6 design-docs restructure submodule pointer (Cursor)

- Bump `design_docs` submodule to `cur/s1b/chore/design-docs-restructure` (design-docs PR #21): archive `reflex_docs` and roadmap/release overlap to `_historical/`; fix Dashboard dead links; retain `Runtime_Signup_Sheet.md` and handoff templates. Docs-only CPPR.

### 2026-06-29 — D3 fix: fm_server_beta.sh nginx check false-negative (Cursor)

- **`scripts/ops/fm_server_beta.sh` (`check_cmd`):** `00-resolver.conf` is generated at proxy container start (`proxy/docker-entrypoint.d/20-resolver-from-resolv.sh`), not committed in-repo. The throwaway `nginx -t` harness was missing that file and always failed even when the live proxy was healthy. `check` now validates via `exec -T proxy nginx -t` when the proxy container is running; otherwise it mounts a stub resolver into the throwaway container. Closes anomaly `2026-06-28_CI-CD_fm-server-beta-check-nginx-resolver.md`.

### 2026-06-29 — D5 implementation: live VPS state query (Cursor)

- **`scripts/ops/vps_state.sh` (new):** Single-concern script that SSHes the production VPS in one read-only round-trip and prints a timestamped `## Live VPS State (SSH-verified)` markdown block (active color, deployed API/Web SHAs, container count, Celery worker/beat status, last applied `finance` migration, API health, container detail table, drift check). On SSH failure/timeout (hard 20s default) it prints a clearly-marked `UNAVAILABLE` block and exits non-zero so callers surface UNKNOWN instead of falling back to cached state. Reuses the existing `FM_SPRINT_SSH`/`FM_SPRINT_REMOTE_ROOT` config (no new credentials).
- **`scripts/gather_doc_context.sh` (refactor):** Replaced the static `head -60 Runtime_Signup_Sheet.md` "Current VPS State" block with a call to `vps_state.sh`. The Runtime Signup Sheet is now printed under a clearly demoted `## Runtime Signup Sheet (human log — NOT live state)` heading so live state is never conflated with the human-authored log — the root-cause fix for the 2026-06-29 stale-state false HIGH alerts. Implements spec `strategy/automations/specs/vps_state_and_doc_context_spec_2026-06-29.md` (Deliverables 1–2; Deliverable 3 prompt hardening owned by Claude Code, already landed).

### 2026-06-29 — Admin session: planning batch + governance/doc-structure consolidation (D1–D8)

- **Plans authored (ready for Cursor):** `PLAN_LOCAL_SECURITY_AUDIT_SUITE_2026-06-29` (T01–T04), `PLAN_CROSS_BILL_RECURRENCE_ENGINE_2026-06-29` (T01–T04; first-class `cadence` field; blocks F-009), `PLAN_CHORE_DESIGN_DOCS_RESTRUCTURE_2026-06-29` (T01–T03; submodule docs-only).
- **D5 spec:** `strategy/automations/specs/vps_state_and_doc_context_spec_2026-06-29.md` (live `vps_state.sh` + `gather_doc_context.sh` refactor; root cause of stale-state false alarms).
- **D6 doc-structure consolidation (resolved + executed, parent side):** new `strategy/` homes `projections/`, `parking_lot/`, `audits/`, `risk_register.md`; `strategy/README.md` rebuilt as living-state index; `git mv` of success_projection + quarterly_reviews → `projections/`, operational_audit_report + improvement_tracker → `audits/`, with all inbound references (audit automations, legal docs) repointed.
- **Governance:** `governance/coordination/meeting_artifact_protocol.md` added; plan registry updated; two anomalies dispatched (bill-interval → recurrence plan, nginx-check → Cursor chore).
- **AGENTS.md:** §1 trust-but-verify + documentation-maintenance tenets added; stale bill-recurrence fact refreshed to point at the new plan.
- **Prompt hardening (D5):** `daily_summary_prompt.md` + `daily_doc_sweep_prompt.md` now source VPS state live-only (timestamped, UNKNOWN on unavailability, never from the Runtime Signup Sheet/cache) with a trust-but-verify constraint; fixed stale `scripts/dev/gather_doc_context.sh` path. Added `strategy/meetings/cursor_execution_2026-06-29.md` (today's ordered Cursor dispatch list).
- **F-009 + F-006 task files authored (Draft → Ready):** `PLAN_CROSS_RECURRING_AUTO_DEDUCT_F009` (T01–T04: `auto_deduct` flag + idempotency, Celery-beat due-date eval, web toggle, edge cases; bill-recurrence dependency now satisfied) and `PLAN_CROSS_DASHBOARD_WIDGETS_F006` (T01–T04: layout persistence, widget catalog/render, DnD reorder/resize, device variants). Branch prefixes corrected `cursor/` → `cur/`. F-002/F-003 deferred pending rust-tools planning.

### 2026-06-28 — F-011 landing reflect-shipped + forward roadmap (T03+T04)

- **Plan execution:** `PLAN_CROSS_WEDGE_MARKETING_F011` T03+T04 completed. Web PR #90 merged; landing page updated for June production batch (F-001, F-004, F-005, F-010) and honest forward roadmap; HitM V3 approved; promoted **active green**.
- **Governance:** Plan registry reconciled (F-004, F-010, production-UX fix moved to Recently Completed); wedge audit rows 1–3 filled; doc sweep report `strategy/automations/reports/doc_sweep_2026-06-28.md`.

### 2026-06-28 — F-005 savings goals closeout

- **Plan execution:** `PLAN_CROSS_SAVINGS_GOALS_F005_2026-05-05` completed across API and Web. API/Web task PRs merged to `main`; production VPS rebuilt inactive **blue**, applied migration `0016_savings_goal`, smoked blue, then switched active color **green -> blue**.
- **Validation:** API/Web task validation and agent-review fixes completed before merge. Post-switch origin smokes: API health `200`, savings-goals route unauthenticated `401`, web `/app/goals` `200`; P2 monitoring completed with 6/6 health checks green and `TOTAL_NON2XX=0`.

### 2026-06-28 — F-010 export and sharing closeout

- **Plan execution:** `PLAN_CROSS_EXPORT_SHARING_F010_2026-05-05` completed across API and Web. API/Web landing PRs merged to `main`; production VPS rebuilt inactive **green**, applied migration `0015_export_share_token_f010`, smoked green, then switched active color **blue -> green**.
- **Validation:** API CI and Web CI green on landing PRs; local focused validation passed (`manage.py check`, `finance.tests.test_f010_export`, `npm run build`). Post-switch origin smokes: API health `200`, CSV/full export routes unauthenticated `401`, unknown share token `404`, web `/app/data` `200`.

### 2026-06-28 — Minimum viable CI/CD pipeline (PLAN_CROSS_CI_CD)

- **`.github/workflows/health-check.yml`:** Self-hosted VPS uptime monitor in the parent repo — cron `*/10` + `workflow_dispatch`, curls the production web root and `/api/health/`; a non-2xx/3xx response fails the run so GitHub emails the owner. (PR #71 → finance-manager-ecosystem.)
- **Plan execution:** `PLAN_CROSS_CI_CD_2026-06-27` moved Draft → In Progress. T01–T04 workflow files authored and PR'd across three repos: API CI (`uv` + `pytest` + `makemigrations --check` + Redis service, green: 285 pass/0 fail; finance-manager-api PR #43), Web CI (`tsc -b` + `vitest`, Node 22; finance-manager-web PR #71), Dependabot configs in API + Web. Branch protection (T04.SL3) and live health-check verification (T03.SL2) remain as manual steps gated on the first green run. See `plans/S1/S1.B/chore-ci-cd/runtime_handoff.md`.
- **Closeout:** Health check failed from GitHub-hosted runners because Cloudflare returned `403` before reaching the VPS; PR #73 changed the workflow to check the VPS origin directly with `curl --resolve` + `-k`. Main dispatch `28306647911` passed (web `200`, API `200`). Branch protection is waived for the private API/Web repos because enabling it would require GitHub Pro or public repo visibility, both explicitly declined by HitM. `PLAN_CROSS_CI_CD_2026-06-27` is completed.

### 2026-06-26 — Redact compose `up` secret output

- **`scripts/ops/fm_server_beta.sh`:** Added a quiet `compose up` wrapper for deploy/rebuild/switch paths. `podman-compose up` can print fully interpolated `podman run -e KEY=value ...` lines, including values sourced from `.secrets/server.env`; successful `up` output is now discarded, and failed `up` output is printed only after redacting password/secret-style environment values.

### 2026-06-26 — Blue/green: Celery workers in rebuild + active orphan teardown

- **`scripts/ops/fm_server_beta.sh`:** `rebuild-color` now builds and recreates the shared `celery-worker` + `celery-beat` alongside `api/web` (F-014 background workers no longer drift behind API code or get orphaned on rebuilds). New `prune-orphans` command + `prune_orphan_containers` helper actively remove stale containers whose service is no longer in the compose file, scoped strictly to the project. `deploy` and `switch` keep the workers running and prune orphans. `status` filter now includes celery. **Note:** intentionally does **not** use `podman-compose up --remove-orphans` on a partial service list — that recreates the whole project (full-stack bounce incl. active color); the scoped prune is used instead so blue/green rebuilds leave the active color untouched.
- **`docker-compose.bluegreen.yml`:** Fixed a broken duplicate `api-green:` key (a null stub was overriding the real definition) and replaced the non-functional `command:`-based celery services (the API image `ENTRYPOINT` ignores `command`, so they ran `runserver` instead of celery) with a single working `celery-worker` + `celery-beat` using `entrypoint:` overrides. `api-green` env aligned with `api-blue` (email/notify vars).
- **`.gitignore`:** Ignore `*.secret` / `smtp.secret` so ad-hoc secret-handoff files are never committed.
- **Validation:** `bash -n`, dry-run, and a live VPS `rebuild-color blue` on the inactive color — green (active) container IDs unchanged (not recreated), blue + celery rebuilt, prune removed 0 orphans, active `api/web` returned `200` throughout.

### 2026-06-26 — Admin governance overhaul (three-tool model)

- **`AGENTS.md`:** Restructured §0–§6 — three-tool model (`cur/` / `cla/` / `agy/`), universal rules inline, branch conventions, per-agent reading order, CPPR/CPPRD discipline, retired daily-status PR pattern.
- **`CLAUDE.md`:** New Claude Code–specific admin rules.
- **`governance/README.md`:** Trimmed to router table + enums; reading sequences moved to `AGENTS.md`.
- **`governance/execution/branching_guidelines.md`:** Branch prefix table updated to `cur/` / `cla/` / `agy/` (new branches only).
- **Archived:** `governance/archived/` — `orchestration.md`, skill mirrors, `agent_context_delivery.md`; index README added.
- **Cursor rule:** `.cursor/rules/sprint-task-specification.mdc` (from former `governance/sprint_task_specification.md`).
- **Scripts archived:** Slack bridges + `orchestrator.py` → `scripts/archived/` (see `scripts/archived/README.md`).
- **Strategy:** Admin-only header on `strategy/current_status.md`; superseded note on `cursor_vs_claude_max_cba.md`.
- **Cross-links:** `plans/README.md`, `agent_workspace_isolation.md`, orchestration-manager skill paths updated.

- **Sprint pipeline queue:** shared next-slice Slack bodies live under [`plans/pipeline_queue/README.md`](plans/pipeline_queue/README.md); set **`SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR`** there (replaces per-plan `…/feat-f007-walkthrough-polish/evidence/pipeline_queue/`). [`plans/README.md`](plans/README.md) index updated; [`governance/sprint_queue_message_spec_v1.md`](governance/archived/sprint_queue_message_spec_v1.md) runbook + archived [`scripts/sprint_slack_pipeline_bridge.py`](scripts/archived/sprint_slack_pipeline_bridge.py) example env aligned.

### 2026-05-22 — Definition of done, F-011 beta subpages, rollout-order huddle

- **Governance:** [`governance/plans/definition_of_done.md`](governance/plans/definition_of_done.md) — PWA completeness note, class **A/B**, mandatory localization vs **shelved** signoff, SEO matrix + in-sprint P0 expectation, F-011 beta comms, completion checklist; §5b + checklist for **`#sprint-queue`** when used. [`governance/sprint_queue_message_spec_v1.md`](governance/sprint_queue_message_spec_v1.md) — normative **`sprint-queue-v1`** post shape (Cursor PA → cursor-agent). Cross-links: [`governance/plans/plan_template.md`](governance/plans/plan_template.md) §1b, [`governance/reference/glossary.md`](governance/reference/glossary.md) §12–§13, [`governance/README.md`](governance/README.md), [`governance/orchestration.md`](governance/orchestration.md) (protocols table), [`governance/cursor_pa_slack_visibility.md`](governance/cursor_pa_slack_visibility.md).
- **Huddle:** [`strategy/huddles/2026-05-22-feature-rollout-sprint-order/`](strategy/huddles/2026-05-22-feature-rollout-sprint-order/) — README (incl. transcript provenance), talking points, `DECISIONS`/`ACTIONS` stubs for product · beta · infra sprint order.
- **F-011:** [`plans/S1/S1.B/feat-f011-wedge-landing-hero/README.md`](plans/S1/S1.B/feat-f011-wedge-landing-hero/README.md) — beta subpages scope (about, pipeline, release notes + bugfixes).
- **F-007 polish:** [`plans/S1/S1.B/feat-f007-walkthrough-polish/README.md`](plans/S1/S1.B/feat-f007-walkthrough-polish/README.md) — shelved i18n for tours + `definition_of_done` cross-links; [`SLACK_SPRINT_QUEUE.md`](plans/S1/S1.B/feat-f007-walkthrough-polish/SLACK_SPRINT_QUEUE.md) — examples + slice order (spec lives under `governance/`). **Design:** [`design_docs/40_System_Design/12_Cursor_CLI_Slack_Cloud_Agent_Bridge.md`](design_docs/40_System_Design/12_Cursor_CLI_Slack_Cloud_Agent_Bridge.md) — `#sprint-queue` pointers aligned to governance + `Task Id:` spelling.
- **`#sprint-queue` first line:** [`governance/sprint_queue_message_spec_v1.md`](governance/sprint_queue_message_spec_v1.md), [`governance/reference/glossary.md`](governance/reference/glossary.md), [`governance/plans/definition_of_done.md`](governance/plans/definition_of_done.md), bridge doc, F-007 polish Slack example — require **`@CursorPA`** (no space); `@Cursor PA` does not trigger the runner mention in HitM’s Slack workspace.
- **Sprint pipeline gap (narrowed):** [`governance/sprint_queue_message_spec_v1.md`](governance/sprint_queue_message_spec_v1.md) **Pipeline continuity** + [`governance/cursor_pa_slack_visibility.md`](governance/cursor_pa_slack_visibility.md) — `#sprint-queue` intake alone does not post `#review-queue`; run the bridge (and optional local inbox) on the PA host for continuity. Phase 1 manual relay envelopes remain valid without the bridge.
- **Sprint Slack bridge:** [`scripts/sprint_slack_pipeline_bridge.py`](scripts/sprint_slack_pipeline_bridge.py) — Web API poller for `SPRINT_PIPELINE_JSON` (`READY_FOR_REVIEW` / `REVIEW_VERDICT`), optional **`SPRINT_PIPELINE_LOCAL_INBOX`** JSONL on the same host (no sprint-thread READY required), [`scripts/sprint_pipeline_emit_ready.py`](scripts/sprint_pipeline_emit_ready.py) helper, reviewer-agent verdict mode enabled via **`SPRINT_BRIDGE_REVIEW_AGENT_ENABLED`** + workspace/timeout env, conservative defaults with **`SPRINT_BRIDGE_AUTO_PASS_IF_NON_HITM=0`** and **`SPRINT_BRIDGE_AUTO_PASS_V0=0`**, next-slice file under `SPRINT_BRIDGE_NEXT_MESSAGE_BASEDIR`, and HitM gate routing when `requires_hitm: true`. Spec: [`governance/sprint_queue_message_spec_v1.md`](governance/sprint_queue_message_spec_v1.md) §Machine-readable pipeline.
- **Cursor PA paths:** [`governance/cursor_pa_slack_visibility.md`](governance/cursor_pa_slack_visibility.md) §Runtime layout — `~/CursorAgent/headless-cursor-agent/scripts/cursor_slack_runner.py`, inbox/outbox filenames (`cursor_slack_inbox.jsonl`, `cursor_slack_outbox.jsonl`); sprint bridge docstring + sprint spec cross-link for co-running with Socket Mode.
- **design_docs submodule:** bumped to **`finance-manager-design-docs` `main` @ `b7fdab3`** (GitHub merge of bridge PR #19) so clones/rebases track the same Slack sprint-queue contract as `governance/sprint_queue_message_spec_v1.md`.

### 2026-05-21 — AGENTS.md sync + F-007 walkthrough polish plan

- **AGENTS.md:** Continual-learning updates (Cursor PA / Antigravity orchestration, slice-scope bias, breakpoint handoff) for agent workspaces.
- **Plans:** [`plans/S1/S1.B/feat-f007-walkthrough-polish/README.md`](plans/S1/S1.B/feat-f007-walkthrough-polish/README.md) — T00–T03 tasks with V0–V3 evidence hooks + `sprint_verify.sh`; registry + S1.B index + F-007 README cross-link.

### 2026-05-05 — Orchestration huddle execution: sprint verify + Cursor PA Slack docs

- **Scripts:** [`scripts/ops/sprint_verify.sh`](scripts/ops/sprint_verify.sh) — SSH to VPS, git update selected subrepos, `fm_server_beta.sh rebuild-color` + optional `smoke`; evidence logs under `--evidence`. [`scripts/jsdevtesting_stack_check.sh`](scripts/jsdevtesting_stack_check.sh) — HTTPS probes for `jsdevtesting` + `api-jsdevtesting`.
- **Governance:** [`governance/cursor_pa_slack_visibility.md`](governance/cursor_pa_slack_visibility.md); [`governance/archived/agent_workspace_isolation.md`](governance/archived/agent_workspace_isolation.md) and [`governance/README.md`](governance/README.md) / [`governance/orchestration.md`](governance/orchestration.md) updated for Cursor PA + JSONL outbox vs IDE MCP; Antigravity runner marked legacy in [`scripts/antigravity_slack_runner.py`](scripts/antigravity_slack_runner.py); note in [`scripts/cursor_headless_slack_agent.py`](scripts/cursor_headless_slack_agent.py).
- **Huddle:** [`strategy/huddles/2026-05-04-orchestration-overhaul/VERIFICATION_DELTA.md`](strategy/huddles/2026-05-04-orchestration-overhaul/VERIFICATION_DELTA.md); [`implementation_plan.md`](strategy/huddles/2026-05-04-orchestration-overhaul/implementation_plan.md) exit table synced to canonical [`ACTIONS.md`](strategy/huddles/2026-05-04-orchestration-overhaul/ACTIONS.md); [`README.md`](strategy/huddles/2026-05-04-orchestration-overhaul/README.md) pointers.
- **F-007:** [`plans/S1/S1.B/feat-f007-guided-walkthroughs/evidence/V2_ORCHESTRATION_2026-05-05.md`](plans/S1/S1.B/feat-f007-guided-walkthroughs/evidence/V2_ORCHESTRATION_2026-05-05.md) + `runtime_handoff.md` ACTIONS #7 line.

### 2026-05-04 — F-007 guided walkthroughs: slice-based rebuild plan

- **Plans:** [`plans/S1/S1.B/feat-f007-guided-walkthroughs/README.md`](plans/S1/S1.B/feat-f007-guided-walkthroughs/README.md) — rebuild stance, code inventory, tasks **T00–T07** with **T##.SL#** verify-first gates; [`tasks/T00_baseline_rebuild_audit.md`](plans/S1/S1.B/feat-f007-guided-walkthroughs/tasks/T00_baseline_rebuild_audit.md); [`runtime_handoff.md`](plans/S1/S1.B/feat-f007-guided-walkthroughs/runtime_handoff.md) aligned (PR placeholder removed, slice log table).

### 2026-05-04 — Task slices (`T##.SL#`) and clarifying-questions protocol

- **Governance:** [`governance/plans/plan_template.md`](governance/plans/plan_template.md) §1a defines **tasks** `T##` and **slices** `T##.SL#` (**`SL`** distinct from Phase/Stage **S** notation); validator, body template, and execution-order examples updated. [`governance/reference/glossary.md`](governance/reference/glossary.md) §3, [`governance/execution/branching_guidelines.md`](governance/execution/branching_guidelines.md) §2.1, [`governance/plans/plan_registry.md`](governance/plans/plan_registry.md) hierarchy note, [`governance/orchestration.md`](governance/orchestration.md) directives, [`governance/plans/plan_lifecycle.md`](governance/plans/plan_lifecycle.md) §A, [`governance/README.md`](governance/README.md) Sequence A, and skill mirrors [`governance/skill_orchestration_manager.md`](governance/skill_orchestration_manager.md), [`governance/skill_roadmap_rollout_planning.md`](governance/skill_roadmap_rollout_planning.md) aligned.
- **Cursor:** [`feature-implementation-loop`](.cursor/skills/feature-implementation-loop/SKILL.md), [`bugfix-investigation-loop`](.cursor/skills/bugfix-investigation-loop/SKILL.md), [`orchestration-manager`](.cursor/skills/orchestration-manager/SKILL.md) (+ [`AGENT_PROMPT_TEMPLATE.md`](.cursor/skills/orchestration-manager/AGENT_PROMPT_TEMPLATE.md)), [`roadmap-rollout-planning`](.cursor/skills/roadmap-rollout-planning/SKILL.md), [`multi-repo-orchestration`](.cursor/skills/multi-repo-orchestration/SKILL.md), [`shared-subagent-handoff`](.cursor/skills/shared-subagent-handoff/SKILL.md); [`.cursor/rules/core-standards.mdc`](.cursor/rules/core-standards.mdc) and [`.cursor/rules/agent-delegation.mdc`](.cursor/rules/agent-delegation.mdc).
- **Parent docs:** [`AGENTS.md`](AGENTS.md), [`GEMINI.md`](GEMINI.md), [`plans/README.md`](plans/README.md), [`plans/templates/README.md`](plans/templates/README.md), [`plans/S1/S1.B/README.md`](plans/S1/S1.B/README.md).
- **Stage S1.B plan READMEs:** Task-and-slice section added (or research-oriented variant); **F-007** (`feat-f007-guided-walkthroughs`) received a **shelved** note only pending a future slice pass.

### 2026-05-04 — Archive `plans/templates/GEMINI_PLAN_TEMPLATE*.md`

- **Moved** `GEMINI_PLAN_TEMPLATE.md`, `GEMINI_PLAN_TEMPLATE_V2.md`, and `GEMINI_PLAN_TEMPLATE_QUICK.md` to [`plans/archived/gemini_plan_templates/`](plans/archived/gemini_plan_templates/) with index README. **`governance/plans/plan_template.md`** is the only active plan schema; [`plans/templates/README.md`](plans/templates/README.md) points authors there. Updated [`governance/plans/plan_template.md`](governance/plans/plan_template.md) intro and [`GEMINI.md`](GEMINI.md).

### 2026-05-04 — Plans health: `plans/README.md`, remove duplicate `plans/feat/` tree

- **Added** [`plans/README.md`](plans/README.md) as the entry map for active `plans/<Phase>/<Stage>/`, `plans/archived/`, and `plans/templates/` (vs **`strategy/`** and **`governance/`**).
- **Removed** residual duplicate `plans/feat/web-reflex-parity-sweep-1/` (canonical frozen plan: [`plans/archived/feat/web-reflex-parity-sweep-1/`](plans/archived/feat/web-reflex-parity-sweep-1/)).
- **Docs:** `AGENTS.md` orchestration bullet Markdown fix; `plans/S1/S1.B/drift-cleanup/tasks/T01_bill_disable_retro_commit.md` uses submodule-relative wording for the QuickActions comparison; `plans/cursor/_TEMP_ECOSYSTEM_HEALTH_AND_DIRECTIVES_2026-05-04.md` parity item marked resolved; parent [`README.md`](README.md) links [`plans/README.md`](plans/README.md).
- **Governance — orchestration:** [`governance/orchestration.md`](governance/orchestration.md) (single index: strategy, plans, governance table, Cursor layer, runtime, read order, directives snapshot). Skill mirrors: [`governance/skill_roadmap_rollout_planning.md`](governance/skill_roadmap_rollout_planning.md), [`governance/skill_orchestration_manager.md`](governance/skill_orchestration_manager.md). [`governance/README.md`](governance/README.md) table + Sequence F; forbidden-actions bullet aligned with Cursor PR links + GitHub merge checks. [`plans/README.md`](plans/README.md) and [`GEMINI.md`](GEMINI.md) link the orchestration index; `_TEMP` consolidation item marked done.
- **Cursor:** [`.cursor/skills/orchestration-manager/SKILL.md`](.cursor/skills/orchestration-manager/SKILL.md) and [`AGENT_PROMPT_TEMPLATE.md`](.cursor/skills/orchestration-manager/AGENT_PROMPT_TEMPLATE.md) use hierarchical `plans/<Phase>/<Stage>/<sub-plan>/` and PR protocol consistent with `AGENTS.md`.

### 2026-05-04 — `GEMINI.md` aligned with ecosystem layout and governance

- **Rewrote** root [`GEMINI.md`](GEMINI.md): parent vs submodules, `governance/` + `strategy/` + hierarchical `plans/`, canonical **`governance/plans/plan_template.md`**, API `finance/` layout, flagship web, Docker/proxy `:8443` and `scripts/` pointers, CPPRD/PR rules, archived Reflex, and archived root Python scratches path.

### 2026-05-04 — Archive repo-root one-off Python scripts

- **Moved** nine ad-hoc `*.py` files from the parent repo root into [`scripts/archived/root_one_off_python/`](scripts/archived/root_one_off_python/) with an index [`README.md`](scripts/archived/root_one_off_python/README.md). They were Reflex-era / local-smoke scratches (hardcoded paths, not CI); real tests live in `finance_manager_api/` and `finance_manager_web/`.

### 2026-05-04 — Strategic roadmap: `strategy/strategic-roadmap-reframe-53be/`

- **`plans/cursor/strategic-roadmap-reframe-53be/` → `strategy/strategic-roadmap-reframe-53be/`:** Canonical multi-year roadmap tree moved to repo-root **`strategy/`** (sibling to `plans/`). Added [`strategy/README.md`](strategy/README.md) as the entry router.
- **Pointers:** `AGENTS.md`, `governance/*`, `README.md`, `.cursor/` skills/rules, `plans/S1/S1.B/**`, `design_docs/**`, `scripts/local/schedule_agent_sync.sh`, archives, and plan YAML `strategic_link` fields updated; relative markdown links recomputed per file depth.

### 2026-05-04 — Active S1.B plans: `plans/S1/S1.B/` + `cursor-layout-era` archive

- **`plans/cursor/s1b/` → `plans/S1/S1.B/`:** All active Stage S1.B implementation sub-plans, research, feature drafts, and backlog markdown (`FEATURE_IDEAS.md`, `PRODUCT_FEATURE_BACKLOG_INDEX.md`) now live under phase/stage paths. Cross-links, `AGENTS.md`, `governance/*`, strategic README §8, and `.cursor/skills/roadmap-rollout-planning/SKILL.md` updated.
- **`plans/archived/cursor-layout-era/`:** Closed pre-governance umbrellas formerly under `plans/cursor/` (api-reflex beta readiness, web beta rollout, server blue-green install, VPS ops, security hardening, vps-reflex recovery) moved here; index `README.md` explains scope.
- **Submodules / web:** `design_docs` path text updates; `finance_manager_web` comment pointer in `QuickActions.tsx`.

### 2026-05-04 — Governance protocols moved to repo-root `governance/`

- **`plans/_governance/` → `governance/`:** Plan ops manuals (registry, lifecycle, deploy, branching, glossary, HitM schedule docs) now live at the workspace root, sibling to `plans/`. Tactical execution plans use hierarchical `plans/<Phase>/<Stage>/<sub-plan>/` (see later 2026-05-04 S1.B lift in this changelog).
- **Pointers:** `AGENTS.md`, parent `README.md`, `.gitignore` (schedule snapshot path), `scripts/local/schedule_agent_sync.sh`, `.cursor/` skills/rules, `design_docs/` vault links, and plan/strategic markdown cross-references updated to the new layout.

### 2026-05-21 — Parent CPPRD: submodule pins, PWA pause registry, plans + brand pack

- **Submodules:** `finance_manager_api` → **`main`** (merge **`cb02b24`** — PWA D2 idempotency allowlist for categories/tags/sources). `finance_manager_web` → **`main`** (merge **`e3dc6e1`** — offline outbox lookup allowlist + Workbox navigate fix PR #45).
- **PWA implementation sprint:** `plans/S1/S1.B/pwa-implementation-branch/runtime_handoff.md` — paused snapshot + **Open issues (paused)** (online transaction network error; offline shell error unchanged post-#45). `validation_gates.md` touch-up. `governance/plans/plan_registry.md` — sprint row moved to **Paused** (deduped from Draft).
- **Plans / research:** `plans/S1/S1.B/entity-formation-research/ACTION_SEQUENCE.md` (new). `plans/feat/web-reflex-parity-sweep-1/` (parity sweep plan tree). Ongoing edits: `FEATURE_IDEAS.md`, `PRODUCT_FEATURE_BACKLOG_INDEX.md`, `SEO_PRIORITY_MATRIX.md`, `feat-f007-guided-walkthroughs/README.md`.
- **Brand assets:** `resources/hfm_icon_web/` (F-011 README–referenced HitM icon pack; PNG set for wedge / manifest work).
- **`AGENTS.md`:** workspace memory / alignment updates.
- **Branch:** merged **`origin/main`** into `cursor/s1b/feat/s1b-feature-plans-registry` so parent history includes latest ecosystem `main`.

### 2026-05-06 — `fm_server_beta.sh rebuild-color` (Podman blue/green)

- **`scripts/ops/fm_server_beta.sh`:** New **`rebuild-color [--no-build] <blue|green>`** command: builds `api-*`/`web-*` for one color, stops **proxy** plus that color’s app containers, removes those containers via compose **labels** (no `podman-compose rm`, which does not exist), then `up -d` db/redis/api/web/proxy. Avoids Podman **`--requires`** / `depends_on` failures when replacing inactive backends. Parallel compose file keeps `up -d --force-recreate` only (no proxy). **`wait_api_service_ready`** polls `/api/health/` so immediate `smoke` after `rebuild-color` does not race Django startup.
- **`deploy/BLUEGREEN_SWITCHOVER.md`**, **`deploy/SERVER_BETA_INSTALL.md`**, **`governance/deployment/deployment_protocol.md`:** Runbook updated to prefer `rebuild-color` after on-host image changes.

### 2026-05-05 — KNOWN_ISSUES: P0 #8 source balance after transaction delete

- **`plans/archived/post_beta_huddle_2026-04-30/KNOWN_ISSUES.md`:** Issue **#8** (S1) — source balance recalculation broken when transactions are deleted; summary table updated.

### 2026-05-05 — Gemini research CPPRD batch (PSP locks, distribution SEO, entity counsel prep)

- **`plans/S1/S1.B/payment-provider-research/`:** HitM-confirmed **PM1–PM4** (PayMongo primary, Xendit secondary, Maya auto-debit + GCash manual invoice, **~2.0%** blended wallet MDR); `DECISION_MATRIX` Matrices 1–3 filled; `PSP_COMPARISON_MATRIX`, `PAYMENT_ARCHITECTURE_SPLIT`, `README` §0.6/§1/§5 gates; new **`PSP_RESEARCH_NOTES_2026_05.md`** (rationale). Governance note: re-verify on PSP sites before production.
- **`strategy/strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md`:** §2 bullets — PSP MDR **~2.0%** (PM4); §4.1 modeling note vs **~0.85** shortcut.
- **`plans/S1/S1.B/distribution-channel-research/`:** `README` deliverables expanded; **`DECISION_MATRIX.md`**, **`DISTRIBUTION_RESEARCH_NOTES.md`**, **`SEO_GUIDE_01–03`**, **`SEO_PRIORITY_MATRIX.md`** (Gemini-assisted SEO / channel research).
- **`plans/S1/S1.B/entity-formation-research/`:** `RESEARCH_ARTIFACTS` index; **`DTI_VS_OPC_COMPARISON.md`**, **`PH_COUNSEL_QUESTIONNAIRE.md`**, **`TAX_ADVISOR_QUESTIONNAIRE.md`**.

### 2026-05-05 — Wedge consistency audit execution pack

- **`plans/S1/S1.B/wedge-consistency-audit/README.md`:** canonical wedge quote, sequencing vs PWA/W3, **`i18n.ts`** surface map (`en-US` + `tl-PH`), method + deliverables + gates.
- **`plans/S1/S1.B/wedge-consistency-audit/AUDIT_REPORT.md`:** findings table template + P0/P1 + signoff.
- **`plans/S1/S1.B/wedge-consistency-audit/RESEARCH_ARTIFACTS.md`:** artifact index.
- **`plans/S1/S1.B/README.md`**, **`GEMINI_RESEARCH_README.md`:** stage table + Gemini handoff for wedge audit.

### 2026-05-05 — Payment provider `DECISION_MATRIX.md` (PM locks)

- **`plans/S1/S1.B/payment-provider-research/DECISION_MATRIX.md`:** Matrix 1–3 (PSP path, capabilities, settlement economics) + **PM1–PM5** HitM signoff slots (distinct from entity **L** locks).
- **`plans/S1/S1.B/payment-provider-research/README.md`:** **§0.65** hub link; deliverables + §3 pointers; `updated` metadata.
- **`PSP_COMPARISON_MATRIX.md`**, **`PAYMENT_ARCHITECTURE_SPLIT.md`**, **`plans/S1/S1.B/README.md`**, **`GEMINI_RESEARCH_README.md`:** cross-links.

### 2026-05-04 — Entity formation execution posture + US LLC pathways workbook

- **`plans/S1/S1.B/entity-formation-research/README.md`:** **§0.4** — counsel-heavy tail continues; **not** a PWA implementation blocker; **PSP go-live** still gated; hub table + **§7** payment/PWA nuance.
- **`plans/S1/S1.B/entity-formation-research/US_LLC_REGISTRATION_AND_TAX_PATHWAYS.md`:** pathway **decision matrix** (P1–P9), Gemini protocol, dated research log, handoff checklist.
- **`plans/S1/S1.B/entity-formation-research/RESEARCH_ARTIFACTS.md`**, **`plans/S1/S1.B/README.md`:** index + stage table pointers.

### 2026-05-03 — S1.B operating entity pipeline lock + Gemini research protocol

- **`plans/S1/S1.B/entity-formation-research/`:** README **§0.2** (spouse-led PH MoR + HitM US LLC vendor, US-later + future regional split); **§0.3** payment coupling; objectives/scope; `DECISION_MATRIX` HitM locks **L2–L4** (2026-05-03) with L1 still time-gated; `RESEARCH_ARTIFACTS` touch; `HITM_LOCAL_CONTEXT` open question 4 aligned to pipeline + payment §0.6.
- **`strategy/strategic-roadmap-reframe-53be/01_unit_economics_and_costs.md`:** **§5.0** operating entity pipeline mirror; **§5.1** advisory note that §5.0 supersedes generic FEIE-trigger list for initial wedge; **§5.3** points at §5.0 for settlement dual-entity.
- **`plans/S1/S1.B/payment-provider-research/`:** README objective + **§0.6** (L2–L4 locked, PH spouse-led primary column, next dependency tax deep dive); §3 source line + §4 deliverables pipeline-aligned; `PSP_COMPARISON_MATRIX` + `PAYMENT_ARCHITECTURE_SPLIT` aligned to 2026-05-03 pipeline.
- **`plans/S1/S1.B/README.md`:** pointer to **`GEMINI_RESEARCH_README.md`** for external research tools.
- **`plans/S1/S1.B/GEMINI_RESEARCH_README.md`:** first-read protocol for Gemini/Antigravity (folder bounds, HitM-only locks, sources, CPPRD, no secrets).

### 2026-05-03 — PWA implementation + SEO orchestration plan (S1.B)

- **`plans/S1/S1.B/pwa-implementation-branch/`:** Execution-ready plan **`PLAN_CROSS_PWA_IMPLEMENTATION_SPRINT_2026-05-03`** — `README.md` (YAML + phase compass), `validation_gates.md` (BP0–BP_SEO_P1, **SEO P1** gated on **BP_SPRINT_CLOSE**), `runtime_handoff.md`, `CROSS_AGENT_COORDINATION.md`, `governance_validator_run_2026-05-03.md`, tasks **T00–T16** (API D2, web build/manifest/SW, IndexedDB seed, outbox, D3 auth, D4-exec, docs CPPRD, **SEO P0** parallel / **SEO P1** deferred). Host branch: `cursor/s1b/pwa-implementation-branch`. Plan stays **`draft`** until `PLAN_RESEARCH_PWA_INSTALL_OFFLINE_SYNC_2026-05-01` is **`completed`** in registry.
- **`governance/plans/plan_registry.md`:** Draft row for the implementation sprint plan.
- **`plans/S1/S1.B/README.md`:** Sub-plan index row + sprint activation index link to `pwa-implementation-branch/README.md`.

### 2026-05-02 — S1.B entity/payment research governance + continual-learning memory

- **`plans/S1/S1.B/entity-formation-research/`:** Gemini-sourced drafts reconciled to plan governance (no premature `LOCKED` without HitM signoff); `DECISION_MATRIX`, `US_ENTITY_PH_OPERATIONS`, `PH_SPOUSE_LED_AND_TRANSFER`, `REGISTRATION_BREAKPOINTS`, `HITM_LOCAL_CONTEXT`, `SPOUSE_INVOLVEMENT_REQUIREMENTS.md`, `RESEARCH_ARTIFACTS`, plan `README` **draft** status restored; FIA / minimum-capital framed as activity-specific counsel verification.
- **`plans/S1/S1.B/payment-provider-research/`:** `README` §0.6 restored to **L1 time-gated** scenario coupling; Stripe back in scope; `PSP_COMPARISON_MATRIX.md` + `PAYMENT_ARCHITECTURE_SPLIT.md` as labeled research drafts with verify-on-provider disclaimers.
- **`strategy/strategic-roadmap-reframe-53be/`:** Reverted unintended Gemini edits to `01_unit_economics_and_costs.md`, `PARKING_LOT.md` P-2, and phase files (locks belong in entity plan after HitM signoff, not in strategic locks from chat).
- **`.gitignore` / `README.md`:** `.cursorignore` is **local-only** again (not tracked); Antigravity/agent ignore patterns live in the untracked file for per-machine Cursor index hygiene.
- **`AGENTS.md`:** Continual-learning memory — normalize parallel-assistant tagged research before CPPRD; add overlapping agent trees to `.cursorignore`.

### 2026-05-01 — Submodule pins: track `design_docs` + `finance_manager_web` `main` merge commits

- **`design_docs` submodule:** **`15045e1`** (`main`, includes design-docs PR [#16](https://github.com/AzazelAzure/finance-manager-design-docs/pull/16) squash merge onto `main`; supersedes ecosystem pin **`94b2fbf`**).
- **`finance_manager_web` submodule:** **`a5d5f80`** (`main`, merge of web PR [#34](https://github.com/AzazelAzure/finance-manager-web/pull/34); supersedes pin **`39398ae`**).

Keeps the parent checkout aligned with each child’s canonical `main` after GitHub merge, so future submodule updates are a simple fast-forward.

### 2026-05-01 — S1.B CPPRD batch: PWA plans, strategic/governance research, vault + web submodule pins

- **`plans/S1/S1.B/pwa-install-offline-sync-research/`:** New sub-plan (README §1.1–§1.7, §6 bar, D0/D2/D3/D4 specs, `SEEDING_OFFLINE_WINDOW_AND_ATOMICITY.md`, `API_VERSION_AND_CLIENT_WINDOW.md`, `RESEARCH_ARTIFACTS.md`, smoke/ADR).
- **`plans/S1/S1.B/README.md`:** **Sprint activation index — PWA** (`#pwa-sprint-activation-index`), sub-plan table pointers, exit summary tied to D4-exec.
- **`strategy/strategic-roadmap-reframe-53be/`:** `validation_gates.md`, `phases/S1_public_beta_position.md`, `README.md` — PWA exit language, W2/W6 handoffs, Advanced tier reference; plus **`00_strategic_context.md`**, **`01_unit_economics_and_costs.md`**, **`PARKING_LOT.md`** updates from parallel research threads.
- **`governance/`:** `plan_registry.md` (PWA plan row); **`README.md`**, **`deployment_protocol.md`**, **`execution_protocols.md`**, **`plan_lifecycle.md`** — governance/lifecycle alignment.
- **`plans/S1/S1.B/ai-economics-deep-dive/`:** `README.md` plus new artifacts `AI_METERING_MODELS_AND_PRO_PRICE_BENCHMARKS.md`, `CREDIT_FLOOR_SUBSCRIPTION_AND_FOUNDER_MATH.md`, `FOUNDER_AND_MRR_PATH_FORECAST_PHP.md`, `LLM_PROVIDER_COST_SNAPSHOT.md`, `PAYG_VOLUME_BUNDLES_RESEARCH.md`.
- **`plans/S1/S1.B/drift-cleanup/README.md`**, **`plans/S1/S1.B/payment-provider-research/README.md`:** README touch-ups (other threads).
- **`AGENTS.md`:** PWA §1.7 seeding file + sprint activation path.
- **`.cursor/settings.json`:** Workspace/editor settings updates.
- **`design_docs` submodule:** Pinned to **`94b2fbf`** (design-docs PR [#16](https://github.com/AzazelAzure/finance-manager-design-docs/pull/16)) — Web PWA bridge doc (`12_Web_PWA_Install_Offline_Sync.md`), Android cross-ref, **`01_Business_Vision.md`** + **`Beta_Launch_Cutline`** touch-ups, vault `CHANGELOG`.
- **`finance_manager_web` submodule:** Pinned to **`39398ae`** (web PR [#34](https://github.com/AzazelAzure/finance-manager-web/pull/34)) — `CHANGELOG.md` touch-ups.

### 2026-05-01 — Strategic PH pricing lock + PAYG bundle research

- **`strategy/strategic-roadmap-reframe-53be/`:** `01_unit_economics_and_costs.md` **§2.0** locks **Pro ₱249/mo**, **Pro+ ₱349/mo**, **PAYG floor ₱99→100 credits**, **≤100 founding seats** (₱999–₱1,499); PAYG **volume bundles** explicitly **research** (`PAYG_VOLUME_BUNDLES_RESEARCH.md`). `00_strategic_context.md` §3.5 / §3.11, `validation_gates.md` indexing note, `phases/S1_public_beta_position.md` Appendix A snapshot + Q4–Q6 updates.
- **`plans/S1/S1.B/ai-economics-deep-dive/`:** `PAYG_VOLUME_BUNDLES_RESEARCH.md`; `AI_METERING_MODELS_AND_PRO_PRICE_BENCHMARKS.md` **§8.5**; README link; `FOUNDER_AND_MRR_PATH_FORECAST_PHP.md` assumes **§2.0** locks.
- **`design_docs` submodule:** `01_Business_Vision.md` tier table aligned to **₱249** Pro list and **100**-seat founding cap (commit in design_docs repo when batching vault changes).

### 2026-05-01 — S1.B plan hygiene: drift-cleanup complete, AI economics shelved

- **`plans/S1/S1.B/drift-cleanup/README.md`:** `status: completed`; completion note (HitM-confirmed W1; evidence pointers).
- **`plans/S1/S1.B/ai-economics-deep-dive/README.md`:** `status: shelved`; `depends_on` entity + payment plans; status section explains resume trigger.
- **`plans/S1/S1.B/README.md`:** sub-plan table — drift-cleanup **completed**, ai-economics-deep-dive **shelved** with deps; Group C sequencing + personal constraint line updated.
- **`strategy/strategic-roadmap-reframe-53be/phases/S1_public_beta_position.md`:** W2 AI Economics bullet + S1.B exit line note **shelved** until entity + payment research (exit still requires Appendix A closure).

### 2026-05-01 — Canonical web stack: docs, Cursor rules, scripts

- **Docs:** `docs/agent-delegation-pilot.md`, `docs/SPDX_COMPLIANCE.md`, `docs/DEPENDENCY_LOCKFILES.md` — flagship **`finance_manager_web`**; Reflex framed as archived.
- **PR template:** `.github/pull_request_template.md` — target repos and changelog line use **Web** instead of Reflex.
- **Scripts:** `scripts/repos.txt`, `scripts/README.md`, `scripts/check_spdx.py` — include **web** (and Android) in multi-repo helpers; SPDX checker docstring notes **web** policy (web not bulk-scanned until headers are consistent).
- **Cursor:** `.cursor/rules/git-repo-workflow.mdc`, `agent-delegation.mdc`, `reflex-frontend.mdc`; `.cursor/skills/multi-repo-orchestration/SKILL.md`, `design-docs-sync/SKILL.md`, `.cursor/skills/README.md` — align with canonical **API + web + CLI** and archived Reflex.
- **Submodules:** `design_docs` pinned to **`8c4dc65`** (`main`, includes design-docs PR [#15](https://github.com/AzazelAzure/finance-manager-design-docs/pull/15) beta cutline + runtime sheet).

### 2026-05-01 — Plans archive, governance hygiene, design_docs CPPRD (ecosystem)

- **Plans:** Moved legacy top-level `plans/feat/`, `plans/fix/`, `plans/volatile/`, and `plans/volatile_standby/` under `plans/archived/`; refreshed cross-references; corrected post-beta huddle and PH Android archive paths; `governance/README.md`, `plan_registry.md`, and `glossary.md` updated for hierarchical layout and archive index row; strategic plan README stage line and `00_strategic_context.md` broken-path fix.
- **Cursor skills:** `huddle-facilitation` and `roadmap-rollout-planning` aligned with `plans/<Phase>/<Stage>/<sub-plan>/` and archived volatile conventions.
- **Submodules:** `design_docs` pinned to `7c9a57e` on branch `cursor/strategic-doc-sync-2026-05-01` (vault strategic alignment, `design_docs/CHANGELOG.md`, **resolved** strategic-doc conflict set: PH-first `07_Server_Runtime_and_Scaling.md` §2, web-first golden rule / phase triggers, `20_Roadmap/_historical/` for calendar + orchestration_manager packs).

### 2026-05-01 — Plans, deploy runbook, submodule sync

- **Plans:** S1.B drift-cleanup and strategic roadmap README/context updates; T04/T06 task note refresh; governance branching doc table and list formatting.
- **Deploy:** `deploy/BLUEGREEN_SWITCHOVER.md` — Podman `depends_on` / proxy ordering when recycling inactive `api-*` / `web-*` after image rebuilds; API `--no-cache` rebuild caveat.
- **Submodules:** Pinned `finance_manager_api`, `finance_manager_web`, and `finance_manager_reflex` to current `origin/main` after merged beta work (email uniqueness, web onboarding, Reflex archival record). `design_docs` bumped to `main` including design-docs PR [#12](https://github.com/AzazelAzure/finance-manager-design-docs/pull/12) (runtime validation, deployment strategy, triage cross-refs).
