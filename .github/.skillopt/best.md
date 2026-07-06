# Current Skill Catalog Best Map

## Naming

- Skill folder name must match `name` in `SKILL.md` frontmatter.
- Prefer domain-prefixed names for ambiguous platform skills: `frontend-copilotkit-runtime`, `frontend-copilotkit-react-core`, `frontend-copilotkit-a2ui-renderer`.
- Keep package names such as `@copilotkit/runtime` unchanged inside technical examples.
- Central skill routing lives in `.github/instructions/skill-routing.instructions.md`.

## Canonical Clusters

| Cluster | Canonical skills |
|---|---|
| Frontend implementation | `frontend-docs-research`, `frontend-engineering`, `frontend-quality` |
| React architecture/performance | `frontend-react-composition-patterns`, `frontend-react-performance`, `frontend-react-view-transitions`, `frontend-react-native-skills` |
| Relay/GraphQL | `fullstack-graphql-expert`, `frontend-relay-best-practices`, `frontend-relay-performance` |
| CopilotKit | `frontend-copilotkit-setup`, `frontend-copilotkit-develop`, `frontend-copilotkit-debug`, `frontend-copilotkit-runtime`, `frontend-copilotkit-react-core`, `frontend-copilotkit-a2ui-renderer`, `frontend-copilotkit-agui`, `frontend-copilotkit-integrations`, `frontend-copilotkit-self-update` |
| Playwright/testing | `frontend-playwright-best-practices`, `frontend-playwright-test-creator`, `frontend-playwright-cli`, `frontend-playwright-mcp`, `frontend-browserstack` |
| Business analysis/testing requirements | `business-business-analyst`, `business-requirements-engineer`, `business-testmanager` |
| Data/reporting | `dap-database-specialist`, `dap-databricks-specialist`, `dap-powerbi-specialist` |

## Validation

Run from workspace root:

```powershell
.\.github\scripts\validate-skills.ps1
```
