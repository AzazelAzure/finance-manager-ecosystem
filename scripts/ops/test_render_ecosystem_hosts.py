"""Contract tests for ecosystem-hosts nginx render script."""

from __future__ import annotations

import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
RENDER = ROOT / "scripts/ops/render_ecosystem_hosts.sh"
TEMPLATE = ROOT / "proxy/conf.d/ecosystem-hosts.conf.template"
CANONICAL = ROOT / "proxy/conf.d/ecosystem-hosts.conf"
DEPLOY_ARTIFACT = ROOT / "proxy/conf.d/ecosystem-hosts.deploy.conf"


def test_template_preserves_orch_active_color_maps() -> None:
    text = TEMPLATE.read_text(encoding="utf-8")
    assert "map $orch_active_color $orch_api_upstream" in text
    assert "map $orch_active_color $orch_console_upstream" in text
    assert "orch-api-green:8000" in text
    assert "orch-console-green:8081" in text
    assert "proxy_pass http://$orch_api_upstream" in text
    assert "ORCH_PUBLISH_HOST" not in text


def test_tracked_canonical_preserves_color_selector_semantics() -> None:
    text = CANONICAL.read_text(encoding="utf-8")
    assert "map $orch_active_color $orch_api_loopback" in text
    assert "green   127.0.0.1:8010" in text
    assert "host.containers.internal:3000" in text


def test_render_writes_dns_upstream_maps(tmp_path: Path) -> None:
    out = tmp_path / "ecosystem-hosts.conf"
    proc = subprocess.run(
        ["/bin/bash", str(RENDER), str(out)],
        cwd=ROOT,
        text=True,
        capture_output=True,
    )
    assert proc.returncode == 0, proc.stderr
    rendered = out.read_text(encoding="utf-8")
    assert "map $orch_active_color $orch_api_upstream" in rendered
    assert "orch-api-green:8000" in rendered
    assert "orch-console-blue:8081" in rendered
    assert "host.containers.internal:3000" in rendered
