# Validation Gates

## Breakpoint A: Runtime and bridge baseline
- `#cli-interface` task with `!cursor` returns a short threaded reply.
- Runtime mode is confirmed as containerized or local-services, with no mixed mode unless explicitly justified.
- `scripts/fm_docker.sh status` and `scripts/fm_services.sh status` results are recorded.
- API health, Reflex reachability, and proxy routing checks are reported in chunked replies under Slack clipping limits.

## Breakpoint B: API production hardening
- `uv run python manage.py check --deploy` runs with production-like env values.
- `DEBUG=False` in the environment results in Django `DEBUG is False`.
- API targeted tests for changed settings/auth/URL behavior pass.
- Full API suite is green, or remaining failures are grouped with root-cause hypotheses and follow-up task packets.

## Breakpoint C: Reflex runtime smoke
- Reflex is reachable through the intended local beta URL or proxy path.
- Reflex can reach the API container using configured `API_BASE_URL`.
- Browser/manual smoke covers login/session state and one dashboard/API-backed route, or records the blocker preventing it.
- Recent Reflex/API/proxy logs show no repeating crash loop or route-level failure for smoke paths.

## Final readiness gate
- Each touched sub-repo has a focused branch and PR.
- PRs are announced in `#pull-requests`.
- Slack automation state is read and reconciled with GitHub mergeability/check status.
- Changelog/docs impact has been handled for each changed repo.
- `design_docs` readiness boards reflect pass/partial/blocked evidence for beta launch.
