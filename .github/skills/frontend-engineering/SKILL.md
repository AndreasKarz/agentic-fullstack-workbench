---
name: frontend-engineering
description: "Frontend engineering workflow for React 19, TypeScript, Vite, Relay, Component Design System, CopilotKit, MDX, Monaco, Mermaid, React Flow, routing, state, forms, and browser integration. Use when implementing, refactoring, or debugging frontend code."
---

# Frontend Engineering

Implement frontend changes using the current project architecture and existing local patterns.

## Baseline Stack

Read `package.json` before version-sensitive work. Current baseline:

| Concern | Project choice |
|---|---|
| Runtime/package manager | Node 24, Yarn 4 |
| UI runtime | React 19 |
| Build/dev server | Vite |
| Language | TypeScript 5.9 |
| GraphQL client | Relay 20 |
| Component library | Your Component Design System (e.g. `@your-org/ui-kit` or similar) |
| AI integration | CopilotKit v2 |
| Rich content | MDX, Monaco, Mermaid, React Flow |
| Tests | Vitest + Testing Library + jsdom |
| Formatting/linting | Biome shared config |

## Implementation Workflow

Follow these steps in order.

## Step 1: Read Local Context

1. Inspect the nearest component, CSS module, test, and generated Relay types before editing
2. Check `package.json`, `vite.config.ts`, `relay.config.json`, and existing feature folders when the task touches tooling or data flow
3. Prefer existing feature folder structure under `src/components/<feature>/`
4. Use local examples over generic snippets

## Step 2: Choose the Right Pattern

| Need | Pattern |
|---|---|
| GraphQL data on a page | Route/page-level query with child fragment spreads |
| Data inside a child component | Colocated Relay fragment plus generated `$key` type |
| REST call to backend | `authFetch` with `apiUrl` helpers |
| Shared workspace/session state | Existing context providers before creating new ones |
| UI controls | Your component library components before custom HTML |
| Icons | Existing library usage, primarily Tabler icons unless your component library provides the icon |
| Styling | CSS Modules next to the component |
| Long-running render state | Suspense, loading state, error state, and cleanup-aware effects |

## Step 3: Implement React + TypeScript

- Use function components and explicit exported prop interfaces
- Use `import type` for type-only imports
- Keep state as close as possible to the component that owns it
- Use `useMemo` and `useCallback` only when they stabilize expensive work or important prop identity
- Use cleanup in effects that start async work, subscriptions, timers, object URLs, or external resources
- Keep render logic readable; extract a component when branching hides the main flow
- Avoid `any`; model unknown external data with narrow types or Zod where validation is needed

## Step 4: Implement Relay Correctly

Load `fullstack-graphql-expert` for GraphQL/Relay work. Key frontend rules:

- Use `useLazyLoadQuery` only at page or route entry points
- Give each component that displays GraphQL data its own fragment
- Type fragment props with generated `$key` types
- Let parents spread child fragments instead of fetching child fields directly
- Never parse or construct Relay global IDs manually
- Run `yarn relay` after fragment, query, mutation, or schema changes
- Do not edit files under `src/__generated__/`

## Step 5: Implement Component Library + CSS Modules

Load `frontend-ui-designer` for CSS, layout, visual quality, colors, or component sizing.

- Prefer your component library's components and their accessibility behavior
- Put component styles in `<Component>.module.css`
- Use CSS custom properties for colors (e.g. `var(--color-primary)`)
- Use `gap` for layout spacing where possible
- Handle long user-generated text with overflow rules
- Include loading, empty, disabled, error, and focus states when relevant

## Step 6: Implement CopilotKit Features

Load `frontend-ux-designer` for AI interaction design.

- Keep `CopilotKitProvider` integration aligned with `App.tsx`
- Pass task/session/workspace context through existing provider properties when possible
- Keep critical AI actions human-confirmed
- Ensure the app remains usable when AI requests fail
- Avoid hiding business-critical state inside chat-only interactions

## Local File Map

| Path | Purpose |
|---|---|
| `src/App.tsx` | App providers: Relay, component library router, CopilotKit, workspace context |
| `src/RelayEnvironment.ts` | Relay network/store setup |
| `src/components/` | Feature components and CSS modules |
| `src/__generated__/` | Relay generated artifacts; do not edit |
| `src/schema.graphql` | Generated backend schema; do not edit manually |
| `src/vite.config.ts` | Vite, proxy, MDX, Relay, test config |

# Anti-Patterns

| Anti-Pattern | Why It's Wrong | Fix |
|---|---|---|
| Creating a new state provider for local state | Adds global complexity | Keep state local or reuse existing context |
| Calling backend GraphQL with raw fetch | Bypasses Relay store and generated types | Use Relay |
| Using `useLazyLoadQuery` in leaf components | Creates data waterfalls and breaks colocation | Use fragments in children |
| Adding `any` to satisfy TypeScript | Removes safety where UI code needs it most | Model types precisely or narrow unknown data |
| Ignoring async cleanup in effects | Causes stale updates and leaks | Use cancellation flags or abortable APIs |
| Inline CSS for real component styling | Bypasses CSS Modules and design tokens | Move styles to a module |
| Custom form/list controls before your component library | Rebuilds accessibility poorly | Use component library first |
| Manual auth token handling in frontend code | Duplicates dev proxy/provider behavior | Use `authFetch`, existing providers, and configured proxy |

# Important Rules

- Load `frontend-docs-research` before implementation on a new frontend task
- Load `fullstack-graphql-expert` for Relay or GraphQL changes
- Load `frontend-ux-designer` for interaction design, accessibility decisions, and AI-UX
- Load `frontend-ui-designer` for CSS, layout, brand colors, and visual validation
- Keep implementation aligned with local package versions and existing component patterns
- Do not edit generated files or schema artifacts by hand
- Prefer focused, tested changes over broad component rewrites

<!-- Last updated: 2026-07-02 · Part of the Copilot Context Blueprint -->