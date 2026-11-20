# Subagent Dispatch Protocol (Model-Pinned Crew Agents)

This protocol is mandatory for every role that dispatches another crew role.

## Why this exists
The `model:` in a `SKILL.md` only applies when the skill is **invoked as a skill** (`/keymaker` typed by Neo, or the `Skill` tool). A subagent launched with `Agent` + `subagent_type: "general-purpose"` is a generic worker that merely *reads* the SKILL.md as text: it **ignores** the `model:` and inherits the model of the caller (Haiku, in Morpheus's case).

## Two ways to run a role
| Mode | How | Model | Visibility |
|---|---|---|---|
| **Direct (Neo)** | `/keymaker` in chat | `model:` of the skill | Live, interactive, same thread |
| **Dispatched (crew)** | `Agent(subagent_type: "keymaker")` | `model:` of `agents/keymaker.md` (same value, generated from the skill) | Isolated; only the final report returns to the dispatcher |

## Rules
1. **Dispatch with the crew agent:** `Agent(subagent_type: "<role>", description: "...", prompt: "<mission + files to read + expected report>")`. Do **not** pass `model:` — the agent definition carries it.
2. **NEVER dispatch with the `Skill` tool:** it hijacks the caller's thread and ends the orchestration when the role finishes.
3. **Roles without an agent** (run directly, never dispatched): `/morpheus`, `/hardline`, `/neb`, and `/source` (external plane).
4. **Single source of truth:** the `model:` lives only in `skills/crew/<role>/SKILL.md`. `agents/*.md` are **generated** — run `node scripts/gen-agents.mjs` after changing any model (`--check` verifies they are in sync).
5. **Fallback (agents not installed, e.g. Cursor/Antigravity):** dispatch `subagent_type: "general-purpose"` **passing `model:` explicitly**, read from the role's frontmatter (`grep -m1 '^model:' ~/.claude/skills/<role>/SKILL.md`), and instruct the subagent to read that SKILL.md first.
6. **Model resolution order (Claude Code):** per-call `model` → agent frontmatter `model` → `CLAUDE_CODE_SUBAGENT_MODEL` → caller's model. `init-project` sets `CLAUDE_CODE_SUBAGENT_MODEL=sonnet` as a safety net so a model-less dispatch never lands on Haiku.
7. **Depth:** subagents may nest (3 layers by default). Keep `MAX_HOPS = 2` anyway.
