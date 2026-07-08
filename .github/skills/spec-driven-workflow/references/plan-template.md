# Implementation Plan: [FEATURE]

**Feature**: `[NNN-feature-name]` | **Date**: [DATE] | **Spec**: `docs/specs/[NNN-feature-name]/spec.md`

## Summary

[1-2 sentences: primary requirement + chosen technical approach]

## Technical Context

<!-- Prefill with the company stack where it applies; mark anything genuinely open as NEEDS CLARIFICATION. -->

**Language/Version**: [e.g., C# 12 / .NET 8, TypeScript 5 / React 19]
**Primary Dependencies**: [e.g., HotChocolate GraphQL, MassTransit, MongoDB.Driver / Relay, Vite]
**Storage**: [e.g., MongoDB, SQL Server, N/A]
**Testing**: [e.g., xUnit + Moq + Squadron / Vitest + Playwright]
**Target Platform**: [e.g., Azure Container Apps / browser]
**Project Type**: [service/library/web-frontend/data-pipeline]
**Performance Goals**: [domain-specific, or NEEDS CLARIFICATION]
**Constraints**: [domain-specific, or NEEDS CLARIFICATION]
**Scale/Scope**: [domain-specific, or NEEDS CLARIFICATION]

## Constitution Check

*GATE: evaluate against `docs/constitution.md` before detailing Project Structure. Re-check after any structural change.*

[List each Core Principle and whether the plan complies. Violations of a MUST principle go into Complexity Tracking below with a justification, or the plan is revised.]

## Project Structure

```text
docs/specs/[NNN-feature-name]/
├── plan.md              # this file
├── spec.md
└── tasks.md             # produced by the Tasks step
```

### Source Code (adapt to the real repo layout — delete unused options)

```text
# Option 1: Backend service (.NET)
src/<Service>/
├── Abstractions/
├── Core/
├── DataAccess/
├── GraphQL/
└── Host/

# Option 2: Frontend feature (React/Relay)
src/
├── components/<feature>/
├── routes/<feature>/
└── __generated__/        # Relay artifacts
```

**Structure Decision**: [State which option applies and the concrete paths used]

## Complexity Tracking

> Fill ONLY if the Constitution Check found violations that must be justified.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|--------------------------------------|
| [e.g., extra service] | [reason] | [why insufficient] |
