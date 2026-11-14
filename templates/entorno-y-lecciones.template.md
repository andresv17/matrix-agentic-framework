# Local Environment & Persistent Lessons ({{PROJECT_NAME}})

> Curated quick-reference file (< 40 lines) to avoid re-reading extensive logs upon session startup across any AI engine.

- **Development Ports:** Local API on `127.0.0.1:3000`, Web/Frontend on `127.0.0.1:5173`.
- **Runtime & Toolchain:** Primary runtime versions (Node, Python, Go, etc.) and required environment variables.
- **Critical Architecture & UI Rules:**
  - Zero "AI Slop" (no non-functional, purely decorative UI elements without underlying business logic).
  - Every new route or endpoint requires a formal schema or contract first.
- **Verification Gates:**
  - Unit and integration test suites in green.
  - Strict type checking (`tsc --noEmit`, linters) with zero errors.
  - `/oracle` verdict required before signing off on any production milestone.
