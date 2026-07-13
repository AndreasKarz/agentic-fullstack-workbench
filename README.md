# Agentic Fullstack Workbench

Kompakter, wiederverwendbarer Context-Layer für GitHub Copilot in VS Code. Die Workbench wird zusammen mit dem eigentlichen Projekt in einem Multi-Root-Workspace geöffnet.

```text
VS-Code-Workspace
├── agentic-fullstack-workbench   # wiederverwendbare Copilot-Regeln
└── dein-projekt                  # Code, Projektregeln, Memory, OpenSpec
```

Die zentrale Idee: **OpenSpec führt den Change-Lifecycle.** Agents trennen nur Phasen und Berechtigungen. Skills liefern Fachwissen. Es gibt keinen zweiten Plan neben OpenSpec.

## Architektur

| Ebene | Verantwortung |
|---|---|
| OpenSpec | Proposal, Specs, Design, Tasks, Status, Sync, Archiv |
| Agents | Koordination sowie unabhängige Analyse, Umsetzung, Review und Validierung |
| Skills | Lazy geladenes Fachwissen und wiederverwendbare Arbeitsabläufe |
| Instructions | Wenige, wirklich immer oder pfadabhängig geltende Regeln |
| Prompts | Explizite `/opsx-*` Aktionen für den Benutzer |
| MCP | Externe Quellen und Live-Systeme, nicht Memory |

### Agents

Es gibt genau einen sichtbaren Einstieg:

- `Workbench` – findet Projekt und aktiven OpenSpec-Change, lädt Skills und bietet Handoffs an.

Vier versteckte Phasen-Agenten halten die Prüfungen unabhängig:

- `change-analyzer` – liest Artefakte und Code, editiert nichts.
- `change-implementer` – setzt offene OpenSpec-Tasks um.
- `change-reviewer` – prüft Diff gegen Proposal, Specs, Design und Tasks.
- `change-validator` – liefert Build-, Test- und Browser-Evidenz.

Fachrollen wie Backend, Frontend, Daten oder Testautomation sind Skills, keine Agents.

### Skills

Domänen-Skills:

- `backend-developer`
- `frontend-developer`
- `copilotkit-developer`
- `dap-engineer`
- `test-automation-engineer` – OpenSpec-basierte Akzeptanzfälle, ADO Test Plans und UI-Automation
- `context-engineer`
- `git-guardian`
- `caveman`

OpenSpec-Skills werden von OpenSpec generiert:

- `openspec-explore`
- `openspec-propose`
- `openspec-apply-change`
- `openspec-sync-specs`
- `openspec-archive-change`

GraphQL ist absichtlich kein separater Skill: HotChocolate liegt im Backend-Skill, Relay im Frontend-Skill. Ein Fullstack-Change lädt beide.

## Einrichtung

### 1. Voraussetzungen

- aktuelle VS-Code-Version mit GitHub Copilot
- Node.js `>=20.19`
- OpenSpec CLI:

```powershell
npm install -g @fission-ai/openspec@latest
```

### 2. Workspace öffnen

1. Workbench klonen.
2. Workbench und echtes Projekt mit `File > Add Folder to Workspace...` öffnen.
3. Workspace als `.code-workspace` speichern.
4. In `Chat: Open Customizations` prüfen, ob `Workbench`, Skills und `/opsx-*` Prompts erkannt werden.

### 3. OpenSpec im echten Projekt initialisieren

OpenSpec gehört in das Projekt, dessen Code geändert wird:

```powershell
Set-Location C:\Repos\dein-projekt
openspec init
openspec update
```

Das `openspec/` dieser Workbench gilt nur für Änderungen an der Workbench selbst. In einem Multi-Root-Workspace darf Copilot keinen Projekt-Change versehentlich hier anlegen.

## Arbeitsablauf

1. `Workbench` wählen.
2. Idee oder Problem mit `/opsx-explore` untersuchen.
3. Mit `/opsx-propose` einen Change mit Proposal, Specs, Design und Tasks anlegen.
4. `Analyze Change` nutzen; fehlende Entscheidungen zuerst in OpenSpec korrigieren.
5. Mit `/opsx-apply` oder `Implement Change` offene Tasks umsetzen.
6. `Review Change` und `Validate Change` ausführen.
7. Bei Bedarf `/opsx-sync`, danach bewusst `/opsx-archive`.

Der Implementer liest immer die von `openspec instructions apply ... --json` gelieferten `contextFiles`. Task-Checkboxen werden erst nach Umsetzung und fokussierter Prüfung gesetzt.

## MCP-Server

Die Konfiguration liegt in `.vscode/mcp.json`.

| Server | Zweck |
|---|---|
| `afw-ado` | Azure DevOps |
| `afw-sequential-thinking` | strukturierte komplexe Analyse |
| `afw-microsoft-docs` | aktuelle Microsoft-Dokumentation |
| `afw-playwright` | Browser-Automation |
| `afw-mongodb` | read-only bevorzugte MongoDB-Analyse |
| `afw-mssql` | read-only bevorzugte SQL-Server-Analyse |

Für MongoDB wird `MDB_MCP_CONNECTION_STRING`, für SQL Server `MSSQL_MCP_CONNECTION_STRING` erwartet. MCP-Zugriff auf Live-Daten beginnt mit Metadaten und Explain-Plänen; Schreibzugriffe brauchen einen expliziten Auftrag.

Persistentes Projektwissen liegt als Markdown im echten Projekt unter `.github/memory/`. Secrets, Kundendaten, temporäre Task-Zustände und bereits in Code oder OpenSpec vorhandene Fakten gehören nicht dorthin.

## Pflege

- Zentrale Regeln: `AGENTS.md`
- Agents: `.github/agents/`
- Skills: `.github/skills/`
- Instructions: `.github/instructions/`
- OpenSpec-Prompts: `.github/prompts/`
- Workbench-eigene OpenSpec-Regeln: `openspec/config.yaml`

Generierte OpenSpec-Skills und Prompts nicht von Hand ändern:

```powershell
openspec update
```

Nach Strukturänderungen prüfen:

- Agent- und Handoff-Ziele existieren.
- Skill-Ordner und Frontmatter-Name stimmen überein.
- Markdown-Links und MCP-Namen lösen auf.
- README nennt nur vorhandene Artefakte.
- `openspec validate` läuft im betroffenen Projekt, sofern vom installierten Schema unterstützt.

## Quellen

- [OpenSpec Overview](https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md)
- [VS Code Custom Agents](https://code.visualstudio.com/docs/agent-customization/custom-agents)
- [VS Code Custom Instructions](https://code.visualstudio.com/docs/agent-customization/custom-instructions)
- [VS Code Prompt Files](https://code.visualstudio.com/docs/agent-customization/prompt-files)
