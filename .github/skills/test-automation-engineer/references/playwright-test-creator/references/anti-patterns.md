# Anti-Patterns to Avoid

Critical mistakes that break tests, reduce maintainability, or violate Fusion-UI coding standards.

## Table of Contents

1. [Selector Anti-Patterns](#selector-anti-patterns)
2. [POM Anti-Patterns](#pom-anti-patterns)
3. [Test Structure Anti-Patterns](#test-structure-anti-patterns)
4. [Wait Anti-Patterns](#wait-anti-patterns)
5. [Assertion Anti-Patterns](#assertion-anti-patterns)
6. [Data Anti-Patterns](#data-anti-patterns)

## Selector Anti-Patterns

### ❌ Raw Selectors in Tests

```typescript
// ❌ WRONG - Raw selectors in test file
test('clicks submit', async ({page}) => {
  await page.click('[data-test-id="button:submit"]');
  await expect(page.locator('[data-test-id="card:result"]')).toBeVisible();
});

// ✅ CORRECT - Use POM
test('clicks submit', async ({page}) => {
  const formPage = new FormPage(page);
  await formPage.clickSubmit();
  await formPage.expectResultVisible();
});
```

### ❌ CSS Class Selectors

```typescript
// ❌ WRONG - CSS classes change frequently
this.page.locator('.submit-button');
this.page.locator('.card--primary');
this.page.locator('.m-linked-table-row');

// ✅ CORRECT - Use data-test-id
this.page.getByTestId('button:submit');
this.page.getByTestId('card:primary');
this.page.getByTestId('linked-table-row:document');
```

### ❌ XPath Selectors

```typescript
// ❌ WRONG - XPath is fragile and hard to read
this.page.locator('//div[@class="container"]/button[1]');
this.page.locator("xpath=//button[contains(@class, 'submit')]");

// ✅ CORRECT - Use test IDs
this.page.getByTestId('button:submit');
```

### ❌ Text-Based Selection for Primary Elements

```typescript
// ❌ WRONG - Text may be translated or changed
await page.getByText('Submit').click();
await page.locator('button:has-text("Save")').click();
await page.getByRole('button', {name: 'Speichern'}).click();

// ✅ CORRECT - Use test IDs
await page.getByTestId('button:submit').click();
await page.getByTestId('button:save').click();
```

**Exception**: Role-based selection is acceptable for:
- Accessibility testing
- Generic UI that lacks test IDs

### ❌ Regex in Selectors

```typescript
// ❌ WRONG - Regex makes tests brittle and hard to debug
this.page.getByTestId(/card:.*/);
this.page.locator('[data-test-id*="button"]');
await page.getByText(/Submit|Save/i).click();

// ✅ CORRECT - Exact matching
this.page.getByTestId('card:summary');
this.page.getByTestId('button:submit');
```

## POM Anti-Patterns

### ❌ No POM at All

```typescript
// ❌ WRONG - No Page Object Model
test.describe('Feature', () => {
  test('does something', async ({page}) => {
    await page.goto('/feature');
    await page.getByTestId('input:name').fill('Test');
    await page.getByTestId('button:submit').click();
    await expect(page.getByTestId('text:success')).toBeVisible();
  });
});

// ✅ CORRECT - Use POM
test.describe('Feature', () => {
  test('does something', async ({page}) => {
    const featurePage = new FeaturePage(page);
    await featurePage.open();
    await featurePage.fillName('Test');
    await featurePage.submit();
    await featurePage.expectSuccessMessage();
  });
});
```

### ❌ Duplicate POM Code

```typescript
// ❌ WRONG - Same locator defined in multiple places
class PageA {
  private submitButton() {
    return this.page.getByTestId('button:submit');
  }
}

class PageB {
  private submitButton() {
    return this.page.getByTestId('button:submit');
  }
}

// ✅ CORRECT - Extract to shared component or base class
class BasePage {
  protected submitButton() {
    return this.page.getByTestId('button:submit');
  }
}

class PageA extends BasePage {}
class PageB extends BasePage {}
```

### ❌ Awaiting Locator Methods

```typescript
// ❌ WRONG - Locator methods should return Locator, not Promise
private async submitButton() {
  await this.page.waitForSelector('[data-test-id="button:submit"]');
  return this.page.getByTestId('button:submit');
}

// ✅ CORRECT - Return Locator directly, await in action methods
private submitButton(): Locator {
  return this.page.getByTestId('button:submit');
}

async clickSubmit() {
  await this.submitButton().click();
}
```

### ❌ Exposing Internal Locators

```typescript
// ❌ WRONG - Exposing locator to tests
class FormPage {
  get submitButton() {
    return this.page.getByTestId('button:submit');
  }
}

// Test uses internal locator
test('submits', async ({page}) => {
  const form = new FormPage(page);
  await form.submitButton.click();  // Direct locator access
});

// ✅ CORRECT - Expose action methods
class FormPage {
  private submitButton() {
    return this.page.getByTestId('button:submit');
  }

  async clickSubmit() {
    await this.submitButton().click();
  }
}

test('submits', async ({page}) => {
  const form = new FormPage(page);
  await form.clickSubmit();
});
```

## Test Structure Anti-Patterns

### ❌ Importing test from @playwright/test

```typescript
// ❌ WRONG - Loses custom fixtures
import {test, expect} from '@playwright/test';

// ✅ CORRECT - Use app fixtures
import {expect} from '@playwright/test';
import {test} from '../../e2e/fixtures';
```

### ❌ Magic Strings/Numbers

```typescript
// ❌ WRONG - Hardcoded values throughout tests
await page.gotoHomePage('1e4bd230-1f34-4dcb-a572-0c2f17723919');
await expect(items).toHaveCount(5);

// ✅ CORRECT - Constants at module level
const USER_ID = '1e4bd230-1f34-4dcb-a572-0c2f17723919';
const EXPECTED_ITEM_COUNT = 5;

await page.gotoHomePage(USER_ID);
await expect(items).toHaveCount(EXPECTED_ITEM_COUNT);
```

### ❌ test.only in Committed Code

```typescript
// ❌ WRONG - Blocks other tests from running
test.only('my test', async ({page}) => {
  // ...
});

// ✅ CORRECT - Remove .only before committing
test('my test', async ({page}) => {
  // ...
});
```

**Note**: `forbidOnly: !!process.env.CI` in config catches this in CI.

### ❌ Skipped Tests Without Explanation

```typescript
// ❌ WRONG - No explanation for skip
test.skip('broken test', async ({page}) => {});

// ✅ CORRECT - Add reason as fixme or skip with comment
test.fixme('broken test - waiting for API fix', async ({page}) => {});
// or
test.skip('broken test', async ({page}) => {
  // TODO: Re-enable after backend deploy #123
});
```

## Wait Anti-Patterns

### ❌ Arbitrary Timeouts

```typescript
// ❌ WRONG - Arbitrary waits slow tests and cause flakiness
await page.waitForTimeout(3000);
await page.waitForTimeout(5000);

// ✅ CORRECT - Wait for specific conditions
await page.waitForSelector('[data-test-id="page:loaded"]');
await page.waitForLoadState('networkidle');
await expect(element).toBeVisible();
```

### ❌ Fixed Sleep for Loading

```typescript
// ❌ WRONG - Fixed sleep
await page.waitForTimeout(2000);  // Wait for data to load
await expect(table).toBeVisible();

// ✅ CORRECT - Wait for loader to disappear
await page.getByTestId('loader').waitFor({state: 'hidden', timeout: 30000});
await expect(table).toBeVisible();
```

### ❌ Not Using Auto-Waiting

```typescript
// ❌ WRONG - Manual waits before every action
await page.waitForSelector('[data-test-id="button:submit"]');
await page.getByTestId('button:submit').click();

// ✅ CORRECT - Playwright auto-waits, just use action
await page.getByTestId('button:submit').click();
```

## Assertion Anti-Patterns

### ❌ Regex in Assertions

```typescript
// ❌ WRONG - Regex makes tests fragile
await expect(title).toHaveText(/Dokumente.*/);
await expect(page).toHaveURL(/.*\/profile/);

// ✅ CORRECT - Exact matching
await expect(title).toHaveText('Dokumente');
await expect(page).toHaveURL('/profile');
```

**Exception**: URL paths with dynamic segments:
```typescript
// Acceptable for dynamic IDs
await expect(page).toHaveURL(/\/contracts\/\d+/);
```

### ❌ Missing await on Assertions

```typescript
// ❌ WRONG - Missing await causes test to pass incorrectly
test('checks visibility', async ({page}) => {
  expect(page.getByTestId('card')).toBeVisible();  // Missing await!
});

// ✅ CORRECT - Always await assertions
test('checks visibility', async ({page}) => {
  await expect(page.getByTestId('card')).toBeVisible();
});
```

### ❌ Assertions Without Context

```typescript
// ❌ WRONG - Generic assertion message on failure
await expect(items).toHaveCount(5);

// ✅ CORRECT - Use poll with descriptive variable names
const contractItems = page.getByTestId('list:contracts').locator('li');
await expect(contractItems).toHaveCount(5);

// Or use soft assertions for multiple checks
await expect.soft(items, 'Contract list should have 5 items').toHaveCount(5);
```

## Data Anti-Patterns

### ❌ Modifying Shared Test Data

```typescript
// ❌ WRONG - Test modifies data other tests depend on
test('deletes user', async ({page}) => {
  await page.getByTestId('button:delete-user').click();  // Affects other tests!
});

// ✅ CORRECT - Use test-specific data or reset state
test('deletes user', async ({page}) => {
  // Create user specifically for this test
  const userId = await createTestUser();
  await deleteUser(page, userId);
});
```

### ❌ Hardcoding Environment-Specific Data

```typescript
// ❌ WRONG - Hardcoded URLs
test('loads external content', async ({page}) => {
  await page.goto('https://localhost:3000/api/data');
});

// ✅ CORRECT - Use baseURL from config
test('loads external content', async ({page}) => {
  await page.goto('/api/data');  // Uses baseURL automatically
});
```

### ❌ Not Using Type Safety

```typescript
// ❌ WRONG - Untyped test data
const TEST_CASES = [
  {id: '123', name: 'Test', count: 5},
  {id: 456, name: 'Test2', count: '6'},  // Type mismatch!
];

// ✅ CORRECT - Use TypeScript interfaces
interface TestCase {
  id: string;
  name: string;
  count: number;
}

const TEST_CASES: TestCase[] = [
  {id: '123', name: 'Test', count: 5},
  {id: '456', name: 'Test2', count: 6},
];
```

## Summary Checklist

Before committing, verify:

- [ ] No raw selectors in test files
- [ ] All elements selected via `getByTestId()`
- [ ] No regex in selectors or assertions (unless absolutely necessary)
- [ ] Using app's `fixtures.ts`, not `@playwright/test` directly
- [ ] No `.only` or unexplained `.skip`
- [ ] No arbitrary `waitForTimeout()` calls
- [ ] All assertions have `await`
- [ ] Constants defined at module level
- [ ] POM methods encapsulate all locator access
