# Agentic Fullstack Workbench

Kompakter, wiederverwendbarer Context-Layer für GitHub Copilot in VS Code. Die Workbench wird als Git-Submodule in ein bestehendes Projekt eingebunden. Dadurch bleibt sie separat aktualisierbar, während das eigentliche Projekt der einzige VS-Code-Workspace bleibt.

```text
dein-projekt                      # Git-Repo und VS-Code-Workspace
├── .agentic-workbench            # Git-Submodule mit wiederverwendbarem Context
├── .github                       # projektspezifische Regeln und Memory
├── .vscode                       # Copilot-Suchpfade und aktive MCP-Konfiguration
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

### 2. Workbench zum bestehenden Repo hinzufügen

Im Root des bestehenden Projekts ausführen:

```powershell
Set-Location C:\Repos\dein-projekt
git submodule add https://github.com/AndreasKarz/agentic-fullstack-workbench.git .agentic-workbench
git submodule update --init --recursive
```

Git speichert dabei die Submodule-URL in `.gitmodules` und pinnt im Haupt-Repo einen konkreten Workbench-Commit. So erhalten alle Entwickler dieselbe Version.

### 3. Copilot-Suchpfade konfigurieren

Das bestehende Projekt bleibt der einzige geöffnete VS-Code-Ordner. Ergänze seine `.vscode/settings.json`; bestehende Einstellungen und projektspezifische Suchpfade bleiben erhalten:

```jsonc
{
  "chat.agentFilesLocations": {
    ".github/agents": true,
    ".agentic-workbench/.github/agents": true
  },
  "chat.agentSkillsLocations": {
    ".github/skills": true,
    ".agentic-workbench/.github/skills": true
  },
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,
    ".agentic-workbench/.github/instructions": true
  },
  "chat.promptFilesLocations": {
    ".github/prompts": true,
    ".agentic-workbench/.github/prompts": true
  }
}
```

Projektregeln gehören weiterhin in das `AGENTS.md` beziehungsweise `.github/` des Haupt-Repos. Das `AGENTS.md` im Submodule gilt für Änderungen an der Workbench selbst.

Danach das Haupt-Repo in VS Code öffnen und mit `Chat: Open Customizations` prüfen, ob `Workbench`, Skills und `/opsx-*` Prompts erkannt werden.

### 4. MCP-Konfiguration aktivieren

VS Code lädt die aktive Workspace-Konfiguration nur aus `.vscode/mcp.json` des Haupt-Repos. Falls dort noch keine Datei existiert:

```powershell
New-Item -ItemType Directory -Force .vscode | Out-Null
Copy-Item .agentic-workbench/.vscode/mcp.json .vscode/mcp.json
```

Existiert bereits eine `.vscode/mcp.json`, übernimm die Einträge aus `inputs` und `servers` manuell, ohne vorhandene Projektserver zu überschreiben. Die Datei im Submodule ist die Vorlage; die Datei im Haupt-Repo ist die aktive Konfiguration.

Anschliessend die Einbindung und die Projektkonfiguration gemeinsam versionieren:

```powershell
git add .gitmodules .agentic-workbench .vscode/settings.json .vscode/mcp.json
git commit -m "chore: add agentic workbench"
```

### 5. OpenSpec im Haupt-Repo initialisieren

OpenSpec gehört in das Projekt, dessen Code geändert wird:

```powershell
Set-Location C:\Repos\dein-projekt
openspec init
openspec update
```

Das `openspec/` im Haupt-Repo führt dessen Produkt-Changes. `.agentic-workbench/openspec/` gilt ausschliesslich für Änderungen an der Workbench selbst.

### 6. Workbench aktualisieren

Das Haupt-Repo bleibt auf der eingecheckten Workbench-Version, bis das Submodule bewusst aktualisiert wird:

```powershell
git submodule update --remote --merge .agentic-workbench
git add .agentic-workbench
git commit -m "chore: update agentic workbench"
```

Nach einem Workbench-Update Änderungen an `.agentic-workbench/.vscode/mcp.json` bei Bedarf erneut in die aktive `.vscode/mcp.json` des Haupt-Repos übernehmen.

Wer das Haupt-Repo neu klont, initialisiert die Workbench direkt mit:

```powershell
git clone --recurse-submodules <url-des-haupt-repos>
```

Bei einem bereits vorhandenen Clone genügt:

```powershell
git submodule update --init --recursive
```

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

Die versionierte Vorlage liegt im Submodule unter `.agentic-workbench/.vscode/mcp.json`. Aktiv ist die zusammengeführte `.vscode/mcp.json` im Haupt-Repo.

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
