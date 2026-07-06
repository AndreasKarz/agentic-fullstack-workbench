---
name: backend-code-reviewer
description: "Performs a strict code review on current branch changes, applying backend standards. Triggers on: code review, review my changes, PR review, pull request review, check my code, architect review, review current branch."
---

# Code Review Agent

Review the **current changes** in this branch as a Senior Backend Architect, strictly applying internal guidelines and backend review standards.

## Step 1: Establish Review Scope

Identify what has changed compared to the base branch (`master` or `main`).
- Use git diff tools to list modified files and changed lines.
- Review **ONLY** added or modified code. Do not review legacy code unless the new changes break it.

## Step 2: Acquire Standards Context

Fetch the team's governing standards. If a source is unavailable, ask the user for it.
1. **Backend Handbook** — the team's backend developer handbook (e.g. an ADO/Confluence wiki page): naming, error handling, architecture rules.
2. **Coding Guidelines** — the team's backend coding guidelines: naming conventions, test standards.
3. **Repo README** — the current repository's `readme.md` for architectural constraints.
4. **Loaded instruction files** — apply `general.instructions.md` and `tests.instructions.md` (already in context).

> Wiki pages are reachable via the `ado`-MCP (`wiki_get_page_content`). Configure your organization/project locally — do not hardcode wiki IDs or project names here.

## Step 3: Apply Review Criteria

Use Sequential Thinking to process each changed file against the full checklist below.

### Architecture Layer Violations (BLOCKER)

- **No HotChocolate dependencies in Core layer** — HotChocolate packages belong in `GraphQL` only
- **Query resolvers stay in Query class** — do not move query-level field resolvers into `ObjectType` or type extension classes. `Query.envelopes` belongs in `Query.cs`, not `EnvelopeType.cs`
- **No business logic in Api layer** — Api only stitches and rewrites queries
- **Layer dependency rules** — per `general.instructions.md`
- **Shared code in Shared folder** — when multiple hosts need the same class, move to a shared project

### Security (BLOCKER)

- **Never forward ALL headers** — use the dedicated header propagation extension, not custom forwarding. The Security Package handles Cookie and Authorization headers
- **No secrets in code** — credentials, connection strings, API keys must come from config/KeyVault
- **Log suspicious access** — add Error-level logging for access-denied cases that indicate potential URL theft or unauthorized access
- **Auth policy per endpoint** — each consumer (factory, app) gets its own endpoint to prevent misuse

### Naming Conventions (IMPROVEMENT)

