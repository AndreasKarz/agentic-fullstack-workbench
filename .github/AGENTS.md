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

Expert agents are coordinated by orchestrator roles. Call them directly only for a targeted deep dive.

| Expert | When to use | Agent |
|--------|-------------|-------|
| **C# Expert** | C#/.NET design, async, performance, error handling | `agents/csharp-expert.agent.md` |
| **HotChocolate Expert** | HotChocolate GraphQL schema/resolvers/DataLoaders/Fusion | `agents/hotchocolate-expert.agent.md` |
| **Debug Expert** | Build/runtime/GraphQL/MassTransit/MongoDB/pipeline diagnosis | `agents/debug-expert.agent.md` |
| **MongoDB Expert** | MongoDB schema/query/index/performance analysis | `agents/mongodb-expert.agent.md` |
| **MS-SQL Expert** | SQL Server stored procedures, queries, execution plans | `agents/mssql-expert.agent.md` |
| **PowerBI** | PowerBI reports, DAX, Power Query, star schema | `agents/powerbi.agent.md` |
| **Frontend Developer** | React/TypeScript/Vite/Relay/CopilotKit implementation | `agents/frontend-developer.agent.md` |
| **UX/UI Designer** | UX flows, accessibility, CSS, layout, visual validation | `agents/ux-ui-designer.agent.md` |

## Invocation Convention

Call orchestrator roles via `@agent-name` when possible. Orchestrators coordinate their expert agents and skills internally; direct expert invocation is for narrow specialist work only.

## Skills

Skills deliver domain knowledge and load **automatically** based on their `description` when a task matches (`skills/<name>/SKILL.md`). Agents reference the skills relevant to their role. Use `instructions/skill-routing.instructions.md` as the routing map. `.github/skills/ai-caveman/SKILL.md` always takes priority.

## MCP Servers

Prepared globally in `mcp.json` (postfix `-global`). Always available: `sequential-thinking`, `memory`, `microsoft-docs`, `fetch`, `playwright`. Role-specific (configuration required): `ado`, `mongodb`, `mssql`, `drawio`. Start only when needed.

## Workflow

1. **Understand** — gather context, load the relevant instruction/skill.
2. **Plan** — break down the task, choose the appropriate role/experts, propose an approach.
3. **Execute** — work step by step, validate after each step.
4. **Align** — present the result, wait for explicit confirmation before irreversible actions.

<!-- Last updated: 2026-07-06 · Part of the Copilot Context Blueprint (see README.md) -->
