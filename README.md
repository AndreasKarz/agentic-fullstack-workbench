# Agentic Fullstack Workbench

Kompakter, wiederverwendbarer Context-Layer für GitHub Copilot in VS Code. Die Workbench-Dateien werden einmalig direkt in ein bestehendes Git-Repo importiert. Es entsteht weder ein Submodule noch ein zusätzlicher VS-Code-Workspace.

```text
dein-projekt
├── .github                       # Projekt- und Workbench-Customizations
├── .vscode/mcp.json              # aktive MCP-Konfiguration
├── AGENTS.md                     # zentrale Projektregeln
└── openspec                      # Changes und Specs des Projekts
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

### 2. Workbench direkt importieren

Zuerst sicherstellen, dass das bestehende Repo keine offenen Änderungen enthält. Dann im Root des Repos ausführen:

```powershell
Set-Location C:\Repos\dein-projekt
git remote add agentic-workbench https://github.com/AndreasKarz/agentic-fullstack-workbench.git
git fetch agentic-workbench main
git restore --source agentic-workbench/main --overlay -- .github

if (-not (Test-Path 'AGENTS.md')) {
    git restore --source agentic-workbench/main -- AGENTS.md
}

if (-not (Test-Path '.vscode/mcp.json')) {
    git restore --source agentic-workbench/main -- .vscode/mcp.json
}
```

Damit werden die Workbench-Dateien physisch in das bestehende Repo kopiert:

- Bestehende zusätzliche Dateien unter `.github/` bleiben erhalten.
- Workbench-Dateien mit demselben Pfad werden auf den importierten Stand gesetzt und erscheinen im Git-Diff.
- README, `.gitignore` und `openspec/` des bestehenden Repos werden nicht verändert.
- Es sind keine zusätzlichen `chat.*Locations`-Einstellungen notwendig.
- Der Remote `agentic-workbench` bleibt für spätere Updates eingetragen.

Import vor dem Commit prüfen:

```powershell
git status --short
git diff
```

Danach versionieren:

```powershell
git add .github .vscode/mcp.json AGENTS.md
git commit -m "chore: add agentic workbench"
```

Falls `AGENTS.md` oder `.vscode/mcp.json` bereits existierten, wurden sie absichtlich nicht überschrieben:

- Bestehendes `AGENTS.md`: behalten und nur benötigte allgemeine Regeln aus dem Workbench-`AGENTS.md` übernehmen.
- Bestehende `.vscode/mcp.json`: vorhandene Einträge behalten und die Workbench-Einträge aus `agentic-workbench/main:.vscode/mcp.json` einmalig zusammenführen.

Die Workbench-Dateien liegen danach direkt an den VS-Code-Standardorten. Mit `Chat: Open Customizations` prüfen, ob `Workbench`, Skills und `/opsx-*` Prompts erkannt werden.

### 3. OpenSpec im bestehenden Repo initialisieren

OpenSpec gehört in das Repo, dessen Code geändert wird:

```powershell
openspec init
openspec update
```

`openspec/` im bestehenden Repo führt alle Produkt-Changes. Der Import kopiert bewusst kein `openspec/` aus dem Workbench-Quellrepo.

### 4. Workbench später aktualisieren

Den Remote aktualisieren und dieselben Workbench-Pfade erneut importieren:

```powershell
git fetch agentic-workbench main
git restore --source agentic-workbench/main --overlay -- .github
git diff
```

Lokale Anpassungen an gleichnamigen Workbench-Dateien werden dabei ersetzt und müssen aus dem Git-Diff bewusst wieder übernommen werden. `AGENTS.md` und `.vscode/mcp.json` werden bei Updates nicht automatisch verändert.

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

Die aktive Konfiguration liegt direkt im bestehenden Repo unter `.vscode/mcp.json`.

| Server | Zweck |
|---|---|
| `ado` | Azure DevOps |
| `sequential-thinking` | strukturierte komplexe Analyse |
| `microsoft-docs` | aktuelle Microsoft-Dokumentation |
| `playwright` | Browser-Automation |
| `mongodb` | read-only bevorzugte MongoDB-Analyse |
| `mssql` | read-only bevorzugte SQL-Server-Analyse |

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
- [VS Code AI Settings](https://code.visualstudio.com/docs/agents/reference/ai-settings)
- [VS Code MCP Configuration](https://code.visualstudio.com/docs/agents/reference/mcp-configuration)
- [Git Restore](https://git-scm.com/docs/git-restore)
