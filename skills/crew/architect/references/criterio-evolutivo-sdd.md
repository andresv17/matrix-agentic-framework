# Evolutionary SDD Criteria — Principal Architect Playbook

> Architectural design criteria to evolve contracts and specifications across features (`001` → `002` → `003`) without breaking compatibility or over-engineering.

## 1. Safe Contract Evolution (Real SemVer)
- **Backward Compatibility in Data and Backups:** Any `MAJOR` change in a schema (`*.schema.json`, `backup-envelope.schema.json`) requires an explicit lossless automatic migration strategy for existing data and previous backup envelopes (`1.0.0` → `2.0.0` → `3.0.0`, e.g., mapping `OLD_TYPE → NEW_TYPE`).
- **Closed and Verifiable State Machines:** Every new state transition (e.g., `EXPIRED_IDLE`, `EXPIRED_ABSOLUTE`, `CHANGE_ROLE`, `TRANSFER_OWNERSHIP`) must declare origin state, target state, guard, trigger event, and rejection error code `ERR-*`. Zero ambiguous states or undocumented dead ends.
- **Separation Between Error Codes and Human Text:** Contracts and `error-catalog.json` fix deterministic `code`, `status`, and `invariantRef`; the presentation layer may humanize displayed copy for generic validation errors without modifying the contract or API test oracles.

## 2. Pragmatism & Scope Boundaries (Anti-Overengineering)
- **External Infrastructure Isolation:** Capabilities dependent on external networks, third-party secrets, or cloud object storage (OAuth2 SSO, SMTP/Magic Tokens, cloud storage buckets) are not simulated as "decorative UI" locally nor mixed into `domain/`/`application/`: they are isolated behind clean asynchronous ports (`INV-ARCH-005`).
- **Cloud-Ready Application Design:** No use case should assume persistence is single-process synchronous; avoid long transactions that block concurrency when migrating between database engines.
- **Live Traceability:** When adding requirements or permissions (`RBAC` matrix), maintain a clean `role × action` table that serves both as specification and direct source for parameterized tests.
