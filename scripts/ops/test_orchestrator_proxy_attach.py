"""Contract tests for ecosystem-hosts render and proxy network attach scripts."""

from __future__ import annotations

import os
import stat
import subprocess
import textwrap
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
RENDER = ROOT / "scripts/ops/render_ecosystem_hosts.sh"
ATTACH = ROOT / "scripts/ops/attach_orchestrator_proxy_networks.sh"
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
    assert "proxy_pass http://$orch_console_upstream" in text
    assert "host.containers.internal:3000" in text
    assert "ORCH_PUBLISH_HOST" not in text
    assert "127.0.0.1" not in text


def test_tracked_canonical_preserves_local_loopback_dev_maps() -> None:
    text = CANONICAL.read_text(encoding="utf-8")
    assert "map $orch_active_color $orch_api_loopback" in text
    assert "green   127.0.0.1:8010" in text
    assert "host.containers.internal:3000" in text


def test_render_default_output_is_deploy_artifact_not_canonical() -> None:
    canonical_before = CANONICAL.read_text(encoding="utf-8")
    if DEPLOY_ARTIFACT.exists():
        DEPLOY_ARTIFACT.unlink()
    proc = subprocess.run(
        ["/bin/bash", str(RENDER)],
        cwd=ROOT,
        text=True,
        capture_output=True,
    )
    assert proc.returncode == 0, proc.stderr
    assert DEPLOY_ARTIFACT.is_file()
    assert CANONICAL.read_text(encoding="utf-8") == canonical_before
    rendered = DEPLOY_ARTIFACT.read_text(encoding="utf-8")
    assert "orch-api-blue:8000" in rendered
    assert "orch-console-green:8081" in rendered
    DEPLOY_ARTIFACT.unlink(missing_ok=True)


def test_render_refuses_canonical_output_path() -> None:
    proc = subprocess.run(
        ["/bin/bash", str(RENDER), str(CANONICAL)],
        cwd=ROOT,
        text=True,
        capture_output=True,
    )
    assert proc.returncode != 0
    assert "refusing to render over tracked canonical" in proc.stderr


def _write_stub_podman(bin_dir: Path) -> None:
    path = bin_dir / "podman"
    path.write_text(
        textwrap.dedent(
            """
            #!/bin/bash
            set -euo pipefail
            case "$1" in
              ps)
                if [[ "$*" == *"fm-beta_proxy"* ]]; then echo proxy-cid-1; fi
                exit 0
                ;;
              network)
                if [[ "$2" == exists ]]; then
                  [[ "$3" == orchestrator-console-blue || "$3" == orchestrator-console-green ]] && exit 0
                  exit 1
                fi
                if [[ "$2" == connect ]]; then exit 0; fi
                if [[ "$2" == disconnect ]]; then exit 0; fi
                ;;
              inspect)
                if [[ "$3" == *Networks* ]]; then
                  if [[ "$4" == proxy-cid-1 ]]; then
                    echo "fm-beta_default"
                    echo "orchestrator-console-blue"
                  fi
                fi
                exit 0
                ;;
            esac
            exit 0
            """
        ),
        encoding="utf-8",
    )
    path.chmod(path.stat().st_mode | stat.S_IXUSR)


def test_attach_idempotent_when_already_connected(tmp_path: Path) -> None:
    bin_dir = tmp_path / "bin"
    bin_dir.mkdir()
    _write_stub_podman(bin_dir)
    env = os.environ.copy()
    env["PATH"] = f"{bin_dir}:{env.get('PATH', '')}"
    proc = subprocess.run(
        ["/bin/bash", str(ATTACH), "attach"],
        cwd=ROOT,
        env=env,
        text=True,
        capture_output=True,
    )
    assert proc.returncode == 0, proc.stderr
    assert "already attached to orchestrator-console-blue" in proc.stdout


def test_attach_fails_on_missing_network(tmp_path: Path) -> None:
    bin_dir = tmp_path / "bin"
    bin_dir.mkdir()
    stub = bin_dir / "podman"
    stub.write_text(
        textwrap.dedent(
            """
            #!/bin/bash
            set -euo pipefail
            case "$1" in
              ps) echo proxy-cid-1; exit 0 ;;
              network) if [[ "$2" == exists ]]; then exit 1; fi ;;
              inspect) exit 0 ;;
            esac
            exit 0
            """
        ),
        encoding="utf-8",
    )
    stub.chmod(stub.stat().st_mode | stat.S_IXUSR)
    env = os.environ.copy()
    env["PATH"] = f"{bin_dir}:{env.get('PATH', '')}"
    proc = subprocess.run(
        ["/bin/bash", str(ATTACH), "attach"],
        cwd=ROOT,
        env=env,
        text=True,
        capture_output=True,
    )
    assert proc.returncode != 0
    combined = proc.stdout + proc.stderr
    assert "missing presentation network" in combined


def test_attach_fails_on_ambiguous_proxy(tmp_path: Path) -> None:
    bin_dir = tmp_path / "bin"
    bin_dir.mkdir()
    stub = bin_dir / "podman"
    stub.write_text(
        textwrap.dedent(
            """
            #!/bin/bash
            set -euo pipefail
            if [[ "$1" == ps ]]; then echo cid1; echo cid2; exit 0; fi
            exit 0
            """
        ),
        encoding="utf-8",
    )
    stub.chmod(stub.stat().st_mode | stat.S_IXUSR)
    env = os.environ.copy()
    env["PATH"] = f"{bin_dir}:{env.get('PATH', '')}"
    proc = subprocess.run(
        ["/bin/bash", str(ATTACH), "attach"],
        cwd=ROOT,
        env=env,
        text=True,
        capture_output=True,
    )
    assert proc.returncode != 0
    combined = proc.stdout + proc.stderr
    assert "ambiguous proxy container" in combined
