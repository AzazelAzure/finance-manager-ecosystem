# T04 — Branch Protection + Dependabot

## End State

- `.github/dependabot.yml` in `finance-manager-api` (pip ecosystem)
- `.github/dependabot.yml` in `finance-manager-web` (npm ecosystem)
- Branch protection enabled on `main` in both repos requiring CI checks to pass

**Important:** Branch protection must be enabled AFTER T01 and T02 workflows have at least one successful run on `main`. Otherwise `main` will be immediately locked and no PRs can merge.

## Slice Decomposition

| Slice | Title | V-Tier |
|---|---|---|
| T04.SL1 | API dependabot config | V0 |
| T04.SL2 | Web dependabot config | V0 |
| T04.SL3 | Branch protection (manual — GitHub UI) | V0 |

## T04.SL1 — API Dependabot Config

Create `.github/dependabot.yml` in `finance-manager-api`:

```yaml
version: 2
updates:
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
    open-pull-requests-limit: 5
    labels:
      - "dependencies"

  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
    labels:
      - "dependencies"
```

Dependabot will open PRs for outdated packages. It does NOT merge automatically. Each PR goes through the normal review + CI flow.

**Acceptance criteria:**
- [V0] File parses (Dependabot validates on push; first batch of PRs will appear within 24h)

## T04.SL2 — Web Dependabot Config

Create `.github/dependabot.yml` in `finance-manager-web`:

```yaml
version: 2
updates:
  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
    open-pull-requests-limit: 5
    labels:
      - "dependencies"

  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
    labels:
      - "dependencies"
```

**Acceptance criteria:**
- [V0] File present in repo; Dependabot PRs appear within 24h of push

## T04.SL3 — Branch Protection (Manual — GitHub UI)

This cannot be done via a workflow file — it requires GitHub repository settings.

**Steps (do for BOTH `finance-manager-api` and `finance-manager-web`):**

1. Go to GitHub → repo → Settings → Branches → Add branch protection rule
2. Branch name pattern: `main`
3. Enable: **Require status checks to pass before merging**
4. Add required status checks — use the EXACT job names from the workflows:
   - API repo: `test` (from `api-ci.yml` `jobs.test`)
   - Web repo: `ci` (from `web-ci.yml` `jobs.ci`)
5. Enable: **Require branches to be up to date before merging**
6. Do NOT enable: "Include administrators" (you need to be able to push hotfixes in an emergency)
7. Save

**Acceptance criteria:**
- [V0] Branch protection rule visible in Settings → Branches for both repos
- [V0] A test PR (can be a docs-only change) shows required CI status check before merge is allowed
