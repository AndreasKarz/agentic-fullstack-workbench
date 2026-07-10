# Test Patterns

Comprehensive guide for writing E2E tests in Fusion-UI.

## Table of Contents

1. [File Structure](#file-structure)
2. [Test Setup](#test-setup)
3. [Basic Test Structure](#basic-test-structure)
4. [Data-Driven Tests](#data-driven-tests)
5. [Navigation Patterns](#navigation-patterns)
6. [GraphQL Mocking](#graphql-mocking)
7. [Screenshot Testing](#screenshot-testing)
8. [Dialog Testing](#dialog-testing)
9. [Form Testing](#form-testing)
10. [Table Testing](#table-testing)

## File Structure

```
src/
└── <feature>/
    └── e2e/
        ├── pom/
        │   └── <feature>Page.ts
        ├── <feature>.e2e.ts
        └── <feature>.<scenario>.e2e.ts
```

Naming conventions:
- Test files: `<feature>.e2e.ts`
- Special user tests: `<feature>.newUser.e2e.ts`
- POMs: `<feature>Page.ts` or `<feature>Wizard.ts`

## Test Setup

### Import Pattern

Always import `test` from the app's fixtures:

```typescript
import {expect} from '@playwright/test';
import {test} from '../../e2e/fixtures';  // NOT from @playwright/test
import {FeaturePage} from './pom/featurePage';
```

### Test IDs and Constants

Define constants at module level:

```typescript
const USER_ID = '1e4bd230-1f34-4dcb-a572-0c2f17723919';
const CONTRACT_NUMBER = '13681001X';

const EXPECTED_ITEMS = [
  {term: 'Name', definition: 'John Doe'},
  {term: 'Status', definition: 'Active'},
] as const;
```

### BeforeEach Setup

```typescript
test.describe('Feature Name', () => {
  test.beforeEach(async ({page}) => {
    await page.gotoHomePage(USER_ID);
  });

  test('should do something', async ({page}) => {
    // test starts on home page
  });
});
```

## Basic Test Structure

### Simple Test

```typescript
test.describe('DocumentArchive', () => {
  test('should display correct title', async ({page}) => {
    const documentArchive = new DocumentArchivePage(page);
    await documentArchive.navigateTo(USER_ID);
    
    await documentArchive.expectTitleVisible();
    await documentArchive.expectTitle('Dokumente');
  });
});
```

### Test with POM Navigation

```typescript
test('displays contract summary correctly', async ({page}) => {
  const overview = new TasOverviewPage(page);
  
  await overview.open({
    userId: USER_ID,
    contractNumber: CONTRACT_NUMBER,
  });

  await expect(overview.card('card:contract-summary')).toContainText(
    'Ihre Vertragsdaten'
  );
  
  const items = await overview.contractSummaryCard.getItems();
  expect(items).toEqual(EXPECTED_ITEMS);
});
```

## Data-Driven Tests

### For-Loop Pattern

```typescript
const TEST_CASES = [
  {
    description: 'HBL contract with active portfolio',
    contractNumber: '1031944718V',
    visible: ['contractSummary', 'portfolioHistory', 'paymentInformation'],
    hidden: ['paperless', 'portfolioCheck'],
  },
  {
    description: 'VT private account',
    contractNumber: '2503234181PA',
    visible: ['contractSummary', 'portfolioHistory'],
    hidden: ['depotCurrency', 'paymentInformation'],
  },
] as const;

for (const testCase of TEST_CASES) {
  test(testCase.description, async ({page}) => {
    const overview = new WmOverviewPage(page);
    
    await overview.openContract({
      userId: USER_ID,
      contractNumber: testCase.contractNumber,
    });

    for (const card of testCase.visible) {
      await overview.expectCardVisible(card);
    }

    for (const card of testCase.hidden ?? []) {
      await overview.expectCardHidden(card);
    }
  });
}
```

### Nested Describe Pattern

```typescript
for (const contractCase of CONTRACT_CASES) {
  test.describe(`WM overview for ${contractCase.contractNumber}`, () => {
    test(contractCase.description, async ({page}) => {
      // test implementation
    });
  });
}
```

### Validation Examples

```typescript
const VALIDATION_CASES = [
  {
    address: 'Spinnereiplatz 777, 8041, Zürich',
    error: 'Die eingegebene Hausnummer ist ungültig',
  },
  {
    address: 'Eigerweg 12, 3790, Spiez',
    error: 'Die eingegebene PLZ ist ungültig',
  },
] as const;

for (const {address, error} of VALIDATION_CASES) {
  test(`validates: ${error}`, async ({page}) => {
    const wizard = await openWizard(page, USER_ID);
    await wizard.step1.fillForm(parseAddress(address));
    await wizard.step1.clickNext();

    await expect.poll(() => wizard.step1.getFirstErrorMessage()).toBe(error);
  });
}
```

## Navigation Patterns

### Home Page Navigation

```typescript
test('navigates from home', async ({page}) => {
  await page.gotoHomePage(USER_ID);
  await page.getByTestId('tile-card:documents').locator('a').first().click();
  await page.waitForPageFullyLoaded('page:da-overview');
});
```

### Contract Navigation

```typescript
test('opens contract details', async ({page}) => {
  await page.impersonate(USER_ID).contract(CONTRACT_NUMBER).goto();
  await page.waitForPageFullyLoaded('page:contract-details');
});
```

### Using POM Helper Functions

```typescript
async function openWizardForUser(
  page: Page,
  userId: string,
): Promise<AddressChangeWizard> {
  const profilePage = new ProfileOverviewPage(page);
  await profilePage.open(userId);
  
  const addressPage = await profilePage.goToAddressOverview();
  return addressPage.openAddressChangeWizard();
}

test('wizard flow', async ({page}) => {
  const wizard = await openWizardForUser(page, USER_ID);
  // continue with wizard steps
});
```

## GraphQL Mocking

### Route Registration

```typescript
const FIXTURE_DATA = {
  data: {
    me: {
      contracts: [
        {__typename: 'ThreeAStartContract', id: 'contract-1', active: true},
      ],
    },
  },
};

const GRAPHQL_CACHE_IDS: Record<string, string> = {
  welcomeQuery: '38dbd4840238523c19a69f3daa677fdf',
};

async function registerGraphqlRoutes(page: Page) {
  await page.route('**/graphql', async (route) => {
    const request = route.request();
    
    if (request.method() !== 'POST') {
      await route.continue();
      return;
    }

    const postData = request.postData();
    if (!postData) {
      await route.continue();
      return;
    }

    let payload: any;
    try {
      payload = JSON.parse(postData);
    } catch {
      await route.continue();
      return;
    }

    const operationKey = payload.operationName || payload.name || payload.id;

    if (operationKey === 'welcomeQuery' || 
        operationKey === GRAPHQL_CACHE_IDS.welcomeQuery) {
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

### Using in Tests

```typescript
test.describe('Assistant', () => {
  test.beforeEach(async ({page}) => {
    await registerGraphqlRoutes(page);
    await page.gotoHomePage(USER_ID);
  });

  test('loads with mocked data', async ({page}) => {
    // test uses mocked GraphQL responses
  });
});
```

## Screenshot Testing

### Page Screenshot

```typescript
test('page matches screenshot', async ({page}) => {
  const overview = new OverviewPage(page);
  await overview.open(USER_ID);

  await expect(page.getByTestId('page:overview')).toHaveScreenshot(
    'overview-page.png'
  );
});
```

### Component Screenshot with Tolerance

```typescript
test('card matches screenshot', async ({page}) => {
  const overview = new TasOverviewPage(page);
  await overview.open({userId: USER_ID, contractNumber: CONTRACT_NUMBER});

  await expect(overview.addressCard).toHaveScreenshot(
    'address-card.png',
    {maxDiffPixelRatio: 0.03}
  );
});
```

### Stabilizing Screenshots

```typescript
class OverviewPage {
  async expectOverviewScreenshot(name: string) {
    const container = this.page.getByTestId('page:overview');
    
    // Wait for stable height
    await this.waitForStableHeight(container);
    
    // Force consistent dimensions
    await container.evaluate((el, height) => {
      el.style.minHeight = `${height}px`;
      el.style.maxHeight = `${height}px`;
      el.style.overflow = 'hidden';
    }, 4800);

    await expect(container).toHaveScreenshot(`${name}.png`, {
      maxDiffPixelRatio: 0.08,
    });
  }

  private async waitForStableHeight(locator: Locator) {
    let previous = await locator.evaluate((el) => el.scrollHeight);
    let stableCount = 0;

    while (stableCount < 5) {
      await this.page.waitForTimeout(150);
      const current = await locator.evaluate((el) => el.scrollHeight);
      
      if (current === previous) {
        stableCount++;
      } else {
        previous = current;
        stableCount = 0;
      }
    }
  }
}
```

## Dialog Testing

```typescript
test('opens and closes dialog', async ({page}) => {
  const featurePage = new FeaturePage(page);
  await featurePage.open(USER_ID);

  // Open dialog
  await featurePage.openSettingsDialog();
  await expect(page.getByTestId('dialog:settings')).toBeVisible();

  // Interact with dialog
  await page.getByTestId('checkbox:option').click();
  
  // Save and close
  await page.getByTestId('button:save').click();
  await expect(page.getByTestId('dialog:settings')).toBeHidden();
});
```

## Form Testing

### Input Validation

```typescript
test('validates required fields', async ({page}) => {
  const wizard = await openWizardForUser(page, USER_ID);

  // Submit without filling required fields
  await wizard.step1.clickNext();

  await expect
    .poll(() => wizard.step1.getFirstErrorMessage())
    .toBe('Bitte füllen Sie dieses Feld aus.');
});
```

### Form Submission

```typescript
test('submits form successfully', async ({page}) => {
  const wizard = await openWizardForUser(page, USER_ID);

  await wizard.step1.fillForm({
    address: 'Grubenstrasse 49',
    zip: '8045',
    location: 'Zürich',
    countryCode: 'CH',
  });
  
  await wizard.step1.setValidFromNow();
  await wizard.step1.clickNext();

  await wizard.step2.waitForReady();
  // continue with next step
});
```

## Table Testing

### Table Header Validation

```typescript
test('table displays correct headers', async ({page}) => {
  await navigateToDocumentArchive(page);

  const table = page.getByTestId('linked-table:documents');
  await expect(table).toBeVisible();

  const headerCells = table.locator('.m-linked-table__header-item');
  await expect(headerCells.nth(0)).toHaveText('Dokument');
  await expect(headerCells.nth(1)).toHaveText('Datum');
  await expect(headerCells.nth(2)).toHaveText('Dokumententyp');
});
```

### Table Row Iteration

```typescript
test('all dates are within filter range', async ({page}) => {
  await navigateToDocumentArchive(page);
  await applyDateFilter(page, '2024');

  const table = page.getByTestId('linked-table:documents');
  const rows = table.locator('.m-linked-table-row');
  const rowCount = await rows.count();

  expect(rowCount).toBeGreaterThan(0);

  for (let i = 0; i < rowCount; i++) {
    const dateCell = rows.nth(i).locator('.m-linked-table-row__item-content').nth(1);
    const dateText = await dateCell.textContent();
    
    if (dateText?.trim()) {
      const [, , year] = dateText.trim().split('.');
      expect(parseInt(year)).toBe(2024);
    }
  }
});
```
