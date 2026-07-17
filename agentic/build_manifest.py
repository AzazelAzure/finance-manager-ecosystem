#!/usr/bin/env python3
"""Materialize HFM's tracked agentic capability inventory."""

from __future__ import annotations

import ast
import hashlib
import json
import re
import subprocess
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "agentic/manifest.json"
SERVER = ROOT / "scripts/mcp/hfm_mcp/server.py"


def slug(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", value.lower()).strip("-")


def tracked_files() -> list[str]:
    result = subprocess.run(["git", "ls-files", "--cached", "--others", "--exclude-standard"], cwd=ROOT, check=True, capture_output=True, text=True)
    return sorted(line for line in result.stdout.splitlines() if line)


def verification(source: str, *, valid: bool | None = None, binding: bool | None = None) -> dict:
    return {
        "source_present": (ROOT / source).exists(),
        "package_valid": valid,
        "binding_configured": binding,
        "executable_resolves": None,
        "smoke_pass": None,
        "captured_at": None,
        "method": "tracked-source inspection; live probes remain non-mutating and installation-local",
    }


def tool_calls() -> list[tuple[str, str | None]]:
    tree = ast.parse(SERVER.read_text(encoding="utf-8"))
    found: list[tuple[str, str | None]] = []
    for node in tree.body:
        if not isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
            continue
        is_tool = any(isinstance(d, ast.Call) and isinstance(d.func, ast.Attribute) and d.func.attr == "tool" for d in node.decorator_list)
        if not is_tool:
            continue
        script: str | None = None
        for child in ast.walk(node):
            if isinstance(child, ast.Call) and isinstance(child.func, ast.Name) and child.func.id == "run_script" and child.args and isinstance(child.args[0], ast.Constant) and isinstance(child.args[0].value, str):
                script = child.args[0].value
                break
        found.append((node.name, script))
    return sorted(found)


def mutation_for(name: str) -> str:
    external = {"dependabot_batch", "ws_dispatch", "review_push", "ws_review", "vps_state", "vps_freshness"}
    state = {"ws_claim", "ws_release", "queue_push", "queue_done", "vps_claim", "vps_release"}
    local = {"submodule_sync", "anomaly_new", "changelog_entry", "new_tp", "new_plan", "new_meeting_day"}
    if name in external:
        return "external"
    if name in state:
        return "state"
    if name in local:
        return "local"
    return "none"


def main() -> None:
    files = tracked_files()
    entities: list[dict] = []
    relationships: list[dict] = []
    script_ids: dict[str, str] = {}
    for source in files:
        if not source.startswith("scripts/") or source.startswith(("scripts/mcp/.venv/", "scripts/hive_venv/")):
            continue
        path = ROOT / source
        if path.suffix not in {".py", ".sh"} or not path.is_file():
            continue
        entity_id = f"script.hfm.{slug(source.removeprefix('scripts/').rsplit('.', 1)[0])}"
        script_ids[source] = entity_id
        entities.append({"id": entity_id, "kind": "script", "name": path.name, "owner": "product.hfm", "domain": "hfm", "status": "active", "source": source, "version": None, "content_sha256": hashlib.sha256(path.read_bytes()).hexdigest(), "authority": "hfm-repository-owner", "sensitivity": "internal", "mutation_class": "mixed", "interface": {"language": path.suffix.lstrip(".")}, "notes": "Mutation is conservatively mixed until per-script contract review closes.", "verification": verification(source)})
    for source in files:
        if not (source.startswith(".cursor/skills/") or source.startswith(".claude/skills/")) or not source.endswith("/SKILL.md"):
            continue
        path = ROOT / source
        surface = source.split("/", 2)[0].lstrip(".")
        name = Path(source).parent.name
        entity_id = f"skill.source.hfm.{surface}.{slug(name)}"
        entities.append({"id": entity_id, "kind": "skill_package", "name": name, "owner": "product.hfm", "domain": "hfm", "status": "active", "source": source, "version": None, "content_sha256": hashlib.sha256(path.read_bytes()).hexdigest(), "authority": "hfm-repository-owner", "sensitivity": "internal", "mutation_class": "mixed", "interface": {"surface": surface, "classification": "legacy-source-module"}, "notes": "Legacy source module retained for TBV and later disposition; not a portable canonical package.", "verification": verification(source, valid=True)})
    server_id = "mcp.server.hfm.scripts"
    entities.append({"id": server_id, "kind": "mcp_server", "name": "hfm-scripts", "owner": "product.hfm", "domain": "hfm", "status": "gated", "source": "scripts/mcp/hfm_mcp/server.py", "version": "0.1.0", "content_sha256": hashlib.sha256(SERVER.read_bytes()).hexdigest(), "authority": "hfm-product-adapter", "sensitivity": "internal", "mutation_class": "mixed", "interface": {"transport": "stdio", "tool_count": len(tool_calls())}, "notes": "Bash scripts remain authoritative; consumer migration to Orchestrator is separately gated.", "verification": verification("scripts/mcp/hfm_mcp/server.py")})
    for name, script in tool_calls():
        capability_id = f"capability.hfm.{slug(name)}"
        tool_id = f"mcp.tool.hfm.{slug(name)}"
        mutation = mutation_for(name)
        entities.extend([
            {"id": capability_id, "kind": "capability", "name": name, "owner": "product.hfm", "domain": "hfm", "status": "gated", "source": "scripts/mcp/hfm_mcp/server.py", "version": "0.1.0", "content_sha256": None, "authority": "hfm-product-adapter", "sensitivity": "internal", "mutation_class": mutation, "interface": {"logical_name": name}, "notes": "Current HFM-local capability; generic/adapter/product disposition remains governed by TP-28.", "verification": verification("scripts/mcp/hfm_mcp/server.py")},
            {"id": tool_id, "kind": "mcp_tool", "name": name, "owner": "product.hfm", "domain": "hfm", "status": "gated", "source": "scripts/mcp/hfm_mcp/server.py", "version": "0.1.0", "content_sha256": None, "authority": "hfm-product-adapter", "sensitivity": "internal", "mutation_class": mutation, "interface": {"transport": "stdio"}, "notes": "Typed wrapper; does not transfer authority from the underlying script or protocol.", "verification": verification("scripts/mcp/hfm_mcp/server.py")},
        ])
        relationships.extend([{"from": server_id, "type": "exposes", "to": tool_id}, {"from": tool_id, "type": "wraps", "to": capability_id}])
        if script and script in script_ids:
            relationships.append({"from": capability_id, "type": "implements", "to": script_ids[script]})
    profile_source = "agentic/profiles/skill-gap-detection.json"
    profile = json.loads((ROOT / profile_source).read_text(encoding="utf-8"))
    entities.append({"id": profile["profile_id"], "kind": "skill_profile", "name": "HFM skill-gap profile", "owner": "product.hfm", "domain": "hfm", "status": "active", "source": profile_source, "version": "1", "content_sha256": hashlib.sha256((ROOT / profile_source).read_bytes()).hexdigest(), "authority": "hfm-repository-owner", "sensitivity": "internal", "mutation_class": "none", "interface": {"compatible_versions": profile["compatible_versions"]}, "notes": "Narrows evidence and output; cannot expand base-skill authority.", "verification": verification(profile_source, valid=True)})
    relationships.append({"from": profile["profile_id"], "type": "profiles", "to": profile["skill_id"]})
    bundle_source = "agentic/bundles/hfm.json"
    bundle = json.loads((ROOT / bundle_source).read_text(encoding="utf-8"))
    entities.append({"id": bundle["bundle_id"], "kind": "skill_bundle", "name": "HFM agentic bundle", "owner": "product.hfm", "domain": "hfm", "status": "active", "source": bundle_source, "version": "1", "content_sha256": hashlib.sha256((ROOT / bundle_source).read_bytes()).hexdigest(), "authority": "hfm-repository-owner", "sensitivity": "internal", "mutation_class": "none", "interface": {"base_bundles": bundle["base_bundles"]}, "notes": "References portable bundles and HFM profiles without copying shared skill bodies.", "verification": verification(bundle_source, valid=True)})
    relationships.append({"from": profile["profile_id"], "type": "member_of", "to": bundle["bundle_id"]})
    binding_id = "binding.hfm.mcp.workspace"
    entities.append({"id": binding_id, "kind": "binding", "name": "HFM workspace MCP binding", "owner": "product.hfm", "domain": "hfm", "status": "unknown", "source": ".mcp.json", "version": None, "content_sha256": None, "authority": "installation-local", "sensitivity": "internal", "mutation_class": "none", "interface": {"server": "hfm-scripts"}, "notes": "Tracked configuration presence is distinct from live process health; secrets are not recorded.", "verification": verification(".mcp.json", binding=(ROOT / ".mcp.json").is_file())})
    relationships.append({"from": binding_id, "type": "binds", "to": server_id})
    data = {"schema_version": 1, "repository": {"id": "hfm", "domain": "hfm", "manifest_path": "agentic/manifest.json", "revision": None}, "captured_at": datetime.now(timezone.utc).replace(microsecond=0).isoformat(), "entities": sorted(entities, key=lambda item: item["id"]), "relationships": sorted(relationships, key=lambda item: (item["from"], item["type"], item["to"]))}
    OUT.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
