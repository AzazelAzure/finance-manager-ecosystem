# Workspace Protocol — Multi-Workspace Checkout, Dispatch, and VPS Authority

**Locked 2026-07-01** — supersedes `agent_workspace_isolation.md` (2026-05-04 layout; stale paths/roles kept for history — see note there). Source decisions: `strategy/meetings/week27/meeting2026-07-01/tp-workspace-setup/decisions.md` (D1–D7), `workspace_checkout_concept.md`, `per_repo_workspace_architecture.md`, `vps_handoff_compare.md`, `orchestration_tools.md`.

This doc describes the **live, running system** — not just the design. Where implementation diverges from the original design docs, the divergence is called out explicitly (see §7).

---

## 1. Filesystem layout

```
~/Hive_Financial_Manager/
├── HFM/       ← admin/primary (HitM + Claude Code). This repo. Not pooled — always reserved.
├── WS1/       ← full ecosystem clone — Cursor sprint executor / orchestrator
├── WS2/       ← full ecosystem clone — Cursor 2 / AGY automation orchestrator
├── WS3/       ← full ecosystem clone — PR reviewer/triage (becomes Gemini executor if retested)
├── WS4/       ← (not yet created) PR reviewer, only if WS3 becomes a Gemini executor
├── WS-API/    ← per-repo worker: finance_manager_api only. Live (Phase 1 pilot).
├── WS-WEB/    ← per-repo worker: finance_manager_web only. Live (Phase 1 pilot).
└── (future)   WS-CLI, WS-RSTLS, WS-RSTMW, WS-ANDRIOD — created when those repos activate (Phase 2/3)
```

Directory names (`WS1`/`WS2`/`WS3`) were kept generic rather than role-named (`sprint`/`automation`/`review`) per D1 — GitHub collaborator identity for these clones is stable and HitM did not want to churn account renames for a naming preference. Roles are **assigned dynamically** via the checkout system (§2), not baked into the directory name.

Every workspace (including `HFM` itself) sources `~/.fm_workspace.conf`-equivalent — actually `<workspace>/.fm_workspace.conf`, project-root-scoped, gitignored — setting:

```bash
export FM_PRIMARY_WORKSPACE="/home/pproctor/Hive_Financial_Manager/HFM"
export FM_THIS_WORKSPACE="WS1"   # or WS2 / WS3 / WS-API / WS-WEB / HFM
```

All `scripts/workspace/*.sh` resolve `$FM_PRIMARY_WORKSPACE` from the environment, falling back to `$HOME/.fm_workspace.conf` if unset. No hardcoded paths.

---

## 2. Workspace roles and the checkout model

Per D1/D2 resolution, workspaces are **generic pooled slots**, not permanently bound to one agent:

| ID | Default role | Branch policy | Push / PR authority |
|---|---|---|---|
| `HFM` | Admin — HitM + Claude Code. **Not pooled.** | `main`, or short-lived `cla/s1b/admin/*` | Governance PRs, submodule-bump PRs, VPS flip authority |
| `WS1` | Cursor sprint executor / API-task orchestrator | `cur/s1b/*` feature branches; never a long-lived stay on `main` | Ecosystem submodule-bump PRs after sub-repo PRs merge |
| `WS2` | Cursor 2 / AGY automation / Web-task orchestrator | `cur/s1b/*` or `agy/s1b/*` | Same as WS1, scoped to its dispatch |
| `WS3` | PR reviewer/triage (default) — becomes Gemini executor if Gemini coding is retested (then WS3→Gemini, WS4→reviewer) | `main` only, pull-only | **Never pushes feature code; never opens PRs.** Reviews and merges/rejects via `ws_review.sh`. |
| `WS-API` | Per-repo worker — `finance_manager_api` execution only | task branch (e.g. `cur/s1b/feat/...`, or `smoke/*` for pilot tasks) | Opens PRs against `finance-manager-api` directly (no ecosystem superproject) |
| `WS-WEB` | Per-repo worker — `finance_manager_web` execution only | same pattern | Opens PRs against `finance-manager-web` directly |

**Key rule (unchanged from draft):** the full-ecosystem clones (WS1–WS4) **orchestrate**; the per-repo workers (`WS-API`, `WS-WEB`, future `WS-*`) **execute**. Only `HFM` (and, after a sub-repo PR merges, WS1/WS2 in an orchestration capacity) opens ecosystem submodule-bump PRs.

### Checkout protocol

