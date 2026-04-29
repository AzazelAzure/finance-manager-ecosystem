# Deployment vectors: where builds run and how code reaches the VPS

This note supports **reassessment** of how changes get to production: **current patterns** (e.g. develop and PR in Git, **copy** bundle or **pull** on the server, build with Compose) vs **building or running CI *on* the VPS** for “live” experiments.

It is not a mandate to change anything — it is a **decision frame**.

**Standard code loop:** **CPPR** = commit, push, pull request. For accountability in this repo, prefer **CPPRD** = commit, push, pull request, **document** change (changelog and/or `deploy/` / `design_docs` as appropriate). See [`CPPR_AND_CPPRD.md`](./CPPR_AND_CPPRD.md).

## Vocabulary

| Vector | Short description |
|--------|-------------------|
| **Remote build / pull** | Workstation or CI runs tests; you push to Git; VPS (or a runner) **git pull** + `podman-compose build/up` in the right subrepos. |
| **Bundle / rsync** | `create_runtime_bundle.sh` / scp a tarball; server extracts — **no** Git on the host required. |
| **On-VPS build** | SSH to the box, `git pull`, `compose build` **there** — the server is the build environment. |
| **On-VPS “live test”** | Implies you might run **unreviewed** or **branch** code in a **non-production** color (`deploy green`, hit `jsdevtesting` + `api-jsdevtesting`) without going through the same gates as a merge to `main`. |

## When the current pipeline (PR + pull/copy on VPS) stays the right default

- **Reproducibility** — the same commit that passed CI is what you deploy.  
- **Traceability** — `RELEASE_MANIFEST` / known SHAs.  
- **Blast radius** — production secrets and Docker socket stay in a small set of people; no one pastes ad hoc edits on the server.  
- **No resource contention** — build CPU/RAM on developer machines or CI, not on the small VPS that also runs Postgres and the app.

**This remains the recommended default** for **production** and for **cutovers** (see `BLUEGREEN_SWITCHOVER.md`).

## When on-VPS pull + build is reasonable

- **Rapid validation** of a **hotfix** already reviewed in spirit but you need a **one-off** image on **inactive** color.  
- **No CI minutes** or slow external CI — you still **commit and push** after validation so history is not lost.  
- **Solo or trusted operator** — the risk of “uncommitted WIP in `/home/.../finance_manager`” is understood and mitigated (always reset to a tag after).  

**Risks:** uncommitted diffs, wrong branch, mixing subrepos at different SHAs, building with wrong `VITE_*` or `.secrets/server.env` — all **higher** than a CI artifact.

**Mitigation:** use **`fm_server_beta.sh deploy` / `smoke`** and **`jsdevtesting` + `api-jsdevtesting`** (inactive stack) before **`switch`**. Never point **active** color at random builds without the same review bar as your PR flow.

## On-VPS CI / agent (future)

Running **CPPR-style automation** *on* the VPS (e.g. a job that `git fetch` + tests + `compose build`):

- **Pros:** single place to “live test” *after* merge, tight loop with real TLS, DNS, and `8443` proxy.  
- **Cons:** need **hardening** (no arbitrary PR execution without approval), **secrets** on the host, and **idempotent** scripts so a failed run does not half-deploy.

Treat this as **an extension of remote pull**, not a replacement for code review. Prefer **ephemeral** runners or a **dedicated** deploy user with **read-only** Git and **no** production DB admin unless required.

## Practical recommendation

1. **Keep** merge-to-main (or protected branch) + **pull-or-bundle on VPS** for **provenance**.  
2. **Use** blue/green + **`jsdevtesting` + `api-jsdevtesting`** for “live but not public” full-stack tests.  
3. **Add** a tagged release step if you need **immutability** (e.g. “deploy image tag `2026-04-30a`” from CI) — reduces “whatever got built on the box Friday.”  
4. **Avoid** uncommitted production deploys; if you must hotfix on the server, **immediately** cherry-pick into Git and **rebuild** from that commit to eliminate drift.

## Related

- [CPPR_AND_CPPRD.md](./CPPR_AND_CPPRD.md) — **CPPR** / **CPPRD** and documentation accountability.  
- [BLUEGREEN_SWITCHOVER.md](./BLUEGREEN_SWITCHOVER.md) — hostname map, `switch`, staging API.  
- [SERVER_BETA_INSTALL.md](./SERVER_BETA_INSTALL.md) — install layout and `fm_server_beta.sh`.
