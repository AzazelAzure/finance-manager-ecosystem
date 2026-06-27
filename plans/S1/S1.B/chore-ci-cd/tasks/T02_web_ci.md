# T02 — Web CI Workflow

## End State

`.github/workflows/web-ci.yml` in `finance-manager-web` repo. Runs on every push and every PR targeting `main`. Executes TypeScript type check (`tsc --noEmit`) and Vitest unit tests. Build check optional (see note).

## Pre-flight (Cursor: read before writing)

1. Read `finance_manager_web/package.json` — confirm Node version (`.nvmrc` or `engines` field), and confirm these scripts exist:
   - `"test"` or confirm vitest is in `devDependencies` (run as `npx vitest run`)
   - `"build"` for optional build check
2. Read `finance_manager_web/tsconfig.json` — confirm `strict` mode or any settings that affect type-check behavior.
3. Check if any tests exist yet (`find src -name "*.test.ts" -o -name "*.spec.ts"`). If none exist, the test step should still run (Vitest will pass with 0 tests found, which is fine).

## Slice Decomposition

| Slice | Title | V-Tier |
|---|---|---|
| T02.SL1 | Workflow file | V1 |
| T02.SL2 | Verify first run | V1 |

## T02.SL1 — Workflow File

Create `.github/workflows/web-ci.yml`:

```yaml
name: Web CI

on:
  push:
  pull_request:
    branches: [main]

jobs:
  ci:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'   # match .nvmrc or package.json engines
          cache: 'npm'
          cache-dependency-path: finance_manager_web/package-lock.json

      - name: Install dependencies
        run: npm ci
        working-directory: finance_manager_web/

      - name: TypeScript type check
        run: npx tsc --noEmit
        working-directory: finance_manager_web/

      - name: Run tests
        run: npx vitest run
        working-directory: finance_manager_web/
```

**Note on build check:** Intentionally omitted. `npm run build` catches import errors but is slow (~60-90s) and adds Vite env var complexity (it needs `VITE_*` vars). Add it in a second pass once baseline CI is green.

**Note on linting:** Do not add lint as a blocking step here. If ESLint is configured, it can be added as a non-blocking step (`continue-on-error: true`) for visibility, but not a gate, in this pass.

**Acceptance criteria:**
- [V1] Workflow file parses without YAML errors
- [V1] `tsc --noEmit` step runs (type errors will show as failures — that's correct behavior; don't suppress them, fix them)
- [V1] `vitest run` step runs (0 tests is a pass)

## T02.SL2 — Verify First Run

After pushing the workflow file:
- Navigate to GitHub → `finance-manager-web` → Actions tab
- Confirm `Web CI` workflow appears and has run

**Acceptance criteria:**
- [V1] GitHub Actions tab shows `Web CI` workflow with at least one completed run
- Evidence: `evidence/T02.SL2_web_ci_run.png`
