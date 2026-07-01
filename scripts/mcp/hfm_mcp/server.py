"""FastMCP server exposing HFM scripts as typed tools."""

from __future__ import annotations

from mcp.server.fastmcp import FastMCP

from hfm_mcp.runner import run_script

mcp = FastMCP(
    "hfm-scripts",
    instructions=(
        "Hive Financial Manager local tooling. Prefer these tools over ad-hoc shell "
        "for session orientation, PR checks, workspace queues, and VPS read-only state. "
        "Scripts remain source of truth under scripts/."
    ),
)


# ── Orientation (read-only) ───────────────────────────────────────────────────


@mcp.tool()
def session_brief() -> str:
    """Session orientation: repo health, plan status, open PRs, submodule drift."""
    return run_script("scripts/dev/session_brief.sh", timeout=120)


@mcp.tool()
def repo_health() -> str:
    """Per-repo branch, HEAD, and dirty status for parent/api/web."""
    return run_script("scripts/dev/repo_health.sh", timeout=60)


@mcp.tool()
def plan_status() -> str:
    """In-progress, blocked, and draft plan counts from plan_registry.md."""
    return run_script("scripts/dev/plan_status.sh", timeout=30)


@mcp.tool()
def open_prs() -> str:
    """Open PRs across parent, api, and web repos."""
    return run_script("scripts/dev/open_prs.sh", timeout=90)


@mcp.tool()
def submodule_status() -> str:
    """Submodule pin drift vs parent-pinned SHAs."""
    return run_script("scripts/dev/submodule_status.sh", timeout=90)


@mcp.tool()
def handover(plan_slug: str) -> str:
    """Generate a Cursor handover prompt for a plan slug or ID."""
    return run_script("scripts/dev/handover.sh", plan_slug, timeout=60)


@mcp.tool()
def workspace_brief() -> str:
    """Workspace sign-out sheet, FIFO queues, and local workspace identity."""
    return run_script("scripts/dev/workspace_brief.sh", timeout=60)


@mcp.tool()
def ws_status(vps_only: bool = False, workspace: str = "") -> str:
    """Read workspace.lock sign-out sheet. Optional: vps_only or single workspace id."""
    args: list[str] = []
    if vps_only:
        args.append("--vps")
    elif workspace:
        args.extend(["--ws", workspace])
    return run_script("scripts/workspace/ws_status.sh", *args, timeout=30)


@mcp.tool()
def queue_status(repos: str = "") -> str:
    """FIFO task queue state. repos: comma-separated (api,web) or empty for all."""
    args = [r.strip() for r in repos.split(",") if r.strip()] if repos else []
    return run_script("scripts/workspace/queue_status.sh", *args, timeout=30)


@mcp.tool()
def plan_lookup(plan_id: str) -> str:
    """Find a plan by id (e.g. F009 or PLAN_CROSS_CI_CD_2026-06-27)."""
    return run_script("scripts/dev/plan_lookup.sh", plan_id, timeout=60)


# ── PR / CI / tests ───────────────────────────────────────────────────────────


@mcp.tool()
def pr_readiness(
    repo: str = "",
    branch: str = "",
    pr_number: int = 0,
) -> str:
    """PR merge-gate snapshot: mergeable, checks, review. repo: parent|api|web."""
    args: list[str] = []
    if repo:
        args.extend(["--repo", repo])
    if branch:
        args.extend(["--branch", branch])
    if pr_number > 0:
        args.extend(["--pr", str(pr_number)])
    return run_script("scripts/dev/pr_readiness.sh", *args, timeout=120)


@mcp.tool()
def ci_status(repo: str = "", branch: str = "") -> str:
    """Latest GitHub Actions runs. repo: parent|api|web."""
    args: list[str] = []
    if repo:
        args.extend(["--repo", repo])
    if branch:
        args.extend(["--branch", branch])
    return run_script("scripts/dev/ci_status.sh", *args, timeout=90)


@mcp.tool()
def test_api(pytest_args: str = "") -> str:
    """Run API pytest. pytest_args: optional path or -k expression (space-separated)."""
    args = pytest_args.split() if pytest_args.strip() else []
    return run_script("scripts/dev/test_api.sh", *args, timeout=600)


