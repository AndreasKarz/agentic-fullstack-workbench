# VS Code Agent Creator

Create or update workspace agents under `.github/agents/*.agent.md`. Use an agent only when a task needs a distinct tool/permission set, model, independently evaluated phase, or user-selectable persona. Put reusable domain knowledge in a skill.

Before a substantial redesign, check:

- <https://code.visualstudio.com/docs/agent-customization/custom-agents>
- <https://www.anthropic.com/engineering/building-effective-agents>

Prefer the smallest composable workflow that meets a measured need.

## Frontmatter

Current VS Code agent frontmatter supports:

| Field | Use |
|---|---|
| `name` | display name; filename is fallback |
| `description` | concise discovery and purpose text |
| `argument-hint` | optional input hint |
| `tools` | exact built-in, extension, or `<mcp-server>/*` tools |
| `agents` | subagents available to this agent; include `agent` in `tools` |
| `model` | one model or ordered fallback list |
| `user-invocable` | show in picker; default `true` |
| `disable-model-invocation` | block invocation as subagent; default `false` |
| `target` | `vscode` or `github-copilot` |
| `handoffs` | guided next-agent buttons |
| `hooks` | preview, agent-scoped hooks |

Use exact installed tool and agent identifiers. Unknown tools are ignored, which can silently weaken an agent.

```yaml
---
name: change-reviewer
description: "Read-only reviewer for an implemented OpenSpec change."
user-invocable: false
disable-model-invocation: false
model:
  - "GPT-5.6 Terra (copilot)"
tools: [vscode, execute, read, search]
---
```

`user-invocable: false` hides a worker from the picker. Keep `disable-model-invocation: false` when a coordinator must invoke it as a subagent. Restrict access through the coordinator's `agents` list.

## Handoffs

Use handoffs when the user should consciously move between phases.

```yaml
handoffs:
  - label: Review Change
    agent: change-reviewer
    prompt: Review the active OpenSpec change against all artifacts.
    send: false
    model: "GPT-5.6 Terra (copilot)"
```

Prefer `send: false` for approval-sensitive transitions. Verify every handoff target exists.

## Body

Keep the body short and imperative:

1. Define the mission and hard scope boundary.
2. State how to resolve source context and ground truth.
3. Give the ordered workflow and stopping conditions.
4. Define a compact output contract when another phase consumes the result.
5. Refer to skills for domain depth instead of copying patterns into the agent.

Read-only agents must omit edit tools and explicitly forbid edits. Review and validation should remain separate from implementation when independence materially improves confidence.

## Validation

- Agent filename, `name`, `agents`, and handoff identifiers resolve.
- Tool names match current VS Code/MCP configuration.
- Coordinators include `agent` when they declare `agents`.
- Hidden workers remain subagent-invocable when required.
- The agent does not duplicate a skill or OpenSpec lifecycle state.
- The body states what happens on ambiguity, failed evidence, and irreversible actions.

<!-- Last updated: 2026-07-13 -->
