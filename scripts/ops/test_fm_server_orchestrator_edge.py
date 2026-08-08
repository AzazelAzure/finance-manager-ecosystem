"""Contract tests for fm_server_beta orchestrator edge routing integration."""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
FM_SERVER_BETA = ROOT / "scripts/ops/fm_server_beta.sh"


def test_deploy_path_syncs_orchestrator_edge_before_reload() -> None:
    text = FM_SERVER_BETA.read_text(encoding="utf-8")
    assert "sync_orchestrator_edge_routing" in text
    deploy_section = text.split("deploy_cmd()", 1)[1].split("rebuild_color_cmd()", 1)[0]
    assert "sync_orchestrator_edge_routing" in deploy_section
    assert "reload_proxy" in text.split("sync_orchestrator_edge_routing", 1)[1]
    attach_pos = text.find("bash \"$attach\" attach")
    reload_pos = text.find("reload_proxy", text.find("sync_orchestrator_edge_routing"))
    assert attach_pos != -1 and reload_pos != -1
    assert attach_pos < reload_pos


def test_sync_orchestrator_edge_routing_fails_closed() -> None:
    text = FM_SERVER_BETA.read_text(encoding="utf-8")
    assert 'die "Orchestrator edge routing sync failed after proxy deploy"' in text
