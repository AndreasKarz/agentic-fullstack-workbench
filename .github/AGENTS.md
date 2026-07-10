# Repository Copilot Context — Entry Point

Central, role-based Copilot context for this repository (`.github`). This router activates the appropriate **role** based on the task; a role coordinates specialized expert agents and loads only task-relevant context (**Lazy Loading**).

## Core Principles

- **Caveman first** — before every user-facing answer, consider `.github/skills/caveman/SKILL.md` first and apply `caveman` unless the user explicitly says `stop caveman` or `normal mode`.
- **Source-based, no speculation** — mark unverified claims as `ASSUMPTION:`; ask when in doubt (see `instructions/trust-boundary`).
- **Lazy Loading** — load or reference skills and MCP servers only when needed.
- **Metadata standard** — every artifact carries a short description, source, date, and know-how links (see `instructions/metadata-standard`).

## Roles (Delegation)

A role is an **orchestrator agent** that coordinates experts as sub-agents. Choose the appropriate role based on the task:

| Role | When to use | Agent |
|------|-------------|-------|
| **context-engineer** | Maintain Copilot customizations (instructions, skills, agents, prompts) + memory curation | `agents/context-engineer.agent.md` |
| **backend-developer** | .NET/C#, HotChocolate GraphQL, MassTransit, MongoDB, Confix, NUKE | `agents/backend-developer.agent.md` |
| **dap-engineer** | MongoDB, SQL/T-SQL, Azure Data Factory, Databricks/DAP Lakehouse, PowerBI | `agents/dap-engineer.agent.md` |
| **frontend-developer** | React/React Native, Design System, GraphQL/Relay, CopilotKit, UX/UI, Playwright E2E | `agents/frontend-developer.agent.md` |
| **Product Team** | Business analysis (OKR/Flight Levels), requirements (IREB), test management (ISTQB), architecture reviews (IT Architect) | `agents/product-team.agent.md` |

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
| Analysis / planning | strong reasoning model, e.g. `Claude Opus 4.8` or `GPT-5.6 Sol` |
| Implementation | economical workhorse, e.g. `GPT-5.6 Luna` or `MAI-Code-1-Flash` |
| Review | balanced reviewer, e.g. `GPT-5.6 Terra` or `Claude Sonnet 5` |
| Validation | economical workhorse, e.g. `GPT-5.6 Terra` or `Claude Sonnet 5` |

If a model is unavailable or exceeds the parent session's allowed cost tier, Copilot falls back according to VS Code model selection behavior.

## Skills

Skills deliver domain knowledge and load **automatically** based on their `description` when a task matches (`skills/<name>/SKILL.md`). Agents reference the skills relevant to their role. Use `instructions/skill-routing.instructions.md` as the routing map. `.github/skills/caveman/SKILL.md` always takes priority.

## MCP Servers

Configured in `.vscode/mcp.json` with `afw-` server names. Use only these MCP server references: `afw-memory`, `afw-ado`, `afw-sequential-thinking`, `afw-microsoft-docs`, `afw-playwright`, `afw-mongodb`, and `afw-mssql`. Start only when needed.

## Workflow

1. **Understand** — gather context, load the relevant instruction/skill.
2. **Plan** — break down the task, choose the appropriate role/experts, propose an approach.
3. **Execute** — work step by step, validate after each step.
4. **Align** — present the result, wait for explicit confirmation before irreversible actions.

## Spec-Driven Workflow

Every team orchestrator (backend-developer, frontend-developer, dap-engineer, Product Team, context-engineer) offers two additional handoffs as the first step for new features: **Clarify & Specify** (`spec-analyst`) and **Plan & Tasks** (`spec-planner`), before the usual Analyze/Implement/Review/Validate phases. This is adapted from Spec-Driven Development (constitution → clarify/specify → plan → tasks), embodied by the `spec-analyst` and `spec-planner` agents.

- `spec-analyst` interviews the user (max 5 targeted questions) and writes a clarified feature specification.
- `spec-planner` turns the spec into a technical plan (gated by the project constitution) and a task breakdown, then hands off to the team's existing implementer.
- Artifacts (`constitution.md`, `specs/NNN-<name>/{spec,plan,tasks}.md`) live under `docs/` in the **project** folder that was added to this workspace — never inside this workbench.
- Independent of the `Requirements Engineer`/ISTQB flow — pick whichever fits the task; they are not coupled.

<!-- Last updated: 2026-07-06 · Part of the Copilot Context Blueprint (see README.md) -->
