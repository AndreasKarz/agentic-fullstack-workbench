---
name: spec-driven-workflow
description: "Spec-Driven Development workflow adapted from GitHub Spec Kit: constitution, clarify, specify, plan, and tasks. Use when: writing a project constitution, creating or clarifying a feature specification, interviewing the user about a new feature, planning implementation of a feature, breaking a plan into tasks. Triggers on: constitution, spec, specify, clarify, feature specification, implementation plan, task breakdown, spec-driven."
---

<!-- Source: adapted from github/spec-kit (Spec-Driven Development) · Last updated: 2026-07-08 -->

Guide the constitution → clarify/specify → plan → tasks cycle. Artifacts live in the **project** folder (never in this workbench), under `docs/`. This skill is self-contained; it does not depend on the Requirements Engineer role.

## Cycle

1. **Constitution** (once per project, revisited rarely) — non-negotiable principles that gate every plan.
2. **Specify** (per feature) — interview the user (Clarify), then write `spec.md`: WHAT and WHY, no tech.
3. **Plan** (per feature) — HOW: technical context, **Constitution Check gate**, project structure.
4. **Tasks** (per feature) — dependency-ordered, per-user-story breakdown; bridges to the team's existing implementer.

Implementation itself is NOT part of this skill — hand off to the team's existing implementer/reviewer/validator agents.

## Target Folder Resolution (scriptless)

The workbench root is the folder containing `.github/AGENTS.md`. Artifacts never go there.

1. List the workspace roots.
2. The **project root** = the one non-workbench root.
3. If there is more than one non-workbench root, **ask the user** which one to use before writing anything.
4. Artifact paths, relative to the project root:
   - `docs/constitution.md`
   - `docs/specs/NNN-<short-name>/spec.md`
   - `docs/specs/NNN-<short-name>/plan.md`
   - `docs/specs/NNN-<short-name>/tasks.md`

## Numbering (scriptless)

To create a new feature folder:

1. List existing directories under `docs/specs/`.
2. Find the highest `NNN` prefix (3-digit, zero-padded).
3. New feature number = highest + 1 (or `001` if none exist).
4. Derive `<short-name>` as 2-4 kebab-case words from the feature description (preserve acronyms like OAuth2, API, JWT).
5. Create `docs/specs/NNN-<short-name>/` and write `spec.md` from [references/spec-template.md](references/spec-template.md).

## Clarify Protocol (used by Specify)

Run a structured ambiguity scan before, or interleaved with, writing the spec. Never ask more than 5 questions total.

### 1. Taxonomy scan

Mark each category `Clear` / `Partial` / `Missing`:

| Category | Looks at |
|---|---|
| Functional Scope & Behavior | core goals, out-of-scope, user roles |
| Domain & Data Model | entities, attributes, relationships, lifecycle, scale |
| Interaction & UX Flow | key journeys, error/empty/loading states, a11y/localization |
| Non-Functional Quality | performance, scalability, reliability, observability, security, compliance |
| Integration & External Dependencies | APIs, protocols, failure modes, data formats |
| Edge Cases & Failure Handling | negative scenarios, rate limiting, conflict resolution |
| Constraints & Tradeoffs | technical constraints, rejected alternatives |
| Terminology & Consistency | canonical terms, deprecated synonyms |
| Completion Signals | acceptance-criteria testability, Definition of Done |

### 2. Question queue

- Only ask about categories marked `Partial`/`Missing` where the answer materially changes architecture, data model, tasks, tests, UX, or compliance.
- Max 5 questions total. Prioritize: scope > security/privacy > UX > technical detail.
- Each question is either multiple-choice (2-5 mutually exclusive options) or short-phrase (≤5 words).

### 3. Ask one at a time

For a multiple-choice question:

```
**Recommended:** Option A — <one-sentence reasoning>

| Option | Description |
|--------|-------------|
| A | ... |
| B | ... |
| C | ... |
| Short | Provide your own answer (≤5 words) |

Reply with the letter, "yes"/"recommended" to accept, or your own short answer.
```

For a short-answer question:

```
**Suggested:** <answer> — <brief reasoning>

Format: short answer (≤5 words). Reply "yes"/"suggested" to accept, or give your own.
```

Stop asking when: all critical ambiguities are resolved, the user signals "done"/"good enough", or 5 questions have been asked.

### 4. Atomic integration

After EACH accepted answer, immediately (don't batch):

1. Ensure `## Clarifications` exists near the top of `spec.md` (after the header block).
2. Under a `### Session YYYY-MM-DD` heading, append `- Q: <question> → A: <answer>`.
3. Apply the answer to the right section: functional ambiguity → Functional Requirements; data shape → Key Entities; non-functional → Success Criteria (turn a vague adjective into a metric); edge case → Edge Cases; terminology → normalize across the file.
4. Save the file (atomic write) before asking the next question.

## Constitution as Gate

`spec-planner` loads `docs/constitution.md` (if it exists) before writing `plan.md`. Any Core Principle marked as a MUST is a gate: a violation is either resolved by changing the plan, or explicitly justified in the Plan's Complexity Tracking table. Constitution changes use semantic versioning: MAJOR = principle removed/redefined, MINOR = principle added, PATCH = wording clarification.

## Templates

- [references/constitution-template.md](references/constitution-template.md)
- [references/spec-template.md](references/spec-template.md)
- [references/plan-template.md](references/plan-template.md)
- [references/tasks-template.md](references/tasks-template.md)

## Interplay with Existing Rules

- No speculation: mark unresolved items as `ASSUMPTION: ...` instead of guessing (see `trust-boundary.instructions.md`).
- Answer/write in the user's language; keep `FR-###`/`SC-###`/`T###` identifiers and headings in English for cross-project consistency.
- `ai-caveman` communication style still applies to chat replies; written artifacts (spec/plan/tasks) stay in normal, precise prose.
