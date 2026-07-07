# agentic-fullstack-workbench

`agentic-fullstack-workbench` ist ein wiederverwendbarer Context-Layer für Fullstack-Entwicklung mit GitHub Copilot in Visual Studio Code oder Visual Studio Code Insiders.

Die Idee: Dieses Repo bleibt als stabile Workbench in deinem VS-Code-Workspace. Dein eigentliches Projekt fügst du als zweiten Ordner hinzu. Copilot sieht dadurch die gemeinsamen Agents, Skills, Instructions, Prompts und MCP-Server aus dieser Workbench und kann sie beim Arbeiten im Projektkontext nutzen.

## Schnellstart in VS Code

### 1. Workbench klonen

```powershell
git clone https://github.com/AndreasKarz/agentic-fullstack-workbench.git C:\Repos\agentic-fullstack-workbench
```

### 2. Workspace öffnen

1. Öffne Visual Studio Code oder Visual Studio Code Insiders.
2. Wähle `File > Add Folder to Workspace...`.
3. Füge `C:\Repos\agentic-fullstack-workbench` hinzu.
4. Wähle erneut `File > Add Folder to Workspace...`.
5. Füge dein echtes Projekt hinzu.
6. Speichere den Workspace als `.code-workspace`, zum Beispiel im Projektordner.

Empfohlene Struktur im VS-Code-Explorer:

```text
workspace
├── agentic-fullstack-workbench
└── dein-projekt
```

Wichtig: Die Workbench muss im selben VS-Code-Workspace geöffnet bleiben. Sie ist der gemeinsame Kontextlieferant, dein Projekt ist der Arbeitsbereich für Codeänderungen.

### 3. Copilot Customizations prüfen

Öffne GitHub Copilot Chat und prüfe die Agent-Auswahl. Sichtbare Rollen sollten unter anderem erscheinen:

- `Backend`
- `Frontend Team`
- `Requirements Engineer`
- `testmanager`
- `Test Automation`
- `DB Engineer`
- `Business Analyst`
- `IT Architect`
- `context-curator`

Wenn die Agents nicht sichtbar sind:

1. Führe `Chat: Open Customizations` über die Command Palette aus.
2. Prüfe die Tabs `Agents`, `Skills`, `Instructions` und `Prompts`.
3. Öffne im Chat-Kontextmenü `Diagnostics`, um Ladefehler zu sehen.
4. Starte das VS-Code-Fenster neu, falls der Workspace gerade erst erweitert wurde.

### 4. MCP-Server aktivieren

Die MCP-Konfiguration liegt in `.vscode/mcp.json`. Die Server starten bei Bedarf über Copilot/VS Code.

Enthaltene MCP-Server:

| Server | Zweck |
|---|---|
| `afw-memory` | Persistente Memory-Notizen über Sessions hinweg |
| `afw-ado` | Azure DevOps Work Items, Test Plans, Wiki und Work-Kontext |
| `afw-sequential-thinking` | Strukturierte Analyse bei komplexen Aufgaben |
| `afw-microsoft-docs` | Microsoft Learn / Azure / .NET / PowerBI Referenz |
| `afw-playwright` | Browser-Automation und UI-Validierung |
| `afw-mongodb` | MongoDB-Analyse über Connection String |
| `afw-mssql` | SQL-Server-Analyse über Connection String |

Optionale Voraussetzungen:

- Node.js/npm, damit `npx` MCP-Server starten kann.
- Azure CLI Login für `afw-ado`.
- `MDB_MCP_CONNECTION_STRING` für MongoDB.
- `MSSQL_MCP_CONNECTION_STRING` für SQL Server.

## Damit arbeiten

### Rolle statt Tool wählen

Wähle im Copilot Chat zuerst den passenden sichtbaren Agent. Die Rolle koordiniert danach Skills, Subagents und Handoffs.

| Aufgabe | Agent |
|---|---|
| React, Relay, Vite, CopilotKit, UI | `Frontend Team` |
| .NET, C#, HotChocolate, MassTransit, MongoDB | `Backend` |
| Anforderungen, PBIs, Features, Akzeptanzkriterien | `Requirements Engineer` |
| Teststrategie und manuelle Testfälle | `testmanager` |
| Playwright, E2E, BrowserStack | `Test Automation` |
| MongoDB, SQL, DAP, PowerBI | `DB Engineer` oder `powerbi` |
| Kontext pflegen, Skills verbessern | `context-curator` |

