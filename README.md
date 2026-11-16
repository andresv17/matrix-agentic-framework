# ⚡ Matrix Agentic Framework — Virtual Software Engineering Squad & Sovereign Control Plane

> **Autonomous, multi-agent software engineering framework agnostic to any AI provider (Claude, Gemini, OpenAI, Cursor, Antigravity).**  
> Equips your projects with a complete squad of 21 specialized software engineering roles, disk-persisted memory (Write-Ahead Log), and strict separation of powers through out-of-band external auditing.

🌐 *[Leer esta documentación en Español](README.es.md)*

---

## 🎯 What is this framework for?

In traditional AI-assisted coding, a single chat assistant tries to do everything: design the database, write the backend, craft the UI, review security, and run tests. This inevitably results in context drift, undetected hallucinations, and superficial, untested code (*"AI Slop"*).

**Matrix Agentic Framework** solves this by turning your environment into an **autonomous virtual software factory** with highly specialized engineering roles that collaborate, challenge, and audit each other under strict **Spec-Driven Development (SDD)** discipline.

---

## 🏢 The 21 Squad Roles

### A. Sovereign Plane & External Control (Judicial Branch)
- **`The Source`** → **Chief Systems Architect & External Sovereign Auditor.** Operates outside the operational execution crew. Audits agent claims directly against disk (`git diff`, formal contracts, test suites), signs off on production release gates, and enforces Level 2 architectural decisions.

### B. Technical Leadership & Core Engineering (Executive Branch)
- **`/morpheus`** → **Captain / Tech Lead.** Dispatches tasks, orchestrates subagents, maintains velocity, and activates strategic quality gates.
- **`/architect`** → **Solutions Architect & SDD Lead.** Designs clean/hexagonal architecture, formal contracts (OpenAPI, JSON Schema, state machines), and engineering blueprints before any production code is touched.
- **`/keymaker`** → **Senior Full-Stack Developer.** Implements production code and test suites strictly driven by contracts and specifications.
- **`/oracle`** → **Forensic Quality Auditor & QA Gatekeeper.** Verifies disk state, specification compliance, coverage thresholds, and issues formal gate verdicts.
- **`/mouse`** → **Structural Traceability Auditor.** Validates syntax, checklists, and specification ID traceability.

### C. Technical Domain Specialists
- **`/trinity`** → **Offensive & Defensive AppSec.** Hunts down OWASP vulnerabilities, IDOR, CSRF, input sanitization flaws, and runs SAST audits.
- **`/seraph`** → **Zero-Trust, Authentication & Extreme QA.** Audits secure session flows and subjects code to mutation testing (Stryker) and end-to-end combat (Playwright).
- **`/link`** → **Cloud, DevOps & SRE.** Docker containerization, Terraform IaC, GCP/AWS deployments, and CI/CD automation via GitHub Actions.
- **`/sati`** → **Frontend, UI/UX & Accessibility.** Designs resilient components, CSS/Tailwind design tokens, and ensures WCAG 2.1 AA accessibility with zero superficial decorative bloat.
- **`/rama`** → **Data Privacy & Atomic Backups.** Enforces PII redaction, audit logging, and ACID-compliant migrations with full rollback capability.
- **`/merovingian`** → **Root Cause Analysis (RCA) & Dependency Auditor.** Evaluates impact graphs and audits third-party packages for supply-chain vulnerabilities.

### D. Critical Lenses, Debate & Continuous Improvement
- **`/mifune`** → **Anti-Overengineering Pragmatism.** Prevents unnecessary complexity and ensures the leanest, most maintainable path to delivery.
- **`/lock`** → **Devil's Advocate.** Hunts edge cases (`EDGE-*`), concurrency race conditions, and fragile assumptions.
- **`/zion`** → **Technical Debate Arena.** Moderates structured debates (1v1, Squads) between agents to resolve tough architectural trade-offs.
- **`/dojo`** → **Continuous Refactoring.** Designs incremental technical debt cleanup plans (`TECHDEBT-*`).
- **`/hamann`** → **Context & LLM Efficiency Specialist.** Optimizes token consumption and prompt engineering efficiency.
- **`/neb`** → **Status Translator.** Translates dense technical and SDD metrics into plain, human-friendly project status updates.
- **`/hardline`** → **Session Close & Handover Protocol.** Freezes state, creates dated handovers, and generates zero-friction wake-up prompts.

### E. Red Team (Chaos Engineering)
- **`/smith`** → **Chaos Engineering.** Simulates database crashes, network drops, and transactional failures mid-execution.
- **`/sentinels`** → **Attack Vectors.** Simulates exploitation attempts (injections, brute-force, buffer overflows).

---

## ⚖️ When to Use (and When NOT to Use)

### ✅ Ideal Scenarios:
1. **Real-world medium to high complexity software:** Full-stack apps, enterprise APIs, microservices, SaaS platforms, and libraries requiring multiple technical disciplines (security, cloud, UX, architecture, backend).
2. **Zero tolerance for hidden technical debt (*AI Slop*):** Where every commit must pass real test suites, linters, and strict static analysis before being marked complete.
3. **Multi-session, long-running projects:** Projects requiring days or weeks of engineering where context preservation and audit trails are critical.

