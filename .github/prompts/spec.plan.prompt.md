---
agent: spec-planner
model: 'Claude Opus 4.8'
tools: [read, edit, search, todo]
description: Create the technical implementation plan (plan.md) for a clarified feature specification, gated by the project constitution.
---

Hints (do not repeat): load the `spec-driven-workflow` skill; require `spec.md` to exist for the named feature (hand back to `/spec.specify` if missing); load `docs/constitution.md` if present; use `references/plan-template.md`.

Task: Fill Summary, Technical Context, and the Constitution Check gate (evaluate every MUST principle explicitly), then the Project Structure with concrete real paths for this repo. Flag any unresolved `NEEDS CLARIFICATION` instead of guessing. End by suggesting the handoff to `/spec.tasks`.
