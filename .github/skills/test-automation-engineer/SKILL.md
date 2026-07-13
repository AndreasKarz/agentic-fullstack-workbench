---
name: test-automation-engineer
description: "Single entry point for acceptance testing and UI test automation — derive deterministic manual cases and coverage from OpenSpec scenarios, prepare explicitly approved ADO Test Plan cases, and implement Playwright E2E/visual tests with strict Page Object Model, BrowserStack, CLI/MCP browser automation, and local webapp validation. Use when: assess requirement testability; design ISTQB-style positive, negative, boundary, decision-table, or state-transition cases; create a coverage matrix or ADO test case; create/fix a Playwright spec or POM; diagnose flakes/selectors; run visual, cross-browser, BrowserStack, console, network, or local browser checks. NOT for React/UI implementation (use frontend-developer) or backend tests (use backend-developer)."
---

# Test Automation Engineer

Consolidated skill for UI test automation with Playwright, BrowserStack, and local webapp testing. Keep `SKILL.md` as the compact core; load one `references/<domain>/` guide only when the task needs that depth.

## Output style

Apply the `caveman` skill to every user-facing response (default `full`) unless the user says `stop caveman` / `normal mode`. Keep code, commands, selectors, config (`browserstack.yml`, `playwright.config.ts`), and generated `.spec.ts`/page objects in **normal precise form** — never caveman. Relax caveman for irreversible-action confirmations, then resume.

## Capabilities

Discrete units of work this skill owns (map a spec/change to one):

1. **acceptance-design** — assess OpenSpec requirement/scenario testability; derive deterministic manual cases, risk coverage, and an ADO-ready coverage matrix.
2. **strategy** — general Playwright strategy: selectors, assertions, waits, flake prevention, CI.
3. **test-creation** — author/maintain E2E tests with strict Page Object Model.
4. **cli-automation** — drive a browser via `playwright-cli` for inspection, screenshots, generated tests.
5. **mcp-automation** — drive a browser via the `playwright` MCP for snapshots, interaction, validation.
6. **browserstack** — run Playwright on the BrowserStack cloud grid (SDK, config, Local tunnel, matrix).
7. **webapp-testing** — start a local server and validate a running web app (UI, console, network).

## Core discipline (apply without loading references)

- **Strict POM** — separate test logic (specs) from page interactions (page/component objects).
- **OpenSpec first** — requirements and Given/When/Then scenarios are the source for acceptance coverage. Resolve ambiguity in OpenSpec before designing or automating tests.
- **Risk-based coverage** — combine equivalence partitions, boundaries, decision tables, and state transitions only where they add distinct coverage. Include positive, negative, and edge cases according to risk.
- **Deterministic cases** — every manual step has one concrete, observable expected result; never write "works correctly". Keep objective, preconditions, test-data needs, and requirement/scenario traceability.
- **ADO requires approval** — inspect existing `Tested By` links first; create or modify selected test cases only after explicit confirmation. Preserve existing tags and links.
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
| Manual acceptance cases, coverage matrix, ADO Test Plan | Use the core OpenSpec/ISTQB rules above; load automation references only after cases are confirmed |
| General Playwright strategy, flakes, selectors, assertions, waits, CI, test-type choice | `references/playwright-best-practices/playwright-best-practices.md` |
| Create/extend repo E2E tests with strict POM, generate from a test case/URL | `references/playwright-test-creator/playwright-test-creator.md` |
| Browser automation through `playwright-cli` (inspect, screenshot, generate) | `references/playwright-cli/playwright-cli.md` |
| Browser automation through the `playwright` MCP tools | `references/playwright-mcp/playwright-mcp.md` |
| BrowserStack cloud grid: SDK, `browserstack.yml`, Local tunnel, parallelization, device matrix | `references/browserstack/browserstack.md` |
| Local webapp testing: start server, inspect UI behavior, screenshots, console/network logs | `references/webapp-testing/webapp-testing.md` |

**Reference map:** inside a domain guide, an instruction to "load the `frontend-<x>` skill" (e.g. `frontend-playwright-cli`, `frontend-playwright-test-creator`) now means **read `references/<x>/`** in this skill (drop the `frontend-` prefix).

**Cross-skill work:** React/TypeScript/UI implementation → `frontend-developer`. Backend/.NET tests → `backend-developer`. Acceptance decisions remain in OpenSpec even when cases are later copied to ADO.

## Workflow

1. **Understand** — read the active OpenSpec artifacts; clarify risk, target level, UI, and environment.
2. **Design** — flag non-testable scenarios; derive non-redundant cases and a requirement/scenario coverage matrix.
3. **Confirm** — let the user select cases before creating ADO records or automation outside the agreed scope.
4. **Automate** — load the smallest matching guide; implement specs plus page objects with resilient selectors.
5. **Validate** — run focused checks and report evidence, gaps, and residual risk.

## Know-how

- Playwright best practices: <https://playwright.dev/docs/best-practices>
- BrowserStack + Playwright: <https://www.browserstack.com/docs/automate/playwright>

<!-- Last updated: 2026-07-10 · Part of the Copilot Context Blueprint -->
