# Skill: web-pwa-tour-review
Use when: web repo PR with user-facing changes

Blocking findings:
- New route/page without tour/help-mode extension note
- User strings without i18n path (new literal in component)
- Offline-critical surface changed without PWA rationale

Warnings:
- SEO/privacy on new public routes

Evidence required:
- i18n_pwa_tour_scan.sh signals

Route to NEEDS_HITM when:
- Major shell/PWA architecture change without design reference