@mcp.tool()
def test_web(mode: str = "build") -> str:
    """Run web npm script: build, lint, or test."""
    if mode not in ("build", "lint", "test"):
        return "mode must be build, lint, or test"
    return run_script("scripts/dev/test_web.sh", mode, timeout=600)


@mcp.tool()
def test_rust(locked: bool = False) -> str:
    """Run cargo test in finance_manager_rust_tools."""
    args = ["--locked"] if locked else []
    return run_script("scripts/dev/test_rust.sh", *args, timeout=600)


@mcp.tool()
def submodule_sync(submodule: str = "", dry_run: bool = False) -> str:
    """Fetch and checkout submodules to parent-pinned SHAs (write op)."""
    args: list[str] = []
    if dry_run:
        args.append("--dry-run")
    if submodule.strip():
        args.append(submodule.strip())
    return run_script("scripts/dev/submodule_sync.sh", *args, timeout=180)


@mcp.tool()
def branch_delta(repo: str = "all", base: str = "main") -> str:
    """Ahead/behind vs upstream for parent/api/web. repo: all|parent|api|web."""
    if repo not in ("all", "parent", "api", "web"):
        return "repo must be all, parent, api, or web"
    return run_script(
        "scripts/dev/branch_delta.sh",
        "--repo",
        repo,
        "--base",
        base,
        timeout=120,
    )


@mcp.tool()
def stash_triage() -> str:
    """List git stashes across parent, api, and web."""
    return run_script("scripts/dev/stash_triage.sh", timeout=60)


@mcp.tool()
def dependabot_batch(repo: str = "all") -> str:
    """Open Dependabot PRs for api and/or web. repo: all|api|web."""
    if repo not in ("all", "api", "web"):
        return "repo must be all, api, or web"
    args = ["--repo", repo] if repo != "all" else []
    return run_script("scripts/dev/dependabot_batch.sh", *args, timeout=90)


@mcp.tool()
def celery_ready() -> str:
    """Check local Podman stack for running Celery worker/beat containers."""
    return run_script("scripts/dev/celery_ready.sh", timeout=60)


@mcp.tool()
def env_check() -> str:
    """Verify repo-root .env contains keys from .env.example."""
    return run_script("scripts/dev/env_check.sh", timeout=30)


# ── Runtime / VPS (read-only or local) ────────────────────────────────────────


@mcp.tool()
def local_stack_health() -> str:
    """Local Podman stack status and :8443 probes with correct Host headers."""
    return run_script("scripts/dev/local_stack_health.sh", timeout=90)


@mcp.tool()
def vps_state() -> str:
    """Live VPS container snapshot via SSH (timestamped, read-only)."""
    return run_script("scripts/ops/vps_state.sh", timeout=120)


@mcp.tool()
def vps_freshness() -> str:
    """Compare local API/Web SHAs to VPS deployed SHAs."""
    return run_script("scripts/dev/vps_freshness.sh", timeout=120)


@mcp.tool()
def fm_docker_status() -> str:
    """Local docker-compose stack status (scripts/local-stack/fm_docker.sh status)."""
    return run_script("scripts/local-stack/fm_docker.sh", "status", timeout=60)


# ── Workspace mutations (pilot / orchestration) ───────────────────────────────


@mcp.tool()
def ws_claim(
    workspace: str,
    agent: str,
    task: str,
    branch: str,
    force: bool = False,
) -> str:
    """Claim a workspace in workspace.lock. Writes sign-out sheet."""
    args: list[str] = []
    if force:
        args.append("--force")
    args.extend([workspace, agent, task, branch])
    return run_script("scripts/workspace/ws_claim.sh", *args, timeout=30)


@mcp.tool()
def ws_release(workspace: str) -> str:
    """Release a workspace claim in workspace.lock."""
    return run_script("scripts/workspace/ws_release.sh", workspace, timeout=30)


@mcp.tool()
def queue_push(
    repo: str,
    task_id: str,
    plan_id: str,
    branch: str,
    agent: str,
) -> str:
    """Append a PENDING task to a repo FIFO queue (api or web)."""
    return run_script(
        "scripts/workspace/queue_push.sh",
        repo,
        task_id,
        plan_id,
        branch,
        agent,
        timeout=30,
    )


