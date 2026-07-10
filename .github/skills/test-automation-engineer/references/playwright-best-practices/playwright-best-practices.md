---
name: frontend-playwright-best-practices
description: "General Playwright testing guidance. Use when designing Playwright test strategy, fixing flaky tests, reviewing selectors/assertions/waits, configuring CI, or choosing between E2E, component, API, visual, accessibility, and browser automation tests. For this repo's strict E2E POM pattern, load playwright-test-creator."
license: MIT
metadata:
  author: currents.dev
  version: "1.1"
---

# Playwright Best Practices

General Playwright guidance for test strategy, reliability, debugging, selectors, waiting, CI, and advanced browser scenarios. This skill intentionally stays compact and routes executable workflows to local focused skills.

## Local Skill Map

| Need | Load |
|---|---|
| Repo E2E tests with strict Page Object Model | `frontend-playwright-test-creator` |
| Browser automation through local CLI | `frontend-playwright-cli` |
| Browser automation through MCP tools | `frontend-playwright-mcp` |
| Cloud cross-browser/device grid | `frontend-browserstack` |

## Core Rules

- Prefer role, label, and test-id locators over CSS and XPath.
- Assert outcomes, not implementation details.
- Avoid fixed sleeps; wait for user-visible state, network effects, or stable DOM conditions.
- Keep tests isolated: each test owns its data, auth state, browser context, and cleanup.
- Debug flake from evidence: trace, video, console messages, network log, and timing assumptions.
- Split strategy by risk: smoke tests for critical paths, focused E2E for integration risk, component/API tests for local behavior.

## When To Escalate

- Use `frontend-playwright-test-creator` when touching files under `**/e2e/**` or when strict POM rules matter.
- Use `frontend-playwright-cli` or `frontend-playwright-mcp` when validating a running UI without adding test files.
- Use `frontend-browserstack` when the problem depends on browser/device differences.

## Anti-Patterns

| Anti-Pattern | Fix |
|---|---|
| Raw selectors in E2E tests | Encapsulate locators in a Page Object |
| `waitForTimeout` as synchronization | Wait for a visible state or assertion |
| Shared mutable test data | Create isolated fixtures per test or worker |
| Testing every detail through E2E | Move local behavior to component/API tests |
| Ignoring console/network errors | Capture and inspect them during debugging |

<!-- Source: https://github.com/currents-dev/playwright-skills · Last updated: 2026-07-06 -->
