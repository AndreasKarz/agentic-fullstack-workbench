---
name: frontend-docs-research
description: "Frontend documentation research workflow. Use before every new frontend task to refresh current guidance via the `microsoft-docs` MCP server, then supplement with official library docs when needed. Triggers on: frontend task, React, TypeScript, Vite, Relay, component library, CopilotKit, browser APIs, accessibility, performance, testing, build tooling, current best practices."
---

# Frontend Docs Research

Refresh current guidance before frontend implementation so decisions use live documentation, local code, and project constraints together.

## Required First Step

For every new frontend task:

1. Load this skill before implementation work
2. Identify touched technologies from `package.json`, imports, and affected files
3. Use the `microsoft-docs` MCP server first:
   - Search with `microsoft_docs_search`
   - Fetch full pages with `microsoft_docs_fetch` when excerpts are insufficient
4. Produce a short **Docs Refresh** note: what changed or what current guidance matters for the task
5. If `microsoft-docs` tools are unavailable, state that limitation and continue from local repo evidence plus other official docs only when the task can still be completed safely

## Query Strategy

Use targeted queries that include the concrete task, version, and platform where possible.

| Task Area | `microsoft-docs` query examples |
|---|---|
| React + TypeScript implementation | `React TypeScript web app best practices Microsoft Learn` |
| Accessibility | `web accessibility keyboard navigation ARIA Microsoft Learn` |
| Frontend performance | `JavaScript web performance browser rendering Microsoft Learn` |
| Testing | `React testing TypeScript web app Microsoft Learn` |
| Azure-hosted frontend/API integration | `Azure Static Web Apps React authentication best practices` |
| Observability | `Application Insights JavaScript React telemetry best practices` |
| Authentication/token flow | `SPA authentication OAuth PKCE Microsoft identity platform best practices` |
| Build/deployment | `Vite React Azure App Service Static Web Apps deployment` |

For non-Microsoft libraries, use Microsoft Docs as the mandatory starting point, then supplement with official vendor docs or local project skills:

| Library | Preferred follow-up source |
|---|---|
| Relay | `frontend-developer` Relay references and official Relay docs |
| Component library | Component library MCP/docs if available; otherwise inspect existing local usage |
| CopilotKit | Existing local integration and official CopilotKit docs where available |
| Vite/Vitest/Biome | Local configuration first, official docs for version-sensitive behavior |

## Research Output Format

Keep research terse and practical:

```markdown
Docs Refresh:
- Microsoft Docs confirms <relevant guidance> for <task area>.
- Local project uses <version/pattern>, so implementation should <action>.
- No docs conflict found / conflict resolved by following local project convention.
```

Do not paste long documentation excerpts unless the user asks for them.

## Decision Rules

- Local code wins for established project conventions
- Microsoft Docs wins for Microsoft platform, identity, hosting, Azure, observability, browser/security guidance
- Official library docs win for library-specific APIs when Microsoft Docs does not cover them
- Package versions in `src/frontend/package.json` win over memory
- If docs and local patterns conflict, explain the trade-off and choose the lower-risk local-compatible implementation

# Anti-Patterns

| Anti-Pattern | Why It's Wrong | Fix |
|---|---|---|
| Coding from memory on a new task | Practices drift quickly across React, TypeScript, auth, and tooling | Query `microsoft-docs` first |
| Broad generic searches | Results are vague and hard to apply | Include task, library, version, and platform |
| Treating Microsoft Docs as the only source for non-Microsoft APIs | It may not cover Relay, your component library, or CopilotKit details | Use official library docs and local code after Microsoft Docs |
| Ignoring package versions | Examples may target incompatible APIs | Verify versions in `package.json` |
| Copying tutorial code directly | Tutorials may not match local architecture | Adapt to your project's patterns |
| Hiding unavailable MCP tools | Creates false confidence | Report the limitation clearly |

# Important Rules

- Use `microsoft-docs` first for every new frontend task
- Fetch full docs only when search snippets do not provide enough implementation guidance
- Keep the docs summary short and connected to the code change
- Never let external examples override established local architecture without explanation
- Do not block simple safe edits forever if docs tools are down; report the gap and proceed carefully
