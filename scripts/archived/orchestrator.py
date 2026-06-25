#!/usr/bin/env python3
"""
HFM Tiered Agent Orchestrator — agy CLI wrapper

Routes all agent work through the Antigravity CLI (`agy`) so everything
uses Antigravity subscription credits (not the separate Gemini API key).

Three-tier model:
  Executive (Ultra + HitM) → writes task specs (Antigravity IDE)
  Supervisor (this script) → decomposes + dispatches via agy CLI
  Grunt (agy -p subcommands) → single-file changes

Usage:
  python3 scripts/orchestrator.py <task-file> <slice-id> [--timeout MINUTES]

Examples:
  python3 scripts/orchestrator.py plans/S1/S1.B/.../tasks/T01.md SL1
  python3 scripts/orchestrator.py plans/S1/S1.B/.../tasks/T01.md SL1 --timeout 20
"""

import subprocess
import sys
import json
import datetime
import argparse
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
LOG_DIR = REPO_ROOT / "logs" / "dispatch"
LOG_DIR.mkdir(parents=True, exist_ok=True)


def run_agy(prompt: str, timeout_min: int = 10, cwd: str = None) -> dict:
    """
    Run an agy CLI prompt in print mode.

    Returns dict with: stdout, stderr, returncode, duration_s
    """
    cmd = [
        "agy",
        "-p", prompt,
        "--print-timeout", f"{timeout_min}m",
    ]

    work_dir = cwd or str(REPO_ROOT)
    start = datetime.datetime.now()

    result = subprocess.run(
        cmd,
        cwd=work_dir,
        capture_output=True,
        text=True,
        timeout=timeout_min * 60 + 30,  # subprocess timeout slightly longer
    )

    duration = (datetime.datetime.now() - start).total_seconds()

    return {
        "stdout": result.stdout,
        "stderr": result.stderr,
        "returncode": result.returncode,
        "duration_s": duration,
    }


def build_supervisor_prompt(task_file: str, slice_id: str, plan_root: Path) -> str:
    """Build the prompt that turns agy into a supervisor agent."""

    decision_log = plan_root / "DECISION_LOG.md"
    handoff = plan_root / "runtime_handoff.md"

    return f"""\
You are executing a governed task for the HFM Finance Manager project.

# TASK
Execute slice {slice_id} from task spec: {task_file}

# PROTOCOL
1. Read these files IN ORDER before doing anything:
   - governance/glossary.md (terms)
   - {decision_log.relative_to(REPO_ROOT)} (locked decisions)
   - {handoff.relative_to(REPO_ROOT)} (current state)
   - {task_file} (the task spec)

2. After reading, extract from the task spec:
   - End State (what done looks like)
   - Scope Lock (which files to create/modify/avoid)
   - Anti-Patterns (what NOT to do)
   - Acceptance Criteria for slice {slice_id}

3. Execute the slice:
   - Create/modify ONLY the files listed in the Scope Lock
   - Follow the End State description LITERALLY
   - Respect every Anti-Pattern

4. Verify:
   - Run each verification command from the acceptance criteria
   - Report pass/fail for each

5. After completion:
   - Update {handoff.relative_to(REPO_ROOT)}: set slice {slice_id} status to pass or fail
   - Commit changes: git add + git commit (do NOT push)
   - Report: files changed, verification results, any issues found

# RULES
- Follow the task spec LITERALLY. Do not improvise.
- Only modify files listed in Scope Lock.
- If scope is insufficient, STOP and report the gap. Do NOT guess.
- Do NOT push to remote. Commit locally only.
- Do NOT modify governance/ files.
"""


def dispatch(task_file: str, slice_id: str, timeout_min: int):
    """Run the supervisor dispatch."""
    task_path = REPO_ROOT / task_file
    if not task_path.exists():
        print(f"ERROR: Task file not found: {task_path}")
        sys.exit(1)

    plan_root = task_path.parent.parent
    decision_log = plan_root / "DECISION_LOG.md"
    handoff = plan_root / "runtime_handoff.md"

    # Pre-flight
    print(f"═══ HFM ORCHESTRATOR (agy CLI) ═══")
    print(f"Task:    {task_file}")
    print(f"Slice:   {slice_id}")
    print(f"Plan:    {plan_root.relative_to(REPO_ROOT)}")
    print(f"Timeout: {timeout_min}m")

    for label, f in [("DECISION_LOG", decision_log), ("runtime_handoff", handoff)]:
        status = "✅" if f.exists() else "⚠️  MISSING"
        print(f"  {label}: {status}")

    print(f"══════════════════════════════════\n")

    prompt = build_supervisor_prompt(task_file, slice_id, plan_root)

    print(f"Dispatching to agy (timeout {timeout_min}m)...\n")
    result = run_agy(prompt, timeout_min=timeout_min)

    ts = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")

    # Write dispatch log
    log_file = LOG_DIR / f"dispatch_{ts}_{slice_id}.md"
    log_file.write_text(
        f"# Dispatch Log — {slice_id}\n\n"
        f"**Task:** {task_file}\n"
        f"**Time:** {datetime.datetime.now().isoformat()}\n"
        f"**Duration:** {result['duration_s']:.1f}s\n"
        f"**Exit code:** {result['returncode']}\n\n"
        f"## Prompt\n\n```\n{prompt}\n```\n\n"
        f"## Output\n\n{result['stdout']}\n\n"
        f"## Errors\n\n{result['stderr']}\n"
    )

    # Write metadata
    meta_file = LOG_DIR / f"meta_{ts}_{slice_id}.json"
    meta_file.write_text(json.dumps({
        "ts": datetime.datetime.now().isoformat(),
        "task": task_file,
        "slice": slice_id,
        "duration_s": result["duration_s"],
        "exit_code": result["returncode"],
        "log_file": str(log_file.relative_to(REPO_ROOT)),
    }, indent=2))

    # Report
    print(f"\n═══ DISPATCH COMPLETE ═══")
    print(f"Slice:    {slice_id}")
    print(f"Exit:     {result['returncode']}")
    print(f"Duration: {result['duration_s']:.1f}s")
    print(f"Log:      {log_file.relative_to(REPO_ROOT)}")

    if result["returncode"] != 0:
        print(f"\n⚠️  Non-zero exit. Check stderr:")
        print(result["stderr"][:500])

    if result["stdout"]:
        print(f"\n--- Output (last 1000 chars) ---")
        print(result["stdout"][-1000:])

    print(f"═════════════════════════════════")


def main():
    parser = argparse.ArgumentParser(
        description="HFM Tiered Agent Orchestrator — agy CLI wrapper",
        epilog="All execution uses Antigravity subscription credits via agy CLI.",
    )
    parser.add_argument("task_file", help="Task spec path relative to repo root")
    parser.add_argument("slice_id", help="Slice identifier (e.g. SL1)")
    parser.add_argument("--timeout", type=int, default=15,
                        help="Timeout in minutes (default: 15)")

    if len(sys.argv) < 3:
        parser.print_help()
        print(f"\nEnvironment:")
        print(f"  REPO_ROOT: {REPO_ROOT}")
        print(f"  LOG_DIR:   {LOG_DIR}")
        # Check agy is available
        try:
            r = subprocess.run(["agy", "--help"], capture_output=True, timeout=5)
            print(f"  agy CLI:   ✅ found")
        except (FileNotFoundError, subprocess.TimeoutExpired):
            print(f"  agy CLI:   ❌ not found in PATH")
        sys.exit(1)

    args = parser.parse_args()
    dispatch(args.task_file, args.slice_id, args.timeout)


if __name__ == "__main__":
    main()
