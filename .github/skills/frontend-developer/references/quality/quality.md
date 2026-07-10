---
name: frontend-quality
description: "Frontend validation and quality workflow. Use when checking React/TypeScript changes with Relay compiler, Biome, TypeScript, Vitest, Vite build, dev environment, browser validation, accessibility, console/network checks, and visual verification."
---

# Frontend Quality

Validate frontend changes with the smallest checks that cover the actual risk, then broaden when the change touches shared workflows.

## Validation Decision Table

| Change Type | Minimum validation |
|---|---|
| Type-only or small component logic | `yarn typecheck` plus focused test if behavior changed |
| Formatting/lint-sensitive change | `yarn check` |
| Relay fragment/query/mutation | `yarn relay`, then `yarn typecheck` |
| CSS/layout/visual change | Browser screenshot workflow via `frontend-ui-designer` skill |
| User interaction/form behavior | Focused Vitest/Testing Library test plus browser smoke check if practical |
| Shared provider/routing/auth change | `yarn verify`, focused tests, and browser navigation check |
| Build/tooling change | `yarn build` plus relevant config-specific checks |

## Commands

Run from `src/frontend/`.

```bash
yarn relay
yarn typecheck
yarn check
yarn test --run
yarn verify
yarn build
```

Use focused commands first. Avoid full builds for tiny edits unless the changed surface justifies it.

## Test Workflow

1. Prefer `runTests` for relevant test files when the tool supports the project
2. Otherwise run focused Vitest tests from `src/frontend/`
3. Add tests for changed public component behavior, regressions, and non-trivial branching
4. Use Testing Library queries by role, label, and visible text over implementation details
5. Avoid brittle snapshots unless the project already uses them for the same component type

## Browser Validation

Load `dev-environment` for Aspire/browser work and `frontend-ui-designer` for visual checks.

1. Confirm the frontend and API services are running through the Aspire workflow
2. Open the frontend URL, typically `http://localhost:3000`
3. Navigate to the affected screen
4. Check the changed happy path and at least one relevant edge state
5. Inspect console and network errors when behavior looks wrong
6. Take screenshots for visual changes and iterate until the UI passes the client-demo bar

## Accessibility Checks

- Verify keyboard reachability for every new interactive element
- Preserve visible focus states
- Use accessible names for icon-only buttons
- Do not rely on color alone for state
- Ensure loading and error states are perceivable
- Prefer your component library components because they carry React Aria behavior

## Reporting Validation

Report what actually ran and what did not run:

```markdown
Validation:
- `yarn relay` passed.
- `yarn typecheck` passed.
- Browser smoke checked the workspace flow at `http://localhost:3000`.
```

If a check cannot run, say why and what risk remains.

# Anti-Patterns

| Anti-Pattern | Why It's Wrong | Fix |
|---|---|---|
| Saying tests passed without running them | Misleads the user | Report only executed checks |
| Running only typecheck after UI behavior changes | TypeScript does not prove interaction correctness | Add focused tests or browser checks |
| Skipping `yarn relay` after GraphQL edits | Generated types drift from source | Run Relay compiler |
| Ignoring browser console errors | User-visible bugs can pass build checks | Inspect console/network for UI changes |
| Validating only the happy path | Empty/error states often break enterprise workflows | Check relevant edge states |
| Using implementation-detail test selectors first | Tests become brittle | Prefer accessible queries |
| Full build as the only check | Slow and imprecise | Start focused, then broaden by risk |

# Important Rules

- Load `frontend-quality` before declaring frontend work complete
- Use `dev-environment` for browser and Aspire validation
- Use `frontend-ui-designer` for screenshot-based visual quality gates
- Run `yarn relay` for every Relay or GraphQL source change
- Report executed validation commands exactly
- Mention skipped checks and residual risk plainly

<!-- Last updated: 2026-07-02 · Part of the Copilot Context Blueprint -->