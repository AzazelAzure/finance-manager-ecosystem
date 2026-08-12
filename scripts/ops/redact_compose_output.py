#!/usr/bin/env python3
"""Redact sensitive KEY=value and URL-credential forms from compose/tool output.

podman-compose echoes fully interpolated `podman … --env KEY=value` lines.
Pipe all compose stdout/stderr through this filter before it reaches a terminal,
log, or agent transcript.

Reads from a file path when given as argv[1] or VPS_REDACT_FILE; otherwise
streams stdin line-by-line (suitable for `logs -f`).
"""

from __future__ import annotations

import os
import re
import sys
from pathlib import Path

# Mask the value of any env var whose NAME looks sensitive, plus inline URL creds.
_SENSITIVE = (
    r"[A-Za-z0-9_]*(?:PASSWORD|PASSWD|SECRET|TOKEN|APIKEY|API_KEY|"
    r"ACCESS_KEY|PRIVATE_KEY|CREDENTIAL|CREDENTIALS|AUTH|_KEY)"
)
_P1 = re.compile(r"(?i)(\b" + _SENSITIVE + r"\b\s*[:=]\s*)(\S+)")
_P2 = re.compile(r"(://[^:/?#@\s]+:)([^@/?#\s]+)(@)")


def redact_line(line: str) -> str:
    line = _P1.sub(lambda m: m.group(1) + "<redacted>", line)
    line = _P2.sub(lambda m: m.group(1) + "<redacted>" + m.group(3), line)
    return line


def main(argv: list[str] | None = None) -> int:
    argv = list(sys.argv[1:] if argv is None else argv)
    path = argv[0] if argv else os.environ.get("VPS_REDACT_FILE") or os.environ.get(
        "FM_REDACT_FILE", ""
    )
    if path:
        text = Path(path).read_text(errors="replace")
        sys.stdout.write("".join(redact_line(line) for line in text.splitlines(keepends=True)))
        return 0
    for line in sys.stdin:
        sys.stdout.write(redact_line(line))
        sys.stdout.flush()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
