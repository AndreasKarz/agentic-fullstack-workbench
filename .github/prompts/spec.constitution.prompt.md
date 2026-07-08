---
agent: spec-analyst
model: 'Claude Opus 4.8'
tools: [read, edit, search, todo]
description: Create or amend the project constitution (docs/constitution.md) — non-negotiable principles that gate every feature plan.
---

Hints (do not repeat): load the `spec-driven-workflow` skill; resolve the project root (never the workbench) before writing; use `references/constitution-template.md`; apply semantic versioning (MAJOR/MINOR/PATCH) on amendments.

Task: Create `docs/constitution.md` if it does not exist (interview the user for Core Principles and Governance), or amend it if it does (ask what changed, bump the version accordingly, update Last Amended).
