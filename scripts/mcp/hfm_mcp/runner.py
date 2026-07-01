"""Execute allowlisted bash scripts under the HFM primary workspace."""

from __future__ import annotations

import os
import re
import subprocess
from pathlib import Path

_SCRIPT_ROOT = Path(__file__).resolve().parents[3]  # hfm_mcp -> mcp -> scripts -> repo root


def repo_root() -> Path:
    if env := os.environ.get("FM_PRIMARY_WORKSPACE"):
        return Path(env).expanduser().resolve()
    conf = Path.home() / ".fm_workspace.conf"
    if conf.is_file():
        for line in conf.read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            m = re.match(r"^export\s+FM_PRIMARY_WORKSPACE=(.+)$", line)
            if not m:
                m = re.match(r"^FM_PRIMARY_WORKSPACE=(.+)$", line)
            if m:
                val = m.group(1).strip().strip('"').strip("'")
                return Path(val).expanduser().resolve()
    return _SCRIPT_ROOT.resolve()


def run_script(rel_path: str, *args: str, timeout: int = 300) -> str:
    """Run a repo script with bash; return combined output and exit code."""
    root = repo_root()
    script = (root / rel_path).resolve()
    try:
        script.relative_to(root)
    except ValueError as exc:
        raise ValueError(f"Script outside repo root: {script}") from exc
    if not script.is_file():
        raise FileNotFoundError(f"Script not found: {script}")

    env = os.environ.copy()
    env.setdefault("FM_PRIMARY_WORKSPACE", str(root))

    proc = subprocess.run(
        ["bash", str(script), *args],
        cwd=root,
        capture_output=True,
        text=True,
        timeout=timeout,
        env=env,
    )
    parts: list[str] = []
    if proc.stdout:
        parts.append(proc.stdout.rstrip())
    if proc.stderr:
        parts.append("--- stderr ---")
        parts.append(proc.stderr.rstrip())
    parts.append(f"--- exit {proc.returncode} ---")
    return "\n".join(parts)
