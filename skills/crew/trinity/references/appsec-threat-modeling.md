# AppSec & Threat Modeling Playbook — Trinity

> Beyond standard baseline exploit checks: real attack vectors that bring down production systems.

## 1. Availability & Computational Threats (DoS)
- **Algorithmic DoS in Hashing:** Always verify that password adapters (`scrypt`, Argon2, bcrypt, or equivalents) validate maximum cost parameter bounds ($N, r, p$) and enforce fixed upper limits on `maxmem` prior to executing native C/libuv crypto primitives. An unvetted large $N$ parameter in a malformed stored hash can freeze the entire Node/runtime event loop.
- **Password Spraying & Volumetric Abuse:** User-targeted lockouts do not mitigate an attacker testing 1 password against 5,000 distinct accounts or flooding fake hasher computations. Enforce rate limiting by IP/origin on public authentication and registration endpoints.
- **Transactional Contention as a DoS Vector:** Audit that slow cryptographic computation never occurs inside database-level write locks (`BEGIN IMMEDIATE`).

## 2. Multi-Role Authorization (RBAC) & Deep IDOR
- **Exhaustive Matrix Testing (`role × action`):** In shared accounts/workspaces with multiple roles (e.g., `Owner`, `Admin`, `Member`, `Viewer`), every unauthorized cell must return the exact status code (`404` if the resource is hidden from the actor, `403` if visible but lacking permission), evaluated **before** body schema validation.
- **Privilege Escalation & Orphan Protection:** A subordinate admin cannot remove the account owner, transfer ownership they do not possess, or self-assign higher roles. When deleting accounts or leaving shared households, verify transactional atomicity and prevent leaving orphaned resources without owners.

## 3. Session Lifecycle & Input Attack Surface
- **Immediate Server-Side Revocation:** `POST /auth/logout` and `DELETE /users/me` must invalidate tokens in persistent session storage before replying; immediately re-submitting the session cookie must return `401`.
- **Sliding Idle Window + Hard Absolute Expiry:** Verify using an injected clock that `idleTimeout` expires after exact inactivity (`30m + 1ms → 401`) and continuous activity never extends the session past its absolute lifetime (`24h`).
- **Input Injection Vectors:** Audit every newly added field against stored XSS, SQL injection, prototype pollution, and sensitive data leakage in application logs.
