---
name: frontend-playwright-test-creator
description: Creates and maintains E2E UI tests using Playwright with strict Page Object Model (POM) patterns for the Fusion-UI monorepo. Use when: (1) Creating new E2E tests, (2) Extending existing Page Object Models, (3) Fixing or updating Playwright tests, (4) Adding test coverage for UI features, (5) Working with files in `**/e2e/**` directories, (6) User mentions Playwright, E2E tests, or UI testing.
---

# Playwright Test Creator

Create and maintain E2E tests using Playwright with strict POM patterns for Fusion-UI.

## Pre-Flight Checklist

Before starting ANY Playwright work:

1. **Update Playwright** - Always run `yarn playwright install` first
2. **Analyze the UI** - Read the component source code to understand:
   - Available `data-test-id` attributes
   - Component structure and interactions
   - Expected behaviors
3. **Check existing POMs** - Search for existing Page Objects before creating new ones
4. **Learn from existing tests** - Read similar tests in the same feature area

## Directory Structure

```
<app-or-widget>/
└── src/
    └── <feature>/
        └── e2e/
            ├── pom/
            │   └── <feature>Page.ts    # Page Object Model
            └── <feature>.e2e.ts        # Test file
```

## Core Rules

### 1. Strict POM Usage

Every test MUST use Page Object Model. Never write raw Playwright selectors directly in test files.

```typescript
// ✅ CORRECT - Use POM
const overview = new WmOverviewPage(page);
await overview.openContract({userId, contractNumber});
await overview.expectCardVisible('contractSummary');

// ❌ WRONG - Raw selectors in tests
await page.click('[data-test-id="button:submit"]');
await expect(page.locator('[data-test-id="card:summary"]')).toBeVisible();
```

### 2. Selection via data-test-id ONLY

Always use `getByTestId()` with `data-test-id` attributes. Never use CSS selectors, XPath, or text content for primary selection.

```typescript
// ✅ CORRECT
this.page.getByTestId('button:submit');
this.page.getByTestId('card:contract-summary');

// ❌ WRONG
this.page.locator('.submit-button');
this.page.locator('//button[@class="submit"]');
this.page.getByText('Submit');
```

### 3. No Regex (Except Absolute Necessity)

Avoid regex in selectors and assertions. Use exact matching.

```typescript
// ✅ CORRECT
await expect(title).toHaveText('Dokumente');
await page.getByTestId('button:submit');

// ❌ AVOID
await expect(title).toHaveText(/Dokumente.*/);
await page.getByTestId(/button:.*/);
```

### 4. Test ID Naming Convention

Pattern: `<type>:<name>` or `<type>:<context>-<name>`

| Type | Usage |
|------|-------|
| `page:` | Page containers |
| `card:` | Card components |
| `button:` | Buttons |
| `link:` | Links |
| `input:` | Input fields |
| `dialog:` | Modal dialogs |
| `select:` | Dropdowns |
| `checkbox:` | Checkboxes |
| `heading:` | Headings |
| `text:` | Text elements |
| `table:` | Tables |

## POM Pattern

See [references/pom-patterns.md](references/pom-patterns.md) for complete POM implementation guide.

### Basic POM Structure

```typescript
import {type Locator, type Page, expect} from '@playwright/test';

export class FeaturePage {
  constructor(private readonly page: Page) {}

  // Locator methods (private)
  private submitButton(): Locator {
    return this.page.getByTestId('button:submit');
  }

  // Action methods (public)
  async clickSubmit() {
    await this.submitButton().click();
  }

  // Assertion methods (public, prefixed with expect)
  async expectSubmitVisible() {
    await expect(this.submitButton()).toBeVisible();
  }
}
```

### Extending BasePage

For pages with navigation, extend `BasePage`:

```typescript
import {BasePage} from '../../../../shared/playwright-pom/basePage';

export class ProfileOverviewPage extends BasePage {
  constructor(page: Page) {
    super(page);
  }

  async open(userId: string) {
    await this.gotoHomePage(userId);
    await this.page.getByTestId('link:profile').click();
    await this.waitForPage('page:profile-overview');
  }
}
```

## Test Pattern

See [references/test-patterns.md](references/test-patterns.md) for complete test writing guide.

### Basic Test Structure

```typescript
import {expect} from '@playwright/test';
import {test} from '../../e2e/fixtures';
import {FeaturePage} from './pom/featurePage';

test.describe('Feature Name', () => {
  test('should perform expected behavior', async ({page}) => {
    const featurePage = new FeaturePage(page);
    await featurePage.open();
    await featurePage.expectElementVisible();
  });
});
```

### Data-Driven Tests

```typescript
const TEST_CASES = [
  {input: 'value1', expected: 'result1'},
  {input: 'value2', expected: 'result2'},
] as const;

for (const {input, expected} of TEST_CASES) {
  test(`should handle ${input}`, async ({page}) => {
    // test implementation
  });
}
```

## Custom Fixtures

Always import `test` from the app's fixtures file:

```typescript
import {test} from '../../e2e/fixtures';  // NOT from @playwright/test
```

Available fixture methods:
- `page.gotoHomePage(userId)` - Navigate to home with user impersonation
- `page.impersonate(userId).contract(contractNumber).goto()` - Navigate to contract
- `page.waitForPageFullyLoaded(testId)` - Wait for page with `[data-loaded]`

## GraphQL Route Mocking

For tests requiring specific data:

```typescript
async function registerGraphqlRoutes(page: Page) {
  await page.route('**/graphql', async (route) => {
    const request = route.request();
    const postData = request.postData();
    
    if (postData?.includes('queryName')) {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(FIXTURE_DATA),
      });
      return;
    }
    
    await route.continue();
  });
}
```

## Screenshot Testing

```typescript
// Page screenshot
await expect(page.getByTestId('page:overview')).toHaveScreenshot('overview.png');

// Component screenshot with tolerance
await expect(cardLocator).toHaveScreenshot('card.png', {
  maxDiffPixelRatio: 0.03,
});
```

## Anti-Patterns

See [references/anti-patterns.md](references/anti-patterns.md) for complete list.

Critical mistakes to avoid:
- ❌ Raw selectors in test files
- ❌ Regex in selectors/assertions
- ❌ CSS class or XPath selectors
- ❌ `getByText()` for primary selection
- ❌ Hardcoded waits (`waitForTimeout`)
- ❌ Duplicate POM code

## Workflow

1. **Identify feature** - Determine which feature/component to test
2. **Check existing POMs** - Search `**/e2e/pom/*.ts` for existing models
3. **Analyze UI** - Read component code, identify `data-test-id` attributes
4. **Extend or create POM** - Add methods to existing POM or create new one
5. **Write test** - Use POM methods exclusively
6. **Run locally** - `yarn playwright test --headed <file>`
7. **Verify** - Check test passes consistently

## Commands

```bash
# Update Playwright (ALWAYS FIRST)
yarn playwright install

# Run specific test file
yarn playwright test <path-to-test>.e2e.ts

# Run with browser visible
yarn playwright test --headed

# Run with debug
yarn playwright test --debug

# Generate report
yarn playwright show-report

<!-- Last updated: 2026-07-02 · Part of the Copilot Context Blueprint -->