# Security Protocols and Rules

This document outlines the mandatory security rules and protocols that all developers and autonomous agents MUST follow when working on the Finance Manager ecosystem. 

## 1. Database and Data Access
- **Never bypass the ORM**: All database interactions must use Django's parameterized ORM or appropriate built-in tools. Raw SQL queries are strictly forbidden unless explicitly approved by HitM.
- **Input Sanitization**: Always rely on Django Forms/Serializers to validate and sanitize inputs. Never pass raw user input directly to executable contexts.

## 2. Authentication & Authorization
- **Strict Endpoint Auth**: Any new endpoint exposing or modifying user data MUST be decorated or configured with `IsAuthenticated`.
- **Password Policies**: All password validation must pass the `ComplexPasswordValidator` and `MinimumLengthValidator` (min 12 chars). 
- **Account Lockouts**: `django-axes` is active. Do not bypass or mock rate-limiting logic in production endpoints.

## 3. Secrets and Infrastructure
- **No Plain-Text Secrets**: API keys, tokens, and database credentials MUST strictly be loaded from environment variables. Never hardcode secrets in source files or test scripts.
- **HTTPS & Secure Cookies**: Production deployments enforce `SESSION_COOKIE_SECURE`, `CSRF_COOKIE_SECURE`, and `SECURE_HSTS_SECONDS`. Do not disable these in PRs destined for production.

## 4. Dependencies
- **Dependency Audits**: Any agent adding a new Python package (via `uv`) or NPM package MUST verify it has no known high/critical vulnerabilities.
- **Routine Maintenance**: Agents scheduled to run dependency audits must immediately flag and PR updates for vulnerable packages.

## 5. Frontend Integrity
- **Content Security Policy (CSP)**: Ensure any new external scripts, styles, or fonts are added to the CSP header in `index.html`. 
- **XSS Prevention**: Rely on React's default escaping for rendering variables. Do not use `dangerouslySetInnerHTML` unless absolutely required and thoroughly sanitized.
