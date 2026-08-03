"""Contract tests for ecosystem-hosts nginx render script."""

from __future__ import annotations

import os
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
RENDER = ROOT / "scripts/ops/render_ecosystem_hosts.sh"
TEMPLATE = ROOT / "proxy/conf.d/ecosystem-hosts.conf.template"
CANONICAL = ROOT / "proxy/conf.d/ecosystem-hosts.conf"
DEPLOY_ARTIFACT = ROOT / "proxy/conf.d/ecosystem-hosts.deploy.conf"


def test_template_preserves_orch_active_color_maps() -> None:
    text = TEMPLATE.read_text(encoding="utf-8")
    assert "map $orch_active_color $orch_api_loopback" in text
    assert "map $orch_active_color $orch_console_loopback" in text
    assert "@ORCH_PUBLISH_HOST@:8010" in text
    assert "@ORCH_PUBLISH_HOST@:8091" in text
    assert "proxy_pass http://$orch_api_loopback" in text
    assert "proxy_pass http://$orch_console_loopback" in text
    assert "host.containers.internal:8000" not in text
    assert "host.containers.internal:8081" not in text


def test_tracked_canonical_preserves_color_selector_semantics() -> None:
    text = CANONICAL.read_text(encoding="utf-8")
    assert "map $orch_active_color $orch_api_loopback" in text
    assert "green   127.0.0.1:8010" in text
    assert "green   127.0.0.1:8091" in text
    assert "proxy_pass http://$orch_api_loopback" in text
    assert "proxy_pass http://$orch_console_loopback" in text
    assert "host.containers.internal:3000" in text


def test_render_default_output_is_deploy_artifact_not_canonical() -> None:
    env = os.environ.copy()
    env["ORCH_PUBLISH_HOST"] = "10.89.1.1"
    canonical_before = CANONICAL.read_text(encoding="utf-8")
    if DEPLOY_ARTIFACT.exists():
        DEPLOY_ARTIFACT.unlink()
    proc = subprocess.run(
        ["/bin/bash", str(RENDER)],
        cwd=ROOT,
        env=env,
        text=True,
        capture_output=True,
    )
    assert proc.returncode == 0, proc.stderr
    assert DEPLOY_ARTIFACT.is_file()
    assert CANONICAL.read_text(encoding="utf-8") == canonical_before
    DEPLOY_ARTIFACT.unlink(missing_ok=True)


def test_render_ecosystem_hosts_writes_color_maps(tmp_path: Path) -> None:
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
    assert "map $orch_active_color $orch_api_loopback" in rendered
    assert "10.89.1.1:8010" in rendered
    assert "10.89.1.1:8091" in rendered
    assert "proxy_pass http://$orch_api_loopback" in rendered
    assert "host.containers.internal:3000" in rendered
    assert "@ORCH_PUBLISH_HOST@" not in rendered


def test_render_refuses_canonical_output_path() -> None:
    env = os.environ.copy()
    env["ORCH_PUBLISH_HOST"] = "10.89.1.1"
    proc = subprocess.run(
        ["/bin/bash", str(RENDER), str(CANONICAL)],
        cwd=ROOT,
        env=env,
        text=True,
        capture_output=True,
    )
    assert proc.returncode != 0
    assert "refusing to render over tracked canonical" in proc.stderr


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
