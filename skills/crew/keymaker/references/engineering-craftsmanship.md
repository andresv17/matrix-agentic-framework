# Engineering Craftsmanship — Staff Engineer Standard for Keymaker

> Tactical implementation guide for `src/` and `tests/`. Complements SDD governance without redundant bureaucracy.

## 1. Concurrency, Transactions & Local Persistence (`SqliteUnitOfWork` / Engine Units)
- **Never hold transactional locks during slow operations:** UnitOfWork components serializing operations with immediate locks (`BEGIN IMMEDIATE`) must never execute expensive cryptographic key derivation (`scrypt` / `PasswordHasherPort.hash` or `verify`), compression, or external I/O inside the active write transaction window if it can be computed beforehand.
- **Zero $N+1$ Queries:** When building summary views, avoid triggering $N \times \text{queries}$ in nested loops or redundant full schema validations for historical rows; use batch or aggregate queries behind repository ports.
- **Zero Storage Leaks:** Every ephemeral entity (`sessions`, `login_attempts`, temporary deletion tokens) must implement cleanup routines for expired or revoked records, never unbounded accumulation.

## 2. Defensive Boundaries & Cryptography
- **Hard Bounds on Cryptographic Adapters:** In password verification adapters, explicitly validate upper bounds ($N \le 65536$, $r \le 16$, $p = 1$, $N$ as a power of 2) and pin `maxmem` to a safe constant (e.g., 32 MB) **before** invoking crypto primitives. Never compute `maxmem` by multiplying unvetted parameters from stored hash strings (critical DoS / worker thread hang vector).
- **HTTP Boundary (`src/infrastructure/http/`):** Enforce strict specification precedence (CSRF → Session → Resource 404/403 → Normalization → Schema → Domain). Never swallow errors returning fake 200 statuses or leak internal stack traces in RFC 9457 `ProblemDetails`.

## 3. Pure Presentation Layer (`src/presentation/web/`)
- **Zero Concealment of Critical Failures:** In `logout()`, if the server fails to respond or the teardown errors out, do not silently fake success leaving the cookie alive; inform cleanly or clear with transparent diagnostic feedback.
- **Distinguish Network/Proxy Failures from Domain Failures:** In API error transformers, HTTP responses outside the API contract (e.g., proxy `502` or unrelated services on the port) must never claim "no partial changes were made" if the request never even reached the application backend.
- **Edit Forms Faithful to Contract:** When editing (`PATCH`), clearly distinguish between *"field untouched"* and *"user emptied an optional field"* (e.g., sending `null` when clearing an optional field if the schema allows it), and maintain stable React keys (`key={edit-${id}}`) plus stable memoized objects in Context Providers.
- **Zero Business Logic in UI:** Ages, deltas, clinical alerts, RBAC permissions, and status tokens always arrive from the API or pure projection models derived from generated contracts.
