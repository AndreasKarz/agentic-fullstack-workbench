# Server Memory MCP Overview

`@modelcontextprotocol/server-memory@latest` ist der bevorzugte Memory-Backend-Mechanismus für den Context-Curator.

## Priorität

1. Prüfe, ob `@modelcontextprotocol/server-memory@latest` in der MCP-Konfiguration vorhanden ist.
2. Wenn ja, starte bzw. verwende den `server-memory` MCP über die verfügbaren `mcp_memory-server_*` Tools.
3. Wenn nein oder nicht erreichbar, nutze User-/Repo-Memories oder Markdown-Dateien unter `~\.copilot\memory` als Fallback.

## Typische Operationen

- `mcp_memory-server_read_graph` — gesamten Knowledge Graph lesen.
- `mcp_memory-server_search_nodes` — Entities und Observations suchen.
- `mcp_memory-server_create_entities` — neue Memory-Entities mit Observations anlegen.
- `mcp_memory-server_create_relations` — Beziehungen zwischen Entities anlegen.
- `mcp_memory-server_delete_entities` — nur nach ausdrücklicher Freigabe verwenden.

## Curator-Regeln

- Keine endgültige Löschung ohne ausdrückliche Freigabe.
- Komprimierte Memories als kurze, informationsdichte Observations ablegen.
- Langfristige Präferenzen und wiederverwendbare Regeln als `core` kennzeichnen, wenn das Schema dies unterstützt.
- Vergangene, aber noch nachvollziehbare Fakten als `historical` kennzeichnen, wenn das Schema dies unterstützt.