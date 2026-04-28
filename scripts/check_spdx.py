#!/usr/bin/env python3
"""Simple SPDX header checker for this workspace.

Checks source/doc files under API/CLI/Reflex repos and reports files
that do not contain the required SPDX identifier.
"""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TARGETS = [
    ROOT / "finance_manager_api",
    ROOT / "finance_manager_cli",
    ROOT / "finance_manager_reflex",
]

EXTS = {
    ".py",
    ".sh",
    ".js",
    ".ts",
    ".tsx",
    ".jsx",
    ".css",
    ".md",
    ".toml",
    ".yml",
    ".yaml",
}

SKIP_DIRS = {
    ".git",
    ".venv",
    "venv",
    "node_modules",
    "dist",
    "build",
    "__pycache__",
    ".pytest_cache",
    ".mypy_cache",
    ".ruff_cache",
    ".reflex",
    ".web",
    ".states",
    "logs",
}

REQUIRED = "SPDX-License-Identifier: AGPL-3.0-or-later"


def should_skip(path: Path) -> bool:
    return any(part in SKIP_DIRS for part in path.parts)


def has_spdx(path: Path) -> bool:
    try:
        text = path.read_text(encoding="utf-8", errors="ignore")
    except OSError:
        return False
    # Fast path first for header-like content.
    head = "\n".join(text.splitlines()[:12])
    if REQUIRED in head:
        return True
    return REQUIRED in text


def main() -> int:
    missing: list[Path] = []
    scanned = 0

    for target in TARGETS:
        if not target.exists():
            continue
        for path in target.rglob("*"):
            if not path.is_file() or should_skip(path):
                continue
            if path.name == "LICENSE":
                continue
            if path.suffix.lower() not in EXTS:
                continue
            scanned += 1
            if not has_spdx(path):
                missing.append(path)

    print(f"Scanned files: {scanned}")
    if not missing:
        print("OK: all scanned files include SPDX identifier.")
        return 0

    print(f"Missing SPDX headers: {len(missing)}")
    for p in missing:
        rel = p.relative_to(ROOT)
        print(f" - {rel}")
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
