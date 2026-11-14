# Rule: Write-Ahead Log (WAL) Protocol & Central Memory Bus

This protocol is mandatory for all squad agents.

## 1. Core Principle
**Zero reliance on ephemeral chat context memory.**  
LLMs suffer from catastrophic forgetting and attention degradation as context windows fill or compact. Therefore, the single source of truth for the project does not reside in the chat transcript, but in structured text files persisted to local disk.

## 2. Double-Logging Mechanism
For every micro-milestone (architectural decision, security analysis, commit, test execution, or quality gate verdict):
1. **Role-Specific Incremental Log (`log-<role>.md`):**  
   The active agent first writes a detailed checkpoint containing technical notes, reasoning, and considerations into its own log file (e.g., `claude/log-architect.md` or `agent-logs/log-architect.md`).
2. **Central Bus Entry (`registro-proceso.md`):**  
   Appends a single, concise chronological row to the project's central bus table before returning the response to the user.

## 3. Handling New Projects
If the project log directory does not yet exist in the target repository, the first agent to activate immediately creates it, along with its individual log file and the central process log bus.
