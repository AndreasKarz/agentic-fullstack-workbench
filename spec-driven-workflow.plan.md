# Plan: Spec-Driven Workflow (Constitution / Specs / Plans) im Copilot-Workbench

> Status: APPROVED — bereit zur Umsetzung.
> Methodik adaptiert vom **Spec Kit** (Spec-Driven Development). Upstream-Referenz nur als Provenance:
> `https://github.com/github/spec-kit`. Dieser Plan ist **self-contained** — keine Laufzeit- oder
> Datei-Abhängigkeit zu Fremd-/Temporärordnern. Templates & Protokolle werden im Repo neu
> geschrieben und an unseren Stack angepasst.

## Kontext & Ziel

- Prinzip von Constitution + Specs + Plans adaptiert (NICHT 1:1) übernehmen.
- Neuer `spec-` Cluster: 1 Skill + 2 versteckte Phase-Agenten + 5 Prompts, additiv in JEDEN Team-Orchestrator verdrahtet.
- Flow pro Team: Clarify-Interview → Spezifikation → Plan+Tasks → (bestehende) Implement/Review/Validate.
- Artefakte im PROJEKTORDNER unter `docs/`, nicht im Workbench.
- Nicht-brechend: nur neue Dateien + additive Anhänge an bestehende Frontmatter/Routing/Docs. Keine Deletes/Renames/Verhaltensänderung an bestehenden Agenten/Skills.

## Ziel-Kette pro Team

Team → Clarify & Specify (`spec-analyst`) → Plan & Tasks (`spec-planner`) → Implement (bestehender Team-Implementer) → Review → Validate.

## Fixierte Entscheidungen

1. Ablage: `<project>/docs/constitution.md` + `<project>/docs/specs/NNN-<short-name>/{spec,plan,tasks}.md`. Zielordner = Auto-Detect des einzigen Nicht-Workbench-Roots (Workbench = Ordner mit `.github/AGENTS.md`); bei mehreren Nicht-Workbench-Roots nachfragen.
2. Scriptless: Agenten legen Ordner/Dateien direkt via edit-Tool an. Nummerierung = Scan `docs/specs/` nach `NNN-`, nächste = max+1, dreistellig nullgepolstert.
3. Verdrahtung: jeden Team-Orchestrator additiv erweitern (Clarify&Specify → Plan&Tasks als ERSTE Handoffs vor Analyze/Implement/Review).
4. Scope: Constitution + Specify(inkl. Clarify) + Plan + Tasks. Implementierung über BESTEHENDE Team-Implementer (kein neuer Implement-Agent).
5. Ein `spec-analyst` macht Interview + schreibt `spec.md` (Clarify+Specify gemerged).
6. Prefix `spec-`; INDEPENDENT vom Requirements Engineer (kein RE-Handoff/keine Kopplung; Skill self-contained).

## Umsetzung

### Phase A — Skill (Single Source of Truth)

