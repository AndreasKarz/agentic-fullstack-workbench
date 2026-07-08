# Feature Specification: [FEATURE NAME]

**Feature**: `[NNN-feature-name]`
**Created**: [DATE]
**Status**: Draft
**Input**: User description: "[ORIGINAL REQUEST]"

## Clarifications

<!-- Populated incrementally by the Clarify protocol. Do not pre-fill. -->

### Session [DATE]

- Q: [question] → A: [answer]

## User Scenarios & Testing *(mandatory)*

<!--
  User stories are prioritized user journeys (P1 = most critical). Each must be
  INDEPENDENTLY TESTABLE: implementing only P1 should still be a viable MVP.
-->

### User Story 1 - [Brief Title] (Priority: P1)

[Plain-language journey]

**Why this priority**: [Business value]
**Independent Test**: [How this story alone can be verified]

**Acceptance Scenarios**:

1. **Given** [state], **When** [action], **Then** [outcome]
2. **Given** [state], **When** [action], **Then** [outcome]

---

### User Story 2 - [Brief Title] (Priority: P2)

[Repeat structure. Add P3+ as needed.]

### Edge Cases

- What happens when [boundary condition]?
- How does the system handle [error scenario]?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST [specific capability]
- **FR-002**: Users MUST be able to [key interaction]
- **FR-003**: System MUST [data requirement]

<!-- Mark true unknowns explicitly, max 3 across the whole spec: -->
- **FR-00N**: System MUST authenticate users via [NEEDS CLARIFICATION: auth method not specified]

### Key Entities *(if the feature involves data)*

- **[Entity]**: [What it represents, key attributes, relationships]

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: [Quantified metric, e.g., "Users complete X in under 2 minutes"]
- **SC-002**: [Performance target, technology-agnostic]
- **SC-003**: [User-success rate]

## Assumptions

- [Assumption about users, scope, environment, or dependencies — mark unverified ones `ASSUMPTION: ...`]
