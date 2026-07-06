---
name: business-testmanager
description: "Use when creating test cases, test strategies, coverage matrices, test reports, ADO Test Plans, or deterministic expected results per ISTQB. Triggers on: test case, test strategy, coverage, boundary value, equivalence class, decision table, state transition, regression, acceptance test."
---

# Test Management Domain Knowledge

This skill delivers the subject matter and methodology knowledge for the Test Manager agent. The agent orchestrates — this skill delivers the content depth.

## ISTQB Test Process

```
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────────┐   ┌──────────┐   ┌──────────┐
│ Planning │──▶│ Analysis │──▶│  Design  │──▶│Implementation│──▶│Execution │──▶│ Closure  │
└──────────┘   └──────────┘   └──────────┘   └──────────────┘   └──────────┘   └──────────┘
 Strategy,      What to test?  How to test?   Test cases,        Run tests,      Report,
 resources,     Identify test  Choose         test data,         document        lessons
 schedule       conditions     techniques     env. setup         results         learned
```

## Test Levels

| Level | Focus | Basis | Responsibility | Typical Tools |
|-------|-------|-------|---------------|--------------|
| **Component test** | Individual units in isolation | Code, detail design | Developer | xUnit, NUnit, Moq |
| **Integration test** | Interaction between components | Interface spec | Developer/tester | Testcontainers, WireMock |
| **System test** | Complete system against requirements | Requirements spec | Tester | Playwright, Postman |
| **Acceptance test** | Business requirements, user view | Business processes | PO/tester/end user | ADO Test Plans |

## Test Design Techniques

Detailed techniques with examples: See [references/testdesign-techniken.md](references/testdesign-techniken.md)

### Technique Selection by Situation

| Situation | Recommended Technique | Reason |
|-----------|----------------------|--------|
| Input fields with value ranges | Equivalence classes + boundary value analysis | Systematic coverage with minimal test count |
| Business rules with conditions | Decision table | All condition combinations visible |
| Workflows with state transitions | State transition test | State machine fully covered |
| Complex user processes | Use-case-based testing | Realistic end-to-end scenarios |
| Experience-based testing | Error guessing + exploratory testing | Find defects that techniques miss |

## Deterministic Test Case Formulation

### Expected Results — Gold Standard

**Rule:** Every expected result must be so precise that two different testers reach the **same conclusion** (pass/fail).

| Quality Level | Example | Assessment |
|-------------|---------|-----------|
| ❌ Poor | "Result is displayed" | Not verifiable — WHAT is displayed WHERE HOW? |
| ⚠️ Medium | "Error message is displayed" | Which message? Where? |
| ✅ Good | "Inline error message 'Please enter a valid email address' appears below the 'Email' field in red text (#D82034)" | Deterministically verifiable |

### Checklist for Expected Results

- [ ] **WHAT** happens? (concrete system behavior)
- [ ] **WHERE** is it visible? (element, page, section)
- [ ] **HOW** does it look? (format, color, text)
- [ ] **WHEN** does it happen? (immediately, after delay, after confirmation)
- [ ] **Which values?** (concrete numbers, texts, formats)
- [ ] **What does NOT happen?** (no data change, no navigation, no data loss)

### Patterns for Expected Results by Action Type

| Action Type | Expected Result Pattern |
|------------|------------------------|
| **Submit form** | "Success message '[text]' appears. Record is visible in the list with values [A], [B], [C]. URL changes to [/path]." |
| **Validation error** | "Inline error message '[text]' below field '[name]'. Form remains open. Save button is disabled. No data was saved." |
| **Delete** | "Confirmation dialog with text '[text]' appears. After confirmation: record removed from list. Message '[text]'. Related [links] are cleaned up." |
| **Navigation** | "Page '[title]' loads. URL is [/path]. Breadcrumb shows [A > B > C]. Load time < [n]s." |
| **Status change** | "Status badge changes from '[old]' to '[new]' (color: [color]). 'Last modified' timestamp updated to [format]. Audit log contains entry with [details]." |
| **Email sent** | "Email sent to [address]. Subject: '[text]'. Content contains [key information]. Sender is [address]." |
| **File export** | "File '[name].[format]' downloaded. File size > 0 bytes. Content contains [expected columns/rows]. Encoding: UTF-8." |

## Coverage Analysis

### Coverage Matrix Structure

```
Requirement (AC)    →    Test Condition    →    Test Case    →    Test Result
     1:1                     1:n                   n:1               1:1
```

| Metric | Formula | Target |
|--------|---------|--------|
| **AC coverage** | Tested ACs / All ACs × 100% | ≥ 85% (standard), ≥ 95% (high risk) |
| **Test case efficiency** | Defects found / Number of test cases | Higher = more efficient |
| **Redundancy** | Doubly covered ACs / All ACs | < 10% (low redundancy) |

