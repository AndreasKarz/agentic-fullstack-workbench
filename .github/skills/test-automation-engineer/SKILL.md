---
name: test-automation-engineer
description: "Single entry point for UI test automation — Playwright E2E and visual tests with strict Page Object Model, general Playwright strategy (selectors/assertions/waits/flake prevention/CI), test authoring from a manual test case or URL, browser automation via playwright-cli and via the afw-playwright MCP, BrowserStack cloud-grid runs, and local webapp browser testing. Use when: create/fix/extend a Playwright test, .spec.ts, page object/POM, resilient selectors, flaky test, visual regression, cross-browser/device matrix, BrowserStack / browserstack.yml / Local tunnel / parallelization, generate a test from a flow, drive a browser through CLI or MCP for snapshots/screenshots/console/network checks, or start a local server and validate a running web app. NOT for React/UI implementation (use frontend-developer) or backend tests (use backend-developer)."
---

# Test Automation Engineer

Consolidated skill for UI test automation with Playwright, BrowserStack, and local webapp testing. Keep `SKILL.md` as the compact core; load one `references/<domain>/` guide only when the task needs that depth.

## Output style

Apply the `caveman` skill to every user-facing response (default `full`) unless the user says `stop caveman` / `normal mode`. Keep code, commands, selectors, config (`browserstack.yml`, `playwright.config.ts`), and generated `.spec.ts`/page objects in **normal precise form** — never caveman. Relax caveman for irreversible-action confirmations, then resume.

## Capabilities

Discrete units of work this skill owns (map a spec/change to one):

1. **strategy** — general Playwright strategy: selectors, assertions, waits, flake prevention, CI.
2. **test-creation** — author/maintain E2E tests with strict Page Object Model.
3. **cli-automation** — drive a browser via `playwright-cli` for inspection, screenshots, generated tests.
4. **mcp-automation** — drive a browser via the `afw-playwright` MCP for snapshots, interaction, validation.
5. **browserstack** — run Playwright on the BrowserStack cloud grid (SDK, config, Local tunnel, matrix).
6. **webapp-testing** — start a local server and validate a running web app (UI, console, network).

## Core discipline (apply without loading references)

- **Strict POM** — separate test logic (specs) from page interactions (page/component objects).
- **Resilient selectors** — prefer role- / test-id-based locators; no brittle XPath / nth-child.
- **Independent, deterministic tests** — no shared mutable state; no order dependence.
- **Grid-agnostic** — the same specs run locally and on BrowserStack; only config differs. Parameterize the base URL.
- **No scope creep** — create/run only what is requested.
- **Project structure:**

```
tests/<project>/
├── tests/            # *.spec.ts
└── pom/
    ├── pages/        # BasePage, HomePage, LoginPage …
    └── components/   # Header.component.ts, Modal.component.ts …
```

## Lazy reference loading

Do **not** read `references/` up front. Classify the task, then open the **smallest** matching guide (usually one). Each domain guide lives at `references/<domain>/<domain>.md`; larger domains keep detailed files in that folder's `references/`, `examples/`, or `scripts/` subfolder.

| Task signal | Load only |
|---|---|
| General Playwright strategy, flakes, selectors, assertions, waits, CI, test-type choice | `references/playwright-best-practices/playwright-best-practices.md` |
| Create/extend repo E2E tests with strict POM, generate from a test case/URL | `references/playwright-test-creator/playwright-test-creator.md` |
| Browser automation through `playwright-cli` (inspect, screenshot, generate) | `references/playwright-cli/playwright-cli.md` |
| Browser automation through the `afw-playwright` MCP tools | `references/playwright-mcp/playwright-mcp.md` |
| BrowserStack cloud grid: SDK, `browserstack.yml`, Local tunnel, parallelization, device matrix | `references/browserstack/browserstack.md` |
| Local webapp testing: start server, inspect UI behavior, screenshots, console/network logs | `references/webapp-testing/webapp-testing.md` |

**Reference map:** inside a domain guide, an instruction to "load the `frontend-<x>` skill" (e.g. `frontend-playwright-cli`, `frontend-playwright-test-creator`) now means **read `references/<x>/`** in this skill (drop the `frontend-` prefix).

**Out of scope (separate skills):** React/TypeScript/UI implementation → `frontend-developer`. Backend/.NET tests → `backend-developer`. Manual test-case design / ISTQB coverage → `business-testmanager`.

## Workflow

1. **Understand** — clarify the test case / user flow, target UI, and environment (base URL).
2. **Classify** — map the task to one capability above; load the matching guide only if needed.
3. **Plan** — define POM structure; decide local vs. BrowserStack.
4. **Execute** — specs + page objects; resilient selectors; independent tests.
5. **Align** — present the test result/report; confirm before irreversible actions.

## Know-how

- Playwright best practices: <https://playwright.dev/docs/best-practices>
- BrowserStack + Playwright: <https://www.browserstack.com/docs/automate/playwright>

<!-- Last updated: 2026-07-10 · Part of the Copilot Context Blueprint -->
