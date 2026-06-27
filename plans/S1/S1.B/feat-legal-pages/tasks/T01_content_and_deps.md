# T01 — Publication-Ready Content Files + Dependency Install

## Context

Three policy drafts exist at `strategy/legal/drafts/` (corrected 2026-06-27). They contain internal markers (`[PENDING T05]`, `[ATTORNEY REVIEW]`, `DRAFT STATUS` header) that must be removed before publishing. This task creates the curated publication-ready markdown files that the legal page components will render, and installs the markdown renderer dependency.

## End State

- `react-markdown` and `remark-gfm` installed in `finance_manager_web`
- `src/content/legal/privacy_policy.md` — publication-ready, no draft markers
- `src/content/legal/tos.md` — publication-ready, no draft markers
- `src/content/legal/cookies.md` — publication-ready, no draft markers

## Slice Decomposition

| Slice | Title | V-Tier | Description |
|---|---|---|---|
| T01.SL1 | Content curation | V0 | Create `src/content/legal/` directory and three markdown files; apply stripping rules from plan README §Content Curation Notes |
| T01.SL2 | Dependency install | V1 | `npm install react-markdown remark-gfm`; verify `npm run build` passes |

## T01.SL1 — Content Curation

**Directory:** `finance_manager_web/src/content/legal/`

Create three files by curating from `strategy/legal/drafts/`. Apply these rules (also in plan README):

**Strip:**
- `> **DRAFT STATUS:** ...` block at top of each file
- Standalone `[PENDING T05]` / `[PENDING T06]` labels (the LINE that is just the label, e.g., `\`[PENDING T05]\`\n`)
- `> **\`[ATTORNEY REVIEW]\`** ...` blockquote blocks (entire blockquote)
- Internal notes clearly scoped to attorneys or agents

**Keep:**
- The disclosure SENTENCES that describe current accurate state (e.g., "Until T05 is deployed, tokens are stored in localStorage" — this is accurate user-facing disclosure)
- `[PLACEHOLDER: ...]` text that is a genuine user-facing notice ("When Google OAuth is implemented...")
- All processor tables, retention tables, rights tables
- Version header, effective date, DPO contact
- GDPR and CCPA sections (CYA coverage)

**Acceptance criteria:**
- [V0] No string matching `[ATTORNEY REVIEW]` in any published file
- [V0] No string matching `DRAFT STATUS` in any published file
- [V0] No standalone `[PENDING T0` label lines in any published file
- [V0] All three files render valid GFM markdown (tables, headers, bold intact)

## T01.SL2 — Dependency Install

```bash
cd finance_manager_web
npm install react-markdown remark-gfm
```

Pin to latest stable at time of install. Verify `remark-gfm` is needed for the table syntax in cookie policy §4 and privacy policy §3.

**Acceptance criteria:**
- [V1] `npm run build` passes with packages installed
- [V1] No type errors from react-markdown imports in a test component

## Evidence

- `evidence/T01.SL2_build_log.txt` — `npm run build` output showing success
