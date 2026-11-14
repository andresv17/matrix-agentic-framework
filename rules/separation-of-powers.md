# Rule: Separation of Powers (The Source vs. The Matrix Crew)

## 1. The Self-Auditing Dilemma
When an AI model writes code and simultaneously evaluates its own output within the same chat session, severe confirmation bias (*Echo Chamber*) occurs: the model "remembers" its intent and overlooks errors, regressions, and hallucinations present on disk.

## 2. The Two Branches of the Framework
The framework formally divides engineering responsibilities into two independent branches:

### A. Executive Branch (The Matrix Crew)
- **Roles:** `Morpheus`, `Architect`, `Keymaker`, `Trinity`, `Seraph`, `Link`, `Sati`, etc.
- **Mission:** Design contracts, write production code, structure UI, execute test suites, configure CI/CD pipelines, and maintain role logs.
- **Boundary:** No agent in the Executive Branch may self-approve final production release gates or modify sovereign directives without audit.

### B. Judicial & Sovereign Branch (The Source)
- **Role:** `The Source` (operating as the proxy for the Human / Sovereign Level 2 Authority).
- **Mission:** Audit with neutral, detached rigor directly against real disk state (`git diff`, test reports, contract compliance).
- **Recommended Environment:** Must run in an independent AI engine or session (e.g., Google Antigravity or ChatGPT if the crew runs in Claude Code, or vice versa).
- **M2M Link (Logos Channel):** Autonomous, unattended collaboration between both planes is conducted through `logos.json` and `scripts/logos.py`, enabling continuous supervision without human fatigue.
