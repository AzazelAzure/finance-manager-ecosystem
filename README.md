# Hive Finance Manager — Ecosystem

A multi-currency personal finance platform built and operated solo, from schema design
to production deployment. This repository is the ecosystem root: it wires together the
component repositories as Git submodules and holds shared infrastructure, deployment
tooling, and governance.

**Live:** [thehivemanager.com](https://thehivemanager.com) · Beta

---

## What it is

A full-stack SaaS application for tracking payment sources, upcoming expenses,
categories, tags, and transactions across multiple currencies, with a computed
financial snapshot in the user's base currency. Designed as a PWA — installable,
offline-capable, and sync-aware.

---

## Stack

| Layer | Technology |
|---|---|
| API | Django 6 / Django REST Framework, PostgreSQL, Celery + Redis |
| Auth | SimpleJWT + django-allauth, Argon2 hashing, django-axes brute-force protection |
| Schema | drf-spectacular (OpenAPI), layered service / domain / validator architecture |
| Frontend | React 19 + TypeScript, Vite, Tailwind, TanStack Query, Zod, Recharts |
| PWA | Offline-first IndexedDB sync (Dexie), Workbox service workers |
| Infra | Docker Compose, blue/green zero-downtime deployment, nginx reverse proxy, VPS |
| In progress | Rust compute layer (numerics/middleware), Android TWA client |
| Testing | pytest + factory-boy (API), Vitest (web) |

---

## Ecosystem layout

| Submodule | What it is |
|---|---|
| [`finance-manager-api`](https://github.com/AzazelAzure/finance-manager-api) | Django/DRF backend — primary codebase |
| [`finance-manager-web`](https://github.com/AzazelAzure/finance-manager-web) | React 19 + TypeScript PWA — flagship frontend |
| [`finance-manager-cli`](https://github.com/AzazelAzure/finance-manager-cli) | Click-based CLI client |
| [`finance-manager-rust-tools`](https://github.com/AzazelAzure/finance-manager-rust-tools) | Pure Rust numerics: tag spend allocation, projection/burn-rate helpers |
| [`finance-manager-rust-middleware`](https://github.com/AzazelAzure/finance-manager-rust-middleware) | Rust middleware layer (in progress) |
| [`finance-manager-andriod`](https://github.com/AzazelAzure/finance-manager-andriod) | Android TWA client (bootstrap) |
| [`finance-manager-design-docs`](https://github.com/AzazelAzure/finance-manager-design-docs) | Canonical design and feature specification docs |
| [`finance-manger-reflex-frontend`](https://github.com/AzazelAzure/finance-manger-reflex-frontend) | Reflex frontend — archived; superseded by the React PWA |

**Clone with submodules:**

```bash
git clone --recurse-submodules git@github.com:AzazelAzure/finance-manager-ecosystem.git
# or after a plain clone:
git submodule update --init --recursive
```

---

## Repository layout (this repo)

- **`docker-compose.yml`** — local dev stack (Postgres, API, web, nginx). Copy `.env.example` to `.env` and fill secrets; `.env` is gitignored.
- **`docker-compose.bluegreen.yml`** — production-style blue/green stack with inactive-color isolation.
- **`proxy/`** — nginx image and config for blue/green routing. TLS material (`proxy/certs/*.pem`) is gitignored; generate per machine.
- **`deploy/`** — deployment runbooks: blue/green switchover, bundle push, server setup, deployment vector decision guide.
- **`scripts/`** — lifecycle helpers: Docker management, DB utilities, release tagging, VPS state checks, security audit tooling.
- **`governance/`** — development protocols: plan lifecycle, branching guidelines, deployment protocol, agent workspace rules.
- **`docs/`** — cross-cutting notes: dependency lockfile policy, SPDX compliance, agent delegation metrics.
- **`.cursor/rules/`** and **`.cursor/skills/`** — agent delegation rules and reusable skill definitions for the multi-agent development system (see below).

---

## How it's built

This project is developed by a single operator using a structured multi-agent system.
Three AI coding agents — Cursor (sprint execution), Claude Code (governance and PR ops),
and Antigravity (status and automation) — work against the same codebase under defined
role separation, with the human as architect and decision-maker throughout.

The coordination layer lives in `AGENTS.md`, `.cursor/rules/`, `.cursor/skills/`, and
`governance/`. Branch discipline, PR flows, and planning artifact protocols are enforced
across agents, not just suggested. The result is team-pace output from a one-person
operation.

The API is approximately 80% hand-coded by the primary author; agent-generated code
operates within the architecture and conventions established by hand.

---

## Local development

See the README in each submodule for repo-specific setup. For the full local stack:

```bash
cp .env.example .env
# fill in DB_PASSWORD, SECRET_KEY, and other required vars
docker compose up
```

The API will be available at `http://localhost:8000` and the web frontend at
`http://localhost:3000` (or via the nginx proxy at `http://localhost:8080`).

---

## License

The API is licensed under [AGPL-3.0-or-later](https://github.com/AzazelAzure/finance-manager-api/blob/main/LICENSE).
See individual submodule repositories for their respective licenses.
