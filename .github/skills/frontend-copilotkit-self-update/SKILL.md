---
name: frontend-copilotkit-self-update
description: "Use when refreshing this agent's CopilotKit SKILL.md files, not the user's app code. Triggers on: update CopilotKit skills, refresh skills, stale skills, outdated CopilotKit knowledge, wrong API names, reinstall skills, CopilotKit APIs changed."
version: 1.0.0
user_invocable: true
argument_hint: ""
---

# Update CopilotKit Skills

Run this command to pull the latest CopilotKit skills from GitHub:

```bash
npx skills add copilotkit/CopilotKit --full-depth -y
```

This does a fresh clone every time — it always gets the latest version regardless of what's cached.

This works across all tools — Claude Code, Codex, Cursor, Gemini CLI, and others. It detects which tools are installed and updates skills for each.

After the command completes, **start a new session** in your tool to pick up the changes.

## When to Suggest This

- User says the skills have wrong API names or outdated information
- User reports that a CopilotKit API doesn't match what the skill says
- User explicitly asks to update or refresh skills
- A new CopilotKit version was released and skills may be stale