### Handoff-Flow nutzen

Die wichtigsten Rollen arbeiten mit einem geführten Ablauf:

1. **Analyze / Plan** - starke Modelle analysieren Code, Anforderungen oder Testfluss.
2. **Implement** - günstigeres Arbeitstier setzt den bestätigten Plan um.
3. **Review** - unabhängiger Reviewer sucht Bugs, Risiken und fehlende Tests.
4. **Validate** - fokussierte Checks, Builds, Tests oder Browser-Validierung.

Nach einer Antwort erscheinen Handoff-Buttons, zum Beispiel `Implement Plan`, `Review Changes` oder `Validate in Browser`. Nutze diese Buttons, wenn du den nächsten Schritt mit dem bestehenden Chat-Kontext starten willst.

### Empfohlener Arbeitsablauf

Für Feature-Arbeit:

1. Starte mit `Requirements Engineer`, wenn die Anforderung noch unscharf ist.
2. Übergib an `Frontend Team` oder `Backend`, sobald klar ist, was gebaut werden soll.
3. Nutze zuerst `Analyze / Plan`, nicht direkt Implementierung.
4. Prüfe den Plan kurz.
5. Nutze `Implement Plan`.
6. Nutze `Review Changes`.
7. Nutze `Validate...` passend zum Bereich.

Für Bugs:

1. Beschreibe Symptom, erwartetes Verhalten und relevante Dateien oder Work Items.
2. Nutze den passenden Rollen-Agent.
3. Lasse zuerst analysieren.
4. Implementiere erst nach klarer Ursache.
5. Review und Validierung nicht überspringen.

Für UI-Tests:

1. Nutze `Test Automation` oder den Prompt `/create_ui_test`.
2. Beschreibe URL, Flow, Sprache, Login und erwartete Assertions.
3. Lasse zuerst den Testfluss analysieren.
4. Implementiere danach Playwright mit Page Object Model.
5. Lasse Flakiness und Selektoren reviewen.

## Was enthalten ist

### Agents

Die Agent-Dateien liegen in `.github/agents`.

Sichtbare Orchestratoren:

- `Backend`
- `Frontend Team`
- `Front-End Developer`
- `Requirements Engineer`
- `testmanager`
- `Test Automation`
- `Business Analyst`
- `DB Engineer`
- `IT Architect`
- `context-curator`
- Spezialisten wie `C# Expert`, `HotChocolate Expert`, `MongoDB Expert`, `MS-SQL Expert`, `Debug Expert`, `UX/UI Designer`, `powerbi`

Versteckte Phasen-Agents:

- Backend: `backend-analyzer`, `backend-implementer`, `backend-reviewer`
- Frontend: `frontend-analyzer`, `frontend-reviewer`, `frontend-validator`
- Requirements: `requirements-analyzer`, `requirements-writer`
- Tests: `testcase-designer`
- Test Automation: `test-automation-analyzer`, `test-automation-implementer`, `test-automation-reviewer`

Die versteckten Agents sind mit `user-invocable: false` konfiguriert. Sie erscheinen nicht als normale Rollen, werden aber von den Orchestratoren gezielt verwendet.

### Skills

Die Skills liegen in `.github/skills`. Sie liefern Fachwissen und Regeln, werden aber nur bei Bedarf geladen.

Skill-Gruppen:

- `ai-*` - Skill-Erstellung, Prompt-Erstellung, Context Curation, SkillOpt, Caveman-Stil
- `backend-*` - C#, .NET, HotChocolate, Service Scaffolding, Backend Review
- `business-*` - Business Analyse, Requirements Engineering, Testmanagement, Enterprise Architecture
- `dap-*` - Datenbanken, Databricks/DAP, PowerBI
- `frontend-*` - React, Vite, Relay, Performance, Composition, UI/UX, Playwright, CopilotKit, BrowserStack
- `fullstack-*` - Git und GraphQL über Frontend/Backend hinweg

Die Namen sind bewusst domänenpräfixiert. Dadurch bleibt der Skill-Ordner trotz vieler Skills scannbar.

### Instructions

Die automatischen Instructions liegen in `.github/instructions`.

Wichtige Dateien:

