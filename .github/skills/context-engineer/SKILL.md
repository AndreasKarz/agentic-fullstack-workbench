---
name: context-engineer
description: "Single entry point for authoring and curating Copilot context — create/update skills, agents, instructions, prompts, and project memory; consolidate overlapping customizations; debug discovery; and build compact DIGEST/RAW knowledge. Use when: create or review SKILL.md, .agent.md, .instructions.md, .prompt.md, AGENTS.md, or .github/memory; design routing, handoffs, applyTo patterns, tool restrictions, progressive disclosure, prompt structure, context curation, or Hierarchical RAG."
---

# Context Engineer

Consolidated skill for creating and curating Copilot context artifacts (skills, agents, instructions, prompts) and memory. Keep `SKILL.md` as the compact core; load one `references/<domain>/` guide only when the task needs that depth.

## Output style

Apply the `caveman` skill to every user-facing response (default `full`) unless the user says `stop caveman` / `normal mode`. Keep artifact content, YAML frontmatter, file paths, `applyTo` globs, and generated markdown in **normal precise form** — never caveman. Relax caveman for irreversible-action confirmations (e.g. deleting artifacts), then resume.

## Capabilities

Discrete units of work this skill owns (map a spec/change to one):

1. **skill-creator** — create/update/review/package `SKILL.md` (structure, frontmatter, progressive disclosure, bundled references/assets/scripts).
2. **agent-creator** — create/update `.agent.md` (structure, workflow, domain knowledge, handoffs, tool/visibility flags).
3. **instructions-creator** — create/update `*.instructions.md` / `copilot-instructions.md` (applyTo patterns, instruction hierarchies).
4. **prompt-creator** — craft/improve/debug `.prompt.md` and LLM system prompts (few-shot, chain-of-thought, metaprompts).
5. **context-curator** — analyze-first curation of `.github`/`.copilot` customizations and memory (context rot, drift, overlap, stale entries).
6. **skillopt-curator** — SkillOpt-style bounded edit loop to tighten/consolidate `.github` after a session.
7. **hierarchical-rag** — DIGEST/RAW two-tier knowledge structure for context compression.

## Orientation

- **Analyze-first for curation:** propose a plan and only execute destructive/broad changes on explicit confirmation.
- **Metadata standard:** every artifact carries a `description` with trigger keywords, plus source/date where useful; the folder name must match the frontmatter `name` (see `metadata-standard.instructions.md`, auto-loaded).
- **Progressive disclosure:** keep a compact `SKILL.md` core and push depth into `references/`; the same principle these guides teach applies to the guides themselves.
- Project memory is plain Markdown under the active project's `.github/memory/`; MCP servers are for external evidence only.

## Lazy reference loading

Do **not** read `references/` up front. Classify the task, then open the **smallest** matching guide (usually one). Each domain guide lives at `references/<domain>/<domain>.md`; larger domains keep detailed files in that folder's `references/`, `scripts/`, `assets/`, or `agents/` subfolder.

| Task signal | Load only |
|---|---|
| Create/update/review/package a `SKILL.md` skill | `references/skill-creator/skill-creator.md` |
| Create/update a `.agent.md` agent | `references/agent-creator/agent-creator.md` |
| Create/update `*.instructions.md` / `copilot-instructions.md` | `references/instructions-creator/instructions-creator.md` |
| Create/improve/debug a prompt or system prompt | `references/prompt-creator/prompt-creator.md` |
| Analyze/curate `.github`/`.copilot` customizations + memory | `references/context-curator/context-curator.md` |
| Tighten/consolidate `.github` after a session (SkillOpt) | `references/skillopt-curator/skillopt-curator.md` |
| Build/maintain a DIGEST/RAW Hierarchical RAG structure | `references/hierarchical-rag/hierarchical-rag.md` |

**Reference map:** inside a domain guide, an instruction to "load the `ai-<x>` skill" now means **read `references/<x>/`** in this skill (drop the `ai-` prefix, e.g. `ai-skill-creator` → `references/skill-creator/`).

## Workflow

1. **Understand** — clarify which artifact scope is affected (skill / agent / instruction / prompt / curation / memory).
2. **Classify** — map the task to one capability above; load the matching guide only if needed.
3. **Execute** — follow the metadata standard; analyze-first for curation, apply broad/destructive changes only on explicit confirmation.
4. **Validate** — folder name matches `name`; `description` has trigger keywords; references resolve.
5. **Align** — present result; confirm before irreversible actions.

<!-- Last updated: 2026-07-10 · Part of the Copilot Context Blueprint -->
