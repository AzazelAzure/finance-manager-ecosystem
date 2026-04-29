# CPPR and CPPRD — code flow and documentation accountability

## Definitions

| Acronym | Expands to | Purpose |
|--------|------------|--------|
| **CPPR** | **C**ommit, **P**ush, **P**ull **R**equest | Standard delivery loop: work is committed, pushed, and proposed for review in a PR before merge. |
| **CPPRD** | **C**ommit, **P**ush, **P**ull **R**equest, **D**ocument | Same as CPPR, plus **versioned documentation** in this workspace that summarizes what the PR changes so there is **accountability** and a durable record beyond the PR UI alone. |

**CPPR** is the minimum for mergeable work. **CPPRD** is the default bar for work that should be traceable in **repo docs** (not only GitHub), especially cross-cutting, operational, or customer-visible behavior.

## What “Document” (the D) means

Use the **D** when the change should be **discoverable** after the PR is merged and the GitHub tab is no longer in front of you.

| Kind of change | Where to document |
|----------------|------------------|
| User-visible or API behavior in a subrepo | That subrepo’s **`CHANGELOG.md`** (`[Unreleased]` until release). |
| Ecosystem / deploy / proxy / blue-green | `deploy/*.md` (e.g. `BLUEGREEN_SWITCHOVER.md`, this file) or a short addition to the relevant runbook. |
| Architecture, phases, or operational contracts | `design_docs/` (follow repo rules for design-doc updates when behavior or rollout assumptions change). |
| One-line pointer only | A link in **`SERVER_BETA_INSTALL.md`** or a “See also” if the main narrative lives elsewhere. |

The PR **description** should still hold the narrative for reviewers, but **CPPRD** requires at least one **durable, grep-friendly** place in the tree (changelog or deploy/design doc) that states **what** changed and **why** at a high level.

## Why CPPRD

- **Accountability** — “What did we agree shipped?” is answerable from the repo, not only from Slack or GitHub’s closed PR list.  
- **Onboarding** — new agents and humans can follow `CHANGELOG` and `deploy/` without re-reading every PR.  
- **VPS / ops** — runbooks stay aligned with what is actually on `main`.

## When CPPR without D is acceptable

- Mechanical edits (typos, formatting) with no behavior or deploy impact.  
- Purely internal refactors with no public contract change — still often worth a one-line `[Unreleased]` note if the blast radius is non-obvious.

## Related

- [SERVER_BETA_INSTALL.md](./SERVER_BETA_INSTALL.md) — install and `fm_server_beta.sh`.  
- [DEPLOYMENT_VECTORS.md](./DEPLOYMENT_VECTORS.md) — where builds run vs pull on VPS.  
- [BLUEGREEN_SWITCHOVER.md](./BLUEGREEN_SWITCHOVER.md) — blue/green hostnames and switch steps.
