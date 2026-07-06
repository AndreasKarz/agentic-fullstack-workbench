---
description: 'Authoring standard for context artifacts (skills, agents, instructions, prompts): header metadata + naming. Use when creating or updating a SKILL.md, *.agent.md, *.instructions.md, or *.prompt.md.'
applyTo: '**/*.instructions.md, **/*.agent.md, **/*.prompt.md, **/SKILL.md'
---

# Metadata Standard per Artifact

Every context artifact carries these elements in the header:

- **Short description** — what & when, in the frontmatter `description`. Include trigger keywords (the `description` is the discovery surface — if keywords are missing, the artifact won't be found).
- **Source** — upstream URL if externally derived (as HTML comment or body line).
- **Date** — date of last update (`YYYY-MM-DD`).
- **Know-how** — 2–3 URLs to learning resources, where useful.

## Conventions

- **Filenames:** `*.agent.md`, `*.instructions.md`, `skills/<kebab-name>/SKILL.md`, `*.prompt.md`.
- Skill folder name = `name` in frontmatter (otherwise silent failure).
- `description` with colon **always quote** (`"Use when: …"`).
- `applyTo: "**"` only if truly relevant everywhere (context cost!) — otherwise specific globs (`**/*.cs`, `src/api/**`).
- **No** secrets, personal paths, ADO GUIDs, or internal URLs — the blueprint is shareable and self-contained.

<!-- Last updated: 2026-07-02 -->
