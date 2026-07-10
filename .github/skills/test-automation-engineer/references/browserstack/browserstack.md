---
name: frontend-browserstack
description: "Run Playwright tests on the BrowserStack cloud grid: SDK setup, browserstack.yml, capabilities, Local tunnel for internal apps, parallelization, and cross-browser/device matrix. Use for: BrowserStack, cloud browser grid, cross-browser testing, real device testing, browserstack.yml, BrowserStack Local, parallel Playwright, run tests on BrowserStack."
---

# Playwright on BrowserStack

Guidance for running **Playwright** tests on the **BrowserStack** cloud grid (cross-browser / real-device coverage). Load when configuring BrowserStack, scaling Playwright runs, or testing internal apps through the Local tunnel.

## Setup (SDK)

- Add the BrowserStack Node SDK (`browserstack-node-sdk`) as a dev dependency.
- Run tests via the SDK wrapper (`npx browserstack-node-sdk playwright test`), not the plain runner.
- Configure via **`browserstack.yml`** at the project root — do **not** hardcode credentials.

## Credentials

- Provide `BROWSERSTACK_USERNAME` and `BROWSERSTACK_ACCESS_KEY` via **environment variables** (CI secrets / local env). Never commit them.

## `browserstack.yml` essentials

- `platforms:` — the browser/OS/device matrix (e.g. Chrome/Windows, Safari/macOS, Chrome/Android, Safari/iOS).
- `parallelsPerPlatform:` — parallel sessions per platform.
- `browserstackLocal: true` — enable the Local tunnel for internal / non-public apps.
- `buildName` / `projectName` — traceability in the BrowserStack dashboard.

## BrowserStack Local (internal apps)

For apps not reachable from the public internet (A / UAT / PAV portals), enable **BrowserStack Local** so the cloud browsers tunnel to the local/VPN network. Verify the tunnel is up before the run.

## Best Practices

- Keep Playwright tests **grid-agnostic**: same specs run locally and on BrowserStack. Only config differs.
- Parallelize by platform; keep tests independent (no shared state) so they shard safely.
- Use the **Page Object Model** and resilient selectors (see `frontend-playwright-test-creator`).
- Tag/organize by `buildName` per CI run for reporting.
- Fail the CI job on any session failure; publish the BrowserStack report link.

## Anti-Patterns

- Credentials in `browserstack.yml` or source control.
- Environment-specific hardcoded URLs in specs (parameterize base URL).
- Over-broad device matrix on every PR (reserve full matrix for nightly/regression).

## Know-how

- Playwright on BrowserStack: https://www.browserstack.com/docs/automate/playwright
- browserstack.yml reference: https://www.browserstack.com/docs/automate/playwright/browserstack-yml
- BrowserStack Local: https://www.browserstack.com/docs/automate/playwright/local-testing

<!-- Last updated: 2026-07-02 -->
