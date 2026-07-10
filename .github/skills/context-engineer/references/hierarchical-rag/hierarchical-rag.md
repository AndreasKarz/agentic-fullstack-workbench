---
name: ai-hierarchical-rag
description: "Use when creating, maintaining, or querying a Hierarchical RAG DIGEST/RAW knowledge structure. Triggers on: hierarchical RAG, DIGEST/RAW, context compression, knowledge distillation, create digest, update RAW, summary index, two-tier context, save tokens."
---

# Hierarchical RAG

Structure project knowledge in two layers so the LLM always works in the right layer and unnecessary token burning is avoided.

## Core Concept

```
DIGEST/   ← Compressed knowledge (standard working layer)
  00_catalog.md       → Entry point / navigation index
  glossary.md         → Terms & abbreviations
  decisions.md        → Documented constraints & decisions
  10_topics/          → Cross-topic summaries
  20_folders/         → Folder-level digests (one file per RAW folder)

RAW/      ← Original documents (on demand only)
  01_Folder/
  02_Folder/
  ...
```

**Rules of thumb:**
- **DIGEST first** — 80–90% of all queries can be answered with the digest alone
- **RAW on demand only** — When a precise passage, exact date, or complete document is needed
- **Never index RAW without updating the digest** — New document = new/updated digest entry

---

## Query Routing: Which Layer to Use?

| Signal in the request | Layer |
|---|---|
| "What is X?" / term explanation | `glossary.md` |
| "What topics exist for...?" | `10_topics/` |
| "What's in folder X?" | `20_folders/` |
| "What constraints/decisions exist?" | `decisions.md` |
| "Show me the exact document..." | `RAW/` |
| "Exact quote from chapter X" | `RAW/` |
| "All details on process Y" | `RAW/` only if topic summary is insufficient |

---

## Workflows

### Add a new document to RAW → update digest

```
1. Place document in the appropriate RAW/ folder path
2. Update 20_folders/<folder>.digest.md:
   - Add filename + short description
3. Check if 10_topics/<topic>.md is affected → supplement there
4. Add new terms to glossary.md
5. Adjust 00_catalog.md statistics if needed
```

### Create a new RAW folder → build full digest

See [references/setup-workflow.md](references/setup-workflow.md) for the complete step-by-step process.

### Analyze an existing structure

```
1. Read 00_catalog.md → overview & statistics
2. Scan 20_folders/ → what is where?
3. Read 10_topics/ → thematic grouping
4. If needed: open RAW for detailed analysis
```

---

## Digest Quality Standards

### `20_folders/<folder>.digest.md`
```markdown
# <Folder Name> Digest

| File | Description | Key Info |
|------|-------------|----------|
| file.pdf | Short description | Version, date, scope |
```

### `10_topics/<topic>.md`
```markdown
# <Topic>

## Overview
[2–3 sentences: what is the topic, why is it relevant]

## Key Documents
- `RAW/<path>` — Short description
```

### `00_catalog.md`
```markdown
# Context Catalog

| Metric | Value |
|--------|-------|
| Markdown files | X |
| Reduction | X% |

## Quick Navigation
...Folder table + topic links...
```

---

## Measuring Token Efficiency

Goal: **≥ 60% reduction** compared to direct RAW indexing.

| Layer | Typical Size |
|---|---|
| 00_catalog.md | ~1–2 KB |
| One topic file | ~5–15 KB |
| One folder digest | ~10–30 KB |
| One RAW document | 50–500+ KB |

If a topic's digest is larger than the largest RAW document → digest is too detailed, trim it.

---

## Freshness Gate — Keeping the RAG Current

On every digest access: check `_sources.md` to verify sources are within their TTL.

> **🔒 Security:** `_sources.md` contains internal URLs and is excluded via `**/_sources.md` in `.gitignore`. Never commit it!

```
Check _sources.md → TTL OK? → Yes → Use digest directly
                              → No  → Check source → Changed? → Update RAW + digest
```

**Core rules:**
- Max 3 freshness checks per request
- Stale digest > no digest
- Manual sources: ask user instead of checking automatically

Full concept: [references/freshness-gate.md](references/freshness-gate.md)

---

## Best Practices & External Resources

For deeper theory and current developments: [references/best-practices.md](references/best-practices.md)
