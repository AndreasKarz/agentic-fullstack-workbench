# Context-Curator – Kurzüberblick

- Zweck: Pflegt Agenten-Kontext (Skills/Tools/Prompts) und User-Memories.
- Problemraum:
  - Skill-Drift: Skills passen nicht mehr zum tatsächlichen Verhalten.
  - Kontext-Rot: Veraltete, redundante oder irrelevante Kontexteinträge.
- Lösung:
  - Regelmäßige Analyse von Nutzung und Speicherinhalten.
  - Gezielte Aktionen: mark_stale, archive, merge, rewrite, compress, tag_core, tag_historical.
  - Nutzung eines Memory-Backends wie Mem0 für persistente, semantische Erinnerungen.
