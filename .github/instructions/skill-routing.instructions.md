---
description: "Skill routing map for this workspace. Use when selecting which domain-prefixed skill to load for a task, especially after skill renames or when multiple skills look relevant."
applyTo: "**"
---

# Skill Routing

Before any user-facing answer, route through `ai-caveman` first and apply its response style unless the user explicitly says `stop caveman` or `normal mode`.

Use the most specific skill first. Combine only when the task genuinely crosses domains.

## Core Routing

| Signal | Load |
|---|---|
| Creating/updating skills, agents, instructions, prompts | `ai-skill-creator`, `ai-agent-creator`, `ai-instructions-creator`, `ai-prompt-creator` |
| Curating `.github` customizations after a session | `ai-skillopt-curator` |
| Curating `.github`, `.copilot`, and memories | `ai-context-curator` |
| Hierarchical RAG / DIGEST / RAW context | `ai-hierarchical-rag` |
| Constitution, write/clarify a feature spec, plan/tasks breakdown, spec-driven development | `spec-driven-workflow` |
| Git workflow, branches, rebase, cherry-pick | `fullstack-git-specialist` |
| Backend .NET service work (GraphQL, MassTransit, MongoDB, startup/DI) | `backend-developer` |
| C# design, async, error handling, performance | `backend-developer` → `references/csharp-dotnet.md` |
| HotChocolate server patterns (stitching, Fusion, DataLoaders) | `backend-developer` → `references/hotchocolate.md` |
| Backend / PR / architect code review | `backend-developer` → `references/code-review.md` |
| New .NET service scaffold | `backend-developer` → `references/service-scaffolding.md` |
| Business value, OKR, stakeholder, business case | `business-business-analyst` |
| Requirements, acceptance criteria, NFRs | `business-requirements-engineer` |
| Test cases, test strategy, coverage, test reports | `business-testmanager` |
| MongoDB/SQL data pipeline implementation | `dap-database-specialist` |
| Databricks / DAP / Lakehouse | `dap-databricks-specialist` |
| PowerBI / DAX / Power Query / dashboards | `dap-powerbi-specialist` |
| GraphQL schema, Relay client, HotChocolate schema design | `fullstack-graphql-expert` |

## Frontend Routing

| Signal | Load |
|---|---|
| Any frontend implementation/validation/design task | `frontend-developer` (compact core + lazy `references/<domain>/`) |
| New frontend task — docs refresh first | `frontend-developer` → `references/docs-research/` |
| React/TS/Vite/routing/state implementation | `frontend-developer` → `references/engineering/` |
| Frontend validation / typecheck / build / browser checks | `frontend-developer` → `references/quality/` |
| CSS, layout, color, spacing, visual polish | `frontend-developer` → `references/ui-designer/` |
| UX flow, accessibility concept, AI-UX, interaction design | `frontend-developer` → `references/ux-designer/` |
| React component composition/API design | `frontend-developer` → `references/react-composition-patterns/` |
| React performance, bundle, re-render, waterfalls | `frontend-developer` → `references/react-performance/` |
| React Native / Expo | `frontend-developer` → `references/react-native/` |
| React View Transition API | `frontend-developer` → `references/react-view-transitions/` |
| Relay correctness | `frontend-developer` → `references/relay-best-practices/` |
| Relay performance | `frontend-developer` → `references/relay-performance/` |
| Vite config/plugins/build/SSR | `frontend-developer` → `references/vite/` |
| Formik/Yup forms | `frontend-developer` → `references/formik-patterns/` |
| UI/a11y/design audit | `frontend-developer` → `references/web-design-guidelines/` |

## CopilotKit Routing

| Signal | Load |
|---|---|
| Add CopilotKit to a project | `frontend-copilotkit-setup` |
| Build CopilotKit React UI, hooks, tools, renderers | `frontend-copilotkit-react-core` |
| Build CopilotKit server runtime / agents / tools | `frontend-copilotkit-runtime` |
| Debug CopilotKit connectivity, streaming, tool calls | `frontend-copilotkit-debug` |
| Implement AG-UI agent backend/protocol | `frontend-copilotkit-agui` |
| Wire external agent frameworks into CopilotKit | `frontend-copilotkit-integrations` |
| Render A2UI declarative surfaces | `frontend-copilotkit-a2ui-renderer` |
| Refresh local CopilotKit skill knowledge | `frontend-copilotkit-self-update` |

## Test Automation Routing

| Signal | Load |
|---|---|
| General Playwright strategy/flakes/selectors | `test-automation-engineer` → `references/playwright-best-practices/` |
| Repo E2E tests with strict POM | `test-automation-engineer` → `references/playwright-test-creator/` |
| Browser automation through CLI | `test-automation-engineer` → `references/playwright-cli/` |
| Browser automation through MCP tools | `test-automation-engineer` → `references/playwright-mcp/` |
| BrowserStack cloud grid | `test-automation-engineer` → `references/browserstack/` |
| Local webapp browser testing | `test-automation-engineer` → `references/webapp-testing/` |

## Selection Rules

- Prefer a domain-prefixed skill name over an old unprefixed alias.
- Use package names such as `@copilotkit/runtime` only for code/API references, not as skill names.
- If a skill's `requires` frontmatter names another skill, load the required skill first when the task depends on that foundation.
- For overlapping frontend tasks, route through `frontend-developer` plus the matching `references/<domain>/` guide.
- For overlapping backend GraphQL tasks, use `fullstack-graphql-expert` for schema/Relay design and `backend-developer` → `references/hotchocolate.md` for server implementation details.

<!-- Last updated: 2026-07-06 -->
