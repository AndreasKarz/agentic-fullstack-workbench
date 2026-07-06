---
name: ai-context-curator
description: "Use when analyzing or curating Copilot customizations in .copilot or .github plus memories. Detects context rot, skill drift, stale entries, and overlapping prompts/agents/skills. Starts analyze-first; execute changes only when explicitly asked."
tags:
  - maintenance
  - memory
  - agents
  - context
version: 0.1.0
entrypoint: curator-core
---

# Context-Curator

## Overview

This skill defines a Context Curator for agent environments.
The curator observes how skills, tools, prompts, and user memories are used, detects context rot and skill drift, and proposes curation steps or executes them via tools.

It can:
- Maintain agent context (agents, skills, instructions, prompts) in `.copilot/**` or `.github/**`, as well as
- Curate memories and chat histories via the configured `afw-memory` MCP server, user-/repo-memories, or the local Markdown memory store under `~/.copilot/memory`.

Memory priority:
1. Check if `afw-memory` is present in `.vscode/mcp.json`.
2. If yes: start or use the `afw-memory` MCP tools.
3. If not or unreachable: use user-/repo-memories or Markdown files under `~\.copilot\memory` as fallback.

Do not perform destructive actions when only analysis signals are present.

The skill is structured with sub-agents:
- `curator-core` coordinates the overall process.
- `skills-curator` focuses on skills/tools/prompts.
- `memory-curator` focuses on user memories.

## When to use this skill

Use this skill when:

- The skill/tool/prompt catalog of a system has grown and
  - unused or outdated entries are suspected,
  - functionally overlapping or inconsistent instructions are present;
- User memories, repo memories, or chat histories become cluttered and redundant;
- A user names a concrete scope like `C:\Users\...\.copilot`, `.github/**`, skills, agents, prompts, or memories;
- `afw-memory` or local Markdown memories under `.copilot/memory` are available and a "second brain" curation is needed.

## High-level process

1. **Analysis phase**
  - Read metrics and raw data about agents/skills/instructions/prompts (e.g. `last_used_at`, `usage_count`, `pinned`, error rates), where available.
  - If usage metrics are missing, use only reliable proxy signals: modification time, file size, frontmatter, trigger descriptions, local Markdown memory hits, and content overlaps.
  - Before memory access, check MCP configuration for `afw-memory` and use its memory tools on success.
    - If `afw-memory` is not configured or unreachable, read memory information from user-/repo-memories or Markdown files under `~/.copilot/memory`, where available.
   - Identify candidates for:
     - "stale" (unused for too long),
     - "archive_candidate" (unused even longer),
     - "merge_candidate" (overlap and duplicates),
     - "rewrite_candidate" (description no longer matches behavior).

2. **Planning phase**
   - Generate a numbered curation plan with brief justifications.
   - Clearly separate:
     - skills/tools/prompts, and
     - user memories.

3. **Curation phase**
   - Execute idempotent actions, e.g.:
     - Agents/skills/instructions/prompts:
       - `mark_stale`, `archive`, `pin`, `unpin`, `merge`, `rewrite`.
     - Memories:
       - `archive`, `compress`, `tag_core`, `tag_historical`.
   - For `merge`/`rewrite` always generate a before/after view of the content.

4. **Documentation phase**
   - Output a compact table of all changes.
   - Keep justifications brief and technical (metrics, observations — no marketing language).

## Modes

The Context Curator operates in two modes:

### Analyze Mode

- Focus: observe and evaluate, no changes.
- Output:
  - List of observations (e.g. "Skill X: 0 uses in 60 days", "Memory Y: 10 similar entries"),
  - Proposal for concrete curation steps, but no execution yet.

### Curate Mode

- Focus: execute a clearly defined curation plan.
- Actions:
  - For agents/skills/instructions/prompts: file changes or available curation tools that actually apply status changes, merges, or rewrites.
  - For memories: prefer `afw-memory` tools; if `afw-memory` is not configured or unreachable, user-/repo-memories or Markdown files under `~/.copilot/memory` as fallback.
- Every change is briefly justified.

## Inputs and assumptions

The skill assumes the following possibilities:

- Tools/integrations may exist with which the agent can:
  - Read agent/skill/instruction/prompt metadata (incl. usage, last used, pinned status).
  - Make changes to these entries (e.g. status fields, description text, config values).
  - Access `afw-memory` tools to:
    - search memories,
    - add new memories,
    - update or archive existing memories.
  - Fall back to user-/repo-memories or Markdown files under `~/.copilot/memory` if `afw-memory` is not configured or unreachable.

- Typical inputs:
  - `mode`: `"analyze"` or `"curate"`.
  - Thresholds:
    - `skills.stale_after_days`,
    - `skills.archive_after_days`,
    - `memories.stale_after_days`,
    - `memories.archive_after_days`.
  - Optional: scopes such as `agent_id`, `user_id`, `namespace`, `.copilot/**`, `.github/**`, or specific directories.

## Subagents

This skill uses three sub-agents:

- `curator-core`:
  - central control, orchestrates analysis and curation steps.

- `skills-curator`:
  - specializes in curating agents/skills/instructions/prompts.
  - responsible for detecting "stale", "archive_candidate", "merge_candidate", "rewrite_candidate" in the skill layer.

- `memory-curator`:
  - specializes in memories and chat histories.
  - first checks configuration and uses `afw-memory`; then falls back to user-/repo-memories or Markdown files under `~\.copilot\memory`.

Instructions for these sub-agents are in the files in the `agents/` directory.

## Output format

When working as a Context Curator, follow this output format:

1. **Curation plan (required)**
   - A numbered list, e.g.:

     1. Skill `summarize-report`: mark_stale — 0 uses in 45 days.
     2. Skill `legacy-export`: archive — 0 uses in 120 days, replaced by `export-v2`.
     3. Memory cluster "Travel Conditions 2023": move to historical — all facts clearly past-dated.

2. **Change log (in curate mode)**
   - A table with columns:

     | Type | ID/Name | Action | Reason |

3. **Diff section (for merge/rewrite)**
   - Show brief before/after:

     ```text
     BEFORE:
     <old description/configuration>

     AFTER:
     <new description/configuration>
     ```

## Guidelines

- Never delete permanently unless explicitly requested. Default action is archive.
- Respect `pinned` status:
  - Do not modify or archive pinned items.
- If `pinned` status cannot be determined, treat the item as not safely archivable — propose at most review/rewrite.
- Make no silent assumptions about data scopes:
  - Only process what you have explicitly received info and/or tools for.
- Stay concise and technical:
  - Base reasons on metrics and observations — no marketing terms.
- Before triggering changes, ensure a clear plan is present in the same output.

<!-- Last updated: 2026-07-02 · Part of the Copilot Context Blueprint -->