### ❌ NOT Designed For:
- 5-minute quick fixes, throwaway scripts, or simple conversational queries.
- Projects without software code (e.g., bare cloud account setups without application logic).

---

## 🏛️ The Golden Rule: Separation of Powers

The framework establishes a strict architectural boundary between **execution** and **auditing**:

```
┌────────────────────────────────────────────────────────────────────────┐
│  SOVEREIGN PLANE (Judicial Branch / Auditing) — THE SOURCE             │
│  Recommended engine: Google Antigravity / Gemini / ChatGPT external    │
│  • Audits real disk state (git diff, contracts, test results).         │
│  • Signs off on Level 2 gates and issues sovereign approvals.          │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │ Logos Channel (M2M / scripts/logos.py)
                                   ▼
┌────────────────────────────────────────────────────────────────────────┐
│  OPERATIONAL CREW (Executive Branch) — THE MATRIX CREW (20 Roles)      │
│  Recommended engine: Claude Code CLI / Cursor / VS Code                │
│  • Designs, codes, refactors, secures, and tests.                      │
│  • Writes every milestone to the on-disk Write-Ahead Log (WAL).        │
└────────────────────────────────────────────────────────────────────────┘
```

### Why run them in separate AI engines?
1. **Breaking the Echo Chamber:** If the same model that wrote the code audits it in the same conversation, confirmation bias causes it to approve its own hallucinations. An external engine audits cold disk state without conversational bias.
2. **Separation of Powers (Executive vs. Judicial):** The builder cannot sign their own production release gate.
3. **Context Window Preservation:** The execution crew burns thousands of tokens on compiler output, terminal logs, and code diffs. *The Source* maintains a clean, high-level context to make strategic architectural decisions without context fog.

> *Note: If you only have access to one AI model, you can run Source and Matrix in separate terminal windows, but **never within the same chat conversation**.*

---

## 💾 Persistent Memory: Write-Ahead Log (WAL) Protocol

No agent relies on ephemeral chat context memory. For every decision or milestone:
1. The active agent writes a detailed checkpoint in its role log: `claude/log-<role>.md` (or `agent-logs/log-<role>.md`).
2. Appends a chronological entry to the central project bus: `claude/process-log-<project>.md` (or `registro-proceso-<project>.md`).
3. Upon startup or context compaction, the `session-context.mjs` hook automatically injects live Git status and the latest bus entries.

---

## 🚀 Installation & Setup

### Option A: As a Native Plugin (Google Antigravity)
This repository includes a standard `plugin.json` manifest.
1. Add this repository URL to your Plugins Manager or clone it into your plugins directory.
2. Enable the **Matrix Agentic Framework** plugin. All 21 roles and governance rules will be instantly available.

### Option B: Interactive Adaptive Installer (`install.sh`)
Clone the repository and run the setup wizard:

```bash
git clone https://github.com/andresv17/matrix-agentic-framework.git
cd matrix-agentic-framework

# Launch the interactive setup wizard:
./install.sh
```

The interactive wizard will guide you through:
1. **Where to install the Execution Crew?** (Claude Code CLI, Antigravity, Cursor, or custom path).
2. **Where to install The Source?** Automatically recommends an alternate engine (e.g., Gemini or ChatGPT if you chose Claude for the crew) to uphold the separation of powers.
3. **Linking method:** Symlinks (recommended for seamless `git pull` updates) or physical copy.
4. **Project initialization:** Optionally initialize the memory bus in an existing project.

> *Non-interactive CLI flags for CI/CD or automation: `./install.sh --crew`, `./install.sh --source`, `./install.sh --all`, or `--crew-dir <path>` / `--source-dir <path>`.*

### Initializing a Project with Matrix Memory
In the root directory of any software repository:

```bash
/path/to/matrix-agentic-framework/install.sh --init-project .
```

This provisions:
- Central event bus: `claude/process-log-<project>.md` (or `registro-proceso-<project>.md`)
- Fixed facts & environment notes: `claude/environment-and-lessons.md` (or `entorno-y-lecciones.md`)
- Live memory injection hook: `.claude/hooks/session-context.mjs`
- Logos `Stop` guard hook (prevents Morpheus from ending turns without `logos.py write` / `wait --for morpheus`): `.claude/hooks/logos-stop-guard.mjs` (reference in `skills/crew/morpheus/references/logos-stop-guard.mjs` and `skills/source/references/logos-stop-guard.mjs`)
- Session hook configuration: `.claude/settings.json`
- M2M communication channel: `scripts/logos.py`

---

## 🛸 The Logos Channel (Autonomous M2M Supervision)

To enable unattended autonomous collaboration between **The Source** and **Morpheus**:
1. In the crew terminal, enter:
   ```text
   Morpheus: turn on the Logos   (or: "Morpheus: enciende la Logos")
   ```
2. In the sovereign auditor terminal, enter:
   ```text
   Source: turn on the Logos     (or: "Source: enciende la Logos")
   ```
Both agents will negotiate directives, verify code on disk, and execute quality gates via `logos.json` and `scripts/logos.py` without requiring continuous human presence. In Claude Code, `.claude/hooks/logos-stop-guard.mjs` acts as a deterministic `Stop` hook so Morpheus never drops the `wait --for morpheus` loop. To disconnect, simply type: `"turn off the Logos"` or `"apaga la Logos"`.

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for details.
