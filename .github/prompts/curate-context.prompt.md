---
name: curate-context
description: "Example prompts for triggering the Context Curator: analyze-first mode, curate specific scopes (agents, skills, prompts, memories). Use when invoking the ai-context-curator skill or the context-curator agent. Triggers: curate context, analyze .copilot, analyze .github, create curation plan, context rot, skill drift."
---

# Context Curator Example Prompts

## Start Analysis

- "Analyze with the ai-context-curator skill all agents, skills, instructions, and prompts in `~\.copilot` and propose a curation plan. Do not make any changes yet."
- "Analyze with the ai-context-curator skill all agent skills and prompts in this repo and propose a curation plan. Do not make any changes yet."
- "Please review the existing memories/preferences for this project and identify what can be archived or compressed."

## Execute Curation Plan

- "Please execute items 1–3 from your last curation plan, but leave all `pinned` skills unchanged."
- "Implement the rewrite candidates from the last curation plan; archive nothing if `pinned` status or usage metrics are missing."
- "Archive all skills marked as 'archive_candidate' and move old project notes to the historical area, provided the items are not `pinned`."

<!-- Last updated: 2026-07-02 · Part of the Copilot Context Blueprint -->