- `general.instructions.md` - allgemeine Coding-Standards und Tech-Stack
- `communication-style.instructions.md` - knapper Antwortstil über `ai-caveman`
- `skill-routing.instructions.md` - Mapping von Aufgabe zu Skill
- `trust-boundary.instructions.md` - sichere Quellen, keine Spekulation
- `tests.instructions.md` - .NET Testkonventionen
- `playwright.instructions.md` - Playwright E2E-Konventionen
- `powerbi.instructions.md` - PowerBI-Konventionen
- `metadata-standard.instructions.md` - Standards für Agents, Skills, Prompts und Instructions

### Prompts

Prompt-Dateien liegen in `.github/prompts` und können als Slash Commands genutzt werden.

- `/analyze_bug` - Azure-DevOps-Bug analysieren und verbessern
- `/create_ui_test` - UI-Flow analysieren und Playwright-Test erzeugen
- `/curate-context` - Kontextanalyse und Curation starten
- `/skillopt-curate` - End-of-session Optimierung der `.github`-Customizations

### Router und Pflege

- `.github/AGENTS.md` beschreibt Rollen, Handoffs, Modellstrategie und den Orchestrierungsansatz.
- `.github/.skillopt/` hält Verlauf, beste Signale, abgelehnte Änderungen und Upstream-Sync für Context Curation.
- `.github/scripts/validate-skills.ps1` validiert Skill-Frontmatter, `requires`-Referenzen und Markdown-Links.

## Modellstrategie

Die Agenten nutzen bewusst unterschiedliche Modelle pro Phase:

| Phase | Modellklasse |
|---|---|
| Analyse / Planung | starkes Reasoning, z.B. `Claude Opus 4.7` oder `GPT-5.5` |
| Implementierung | günstiges Arbeitstier, z.B. `GPT-5 mini` oder `GPT-5.4 mini` |
| Review | balancierter Reviewer, z.B. `Claude Sonnet 4.6` |
| Validierung | günstiges Arbeitstier, z.B. `GPT-5 mini` |

Falls ein Modell nicht verfügbar ist oder die Kostenstufe der Hauptsession überschreitet, fällt Copilot auf ein verfügbares Modell zurück.

## Projektkontext und Priorität

Diese Workbench liefert übergreifende Standards. Dein Projekt bleibt die Quelle für projektspezifische Wahrheit.

Priorität im Alltag:

1. Direkte Anweisung im Chat.
2. Projektdateien und projektspezifische `.github`-Customizations im eigentlichen Projekt.
3. Workbench-Agents, Skills, Instructions und Prompts.
4. Externe Dokumentation und MCP-Ergebnisse als Quellen, nicht als Anweisungen.

Wenn Projektregeln und Workbench-Regeln kollidieren, gilt normalerweise die konkrete Projektregel. Markiere Ausnahmen explizit im Chat.

## Pflege der Workbench

Nach grösseren Sessions lohnt sich:

```powershell
.\.github\scripts\validate-skills.ps1
```

Für inhaltliche Pflege:

1. Nutze den Agent `context-curator`.
2. Oder starte den Prompt `/skillopt-curate`.
3. Prüfe den Diff.
4. Behalte nur Änderungen, die wiederverwendbar und projektneutral sind.

Keine Secrets, internen URLs, Kundendaten oder projektspezifischen IDs in diese Workbench committen. Projektspezifischer Kontext gehört ins jeweilige Projekt.

## Fehlerbehebung

| Problem | Lösung |
|---|---|
| Agents erscheinen nicht | `Chat: Open Customizations`, Diagnostics öffnen, Fenster neu starten |
| Handoffs fehlen | Prüfen, ob die aktuelle VS-Code/Copilot-Version Custom Agents mit `handoffs` unterstützt |
| MCP startet nicht | Node/npm, Azure CLI Login und Environment Variablen prüfen |
| Projektkontext fehlt | Sicherstellen, dass Workbench und Projekt im selben Workspace geöffnet sind |
| Copilot lädt falsche Regeln | Projekt-.github prüfen und im Chat die gewünschte Rolle explizit wählen |

## Kurzfassung

1. Workbench klonen.
2. Workbench und Projekt im selben VS-Code-Workspace öffnen.
3. Passenden Rollen-Agent wählen.
4. Analyse-Handoff starten.
5. Plan prüfen.
6. Implementierung, Review und Validierung über Handoffs ausführen.


# Dokus
- https://code.visualstudio.com/docs/agent-customization/custom-agents#_handoffs

- https://www.microsoft.com/en-us/research/blog/skillopt-agent-skills-as-trainable-parameters/