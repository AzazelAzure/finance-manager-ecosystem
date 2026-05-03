# Finance Manager Ecosystem

This is the default repository for the Hive financial manager ecosystem. It
tracks the component repositories that make up the system through Git
submodules.

## Channel

Project updates and coordination are shared in Slack channel
`#all-hive-financial-manager`.

## Submodules

| Path | Repository |
| --- | --- |
| `design_docs` | `git@github.com:AzazelAzure/finance-manager-design-docs.git` |
| `finance_manager_api` | `git@github.com:AzazelAzure/finance-manager-api.git` |
| `finance_manager_cli` | `git@github.com:AzazelAzure/finance-manager-cli.git` |
| `finance_manager_web` | `git@github.com:AzazelAzure/finance-manager-web.git` |
| `finance_manager_reflex` | `git@github.com:AzazelAzure/finance-manger-reflex-frontend.git` (**archived** product; submodule retained for history only) |
| `finance_manager_android` | `git@github.com:AzazelAzure/finance-manager-andriod.git` |
| `finance_manager_rust_middleware` | `git@github.com:AzazelAzure/finance-manager-rust-middleware.git` |
| `finance_manager_rust_tools` | `git@github.com:AzazelAzure/finance-manager-rust-tools.git` |

To initialize the component repositories after cloning:

```bash
git submodule update --init --recursive
```

## Parent repository layout (this repo)

- **`docker-compose.yml`** — local stack (Postgres, API, **web** (Vite build), nginx proxy). Blue/green production-style flows use `docker-compose.bluegreen.yml` + `proxy/`. Copy **`.env.example`** to **`.env`** and set secrets locally; **`.env` is gitignored.**
- **`scripts/`** — lifecycle helpers (`fm_docker.sh`, `fm_services.sh`, DB utilities, etc.). Virtualenvs under `scripts/` (e.g. `hive_venv/`) are ignored.
- **`proxy/`** — nginx image and config. **TLS material** under `proxy/certs/*.pem` is ignored; generate or copy certs per machine and keep private keys out of git.
- **`governance/`** — plan ops protocols (registry, lifecycle, deploy, branching, glossary); read `governance/README.md` first when authoring or executing governed work.
- **`plans/`** — tactical execution plans under `plans/cursor/<phase-stage>/<sub-plan>/`; see `.cursor/skills/roadmap-rollout-planning/SKILL.md`.
- **`docs/`** — cross-cutting notes (lockfiles, SPDX, agent pilot).
- **`finance_manager_rust_middleware/`** and **`finance_manager_rust_tools/`** — separate repos (see table above); develop Rust work there and bump submodule SHAs when sharing changes with the ecosystem.
- **`.gitignore`** — excludes `.env`, venvs, local dumps, editor ignore files (`.cursorignore`, `.antigravityignore`), and local certificates.
