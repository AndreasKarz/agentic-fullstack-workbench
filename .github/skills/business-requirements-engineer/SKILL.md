---
name: business-requirements-engineer
description: "Use when eliciting, documenting, validating, or reviewing requirements per IREB. Covers user stories, features, PBIs, epics, GIVEN/WHEN/THEN acceptance criteria, NFRs per ISO 25010, quality checks, and traceability. Triggers on: requirement, acceptance criteria, NFR, IREB."
---

# Requirements Engineering Domain Knowledge

This skill delivers the subject matter and methodology knowledge for the Requirements Engineer agent. The agent orchestrates — this skill delivers the content depth.

## IREB RE Lifecycle

```
┌──────────┐    ┌──────────────┐    ┌──────────┐    ┌──────────────┐    ┌────────────┐
│ Elicit   │───▶│  Document    │───▶│  Review  │───▶│    Align     │───▶│  Manage    │
│          │◀───│              │◀───│          │◀───│              │◀───│            │
└──────────┘    └──────────────┘    └──────────┘    └──────────────┘    └────────────┘
  Elicitation    Documentation       Validation      Negotiation         Management
```

### Elicitation Techniques

| Technique | When to use | Strength | Weakness |
|-----------|------------|---------|---------|
| **Interview** | Individual stakeholder inquiry | Deep insights, follow-up questions possible | Time-consuming, subjective |
| **Workshop** | Multiple stakeholders together | Consensus, diverse perspectives | Group dynamics, dominance |
| **Observation** | Understand existing processes | Uncovers implicit knowledge | Hawthorne effect |
| **Document analysis** | Understand existing systems/processes | Leverage existing knowledge | May be outdated |
| **Prototyping** | UI-related requirements | Concretization, early feedback | Can be misunderstood as "finished" |
| **Questionnaire** | Broad stakeholder group | Scalable, quantifiable | No follow-up, misunderstandings |
| **Brainstorming** | Creative/innovative features | Generate many ideas | Evaluation/prioritization needed |

### Documentation Formats

Detailed templates and patterns: See [references/templates.md](references/templates.md)

## Types of Requirements

### Functional Requirements (FR)

Describe **what** the system should do.

**Formulation patterns (IREB-compliant):**

| Obligation | Keyword | Example |
|------------|---------|---------|
| **Mandatory** | must / shall | "The system **must** lock the user after 3 failed attempts." |
| **Desired** | should | "The system **should** provide a password strength indicator." |
| **Intended** | will | "The system **will** support 2FA in a future version." |

**Quality attributes of a good FR:**
- Atomic (one requirement per sentence)
- Unambiguous (only one interpretation possible)
- Necessary (contributes to business goal)
- Testable (verifiable through test)
- Traceable (source and target documented)
- Feasible (technically and economically achievable)

### Non-Functional Requirements (NFR) per ISO 25010

Detailed NFR categories and measurement methods: See [references/nfr-iso25010.md](references/nfr-iso25010.md)

## Acceptance Criteria — GIVEN/WHEN/THEN

### Structure

```gherkin
GIVEN [precondition — concrete system state]
WHEN  [trigger — user action or system event]
THEN  [expectation — measurable, verifiable outcome]
```

### Formulation Rules

| Rule | Explanation | Example |
|------|------------|---------|
| **Concrete GIVEN** | State with values, not abstract | ✅ "GIVEN a user with role 'Advisor' is logged in" ❌ "GIVEN a user is in the system" |
| **Active WHEN** | One clear triggering action | ✅ "WHEN the user clicks 'Cancel Contract'" ❌ "WHEN something happens" |
| **Measurable THEN** | Verifiable with concrete values | ✅ "THEN the status is set to 'Cancelled' and an email is sent to the customer" ❌ "THEN the cancellation is processed" |
| **AND for additions** | Additional conditions/outcomes | "AND the cancellation date matches the next contract expiry" |
| **One scenario per AC** | Each AC tests exactly one aspect | Do not combine multiple independent flows in one AC |
| **Positive + Negative** | Cover both directions | Happy path AND error case (e.g. "GIVEN no contract exists") |

### Patterns for Common Scenarios

