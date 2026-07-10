# Freshness Gate — Lazy Invalidation for Hierarchical RAG

> **Pattern name:** Freshness Gate (inspired by HTTP Stale-While-Revalidate)  
> **Purpose:** Keep the RAG current without checking all sources on every access  
> **As of:** February 2026

---

## Overview

The Freshness Gate extends the DIGEST/RAW structure with a **time-based freshness check**. Core principle: on every digest access, it checks whether the underlying sources are still within their **TTL (Time-to-Live)**. Only expired sources are checked — not the entire RAG.

### Analogy

| HTTP Caching | Hierarchical RAG |
|---|---|
| Cache | `digest/` (immediately available, token-efficient) |
| Origin Server | External sources (SharePoint, Wiki, URLs) |
| Cache-Control Header | `_sources.md` (TTL per resource) |
| Stale-While-Revalidate | Serve digest, check source in background |

---

## New Artifact: `_sources.md`

Lives in the **root** of the RAG structure (next to `digest/` and `RAW/`):

```
.assets/context/<Project>/
├── _sources.md          ← Source registry (⚠️ GITIGNORED!)
├── digest/
│   └── (as before)
└── RAW/
    └── (as before)
```

> **🔒 Security note:** `_sources.md` contains internal URLs (SharePoint, wikis, etc.) and is explicitly excluded via `**/_sources.md` in `.gitignore`. This file must **never** be committed!

### Format

```markdown
# Source Registry

**Project:** <ProjectName>  
**Default TTL:** 7 days

## Sources

| ID | RAW Path | Source Type | Source URL / Origin | Created | Last Checked | Status |
|----|----------|-------------|---------------------|---------|--------------|--------|
| S-001 | RAW/01_Manuals/ | SharePoint | https://tenant.sharepoint.com/sites/... | 2025-11-01 | 2026-02-18 | ✅ current |
| S-002 | RAW/02_Changes/ | Wiki | wiki link | 2025-12-15 | 2026-02-10 | ⚠️ check |
| S-003 | RAW/04_Testing/ | Manual | Provided by team | 2026-01-20 | 2026-01-20 | ✅ current |

## TTL Configuration

| Source Type | TTL | Rationale |
|-------------|-----|-----------|
| Wiki | 3 days | Wiki changes frequently during sprints |
| Work Items | 1 day | Tickets change continuously |
| SharePoint | 7 days | Documents relatively stable |
| Web URL | 14 days | External pages, rare changes |
| Local file | 7 days | Default interval |
| Manual | 30 days | User must confirm manually |
```

### Fields explained

| Field | Description |
|-------|-------------|
| **ID** | Stable reference (S-001, S-002, ...) |
| **RAW Path** | Where the data lives in the RAW layer |
| **Source Type** | Determines the check method and TTL |
| **Source URL / Origin** | Where the data originally came from |
| **Created** | When the entry was first recorded |
| **Last Checked** | When last checked for freshness |
| **Status** | `✅ current` / `⚠️ check` / `🔄 updating` / `❌ unreachable` |

---

## Freshness Gate Workflow

### Trigger: Agent reads a digest

```
1. Agent receives request
2. Agent reads relevant digest (e.g. 10_topics/TestManagement.md)
3. Agent identifies affected RAW paths from the digest
4. Agent reads _sources.md → filters rows where RAW path matches
5. For each affected source:
   a) Calculate: today - "Last Checked" > TTL?
   b) NO → source is fresh. Continue.
   c) YES → trigger freshness check (see below)
6. Respond with digest
```

### Freshness Check by Source Type

| Source Type | Check Method |
|-------------|-------------|
| **SharePoint** | Playwright → open page → read Modified-Date on page |
| **Wiki** | MCP wiki tool → compare revision/version |
| **Work Items** | MCP work item tool → check ChangedDate |
| **Web URL** | `fetch_webpage` → Last-Modified header or content hash |
| **Local file** | `Get-Item -Path ... \| Select-Object LastWriteTime` |
| **Manual** | Ask user: "Source S-003 was last checked on X. Is it still current?" |

### After the Freshness Check

```
If source UNCHANGED:
  → _sources.md: "Last Checked" = today, Status = ✅ current
  → No further action

If source CHANGED:
  1. Update RAW (re-fetch/re-convert document)
  2. Update affected digest files:
     - 20_folders/<folder>.digest.md
     - 10_topics/<topic>.md (if affected)
     - glossary.md (new terms?)
  3. _sources.md: "Last Checked" = today, Status = ✅ current
  4. 00_catalog.md: adjust statistics if needed

If source UNREACHABLE:
  → _sources.md: Status = ❌ unreachable
  → Inform user: "Source S-002 is unreachable"
  → Use digest anyway (stale is better than nothing)
```

---

## Visualization: Decision Flow

```
               ┌──────────────────┐
               │  Digest read     │
               └────────┬─────────┘
                        │
                        ▼
               ┌──────────────────┐
               │ Read + filter    │
               │ _sources.md      │
               └────────┬─────────┘
                        │
              ┌─────────┴─────────┐
              │                   │
           TTL OK            TTL expired
              │                   │
              ▼                   ▼
     ┌────────────┐    ┌──────────────────┐
     │ Respond    │    │ Freshness check  │
     │ directly   │    │ (by type)        │
     └────────────┘    └────────┬─────────┘
                                │
                       ┌───────┴───────┐
                       │               │
                  Unchanged         Changed
                       │               │
                       ▼               ▼
               ┌──────────┐  ┌─────────────────┐
               │ Update   │  │ Update RAW      │
               │ date     │  │ Update digest   │
               │ → done   │  │ Update date     │
               └──────────┘  │ → done          │
                             └─────────────────┘
```

---

## Performance Rules

| Rule | Rationale |
|------|-----------|
| **Max 3 freshness checks per request** | Otherwise response becomes too slow |
| **Parallel checks where possible** | Check SharePoint + wiki simultaneously |
| **Manual sources not automatically** | Do not prompt user on every request |
| **Stale digest > no digest** | Prefer outdated info over an error |
| **Always log check result** | In `_sources.md` → audit trail |

---

## Edge Cases

### Source no longer exists
```
Status = ❌ unreachable
→ Inform user
→ Digest remains (with note "as of: last known date")
→ Record in decisions.md as "Known Gap"
```

### Multiple sources for one RAW folder
```
Each source gets its own row in _sources.md
→ Folder digest is only considered "fresh" when ALL sources are OK
```

### Manual override
```
User says: "Please update all sources now"
→ Go through all rows in _sources.md (regardless of TTL)
→ Batch update all reachable sources
```

---

## Migration: Adding Freshness Gate to an Existing RAG

For a RAG **without** `_sources.md`:

```
1. Create _sources.md (empty table)
2. For each RAW folder:
   a) Where do the documents come from? → enter source type + URL
   b) When were they last fetched? → created date
   c) Last Checked = Created (since never checked)
3. Define TTL configuration
4. From now on: apply Freshness Gate workflow on every digest access
```
