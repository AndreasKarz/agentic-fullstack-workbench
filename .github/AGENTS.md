# Repository Copilot Context — Entry Point

Central, role-based Copilot context for this repository (`.github`). This router activates the appropriate **role** based on the task; a role coordinates specialized expert agents and loads only task-relevant context (**Lazy Loading**).

## Core Principles

- **AI-caveman first** — before every user-facing answer, consider `.github/skills/ai-caveman/SKILL.md` first and apply `ai-caveman` unless the user explicitly says `stop caveman` or `normal mode`.
- **Source-based, no speculation** — mark unverified claims as `ASSUMPTION:`; ask when in doubt (see `instructions/trust-boundary`).
- **Lazy Loading** — load or reference skills and MCP servers only when needed.
- **Metadata standard** — every artifact carries a short description, source, date, and know-how links (see `instructions/metadata-standard`).

## Roles (Delegation)

A role is an **orchestrator agent** that coordinates experts as sub-agents. Choose the appropriate role based on the task:

| Role | When to use | Agent |
|------|-------------|-------|
| **Backend** | .NET/C#, HotChocolate GraphQL, MassTransit, MongoDB, Confix, NUKE | `agents/backend.agent.md` |
| **DB Engineer** | MongoDB, SQL/T-SQL, Azure Data Factory, Databricks/DAP Lakehouse, PowerBI | `agents/db-engineer.agent.md` |
| **Frontend Team** | React/React Native, Design System, GraphQL/Relay, CopilotKit (sub-agents: Dev/UI/UX/Simplicity/Reviewer/E2E) | `agents/frontend-team.agent.md` |
| **BA / RE / Test Manager** | Requirements (IREB), test cases (ISTQB), business analysis (OKR/Flight Levels) | `agents/requirements-engineer.agent.md`, `agents/testmanager.agent.md`, `agents/business-analyst.agent.md` |
| **Test Automation** | Playwright + BrowserStack, Page Object Model | `agents/test-automation.agent.md` |
| **IT Architect** | Generic EA reviews, architecture diagrams | `agents/it-architect.agent.md` |
| **Context Curator** | Maintain context, update skills, remove redundancy/context rot | `agents/context-curator.agent.md` |

## Expert Agents

Expert agents are coordinated by orchestrator roles. 

## Invocation Convention

Call orchestrator roles via `@agent-name` when possible. Orchestrators coordinate their expert agents and skills internally; direct expert invocation is for narrow specialist work only.

## Phase Agents and Handoffs

Visible role agents are coordinators. Hidden phase agents do the focused work and are wired through `agents` and `handoffs`.

Default flow for implementation work:

1. **Analyze** — use a strong model to inspect source evidence and produce a compact plan.
2. **Implement** — use a cheaper workhorse model to execute the confirmed plan with minimal edits.
3. **Review** — use an independent reviewer model to find correctness, architecture, UX, test, and regression risks.
4. **Validate** — use a focused validator for test, build, type, browser, or Playwright evidence.

Keep phase agents hidden with `user-invocable: false`. Use `disable-model-invocation: true` on workers that should only be reachable when an orchestrator explicitly lists them in `agents`.

Model routing policy:

| Phase | Preferred model class |
|------|------------------------|
| Analysis / planning | strong reasoning model, e.g. `Claude Opus 4.7 (copilot)` or `GPT-5.5 (copilot)` |
| Implementation | economical workhorse, e.g. `GPT-5 mini (copilot)` or `GPT-5.4 mini (copilot)` |
| Review | balanced reviewer, e.g. `Claude Sonnet 4.6 (copilot)` |
| Validation | economical workhorse, e.g. `GPT-5 mini (copilot)` |

If a model is unavailable or exceeds the parent session's allowed cost tier, Copilot falls back according to VS Code model selection behavior.

## Skills

Skills deliver domain knowledge and load **automatically** based on their `description` when a task matches (`skills/<name>/SKILL.md`). Agents reference the skills relevant to their role. Use `instructions/skill-routing.instructions.md` as the routing map. `.github/skills/ai-caveman/SKILL.md` always takes priority.

## MCP Servers

Configured in `.vscode/mcp.json` with `afw-` server names. Use only these MCP server references: `afw-memory`, `afw-ado`, `afw-sequential-thinking`, `afw-microsoft-docs`, `afw-playwright`, `afw-mongodb`, and `afw-mssql`. Start only when needed.

## Workflow

1. **Understand** — gather context, load the relevant instruction/skill.
2. **Plan** — break down the task, choose the appropriate role/experts, propose an approach.
3. **Execute** — work step by step, validate after each step.
4. **Align** — present the result, wait for explicit confirmation before irreversible actions.

<!-- Last updated: 2026-07-06 · Part of the Copilot Context Blueprint (see README.md) -->
