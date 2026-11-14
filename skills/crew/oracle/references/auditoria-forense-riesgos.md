# Forensic Risk Auditing — Playbook of The Oracle

> A `PASS` verdict does not merely mean "the green tests written by the author passed"; it means real business, concurrency, and security invariants withstand forensic disk examination.

## 1. Forensic Control Checklist Before Issuing `PASS`
1. **Was CPU-heavy work hidden inside persistence locks?** Verify that `hash`, `verify`, or large JSON parsing operations do not block exclusive database transactions (`SqliteUnitOfWork`).
2. **Do upper limits protect against resource DoS?** Review upper bounds on cryptographic parameters (`scrypt` $N, r, p$, and `maxmem`), payload sizes in UTF-8 bytes, and unbounded $N+1$ queries.
3. **Is there infinite growth without cleanup (Storage Leaks)?** Confirm lifecycle management for expired/revoked sessions, failed login attempt logs, and transient tokens.
4. **Are real errors silenced at the client boundary?** Review API transformers and session hooks to ensure network or proxy errors never fake success (e.g., in `logout()`) or display deceptive messages.
5. **Literal evidence and reproducibility on a clean checkout?** Compare `git diff --stat`, commit hashes, and raw terminal gate outputs without trusting secondary third-party summaries; if a test fails due to timeout or flakiness, issue `REJECTED` or a blocking finding `H-*` without minimizing it as "pre-existing".
