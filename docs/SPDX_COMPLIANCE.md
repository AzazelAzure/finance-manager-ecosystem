# SPDX and License Compliance Guide

This workspace uses **AGPL-3.0-or-later** for all product repositories:

- **Ecosystem** (monorepo root: scripts, governance, strategy)
- `finance_manager_api`
- `finance_manager_cli`
- `finance_manager_web` (flagship SPA; follow web repo policy for JS/TS header style)
- `finance_manager_android`
- `finance_manager_rust_tools`
- `finance_manager_rust_middleware`
- `finance_manager_reflex` (**archived**; SPDX still applies if you touch legacy paths)

Each repo must have a root `LICENSE` file containing the full AGPL text. Per-file SPDX headers are required for source code; design and strategy markdown may backfill headers over time (repo-level `LICENSE` still applies to those files).

## Why SPDX headers

SPDX headers make license intent machine-readable and easier to audit at scale.

## Standard header to use

Use this exact line at the top of source files where practical:

```text
SPDX-License-Identifier: AGPL-3.0-or-later
```

## Header examples by file type

Python:

```python
# SPDX-License-Identifier: AGPL-3.0-or-later
```

Shell:

```sh
# SPDX-License-Identifier: AGPL-3.0-or-later
```

JavaScript / TypeScript / CSS:

```text
/* SPDX-License-Identifier: AGPL-3.0-or-later */
```

Markdown / text docs:

```text
<!-- SPDX-License-Identifier: AGPL-3.0-or-later -->
```

## Minimum compliance checklist

1. Keep a `LICENSE` file in each repo root.
2. Keep README license section aligned with the selected SPDX identifier.
3. Add SPDX headers to newly created source files.
4. Backfill headers across existing source files over time.
5. Ensure release artifacts include license text.
6. For AGPL network use, provide corresponding source to users as required.

## Repository metadata recommendations

For each repo, add/align:

- `pyproject.toml`:
  - `license = { text = "AGPL-3.0-or-later" }`
- Optional classifier:
  - `License :: OSI Approved :: GNU Affero General Public License v3 or later (AGPLv3+)`

## Local validation script

Run from workspace root:

```bash
python scripts/check_spdx.py
```

The script reports files that are missing SPDX headers in key source/document file types.