| Scenario Type | GIVEN Pattern | WHEN Pattern | THEN Pattern |
|--------------|--------------|-------------|-------------|
| **CRUD: Create** | User has permission X | Submit form with valid data | Record created, ID assigned, confirmation shown |
| **CRUD: Read** | Record with ID X exists | Open detail view | All fields correctly displayed (name concrete values) |
| **CRUD: Update** | Record with value A exists | Change value to B and save | Value is B, change date updated, audit log written |
| **CRUD: Delete** | Record without dependencies | Confirm deletion | Record removed, dependent references cleaned up |
| **Validation** | Form is open | Enter invalid value (e.g. text in number field) | Validation message "[text]" shown at field, save disabled |
| **Authorization** | User has role Y (without permission Z) | Call protected action | Access denied, error code 403, no data changes |
| **Boundary value** | Field accepts max. N characters | Enter N+1 characters | Input limited to N characters OR error message |
| **Async** | Process X was triggered | Processing completed | Status changes to "Completed", notification sent |

### Anti-Patterns in ACs

| Anti-Pattern | Why Bad | Correction |
|-------------|---------|----------|
| "System works correctly" | Not testable | Describe concrete behavior + values |
| "User sees the data" | Which data? How? | "User sees first name, last name, date of birth in format dd.MM.yyyy" |
| "Error is handled" | How? What message? | "Error message '[text]' is displayed, no data loss" |
| "Performance is good" | Not measurable | "Response time < 2s at P95 under load of 100 concurrent users" |
| "As in the old system" | Implicit knowledge | Specify behavior explicitly |

## Requirements Validation — IREB Checklist

### Check Individual Requirement

| # | Criterion | Check Question |
|---|-----------|--------------|
| 1 | **Clarity** | Is there only one possible interpretation? |
| 2 | **Completeness** | Are all aspects covered (normal case, error case, boundary values)? |
| 3 | **Consistency** | Does this requirement not contradict any other? |
| 4 | **Correctness** | Is the requirement technically correct? |
| 5 | **Testability** | Can a tester verify whether the requirement is fulfilled? |
| 6 | **Traceability** | Is the source documented? Is a test assigned? |
| 7 | **Necessity** | Does the requirement contribute to the business goal? |
| 8 | **Feasibility** | Is it technically and economically achievable? |

### Check Requirements Specification

| # | Criterion | Check Question |
|---|-----------|--------------|
| 1 | **Scope** | Are in-/out-of-scope clearly defined? |
| 2 | **Completeness** | Are all stakeholder needs covered? |
| 3 | **No redundancy** | Are there no duplicate requirements? |
| 4 | **Consistency** | Do no requirements contradict each other? |
| 5 | **Prioritization** | Are all requirements prioritized (MoSCoW)? |

## Prioritization — MoSCoW

| Priority | Meaning | Share of Scope |
|----------|---------|--------------|
| **Must have** | Without this requirement the release is worthless | ~60% |
| **Should have** | Important, but workaround possible | ~20% |
| **Could have** | Desirable if time and budget allow | ~20% |
| **Won't have** | Explicitly excluded for this release | Documented |

## Azure DevOps Work Item Structure

### Hierarchy

```
Epic (strategic initiative)
├── Feature (business outcome)
│   ├── PBI / User Story (smallest deliverable unit)
│   │   ├── Task (technical sub-task)
│   │   └── Test Case (linked via "Tested By")
│   └── PBI / User Story
└── Feature
```

### Work Item Quality Criteria

| Field | Rule |
|-------|------|
| **Title** | Meaningful, max. 80 characters, outcome-oriented |
| **Description** | HTML-formatted for ADO, business context + scope (in/out) |
| **Acceptance Criteria** | GIVEN/WHEN/THEN, each AC independently testable |
| **Tags** | Tags per team convention — preserve existing tags |
| **Area Path** | Correctly assigned |
| **Parent** | PBI must be linked to feature |
| **Tested By** | Test cases MUST be linked |

## Traceability

### Traceability Chain

```
Business Goal → Epic → Feature → PBI → Acceptance Criterion → Test Case → Test Result
```

### Traceability Matrix

| Source | Requirement (ID) | AC | Test Case (ID) | Status |
|--------|------------------|----|----------------|--------|
| [Stakeholder/Document] | [PBI-123] | AC-1 | [TC-456] | ✔/✖/❓ |

> Every requirement MUST be traceable forward (to tests) and backward (to source).

<!-- Last updated: 2026-07-02 · Part of the Copilot Context Blueprint -->