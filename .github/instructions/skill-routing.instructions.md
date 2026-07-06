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
| Git workflow, branches, rebase, cherry-pick | `fullstack-git-specialist` |
| Backend .NET service implementation | `backend-developer` |
| C# design, async, error handling, performance | `backend-csharp-expert` |
| HotChocolate server patterns | `backend-hotchocolate-specialist` |
| Backend review | `backend-code-reviewer` |
| New .NET service scaffold | `backend-service-scaffolder` |
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
| Any new frontend implementation task | `frontend-docs-research`, then `frontend-engineering` |
| Frontend validation / typecheck / build / browser checks | `frontend-quality` |
| CSS, layout, color, spacing, visual polish | `frontend-ui-designer` |
| UX flow, accessibility concept, AI-UX, interaction design | `frontend-ux-designer` |
| React component composition/API design | `frontend-react-composition-patterns` |
| React performance, bundle, re-render, waterfalls | `frontend-react-performance` |
| React Native / Expo | `frontend-react-native-skills` |
| React View Transition API | `frontend-react-view-transitions` |
| Relay correctness | `frontend-relay-best-practices` |
| Relay performance | `frontend-relay-performance` |
| Vite config/plugins/build/SSR | `frontend-vite` |
| Formik/Yup forms | `frontend-formik-patterns` |
| UI/a11y/design audit | `frontend-web-design-guidelines` |
| Local webapp browser testing | `frontend-webapp-testing` |

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

## Playwright Routing

| Signal | Load |
|---|---|
| General Playwright strategy/flakes/selectors | `frontend-playwright-best-practices` |
| Repo E2E tests with strict POM | `frontend-playwright-test-creator` |
| Browser automation through CLI | `frontend-playwright-cli` |
| Browser automation through MCP tools | `frontend-playwright-mcp` |
| BrowserStack cloud grid | `frontend-browserstack` |

## Selection Rules

- Prefer a domain-prefixed skill name over an old unprefixed alias.
- Use package names such as `@copilotkit/runtime` only for code/API references, not as skill names.
- If a skill's `requires` frontmatter names another skill, load the required skill first when the task depends on that foundation.
- For overlapping frontend tasks, route through `frontend-engineering` plus the narrow specialist skill.
- For overlapping backend GraphQL tasks, use `fullstack-graphql-expert` for schema/Relay design and `backend-hotchocolate-specialist` for server implementation details.

<!-- Last updated: 2026-07-06 -->
