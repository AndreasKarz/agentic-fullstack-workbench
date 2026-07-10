# Current Skill Catalog Best Map

## Naming

- Skill folder name must match `name` in `SKILL.md` frontmatter.
- Prefer domain-prefixed names for ambiguous platform skills: `copilotkit-developer` consolidates the former `frontend-copilotkit-*` skills under `references/<domain>/`.
- Keep package names such as `@copilotkit/runtime` unchanged inside technical examples.
- Central skill routing lives in `.github/instructions/skill-routing.instructions.md`.

## Canonical Clusters

| Cluster | Canonical skills |
|---|---|
| Frontend implementation | `frontend-developer` (compact core + `references/<domain>/`: docs-research, engineering, quality) |
| React architecture/performance | `frontend-developer` → `references/{react-composition-patterns,react-performance,react-view-transitions,react-native}/` |
| Relay/GraphQL | `fullstack-graphql-expert`; `frontend-developer` → `references/{relay-best-practices,relay-performance}/` |
| CopilotKit | `copilotkit-developer` → `references/{setup,develop,react-core,runtime,agui,integrations,a2ui-renderer,debug,self-update}/` |
| Playwright/testing | `test-automation-engineer` → `references/{playwright-best-practices,playwright-test-creator,playwright-cli,playwright-mcp,browserstack,webapp-testing}/` |
| Business analysis/testing requirements | `business-business-analyst`, `business-requirements-engineer`, `business-testmanager` |
| Data/reporting | `dap-engineer` → `references/{database-specialist,databricks-specialist,powerbi-specialist}/` |

## Validation

Run from workspace root:

```powershell
.\.github\scripts\validate-skills.ps1
```
