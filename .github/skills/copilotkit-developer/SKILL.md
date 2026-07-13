---
name: copilotkit-developer
description: "Single entry point for building CopilotKit v2 AI features — add/bootstrap CopilotKit, React UI (@copilotkit/react-core/v2: provider, CopilotChat/Popup/Sidebar, useAgent, useFrontendTool, useRenderTool, human-in-the-loop, threads, renderers), server runtime (@copilotkit/runtime/v2: CopilotRuntime, createCopilotRuntimeHandler, BuiltInAgent, AgentRunner, middleware, server tools, transcription), the AG-UI protocol (SSE, AbstractAgent/HttpAgent, state sync, tool calls), external agent-framework integrations (LangGraph, CrewAI, PydanticAI, Mastra, ADK, LlamaIndex, Agno, Strands, Microsoft Agent Framework), A2UI declarative surface rendering, and debugging. Use when: install/wire CopilotKit, build a chat/copilot feature, register frontend/server tools, share app context, handle agent interrupts/HITL, implement or wire an AG-UI agent backend, render A2UI surfaces, or debug runtime connectivity/streaming/tool/transcription/version issues. NOT for React UI implementation itself (use frontend-developer) or backend microservices (use backend-developer)."
---

# CopilotKit Developer

Consolidated skill for building AI features with CopilotKit v2 (React UI + server runtime + AG-UI). Keep `SKILL.md` as the compact core; load one `references/<domain>/` guide only when the task needs that depth.

## Output style

Apply the `caveman` skill to every user-facing response (default `full`) unless the user says `stop caveman` / `normal mode`. Keep code, commands, package names (`@copilotkit/react-core`, `@copilotkit/runtime`), config, and generated artifacts in **normal precise form** — never caveman. Relax caveman for irreversible-action confirmations, then resume.

## Capabilities

Discrete units of work this skill owns (map a spec/change to one):

1. **setup** — add CopilotKit to a project or bootstrap a new one (install, runtime wiring, provider, first chat).
2. **develop** — build AI features: chat interfaces, frontend tools, shared context, agent interrupts.
3. **react-core** — CopilotKit React UI: provider, chat components, hooks, tools, renderers, threads, HITL.
4. **runtime** — CopilotKit server runtime: `CopilotRuntime`, handler, agents/runners, middleware, server tools, transcription.
5. **agui** — the AG-UI protocol: custom agent backends, SSE event streams, state sync, tool calls.
6. **integrations** — wire external agent frameworks (LangGraph, CrewAI, PydanticAI, Mastra, ADK, …) via AG-UI.
7. **a2ui-renderer** — render A2UI declarative surfaces (`createSurface`, `updateComponents`, message renderer, themes).
8. **debug** — diagnose connectivity, streaming, tool execution, transcription, and version-mismatch issues.
9. **self-update** — refresh this skill's CopilotKit reference guides when the APIs change.

## Orientation

- CopilotKit v2 splits into **client** (`@copilotkit/react-core/v2`) and **server runtime** (`@copilotkit/runtime/v2`); the runtime bridges the UI to agents.
- Agents talk to the frontend over the **AG-UI protocol** (SSE event stream). External frameworks integrate through the same protocol.
- Read `package.json` for the installed CopilotKit version before version-sensitive work; APIs evolve fast (see the `self-update` guide).

## Lazy reference loading

Do **not** read `references/` up front. Classify the task, then open the **smallest** matching guide (usually one). Each domain guide lives at `references/<domain>/<domain>.md`; larger domains keep detailed files in that folder's `references/` (and `setup` has `assets/`).

| Task signal | Load only |
|---|---|
| Add/bootstrap CopilotKit, install, first working chat | `references/setup/setup.md` |
| Build AI features, frontend tools, shared context, interrupts | `references/develop/develop.md` |
| React provider, chat components, hooks, tools, renderers, threads, HITL | `references/react-core/react-core.md` |
| Server runtime, `CopilotRuntime`, agents/runners, middleware, server tools, transcription | `references/runtime/runtime.md` |
| AG-UI protocol, custom agent backend, SSE, state sync, tool calls | `references/agui/agui.md` |
| Wire an external agent framework (LangGraph, CrewAI, Mastra, …) via AG-UI | `references/integrations/integrations.md` |
| Render A2UI declarative surfaces | `references/a2ui-renderer/a2ui-renderer.md` |
| Debug connectivity, streaming, tool/transcription failures, version mismatch | `references/debug/debug.md` |
| Refresh this skill's CopilotKit guides (not app code) | `references/self-update/self-update.md` |

**Reference map:** inside a domain guide, an instruction to "load the `frontend-copilotkit-<x>` skill" now means **read `references/<x>/`** in this skill (drop the `frontend-copilotkit-` prefix, e.g. `frontend-copilotkit-react-core` → `references/react-core/`).

**Cross-skill work:** React/TypeScript/UI implementation → `frontend-developer`. GraphQL/Relay data → `frontend-developer` Relay references plus `backend-developer` for the server schema. Backend/.NET → `backend-developer`.

## Workflow

1. **Understand** — check the installed CopilotKit version (`package.json`) and existing provider/runtime wiring.
2. **Classify** — map the task to one capability above; load the matching guide only if needed.
3. **Implement** — keep human-in-the-loop for critical actions; keep the app usable when AI requests fail.
4. **Validate** — verify the runtime connects and events stream; use the `debug` guide on failures.
5. **Align** — present result; confirm before irreversible actions.

## Know-how

- CopilotKit docs: <https://docs.copilotkit.ai>

<!-- Last updated: 2026-07-10 · Part of the Copilot Context Blueprint -->