### Coverage Types

| Type | Description | When to use |
|------|------------|------------|
| **Requirements-based** | Every requirement/AC tested at least once | Always (baseline) |
| **Risk-based** | High risks have more tests | When budget/time is limited |
| **Code-based** | Line/branch coverage | Component tests |
| **Exploratory** | Session-based, experience-driven | Supplementary to structured tests |

## Test Strategy by Risk

### Risk-Based Test Prioritization

| Risk Level | Probability × Impact | Test Strategy |
|-----------|---------------------|--------------|
| **Critical** (R1) | High × High | Full coverage: positive + negative + boundary + integration + performance |
| **High** (R2) | High × Medium OR Medium × High | Positive + negative + boundary + selected integration |
| **Medium** (R3) | Medium × Medium | Positive + most important negative tests |
| **Low** (R4) | Low × any OR any × Low | Happy path + spot checks |

### Risk Assessment for Test Cases

| Factor | High | Medium | Low |
|--------|------|--------|-----|
| **Business criticality** | Core process, regulatory | Support process | Nice-to-have |
| **User frequency** | Daily, many users | Weekly, few users | Rarely, admin-only |
| **Technical complexity** | Many interfaces, async | Moderate logic | Simple CRUD |
| **Change history** | Frequently changed, error-prone | Occasionally changed | Stable for a long time |

## Azure DevOps Test Plans Integration

### Test Case Creation via MCP

```
1. mcp_ado_testplan_list_test_plans     → Available test plans
2. mcp_ado_testplan_list_test_suites    → Test suites in plan
3. mcp_ado_testplan_create_test_case    → Create new test case
4. mcp_ado_testplan_add_test_cases_to_suite → Add test cases to suite
5. mcp_ado_wit_link_work_item_to_pull_request → Link test case to PBI
```

### Test Case Linking (Mandatory)

```
Work Item (PBI/Feature)
    │
    ├── Tested By ──▶ Test Case 1
    ├── Tested By ──▶ Test Case 2
    └── Tested By ──▶ Test Case 3
```

**Rules:**
- Every test case is linked to the work item via "Tested By"
- Every AC has at least 1 test case
- Test cases carry tags per team convention. Do not remove existing tags.
- Numbering: sequential (1, 2, 3 ...), renumber on selection

### ADO Test Case Format

```
Title:          TC-[No]: [Meaningful, action-oriented title]
Area Path:      [Same area path as linked work item]
Tags:           (per team convention)
Assigned To:    [Optional]

Test Steps:
  Step 1: [Action]
    Expected Result: [Detailed, deterministic result]
  Step 2: [Action]
    Expected Result: [Detailed, deterministic result]

Preconditions:
  - [Precondition 1]
  - [Precondition 2]
```

## Test Reporting

### Test Report Template

```markdown
# Test Report: [Work Item / Feature Title]

**Date:** [MM/DD/YYYY] | **Tester:** [Name/AI] | **Overall Status:** 🟢/🟡/🔴

## Summary

| Metric | Value |
|--------|-------|
| Total test cases | [n] |
| Passed | [n] ([%]%) |
| Failed | [n] ([%]%) |
| Blocked | [n] ([%]%) |
| Not executed | [n] ([%]%) |
| AC coverage | [n/m] ([%]%) |

## Defects

| # | Test Case | Defect Description | Severity | Status |
|---|----------|--------------------|---------|----|
| 1 | TC-[No] | [What happened vs. what was expected] | Critical/High/Medium/Low | Open/In Progress/Resolved |

## Risk Assessment

| Area | Residual Risk | Reason |
|------|--------------|--------|
| [Area] | High/Medium/Low | [Why?] |

## Recommendation

[Go / No-Go with justification. For No-Go: what needs to happen before go?]
```

### Severity Definitions

| Severity | Definition | Response |
|---------|-----------|---------|
| **Critical** | System unusable, data loss, security vulnerability | Fix immediately, release blocked |
| **High** | Core function impaired, no workaround | Fix before release |
| **Medium** | Function impaired, workaround available | Fix in next sprint |
| **Low** | Cosmetic, low impact | Backlog, by priority |

## Regression Test Strategy

### When Regression Tests?

| Trigger | Regression Scope |
|---------|----------------|
| New feature | Affected existing functions + interfaces |
| Bug fix | Fix verification + related functions |
| Configuration change | All affected features |
| Release | Critical paths + smoke tests |

### Smoke Test Set (Minimum for every release)

1. Login/logout works
2. Main navigation reachable
3. Core process 1 (happy path) completes
4. Core process 2 (happy path) completes
5. Data displayed correctly (spot check)
6. No JavaScript/API errors in console

<!-- Last updated: 2026-07-02 · Part of the Copilot Context Blueprint -->