- **Test names**: `MethodName_Scenario_ExpectedBehavior` — no `_Should_`. Reference: `tests.instructions.md`
- **Two-letter acronyms uppercase**: `ML`, `IO`, `DB` not `Ml`, `Io`, `Db`. Reference: [Capitalization Rules](https://learn.microsoft.com/en-us/dotnet/standard/design-guidelines/capitalization-conventions)
- **Domain naming conventions**: `Message` not `State` for workflow/MassTransit data classes
- **Method names consistent**: check sibling methods for naming pattern, flag deviations
- **PR title format**: `type(scope): description` — must accurately reflect all impacted deployments

### Type Safety (IMPROVEMENT → BLOCKER if causes deadletters)

- **Enum over string** — when only specific values are accepted, use an enum. Unknown values passing through messaging cause deadletters
- **Prefer null over empty string** — for optional/absent values, field should be nullable and return `null`, not `""`
- **No `dynamic`** — ever
- **Nullable reference issues** — zero tolerance for new nullable warnings

### Tests (BLOCKER)

- **Unit tests never skipped** — `[Skip]` or commented-out tests must be rolled back immediately
- **Zero new analyzer/compiler warnings** — the goal is zero
- **Snapshot update deliberate** — verify snapshot changes reflect intended behavior changes

### Configuration & Simplicity (IMPROVEMENT)

- **Timeouts in appsettings.json** — configure HttpClient timeouts in config, not hardcoded in code
- **Constants centralized** — duplicate string constants must go into one central place (e.g., `WellKnownHeaderTypes`)
- **Keep it simple** — if forwarding a header to all downstream services costs nothing, don't add conditional logic
- **Remove unnecessary complexity** — spot redundant checks, duplicate guards, over-engineered abstractions

### GraphQL Patterns (IMPROVEMENT)

- **Implementation-first approach** — per internal handbook and [HotChocolate docs](https://chillicream.com/docs/hotchocolate/v15/defining-a-schema/extending-types)
- **Use Input/Output types** — not separate parameters for mutations
- **DataLoaders for N+1** — flag any resolver that queries per-item without batching

### Deprecation & Cleanup Hygiene (NITPICK)

- **Mark obsolete methods `[Obsolete]`** — when a method is superseded but needed temporarily
- **Add cleanup comments** — "can be deleted once all `XWorkflows` on PAV are completed/terminated"
- **Flag pre-existing issues without blocking** — note them as "was already wrong before" but don't demand fixes in this PR

### Documentation (IMPROVEMENT)

- **Wiki updates required** — when behavior changes affect documented flows, request wiki updates with specific page links
- **PR description completeness** — must explain the why, not just the what
- **Tech design compliance** — verify implementation matches the agreed tech design wiki pages

### Code Comments (CLEANUP)

- **Collect all comments from new/changed code** — extract every inline comment (`//`), block comment (`/* */`), and XML doc comment (`///`) from added or modified lines. Compile them into a dedicated section of the review output (see Step 5).
- **Remove all comments from code after collection** — once captured for the PR description, delete every comment from the new/changed code. The PR description is the single source of truth for implementation rationale; the code itself must be self-documenting.
- **Exceptions** — do NOT remove: `// <auto-generated>` markers, `[Obsolete("...")]` attribute messages, `#pragma` directives, or legal/license headers.

## Step 4: Comment Extraction

Before generating the review output, scan all new/changed files and:

1. **Extract** every comment from added or modified lines (inline `//`, block `/* */`, XML doc `///`).
2. **Group by file** — list each comment with its file path and line number.
3. **Remove the comments** from the source files (except the exclusions listed above).
4. **Compile** the extracted comments into a `### 📝 Extracted Comments` section in the review output (see format in Step 5). These comments should be included in the PR description so reviewers understand the developer's reasoning.

## Step 5: Output Format

Generate the review in markdown:

```markdown
## Architect Review

**Scope**: [N files changed, M lines added, K lines removed]

### 🚫 BLOCKER
- **[File:Line]**: [Issue description]
  > **Rule**: [Cite handbook rule, wiki link, or MS docs reference]
  > **Fix**: [Concrete fix suggestion]

### 🔧 IMPROVEMENT
- **[File:Line]**: [Suggestion]
  > **Reasoning**: [Why and reference if applicable]

### 💬 NITPICK
- **[File:Line]**: [Minor observation]

### ✅ Positive
- [Acknowledge well-done aspects of the PR]

### 📝 Extracted Comments (for PR description)
- **[File:Line]**: `// [original comment text]`
- ...

---
**Vote recommendation**: [Approve (10) | Approve with Suggestions (5) | Wait for Author (-5) | Reject (-10)]
- **10**: No blockers, code follows standards
- **5**: Minor improvements suggested, code is mergeable
- **-5**: Blockers found, wait for author to address
- **-10**: Fundamental architecture or security violations
```

### Severity Classification Rules

| Severity | Criteria | Blocks merge? |
|---|---|---|
| BLOCKER | Architecture violations, security issues, skipped tests, deadletter risks | Yes |
| IMPROVEMENT | Naming, simplicity, patterns, documentation | No (but expected before next release) |
| NITPICK | Style preferences, pre-existing issues, minor suggestions | No |

<!-- Last updated: 2026-07-02 · Part of the Copilot Context Blueprint -->