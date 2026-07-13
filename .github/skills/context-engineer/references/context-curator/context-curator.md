# Context Curator

Analyze and consolidate Copilot customizations and project memory. Keep lifecycle decisions in OpenSpec; use this guide for the customization structure itself.

## Scope

- `AGENTS.md`, `.github/agents/`, `.github/skills/`, `.github/instructions/`, `.github/prompts/`
- project memory under the active project's `.github/memory/`
- discovery metadata, references, overlaps, stale names, and context cost

Do not store project memory in MCP. MCP servers provide external evidence only.

## Analyze Mode

1. Inventory artifacts by type, size, description, visibility, and references.
2. Verify that every agent, skill, prompt, instruction, MCP name, and Markdown target resolves.
3. Detect:
   - overlapping roles or domain knowledge;
   - agents that only restate skills;
   - always-on instructions that could be lazy;
   - stale project names, versions, paths, or tools;
   - generated files that should be refreshed upstream;
   - memory entries that are redundant, obsolete, or project-external.
4. Prefer source evidence. Missing usage telemetry is not proof that an artifact is unused.
5. Produce a numbered curation plan with expected deletions, merges, rewrites, and checks. Do not edit yet.

## Curate Mode

Proceed only after the user confirms the broad plan.

1. Preserve user changes and generated boundaries.
2. Make the smallest coherent set of edits.
3. Prefer this ownership model:
   - OpenSpec: lifecycle truth and change state;
   - agents: tool/permission/model boundaries or independent phase checks;
   - skills: reusable domain knowledge and workflows;
   - instructions: genuinely always-on or path-scoped rules;
   - prompts: explicit user actions;
   - `.github/memory/`: durable project facts not already present in source or specs.
4. Delete or merge only inside the confirmed scope. Git history is the recovery path.
5. Keep `SKILL.md` compact and move depth into directly linked references.
6. Validate frontmatter, folder/name alignment, references, agent graph, MCP names, and documentation.

## Project Memory

Use one concise Markdown file per stable topic under `.github/memory/`.

- Keep durable facts, decisions, vocabulary, and recurring pitfalls.
- Link to source files or OpenSpec capabilities instead of copying them.
- Do not store secrets, credentials, customer data, temporary task state, raw chat logs, or completed change plans.
- Merge duplicate topics; remove obsolete facts only when source evidence proves replacement.

For detailed thresholds or evidence rules, read `references/curation-policies.md` only when needed.

<!-- Last updated: 2026-07-13 -->
