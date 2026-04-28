# SPDX and License Compliance Guide

This workspace currently uses **AGPL-3.0-or-later** for:

- `finance_manager_api`
- `finance_manager_cli`
- `finance_manager_reflex`

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
