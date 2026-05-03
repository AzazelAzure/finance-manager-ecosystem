# Dependency lockfiles: why, what, and how to move there

This document is a **roadmap** for tightening dependency management across API, CLI, **web** (npm/Vite lockfiles), and (later) Rust. `finance_manager_reflex` is **archived**. It complements `notes.txt` (repo split, contracts, releases).

## What lockfiles actually change (security framing)

- **Lockfiles do not replace** secure coding, auth, secrets handling, or network hardening. They are not a “closed door” in that sense.
- **They do reduce** several real risks:
  - **Supply-chain drift**: every `pip install` without a lock can pull different transitive packages day to day, including unexpected upgrades or resolver changes.
  - **Unbounded ranges**: `package>=1.0` in `pyproject.toml` (or loose `requirements.txt`) allows the resolver to float to new versions you never tested.
  - **Auditability**: a committed lock gives a **exact bill of materials** for “what ran in prod” and for scanners (`pip-audit`, `uv pip audit`, GitHub Dependabot, etc.).
- **Hash-pinned installs** (optional, stricter): tools can require that every wheel/sdist matches a known hash so a compromised index cannot silently substitute artifacts (defense in depth, not a silver bullet).

So the goal is **reproducible, reviewable installs**—harder for dependency chaos (and some supply-chain attacks) to slip in unnoticed—not a substitute for application security.

## Current state in this workspace (snapshot)

| Area | Today | Next step toward “real” locks |
|------|--------|--------------------------------|
| `finance_manager_api/` | `pyproject.toml` + `uv.lock` with runtime deps and a `dev` dependency group. | Keep lock refreshed via `uv lock`; use `uv sync --frozen --group dev` in CI. |
| `finance_manager_cli/` | `pyproject.toml` + `uv.lock` are in place. | Continue resolving via `uv lock`; install with `uv sync --frozen`. |
| `finance_manager_web/` | `package-lock.json` (or project lockfile) for the Vite SPA. | Install with `npm ci` (or equivalent) in CI/images; fail if lock drifts. |
| `finance_manager_reflex/` (archived) | Historical `pyproject.toml` + `uv.lock` may remain. | No longer a production delivery surface. |
| `finance_manager_rust_tools/` | `Cargo.toml` + committed **`Cargo.lock`** | CI uses `cargo test --locked` / `cargo clippy --locked`; refresh the lock when direct deps change. |

## Recommended directions (pick one stack per repo, stay consistent)

### Option A — **uv** (modern, fast; good for multi-repo later)

- Declare direct deps in `pyproject.toml` (or `requirements.in`).
- Run `uv lock` → commit **`uv.lock`**.
- CI/prod: `uv sync --frozen` (or equivalent) so installs **fail** if lock is out of date.
- Optional: enable hash modes where supported for release builds.

### Option B — **Poetry**

- `poetry lock` → commit **`poetry.lock`**.
- Deploy with `poetry install --no-dev` (or export to constraints for containers).

### Option C — **pip-tools** (minimal change if you like `requirements.txt`)

- Maintain **`requirements.in`** (high-level, human-edited) with only top-level packages (ranges allowed).
- Run **`pip-compile`** → generates **`requirements.txt`** with **all** transitive pins (optionally `--generate-hashes`).
- Install in CI/prod with `pip install -r requirements.txt` and consider **`pip install --require-hashes`** when hashes are present.

### Rust

- For anything you **ship** (middleware binary, sidecar, CLI): **commit `Cargo.lock`** and build with `--locked` in CI/release so dependency graphs cannot shift silently.

### Web / JS (`finance_manager_web`)

- Commit **`package-lock.json`** (npm), **`pnpm-lock.yaml`**, or **`yarn.lock`**—never rely on unconstrained installs in CI or production images.

## Migration checklist (per Python repo)

1. **Choose one tool** (uv / Poetry / pip-tools) and document it in that repo’s README.
2. **Separate environments**: runtime deps vs dev/test deps (separate lock or optional dependency groups).
3. **Generate lock** from the canonical spec; **commit the lockfile**.
4. **CI**: install with **frozen** semantics (`--frozen`, `--no-dev` as appropriate); fail PRs that change deps without updating the lock.
5. **Containers/releases**: copy only the lock + install command—no `pip install django` ad hoc in Dockerfile without updating the lock.
6. **Automation**: Dependabot / Renovate on the lockfile; optional `pip-audit` or `uv pip audit` on schedule.
7. **When splitting repos** (`notes.txt`): each repo owns its lock; a **workspace/meta repo** can still record **compatible version tuples** (API `v1.2.3` + CLI `v0.4.1`) without merging dependency files.

## Optional hardening (after locks exist)

- **Hash-pinned** requirements from `pip-compile --generate-hashes` (pairs well with `pip install --require-hashes`).
- **Private index** + allowlist for prod (reduces public-index substitution risk; operational cost is higher).
- **Reproducible Docker builds**: pin base image digests **and** Python lockfiles.

## Related

- Repo split, versioning, and contract testing: see **`notes.txt`** sections 2–5.
- When the Rust middleware repo exists, add the same discipline: **`Cargo.lock` + locked CI builds**.