@mcp.tool()
def queue_done(
    repo: str,
    task_id: str,
    failed: bool = False,
) -> str:
    """Mark a queued task DONE or FAILED (failed=True)."""
    args: list[str] = [repo, task_id]
    if failed:
        args.append("--failed")
    return run_script("scripts/workspace/queue_done.sh", *args, timeout=30)


@mcp.tool()
def ws_dispatch(
    repo: str,
    dry_run: bool = True,
    direct: bool = False,
) -> str:
    """Dispatch next queued task to WS-API or WS-WEB worker. Default dry_run=True."""
    args: list[str] = [repo]
    if dry_run:
        args.append("--dry-run")
    elif direct:
        args.append("--direct")
    return run_script("scripts/workspace/ws_dispatch.sh", *args, timeout=900)


@mcp.tool()
def ws_review(
    repo: str,
    pr_number: int,
    action: str = "auto",
    reason: str = "",
) -> str:
    """Review and optionally merge a PR via WS3. action: auto, approve, or reject."""
    action_map = {
        "auto": "--auto",
        "approve": "--approve",
        "reject": "--reject",
    }
    flag = action_map.get(action)
    if flag is None:
        return "action must be auto, approve, or reject"
    if action == "reject" and not reason.strip():
        return "reason is required when action is reject"
    args: list[str] = [repo, str(pr_number), flag]
    if action == "reject":
        args.append(reason)
    return run_script("scripts/workspace/ws_review.sh", *args, timeout=900)


@mcp.tool()
def vps_claim(
    workspace: str,
    operation: str,
    api_sha: str = "",
    web_sha: str = "",
    color: str = "",
) -> str:
    """Claim VPS deploy authority (hard block if already held)."""
    args = [workspace, operation]
    if api_sha:
        args.append(api_sha)
    if web_sha:
        args.append(web_sha)
    if color:
        args.append(color)
    return run_script("scripts/workspace/vps_claim.sh", *args, timeout=30)


@mcp.tool()
def vps_release(workspace: str) -> str:
    """Release VPS authority in workspace.lock."""
    return run_script("scripts/workspace/vps_release.sh", workspace, timeout=30)


# ── Scaffolding ───────────────────────────────────────────────────────────────


@mcp.tool()
def anomaly_new(plan_slug: str, short_desc: str) -> str:
    """Scaffold strategy/anomalies/ log from template (does not edit anomalous code)."""
    return run_script("scripts/dev/anomaly_new.sh", plan_slug, short_desc, timeout=30)


@mcp.tool()
def changelog_entry(title: str, agent: str, repo: str = "parent") -> str:
    """Insert [Unreleased] CHANGELOG block (CPPRD document step). repo: parent|api|web."""
    if repo not in ("parent", "api", "web"):
        return "repo must be parent, api, or web"
    return run_script(
        "scripts/dev/changelog_entry.sh",
        title,
        agent,
        "--repo",
        repo,
        timeout=30,
    )


@mcp.tool()
def new_tp(slug: str, week: int = 0, date: str = "") -> str:
    """Scaffold strategy/meetings/.../tp-<slug>/ talking-point folder."""
    args: list[str] = [slug]
    if week > 0:
        args.extend(["--week", str(week)])
    if date.strip():
        args.extend(["--date", date.strip()])
    return run_script("scripts/dev/new_tp.sh", *args, timeout=30)


@mcp.tool()
def new_plan(phase: str, stage: str, status: str, slug: str) -> str:
    """Scaffold plans/<Phase>/<Stage>/<status>/<slug>/ per plan_template."""
    return run_script(
        "scripts/dev/new_plan.sh",
        phase,
        stage,
        status,
        slug,
        timeout=30,
    )


@mcp.tool()
def new_meeting_day(week: int = 0, date: str = "") -> str:
    """Scaffold strategy/meetings/week<N>/meeting<date>/ with agenda/ and anomalies/."""
    args: list[str] = []
    if week > 0:
        args.extend(["--week", str(week)])
    if date.strip():
        args.extend(["--date", date.strip()])
    return run_script("scripts/dev/new_meeting_day.sh", *args, timeout=30)


def main() -> None:
    mcp.run(transport="stdio")


if __name__ == "__main__":
    main()
