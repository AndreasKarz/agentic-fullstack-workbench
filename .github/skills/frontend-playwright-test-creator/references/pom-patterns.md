# Page Object Model (POM) Patterns

Comprehensive guide for implementing Page Object Models in Fusion-UI Playwright tests.

## Table of Contents

1. [Basic POM Structure](#basic-pom-structure)
2. [Using BasePage](#using-basepage)
3. [Locator Patterns](#locator-patterns)
4. [Action Methods](#action-methods)
5. [Assertion Methods](#assertion-methods)
6. [Wizard/Multi-Step POMs](#wizard-multi-step-poms)
7. [Composite POMs](#composite-poms)
8. [Helper Classes](#helper-classes)

## Basic POM Structure

Every Page Object follows this structure:

```typescript
import {type Locator, type Page, expect} from '@playwright/test';

// Constants for test IDs - defined at module level
const PAGE_TEST_ID = 'page:feature-name';
const SUBMIT_BUTTON_TEST_ID = 'button:submit';
const CARD_SUMMARY_TEST_ID = 'card:summary';

export class FeaturePage {
  constructor(private readonly page: Page) {}

  // === PRIVATE LOCATOR METHODS ===
  // Return Locator objects, do not await
  
  private submitButton(): Locator {
    return this.page.getByTestId(SUBMIT_BUTTON_TEST_ID);
  }

  private summaryCard(): Locator {
    return this.page.getByTestId(CARD_SUMMARY_TEST_ID);
  }

  // === PUBLIC ACTION METHODS ===
  // Perform user interactions
  
  async clickSubmit() {
    await this.submitButton().click();
  }

  async waitUntilLoaded() {
    await this.page.waitForPageFullyLoaded(PAGE_TEST_ID);
  }

  // === PUBLIC ASSERTION METHODS ===
  // Prefix with 'expect', return Promise<void>
  
  async expectSubmitVisible() {
    await expect(this.submitButton()).toBeVisible();
  }

  async expectSummaryText(expected: string) {
    await expect(this.summaryCard()).toHaveText(expected);
  }
}
```

## Using BasePage

For pages requiring navigation, extend `BasePage`:

```typescript
import type {Page} from '@playwright/test';
import {BasePage} from '../../../../shared/playwright-pom/basePage';

export class ProfileOverviewPage extends BasePage {
  constructor(page: Page) {
    super(page);
  }

  // Navigation method
  async open(userId: string) {
    await this.gotoHomePage(userId);
    await this.page.getByTestId('link:profile').click();
    await this.waitForPage('page:profile-overview');
  }

  // Contract-based navigation
  async openContract(userId: string, contractNumber: string) {
    await this.impersonateContract(userId, contractNumber);
    await this.waitForPage('page:contract-details');
  }
}
```

### BasePage Methods

```typescript
class BasePage {
  protected readonly page: Page;

  async gotoHomePage(userId: string);
  async impersonateContract(userId: string, contractNumber: string);
  async waitForPage(testId: string);
  getPage(): Page;
}
```

## Locator Patterns

### Simple Locators

```typescript
// Direct test ID
private submitButton(): Locator {
  return this.page.getByTestId('button:submit');
}

// Scoped within container
private cardTitle(): Locator {
  return this.page.getByTestId('card:summary').locator('h4');
}
```

### Dynamic Locators

```typescript
// With parameter (for indexed elements)
private contractCard(index: number): Locator {
  return this.page.getByTestId(`card:contract-${index}`);
}

// With type parameter
private addressCard(type: 'domicile' | 'correspondence'): Locator {
  return this.page.getByTestId(`card:${type}-address`);
}
```

### Locator Constants Pattern

Define reusable card/element maps:

```typescript
export const WM_OVERVIEW_CARDS = {
  contractSummary: 'card:contract-summary',
  portfolioHistory: 'card:portfolio-history-chart',
  paymentInformation: 'card:payment-information',
} as const;

export type WmOverviewCard = keyof typeof WM_OVERVIEW_CARDS;

export class WmOverviewPage {
  private cardLocator(card: WmOverviewCard): Locator {
    return this.page.getByTestId(WM_OVERVIEW_CARDS[card]);
  }

  async expectCardVisible(card: WmOverviewCard) {
    await expect(this.cardLocator(card)).toBeVisible();
  }
}
```

## Action Methods

### Click Actions

```typescript
async clickSubmit() {
  await this.submitButton().click();
}

async clickMenuItem(name: string) {
  await this.page
    .getByTestId('navigation-menu')
    .getByTestId(`menu-item:${name}`)
    .click();
}
```

### Form Input Actions

```typescript
async fillEmail(email: string) {
  const input = this.page.getByTestId('input:email');
  await input.fill('');  // Clear first
  await input.type(email);
}

async selectCountry(code: string) {
  await this.page.getByTestId('select:country').selectOption(code);
}

async setCheckbox(checked: boolean) {
  const checkbox = this.page.getByTestId('checkbox:agree');
  const isChecked = await checkbox.isChecked();
  
  if (checked !== isChecked) {
    await checkbox.click();
  }
}
```

### Wait Actions

```typescript
async waitUntilLoaded() {
  await this.page.waitForPageFullyLoaded('page:overview');
}

async waitForDialog() {
  await this.dialog.waitFor({state: 'visible'});
}
```

## Assertion Methods

Always prefix with `expect`:

```typescript
// Visibility
async expectCardVisible(card: WmOverviewCard) {
  await expect(this.cardLocator(card)).toBeVisible();
}

async expectCardHidden(card: WmOverviewCard) {
  await expect(this.cardLocator(card)).toBeHidden();
}

// Text content
async expectTitle(expected: string) {
  await expect(this.title()).toHaveText(expected);
}

// Count
async expectItemCount(expected: number) {
  await expect(this.items()).toHaveCount(expected);
}

// Screenshots
async expectOverviewScreenshot(name: string) {
  await expect(this.page.getByTestId('page:overview')).toHaveScreenshot(
    `${name}.png`,
    {maxDiffPixelRatio: 0.03}
  );
}
```

### Polling Assertions

For values that async-update:

```typescript
async expectContractSelected(contractNumber: string, selected: boolean) {
  await expect
    .poll(() => this.isContractChecked(contractNumber))
    .toBe(selected);
}
```

## Wizard/Multi-Step POMs

For multi-step wizards, create separate step classes:

```typescript
export class AddressChangeWizard extends BasePage {
  private readonly dialog: Locator;
  readonly step1: AddressChangeStep1;
  readonly step2: AddressChangeStep2;
  readonly step3: AddressChangeStep3;

  constructor(page: Page) {
    super(page);
    this.dialog = page.getByTestId('dialog:address-change');
    this.step1 = new AddressChangeStep1(this.dialog);
    this.step2 = new AddressChangeStep2(this.dialog);
    this.step3 = new AddressChangeStep3(this.dialog);
  }

  async waitForOpen() {
    await this.dialog.waitFor({state: 'visible'});
    await this.step1.waitForReady();
  }
}

class AddressChangeStep1 {
  constructor(private readonly dialog: Locator) {}

  async waitForReady() {
    await this.addressInput().waitFor({state: 'visible'});
  }

  private addressInput(): Locator {
    return this.dialog.getByTestId('input:address');
  }

  async fillForm(data: AddressFormInput) {
    await this.addressInput().fill(data.address);
    await this.zipInput().fill(data.zip);
  }

  async clickNext() {
    await this.dialog.getByTestId('button:next').click();
  }
}
```

## Composite POMs

For pages with reusable card patterns:

```typescript
// Reusable card helper
class DescriptionListCard {
  constructor(private readonly card: Locator) {}

  async getItems(): Promise<Array<{term: string; definition: string}>> {
    const items = this.card.locator('[data-test-id^="description-list-item"]');
    const count = await items.count();
    const result: Array<{term: string; definition: string}> = [];

    for (let i = 0; i < count; i++) {
      const item = items.nth(i);
      const term = await item.locator('dt').innerText();
      const definition = await item.locator('dd').innerText();
      result.push({term: term.trim(), definition: definition.trim()});
    }

    return result;
  }
}

// Page using composite
export class TasOverviewPage {
  constructor(private readonly page: Page) {}

  get contractSummaryCard(): DescriptionListCard {
    return new DescriptionListCard(
      this.page.getByTestId('card:contract-summary')
    );
  }

  get paymentInfoCard(): DescriptionListCard {
    return new DescriptionListCard(
      this.page.getByTestId('card:payment-information')
    );
  }
}
```

## Helper Classes

### Navigation Options Interface

```typescript
export interface ContractAccess {
  userId: string;
  contractNumber: string;
}

export class ContractPage {
  async openContract({userId, contractNumber}: ContractAccess) {
    await this.page.impersonate(userId).contract(contractNumber).goto();
    await this.waitUntilLoaded();
  }
}
```

### Form Input Interface

```typescript
export interface AddressFormInput {
  address?: string;
  zip: string;
  location: string;
  countryCode: string;
}

export class AddressForm {
  async fillForm(form: AddressFormInput) {
    if (form.address !== undefined) {
      await this.fillInput(this.addressInput(), form.address);
    }
    await this.fillInput(this.zipInput(), form.zip);
    await this.fillInput(this.locationInput(), form.location);
    await this.countrySelect().selectOption(form.countryCode);
  }

  private async fillInput(locator: Locator, value: string) {
    await locator.waitFor({state: 'visible'});
    await locator.fill('');
    await locator.type(value);
  }
}
```
