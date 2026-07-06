---
description: "Playwright E2E test conventions: strict Page Object Model (POM), resilient selectors, scope discipline, and project structure. Apply when creating, fixing, or extending Playwright E2E tests. Triggers: Playwright, E2E test, spec.ts, e2e.ts, Page Object, POM, UI test, browser test, Playwright test."
applyTo: "**/*.spec.ts, **/*.e2e.ts, **/e2e/**"
---

# Playwright E2E Conventions

<!-- Source: Playwright Best Practices — https://playwright.dev/docs/best-practices · Last updated: 2026-07-02 -->

## Principles

- **Strict POM** — every page/component has a Page Object. No raw selectors in test files.
- **Resilient selectors** — prefer `data-test-id` attributes (`getByTestId()`). No CSS, no XPath, no text (except absolutely necessary).
- **No scope creep** — one test tests exactly one scenario. No tests with hidden side effects.
- **Update before working** — run `playwright install` before starting new work.

## Project Structure

```
tests/<project>/
├── tests/
│   └── <feature>.spec.ts        # Test files
└── pom/
    ├── pages/
    │   └── <Feature>Page.ts     # Page Object Models (full pages)
    └── components/
        └── <Feature>Component.ts # Reusable component POs
```

## POM Pattern

```typescript
// pom/pages/ExamplePage.ts
import { Page, expect } from '@playwright/test';

export class ExamplePage {
  constructor(private readonly page: Page) {}

  async navigate() {
    await this.page.goto('/example');
  }

  async clickSubmit() {
    await this.page.getByTestId('button:submit').click();
  }

  async expectSuccessVisible() {
    await expect(this.page.getByTestId('alert:success')).toBeVisible();
  }
}
```

```typescript
// tests/example.spec.ts
import { test } from '@playwright/test';
import { ExamplePage } from '../pom/pages/ExamplePage';

test('submits form successfully', async ({ page }) => {
  const examplePage = new ExamplePage(page);
  await examplePage.navigate();
  await examplePage.clickSubmit();
  await examplePage.expectSuccessVisible();
});
```

## Selectors — Priority Order

1. `getByTestId('...')` — always preferred
2. `getByRole(...)` — for accessibility-relevant elements
3. `getByLabel(...)` — for form fields
4. `getByText(...)` — only when no test-id is available and text is stable
5. CSS / XPath — **forbidden** (except absolute edge case, documented)

## Test-ID Convention

```
<type>:<context>   → e.g. "button:submit", "card:contract-summary", "input:email"
```

## Anti-Patterns

| Anti-Pattern | Alternative |
|---|---|
| Selectors directly in test | Always use POM |
| `page.locator('.css-class')` | `page.getByTestId(...)` |
| `page.waitForTimeout(2000)` | `await expect(locator).toBeVisible()` |
| Multiple pages in one test | Separate tests |
| `page.fill('#id', ...)` | POM method + `getByTestId` |

## Assertions

```typescript
// ✅ Explicit
await expect(page.getByTestId('heading:title')).toHaveText('Overview');
await expect(page.getByTestId('list:items')).toHaveCount(3);

// ❌ Too vague
await expect(page.getByTestId('heading:title')).toBeVisible();
```

## BrowserStack Integration (optional)

When using BrowserStack as cloud grid:
- Configure capabilities via `browserstack.yml` or SDK
- Local tunnel for internal endpoints (`BrowserStackLocal`)
- Cross-browser matrix (Chrome, Firefox, Safari, Edge) + mobile devices
- Parallel execution via `workers` configuration in `playwright.config.ts`

> Load the `frontend-browserstack` skill for details on BrowserStack integration.


<!-- Last updated: 2026-07-02 · Part of the Copilot Context Blueprint -->
