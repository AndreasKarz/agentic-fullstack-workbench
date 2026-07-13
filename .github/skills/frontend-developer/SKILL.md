---
name: frontend-developer
description: "Single entry point for frontend web/mobile development — React 19 + TypeScript + Vite engineering, Relay GraphQL client (fragments/queries/mutations + performance), React performance, composition patterns, React Native/Expo, View Transitions, Formik/Yup forms, Component Design System + CSS Modules UI, UX/accessibility/calm design, web-design audit, mandatory docs research, and frontend validation/quality. Use when: implement/refactor/debug a React or React Native feature, TypeScript UI, Vite config/plugin/SSR, Relay fragment/query/mutation/pagination/fetch-policy, re-render/bundle/waterfall performance, compound components/render props/component API, View Transition animation, Formik form, CSS/layout/spacing/color/visual polish, UX flow/accessibility/AI-UX, a11y/design audit, or validating frontend changes (typecheck/Biome/Vitest/Relay compiler/build/browser). NOT for CopilotKit (use the copilotkit-developer skill) or E2E/browser test automation (use test-automation-engineer)."
---

# Frontend Developer

Consolidated skill for building this project's frontend (React 19, TypeScript, Vite, Relay, Component Design System). Keep `SKILL.md` as the compact core; load one `references/<domain>/` guide only when the task needs that depth.

## Output style

Apply the `caveman` skill to every user-facing response (default `full`) unless the user says `stop caveman` / `normal mode`. Keep code, commands, config, GraphQL, commit/PR text, and generated artifacts in **normal precise form** — never caveman. Relax caveman for security warnings and irreversible-action confirmations, then resume.

## Capabilities

Discrete units of work this skill owns (map a spec/change to one):

1. **docs-research** — refresh current guidance before a new task (mandatory first step).
2. **engineering** — React 19 + TypeScript + Vite feature implementation, routing, state.
3. **relay** — Relay data flow correctness and performance.
4. **react-performance** — re-renders, waterfalls, bundle size, memoization.
5. **react-composition** — compound components, render props, component API design.
6. **react-native** — React Native / Expo mobile features.
7. **view-transitions** — React View Transition API animations.
8. **vite** — build tool config, plugins, SSR, library builds.
9. **forms** — Formik / Yup form state, validation, typed submits.
10. **ui-design** — CSS Modules, layout, brand colors, visual polish.
11. **ux-design** — UX flows, accessibility, calm design, React Aria, AI-UX.
12. **web-design-audit** — a11y / UX / design guideline review.
13. **quality** — validation: typecheck, Biome, Vitest, Relay compiler, build, browser.

## Baseline stack

Read `package.json` before version-sensitive work. Current baseline: Node 24 + Yarn 4, React 19, Vite, TypeScript 5.9, Relay 20, your Component Design System, MDX/Monaco/Mermaid/React Flow, Vitest + Testing Library + jsdom, Biome. App root typically `src/frontend/`.

## Lazy reference loading

Do **not** read `references/` up front. Classify the task, then open the **smallest** matching guide (usually one). Each domain guide lives at `references/<domain>/<domain>.md`; large domains keep detailed files in that folder's `rules/` or `references/` subfolder.

| Task signal | Load only |
|---|---|
| Starting any new frontend task (docs refresh via `microsoft-docs`) | `references/docs-research/docs-research.md` |
| React/TS/Vite/routing/state feature implementation | `references/engineering/engineering.md` |
| Relay fragments/queries/mutations correctness | `references/relay-best-practices/relay-best-practices.md` |
| Relay fetch policy, pagination, render/data performance | `references/relay-performance/relay-performance.md` |
| React re-renders, waterfalls, bundle size, memoization, Suspense | `references/react-performance/react-performance.md` |
| Compound components, render props, boolean-prop avoidance, component API | `references/react-composition-patterns/react-composition-patterns.md` |
| React Native / Expo, mobile lists, animations, native APIs | `references/react-native/react-native.md` |
| View Transition API, shared-element / route transitions | `references/react-view-transitions/react-view-transitions.md` |
| Vite config, plugins, SSR, library/build behavior | `references/vite/vite.md` |
| Formik / Yup forms, validation schemas, submit handling | `references/formik-patterns/formik-patterns.md` |
| CSS, layout, spacing, colors, visual polish, screenshot validation | `references/ui-designer/ui-designer.md` |
| UX flow, accessibility concept, calm design, React Aria, AI-UX | `references/ux-designer/ux-designer.md` |
| a11y / UX / design audit checklist | `references/web-design-guidelines/web-design-guidelines.md` |
| Validation: typecheck, Biome, Vitest, Relay compiler, build, browser | `references/quality/quality.md` |

**Reference map:** inside a domain guide, an instruction to "load the `frontend-<x>` skill" now means **read `references/<x>/`** in this skill. Domain suffixes map directly (e.g. `frontend-ui-designer` → `references/ui-designer/`, `frontend-react-native-skills` → `references/react-native/`).

**Cross-skill work:** GraphQL server/schema → `backend-developer`; combine it with this skill's Relay references for end-to-end GraphQL changes. CopilotKit → `copilotkit-developer`. E2E/browser test automation → `test-automation-engineer`.

## Core rules (apply without loading references)

- **Read before writing** — inspect the nearest component, CSS module, test, and generated Relay types first. Trust the codebase over memory; verify versions in `package.json`.
- **Docs refresh** — on a new task, query the `microsoft-docs` MCP server first (`references/docs-research`), summarize findings in 1–3 bullets, then implement.
- **React/TS** — function components with explicit exported prop interfaces; `import type` for type-only imports; keep state local; `useMemo`/`useCallback` only when they stabilize expensive work or prop identity; clean up async work/subscriptions/timers/object URLs in effects; avoid `any`.
- **Relay** — `useLazyLoadQuery` only at route/page entry; colocate a fragment (typed via generated `$key`) in each component that shows GraphQL data; parents spread child fragments; never build global IDs by hand; run `yarn relay` after fragment/query/mutation/schema changes; never edit `src/__generated__/`.
- **UI** — prefer Component Design System components over custom HTML; styles in `<Component>.module.css`; CSS custom properties for colors; include loading/empty/disabled/error/focus states.
- **Accessibility** — keyboard-reachable interactive elements, visible focus, accessible names for icon-only buttons, never color alone for state.
- **Validation** — smallest check that covers the risk first (`yarn typecheck` → `yarn check` → focused `yarn test` → `yarn relay` → `yarn verify` → `yarn build`); report only checks that actually ran; browser-check UI/interaction changes.
- **Never** — edit generated files/schema by hand, fetch backend GraphQL with raw fetch (use Relay), or hardcode colors.

## Workflow

1. **Refresh** — `references/docs-research`: identify touched tech, query `microsoft-docs`, note current guidance.
2. **Classify** — map the task to one capability above; load the matching domain guide only if needed.
3. **Implement** — small, local-pattern-conform edits; design system + Relay fragments; scoped to the request.
4. **Validate** — `references/quality`: narrowest useful checks, `yarn relay` after GraphQL edits, browser evidence for UX changes.
5. **Align** — present result; confirm before irreversible actions.

<!-- Last updated: 2026-07-10 · Part of the Copilot Context Blueprint -->