1. `.github/skills/spec-driven-workflow/SKILL.md`: Frontmatter `name: spec-driven-workflow` + `description` mit Trigger-Keywords (constitution, spec, specify, clarify, plan, tasks, spec-driven, feature specification) + Source-URL + Datum. Inhalt:
   - SDD-Zyklus (constitution → clarify/specify → plan → tasks → team-implement).
   - **Clarify-Protokoll**: 9-Kategorien-Taxonomie (Functional Scope, Domain/Data, Interaction/UX, Non-Functional, Integration, Edge Cases, Constraints, Terminology, Completion) → Scan Clear/Partial/Missing → max. 5 Fragen, EINE nach der anderen, jede mit `**Recommended:** <Option> — <Begründung>` + Markdown-Optionstabelle (A/B/C + „Short") → nach jeder Antwort atomarer Write in `## Clarifications` + Anwendung auf betroffene Spec-Section.
   - **Zielordner-Auto-Detect-Regel** (Workbench = Ordner mit `.github/AGENTS.md`; Projekt = anderer Root; mehrdeutig → fragen).
   - **Scriptless-Nummerierung** (`docs/specs/NNN-<short-name>/`).
   - **Constitution-als-Gate** (Plan lädt `docs/constitution.md` und prüft Verstöße).
   - Bezug zu bestehenden Regeln: trust-boundary/no-speculation (`ASSUMPTION:`), ai-caveman, Sprache = User-Sprache, metadata-standard.
2. `.github/skills/spec-driven-workflow/references/` (an unseren Stack adaptierte Templates, im Repo neu geschrieben):
   - `constitution-template.md` — Core Principles I..N (MUST = Gates), Zusatz-Sektionen, Governance + SemVer; Projekt-Scaffold.
   - `spec-template.md` — priorisierte User Stories (P1..), Independent-Test, GIVEN/WHEN/THEN, `FR-###`, `[NEEDS CLARIFICATION]` (max 3), Key Entities, messbare `SC-###`, Assumptions, `## Clarifications`-Log.
   - `plan-template.md` — Summary, Technical Context (Vorbelegung mit unserem Stack: .NET 8/10, HotChocolate/Fusion, MassTransit, MongoDB / React 19, Relay, Vite / DAP Databricks, PowerBI), **Constitution Check (GATE)**, Project Structure, Complexity Tracking.
   - `tasks-template.md` — Phasen Setup/Foundational/pro-User-Story/Polish, `T### [P] [US#]`-Format, Dependencies + Parallel-Hinweise, MVP-Strategie (Brücke zu Team-Implementern).

### Phase B — Phase-Agenten (versteckt, wiederverwendbar) *(hängt an A)*

3. `.github/agents/spec-analyst.agent.md`: `user-invocable: false`, `disable-model-invocation: false`; Tools read/edit/search (+ afw-sequential-thinking, afw-memory) — Tools-Frontmatter von bestehendem Phase-Agenten spiegeln. Lädt `spec-driven-workflow`. Aufgaben: Constitution create/update + Specify (Interview → `spec.md`). Model: starke Reasoning-Klasse (Opus). Handoff → `spec-planner`.
4. `.github/agents/spec-planner.agent.md`: gleiche Sichtbarkeit/Tools; lädt Skill; erzeugt `plan.md` (mit Constitution Check) + `tasks.md`. Model: stark/ausgewogen. Handoff → (generisch) Team-Implementer.

### Phase C — Prompts (Einstiegspunkte) *(hängt an B; parallel zu D)*

5. Fünf Prompts im Repo-Format (`agent`/`model`/`tools`/`description` + minimale Params + kurzer Body, der aufs Skill verweist):
   - `.github/prompts/spec.constitution.prompt.md` → `agent: spec-analyst`
   - `.github/prompts/spec.specify.prompt.md` → `agent: spec-analyst`
   - `.github/prompts/spec.clarify.prompt.md` → `agent: spec-analyst`
   - `.github/prompts/spec.plan.prompt.md` → `agent: spec-planner`
   - `.github/prompts/spec.tasks.prompt.md` → `agent: spec-planner`
   Frontmatter-/Parameter-Format an `.github/prompts/analyze_bug.prompt.md` orientieren.

### Phase D — Verdrahtung (additiv, nicht-brechend) *(hängt an B; parallel zu C)*

6. In jedem der 5 Team-Agenten (`backend-team`, `frontend-team`, `dap-team`, `product-team`, `ai-team`): `spec-analyst`,`spec-planner` an `agents:` anhängen; zwei Handoffs VORANSTELLEN — „Clarify & Specify" (→ spec-analyst) und „Plan & Tasks" (→ spec-planner); eine Body-Zeile „New features: start with Clarify & Specify." DAP-Team ggf. `tools: ['agent']` + `agents:` ergänzen (falls nicht vorhanden).
7. `.github/instructions/skill-routing.instructions.md`: Routing-Zeilen anhängen (Signale: constitution / write spec / clarify feature / plan feature / spec-driven → `spec-driven-workflow`).
8. `.github/AGENTS.md`: Abschnitt „Spec-Driven Workflow" anhängen (Flow + Artefakte im Projekt-`docs/`).

### Phase E — Verifikation

9. „Developer: Reload Window" → Registry neu bauen → keine „Unknown agent"-Diagnostics auf den 5 Team-Dateien.
10. Prüfen: 5 Team-Picker zeigen Clarify&Specify + Plan&Tasks als erste Handoffs.
11. Prompt-Binding auf versteckte Agenten testen; Fallback = `spec-*` auf `user-invocable: true` setzen.
12. Voller Dry-Run in einem Test-Projektordner: `/spec.constitution` → `docs/constitution.md`; `/spec.specify` → Interview (max 5, Recommended-Optionen) → `docs/specs/001-*/spec.md`; `/spec.plan` → `plan.md` mit Constitution Check; `/spec.tasks` → `tasks.md` mit `T### [P][US#]`.
13. Auto-Detect wählt Nicht-Workbench-Root (mehrdeutig → fragt). metadata-standard-Compliance; keine Secrets/persönlichen Pfade/GUIDs.

## Neue Dateien (Übersicht)

- `.github/skills/spec-driven-workflow/SKILL.md` (+ `references/{constitution,spec,plan,tasks}-template.md`)
- `.github/agents/spec-analyst.agent.md`, `.github/agents/spec-planner.agent.md`
- `.github/prompts/spec.{constitution,specify,clarify,plan,tasks}.prompt.md`

## Änderungen an bestehenden Dateien (nur additiv)

- `.github/agents/{backend,frontend,dap,product,ai}-team.agent.md` — `agents:` + 2 Handoffs + 1 Body-Zeile.
- `.github/instructions/skill-routing.instructions.md` — Routing-Zeilen.
- `.github/AGENTS.md` — neuer Abschnitt.

## Referenz-Dateien im Repo (Muster, bleiben bestehen)

- `.github/AGENTS.md` — Router/Phase-Agenten/Model-Routing-Muster.
- `.github/agents/backend-team.agent.md` — Vorlage für `agents:`+`handoffs`.
- `.github/agents/requirements-engineer.agent.md` — Stil-Referenz Interview/Anti-Patterns (ENTKOPPELT, kein Handoff).
- `.github/prompts/analyze_bug.prompt.md` — Prompt-Frontmatter/Parameter-Format.
- `.github/instructions/metadata-standard.instructions.md` — Authoring-Standard.

## Scope

- IN: Constitution, Specify (inkl. Clarify-Interview), Plan, Tasks; Verdrahtung in 5 Teams; Routing + AGENTS.md.
- OUT: SpecKit analyze/checklist/converge/taskstoissues; Pflichtdateien research/data-model/contracts/quickstart; Skripte; RE-Kopplung; neuer Implement-Agent; Fremdordner-Referenzen.

## Offene Optionen (später entscheidbar)

1. `spec-planner` macht Plan UND Tasks (Empfehlung) — bei Bedarf später in `spec-planner` + `spec-tasker` splitten.
2. Prompt→versteckter-Agent-Binding: verifizieren; Fallback = Agenten sichtbar.
3. AI Team einbeziehen (harmlos; Spec-Flow zielt dort auf Customization-Änderungen) oder auslassen.
