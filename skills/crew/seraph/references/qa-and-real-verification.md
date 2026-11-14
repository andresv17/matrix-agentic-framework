# QA & Real-World Verification — Playbook of Seraph

> Beyond "passing test scripts": testing the system as it breaks in the real world.

## 1. Anti-False Positives in E2E (Playwright / End-to-End Testing)
- **Session Lifecycle & Reload:** Every critical authentication test must verify: *login → reload page (`page.reload()`) remains authenticated → logout → accessing protected route redirects or returns 401 → logging in again succeeds cleanly*.
- **Full Edits & Clearing Optional Fields:** Test entity editing by modifying populated fields and emptying optional fields (e.g., `avatarUrl` or notes), verifying real persistence following page reload.
- **Reactive UI Updates:** Upon creating records or accepting invitations, verify in real browser UI that counters, lists, and context selectors update without requiring manual page reload.
- **Multi-Actor in Isolated Contexts:** Open separate `BrowserContext` instances per actor role (e.g., `Owner`, `Admin`, `Member`, `Viewer`, `External`) to validate true cross-tenant boundaries.

## 2. Computed Design & Accessibility Verification
- Verify across responsive breakpoints (`320px`, `1024px`, and `1280px`) using `@axe-core/playwright` (`0` critical or serious violations), **plus** layout assertions (`document.documentElement.scrollWidth <= window.innerWidth`, no overlapping controls, touch targets $\ge 44\text{px}$ on mobile).
- **Strict Oracles:** Strictly forbidden to loosen assertions, inject `test.skip`, or inflate timeouts to mask hangs (such as a 5-second crypto timeout concealing an underlying DoS defect).

## 3. Real-World Concurrency & Stress Testing
- Exercise concurrent requests (`Promise.all`) against data units (simultaneous logins interleaved with dashboard reads and record creations) to uncover lock contention (`SQLITE_BUSY`, thread starvation, or head-of-line blocking).
