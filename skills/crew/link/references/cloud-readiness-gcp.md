# Cloud Readiness & Deployment Playbook — Link

> Production operating standards and cloud transition guidelines under `INV-ARCH-005` and `INV-ARCH-006`.

## 1. Mandatory Preparation Before Leaving `127.0.0.1`
- **Networking & Containers:** Configurable `HOST` (`127.0.0.1` locally, `0.0.0.0` in containerized runtimes) and `PORT` injected via environment variables without hardcoded values in configs or reverse proxies.
- **Health Checks & Process Signals:**
  - Public endpoint `/healthz` (session-free, validating database connectivity via `SELECT 1`) for liveness/readiness orchestration probes.
  - Signal handlers for `SIGTERM` and `SIGINT` to gracefully drain in-flight requests (`app.close()`) and shut down connections cleanly.
- **Baseline Observability:** Generation and propagation of `X-Request-ID`, structured JSON logging with secrets redacted (`req.headers.cookie`, `set-cookie`, tokens, passwords omitted), and baseline latency/error rate metrics.

## 2. Target Cloud Architecture
- **Compute:** Serverless containers (scale-to-zero capability, managed TLS/HTTPS, automated scaling).
- **Persistence & Storage:** Managed database engines behind `UnitOfWorkPort` / `RepositorySet` without touching `domain/` or `application/`; cloud object storage with signed URLs for binary uploads, documents, and assets.
- **Identity & Secret Management:** Secret management vaults for API keys, OAuth2 secrets, and credentials; never store secrets in version-controlled `.env` files or Git repositories.
- **CI/CD & IaC:** Reproducible automated workflows pinned to LTS runtimes, modular Infrastructure as Code with remote state storage, and least-privilege IAM policies.
