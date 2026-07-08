# Tasks: [FEATURE NAME]

**Input**: `docs/specs/[NNN-feature-name]/{spec.md, plan.md}`

Format: `- [ ] T### [P?] [US#?] Description with concrete file path`
`[P]` = can run in parallel (different files, no dependency). `[US#]` = maps to a spec User Story.

---

## Phase 1: Setup (Shared Infrastructure)

- [ ] T001 Create/confirm project structure per plan.md
- [ ] T002 Initialize dependencies/tooling needed for this feature
- [ ] T003 [P] Configure linting/formatting if not already covered

---

## Phase 2: Foundational (Blocking Prerequisites)

⚠️ No user-story work starts before this phase is complete.

- [ ] T004 [P] Core models/entities shared by all stories
- [ ] T005 [P] Wiring (DI/routing/schema) needed by every story
- [ ] T006 Error handling / logging baseline for this feature

**Checkpoint**: Foundation ready — user stories may proceed (in parallel if staffed).

---

## Phase 3: User Story 1 - [Title] (Priority: P1) 🎯 MVP

**Goal**: [from spec]
**Independent Test**: [from spec]

### Tests (if applicable)

- [ ] T010 [P] [US1] Contract/unit test for [behavior] in `<path>`

### Implementation

- [ ] T011 [P] [US1] [Entity/component] in `<path>`
- [ ] T012 [US1] [Service/handler] in `<path>` (depends on T011)
- [ ] T013 [US1] Validation and error handling

**Checkpoint**: User Story 1 independently functional and testable.

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

[Same structure as Phase 3]

---

## Phase N: Polish & Cross-Cutting

- [ ] TXXX [P] Documentation updates
- [ ] TXXX Cleanup / refactor
- [ ] TXXX [P] Additional tests

---

## Dependencies & Execution Order

- **Setup** → no dependencies.
- **Foundational** → depends on Setup; blocks all user stories.
- **User Stories** → depend on Foundational; execute in priority order (P1 → P2 → P3); independent stories can run in parallel.
- **Polish** → depends on the user stories being in scope for this delivery.

## Implementation Strategy

1. Setup → Foundational → User Story 1 (MVP) → validate independently → hand off to the team implementer.
2. Add User Story 2, 3, ... incrementally, validating after each.
