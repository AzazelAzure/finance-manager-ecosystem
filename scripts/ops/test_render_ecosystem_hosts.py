"""Contract tests for ecosystem-hosts nginx render script."""

from __future__ import annotations

import os
import stat
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
RENDER = ROOT / "scripts/ops/render_ecosystem_hosts.sh"
TEMPLATE = ROOT / "proxy/conf.d/ecosystem-hosts.conf.template"


def test_template_has_orch_publish_placeholder() -> None:
    text = TEMPLATE.read_text(encoding="utf-8")
    assert "@ORCH_PUBLISH_HOST@" in text
    assert "host.containers.internal:8000" not in text
    assert "host.containers.internal:8081" not in text


def test_render_ecosystem_hosts_writes_upstream(tmp_path: Path) -> None:
    out = tmp_path / "ecosystem-hosts.conf"
    env = os.environ.copy()
    env["ORCH_PUBLISH_HOST"] = "10.89.1.1"
    proc = subprocess.run(
        ["/bin/bash", str(RENDER), str(out)],
        cwd=ROOT,
        env=env,
        text=True,
        capture_output=True,
    )
    assert proc.returncode == 0, proc.stderr
    rendered = out.read_text(encoding="utf-8")
    assert "server 10.89.1.1:8000;" in rendered
    assert "server 10.89.1.1:8081;" in rendered
    assert "host.containers.internal:3000" in rendered
    assert "@ORCH_PUBLISH_HOST@" not in rendered


def test_render_fails_without_publish_host(tmp_path: Path) -> None:
    out = tmp_path / "ecosystem-hosts.conf"
    env = os.environ.copy()
    env.pop("ORCH_PUBLISH_HOST", None)
    proc = subprocess.run(
        ["/bin/bash", str(RENDER), str(out)],
        cwd=ROOT,
        env=env,
        text=True,
        capture_output=True,
    )
    assert proc.returncode != 0
    assert "ORCH_PUBLISH_HOST" in proc.stderr