1. `ws_status.sh` — confirm the target workspace is `IDLE`.
2. `ws_claim.sh <ws> <agent> <task> <branch>` — register it active. Advisory only: if already claimed, prints a warning naming the current holder/task and exits 1; **does not block**. `--force` always available.
3. Do the work in that workspace, on the claimed branch.
4. `ws_release.sh <ws>` — release when done, or when handing off mid-task.

**Never start work in a workspace you haven't claimed. Always release before your session ends, even if work isn't finished.**

---

## 3. Sign-out sheet (`workspace.lock`)

**Location:** `strategy/workspace/workspace.lock` — admin workspace (`HFM`) only, gitignored (covered by the blanket `strategy/` ignore rule; no separate `.gitignore` entry needed).

**Format** (D3 = Option C, plain lockfile, no YAML tooling required):

```
WORKSPACE_ID:STATUS:AGENT:TASK:BRANCH
vps:STATUS:HOLDER:OPERATION:API_SHA:WEB_SHA:COLOR:CLAIMED_AT
```

Live entries as of this writing: `HFM`, `WS1`, `WS2`, `WS3`, `vps`. (`WS4` is added only if Gemini is activated per D1; `WS-API`/`WS-WEB` are **not** separate lockfile rows — they're claimed indirectly, see §5.)

Concurrency: every write goes through an exclusive `flock` on `<file>.lock` (verified under contention — see §7.1).

Read examples:
```bash
scripts/workspace/ws_status.sh              # full table (workspaces + VPS line)
scripts/workspace/ws_status.sh --vps        # VPS line only
scripts/workspace/ws_status.sh --ws WS1     # single workspace line
```

---

## 4. FIFO task queues

**Location:** `strategy/workspace/<repo>.queue` — gitignored, admin workspace only. Live queues: `api.queue`, `web.queue`.

**Format:** `TASK_ID|PLAN_ID|BRANCH|AGENT|STATUS|ENQUEUED_AT|CLAIMED_AT|RELEASED_AT`, `STATUS ∈ {PENDING, CLAIMED, DONE, FAILED}`.

| Script | Does |
|---|---|
| `queue_push.sh <repo> <task_id> <plan_id> <branch> <agent>` | Append a `PENDING` entry. Rejects duplicate `task_id`. |
| `queue_pop.sh <repo>` | Claim the oldest `PENDING` entry (flock-protected), mark `CLAIMED`, print `TASK_ID\|PLAN_ID\|BRANCH\|AGENT` to stdout. |
| `queue_done.sh <repo> <task_id> [--failed]` | Mark `DONE` or `FAILED`, stamp `RELEASED_AT`. |
| `queue_status.sh [repo...]` | Print one or all queues as a table. No args = all. |

**Planning-session deliverable (per `planning_protocol_changes.md`):** a dispatching planning session closes by having Claude Code write queue entries directly via `queue_push.sh`, not just narrate tasks. Enqueuing **is** the approval — HitM already said "dispatch X" by deciding the task belongs in the session output.

---

## 5. Dispatch pipeline (`ws_dispatch.sh`)

**Not in the original Tier 1 script list in `orchestration_tools.md` — built and validated beyond the original design scope.** This is the actual execution path from queue entry to merged PR.

```
ws_dispatch.sh <repo> [--direct | --dry-run]     # repo ∈ {api, web}
```

Repo → orchestrator workspace → worker directory mapping (hardcoded in the script):

| repo | Claims workspace | Executes in |
|---|---|---|
| `api` | `WS1` | `WS-API` |
| `web` | `WS2` | `WS-WEB` |

Flow: `queue_pop.sh <repo>` → `ws_claim.sh <WS1\|WS2>` → execute (see modes below) → `queue_done.sh` (`DONE` or `--failed`) → `ws_release.sh`.

**Modes:**
- **`cursor` (default):** invokes `cursor agent --print --workspace <worker-dir> --trust --force` with a generated task brief (sync to `main`, create task branch, do the work, commit, push, `gh pr create`, print a `DISPATCH_RESULT: SUCCESS|FAILED` sentinel line). Requires the `cursor` CLI.
- **`--direct`:** in-process fallback — the script itself runs `git fetch/checkout/pull/branch`, writes a `smoke_test/<TASK_ID>.txt` deliverable, commits, pushes, and opens the PR via `gh pr create`. Used for pilot/smoke validation without a live Cursor agent.
- **`--dry-run`:** peeks the next `PENDING` task and prints what would happen; no queue or lockfile mutation.

---

## 6. Review pipeline (`ws_review.sh`)

**Also not in the original Tier 1 list.** Operates on GitHub PR numbers directly — see §7.2 for how this diverges from the `review.queue` design in `planning_protocol_changes.md`.

```
ws_review.sh <repo> <pr_number> --auto
ws_review.sh <repo> <pr_number> --approve
ws_review.sh <repo> <pr_number> --reject "reason"
```

Always claims `WS3` for the duration of the review, releases after.

- **`--approve` / `--reject`:** manual override. Since `gh pr review --approve`/`--request-changes` fail on PRs authored by the same account, both paths use `gh pr comment` + (`--approve` only) `gh pr merge --squash --delete-branch`.
- **`--auto`:** pulls the PR diff via `gh pr diff`. Hard-rejects (comment + leave open) if the diff contains a `FIXME` marker. Otherwise, if `WS3/` exists and the `claude` CLI is available, hands the diff to a Claude sub-agent in `WS3` with a fixed review brief (reject on FIXME/TODO/HACK, incoherent diff vs. title, secrets in diff, or a smoke deliverable not showing `status: PASS`) and acts on its `REVIEW_DECISION: APPROVE | REQUEST_CHANGES` line. If neither `WS3/` nor `claude` is available, falls back to heuristic-only approval (comment + merge) — **no FIXME found is treated as sufficient to merge** in that fallback path.

---

## 7. Known divergences from the original design (read before extending)

### 7.1 Concurrency — verified, not just designed
`ws_claim.sh` and `queue_pop.sh` both take an exclusive `flock` on a sidecar `.lock` file before reading/writing. This was tested under real contention (`CONCUR-001/002/003` in `api.queue`, all correctly `FAILED` against a held claim) — the advisory-claim model (D4) plus `flock` exclusivity holds.

### 7.2 No `review.queue` file exists
`planning_protocol_changes.md` designed a `strategy/workspace/review.queue` that `WS3` would pop from. The implemented `ws_review.sh` instead takes an explicit `<repo> <pr_number>` argument — there is no review queue file, and nothing currently signals `WS3` that a PR is ready. In practice, review has been invoked directly by whoever dispatched the task. **Open gap:** if the queue-driven planning model in §4 is meant to include automatic review hand-off, `queue_push.sh` needs a `review` repo target wired up, or `ws_dispatch.sh` needs to auto-enqueue a review entry on successful dispatch. Not yet built.

### 7.3 Smoke pilot already ran — end-to-end, against real repos
Both `ws_dispatch.sh` and `ws_review.sh` were exercised today (2026-07-01, 04:08–05:27 UTC) with synthetic `SMOKE-*` tasks against the **actual** `finance_manager_api` (PRs #74–#78, all merged) and `finance_manager_web` (PRs #104–#105, merged) repos — not a sandbox. This validates the dispatch→review→merge loop end-to-end, including a real `cursor` CLI invocation (`CURSOR-TEST-001`, PR #78). Two loose ends from that pilot are logged as an anomaly rather than fixed inline here: leftover `smoke_test/*.txt` files committed to both repos' `main`, and a reject-path test (`SMOKE-API-REJECT-001`, PR #77) that shows `MERGED` instead of rejected. See `strategy/anomalies/2026-07-01_tp-workspace-setup_smoke-pilot-artifacts-and-reject-merge.md`. **This pilot activity substantially de-risks the F-006/F-009 pilot** (§9) but the two loose ends should be resolved before real feature dispatch begins.

### 7.4 `WS-API` / `WS-WEB` are not lockfile rows
The sign-out sheet (§3) only tracks `HFM`/`WS1`/`WS2`/`WS3`/`vps`. Per-repo worker occupancy is implicit: `ws_dispatch.sh` claims the *orchestrating* ecosystem workspace (`WS1` for API, `WS2` for web), not the worker directory itself. Two dispatches to the same repo in quick succession are therefore serialized by the `WS1`/`WS2` claim, not by a `WS-API`/`WS-WEB` claim — functionally equivalent today (one worker per repo) but worth revisiting if a repo ever gets more than one worker.

---

## 8. VPS runtime authority

VPS deploy authority is tracked in the `vps:` line of `workspace.lock`, **in addition to** (not instead of) `governance/Runtime_Signup_Sheet.md`. Per `vps_handoff_compare.md`'s D5 resolution, these are complementary:

| Concern | Tool |
|---|---|
| Real-time "who holds VPS authority right now" + in-flight target SHAs | `workspace.lock` `vps:` line |
| Claim/release enforcement | `vps_claim.sh` / `vps_release.sh` |
| Durable session log, smoke results, sublet model, status vocabulary (`loading`/`live`/`sublet`/`shutting_down`/`offline`) | `governance/Runtime_Signup_Sheet.md` (unchanged, keep using) |

```
vps:STATUS:HOLDER:OPERATION:API_SHA:WEB_SHA:COLOR:CLAIMED_AT
```

**Unlike workspace claims, VPS claims are a hard block** (D4 exception) — `vps_claim.sh` fails outright if `HOLDER` is already set; there is no `--force`. Covers: `sprint_verify.sh` runs, `fm_server_beta.sh promote/rollback`, VPS migrations, any SSH session that mutates the active stack. Does **not** cover read-only checks (`vps_state.sh`, `vps_freshness.sh`) — safe to run concurrently with a held claim.

**Sequence:**
1. `ws_status.sh --vps` — confirm `IDLE`.
2. `vps_claim.sh <ws> <operation> [api_sha] [web_sha] [color]`.
3. Perform the operation; also start a session in `Runtime_Signup_Sheet.md` (owner, target SHAs).
4. `vps_release.sh <ws>`.
5. Record the outcome (smoke results, final SHAs) in `Runtime_Signup_Sheet.md` — the durable record.

---

## 9. Submodule pin safety

1. Only orchestrator workspaces (`HFM`, and `WS1`/`WS2` post-merge) open ecosystem submodule-bump PRs — never a per-repo worker.
2. Before opening a submodule-bump PR, the orchestrator must be synced to current `origin/main` of the ecosystem superproject.
3. `WS3` never bumps submodules.
4. Before any PR touching submodule pins: `git submodule status` + `git diff origin/main -- <submodule>` to confirm the drift is intentional.

---

## 10. Status and what's still open

Filesystem move, sign-out sheet, queue stubs, and Tier 1(+dispatch/review) scripts are **live** — this is the current state of the system, not a plan. Still open per the TP sequence (`strategy/meetings/week27/meeting2026-07-01/tp-workspace-setup/README.md`):

- **F-006 / F-009 real pilot — gated (D8, 2026-07-01).** §7.3 covers the smoke-only dry run (real feature tasks still haven't been queued). This step is now explicitly blocked on `tp-scripts-organization/` completing first — see the next bullet. Sequencing reasoning: the pilot should exercise the interface agents will actually use (typed MCP calls), not raw shell that gets replaced immediately after.
- **Local MCP server — implemented (Cursor, pending merge).** `scripts/mcp/` FastMCP stdio server (`hfm-scripts`) wraps Tier 1–2 scripts and workspace queue tools; project config `.cursor/mcp.json`. Unblocks F-006/F-009 real pilot once merged and IDE-reloaded. See `scripts/mcp/README.md`.
- **Review-queue wiring** (§7.2) — unblocked, not gated by D8, but still not built.
- **Tier 2 scripts** (`ws_sync_check.sh`, `ws_pre_pr_check.sh`, `ws_handoff.sh`) — not built.
- **`agent_workspace_isolation.md` cleanup** — that doc still describes the pre-migration `~/agent-workspaces/` layout and old executor names; retained for history, superseded by this doc. Consider archiving it once nothing else links to it.

---

## Cross-references

- Design source: `strategy/meetings/week27/meeting2026-07-01/tp-workspace-setup/` (`decisions.md` incl. D8 sequencing gate, `workspace_protocol_draft.md`, `workspace_checkout_concept.md`, `per_repo_workspace_architecture.md`, `vps_handoff_compare.md`, `orchestration_tools.md`, `planning_protocol_changes.md`)
- Gating dependency: `strategy/meetings/week27/meeting2026-07-01/tp-scripts-organization/notes.md` — script taxonomy/inventory + MCP tool wrap, blocks the real F-006/F-009 pilot per D8
- Scripts: `scripts/workspace/*.sh`
- VPS session log: `governance/Runtime_Signup_Sheet.md`
- Superseded layout doc: `governance/agent_workspace_isolation.md`
- Glossary terms: `governance/glossary.md` §14 (HFM, HitM, three-tool model, Workspace, Sign-out sheet, VPS authority)
- Open anomaly from pilot validation: `strategy/anomalies/2026-07-01_tp-workspace-setup_smoke-pilot-artifacts-and-reject-merge.md`
