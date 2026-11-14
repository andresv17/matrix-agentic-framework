# Central SDD Process Log — Project {{PROJECT_NAME}} (Inter-Session Memory Bus)

> **Purpose:** Central persistent on-disk memory bus for *The Matrix* skills in {{PROJECT_NAME}}. No agent relies on conversational context: every architectural decision, commit, finding, or state transition is logged here and in its respective role log (`claude/log-<role>.md` or `agent-logs/log-<role>.md`).

---

## 1. Initial State Snapshot on Disk

- **Sovereign Authority (Level 2):** {{AUTHOR_NAME}}
- **Active Branch:** `main` (or active feature branch)
- **Initial State:** Architecture bootstrap.
- **Truth Artifact Directory Map:**
  - Specifications & Contracts: `specs/`
  - Source Code: `src/`
  - Tests & Quality Gates: `tests/`

---

## 2. Chronological Bus Log (Write-Ahead Log)

| Timestamp | Sender / Role | Action / Commit / Milestone | State / Verdict | Next Recommended Action |
| :--- | :--- | :--- | :--- | :--- |
| {{DATE}} | /architect | Initial architecture blueprint and specification roadmap | APPROVED | Hand off blueprint to /keymaker |
