# `afw-memory` MCP Overview

`afw-memory` ist der konfigurierte Memory-Backend-Mechanismus für den Context-Curator.

## Priorität

1. Prüfe, ob `afw-memory` in `.vscode/mcp.json` vorhanden ist.
2. Wenn ja, starte bzw. verwende die `afw-memory` Tools.
3. Wenn nein oder nicht erreichbar, nutze User-/Repo-Memories oder Markdown-Dateien unter `~\.copilot\memory` als Fallback.

## Typische Operationen

- `afw-memory` read graph — gesamten Knowledge Graph lesen.
- `afw-memory` search nodes — Entities und Observations suchen.
- `afw-memory` create entities — neue Memory-Entities mit Observations anlegen.
- `afw-memory` create relations — Beziehungen zwischen Entities anlegen.
- `afw-memory` delete entities — nur nach ausdrücklicher Freigabe verwenden.

## Curator-Regeln

- Keine endgültige Löschung ohne ausdrückliche Freigabe.
- Komprimierte Memories als kurze, informationsdichte Observations ablegen.
- Langfristige Präferenzen und wiederverwendbare Regeln als `core` kennzeichnen, wenn das Schema dies unterstützt.
- Vergangene, aber noch nachvollziehbare Fakten als `historical` kennzeichnen, wenn das Schema dies unterstützt.