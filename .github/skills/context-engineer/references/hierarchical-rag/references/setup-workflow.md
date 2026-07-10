# Hierarchical RAG — Setup Workflow (New Project)

Step-by-step guide for building a DIGEST/RAW structure from scratch.

---

## Phase 1: Prepare the RAW Layer

```
.assets/context/<ProjectName>/
└── RAW/
    ├── 01_<Category1>/
    ├── 02_<Category2>/
    └── 03_<Category3>/
```

**Rules for RAW:**
- **Never modify** original documents (read only)
- Prefix folder names numerically for stable referencing
- Convert binary files (PDF, DOCX) to Markdown where possible

---

## Phase 2: Create Folder Digests (`20_folders/`)

Create **one digest file** per RAW folder:

```markdown
# 01_<Category1> — Digest

**Last updated:** YYYY-MM-DD  
**Number of documents:** X

## Contents

| File | Type | Description | Key Info |
|------|------|-------------|----------|
| `file1.md` | Guide | Short description | Version X.Y, date |
| `file2.pdf` | Process | Short description | Scope, owner |

## Key Findings

- Bullet 1: Critical info frequently searched for
- Bullet 2: Recurring term or process
```

**Quality criteria:**
- Each table row: max 1 sentence description
- "Key Info": only what genuinely helps when searching (version, date, scope)
- Do not repeat full content — navigate only

---

## Phase 3: Create Topic Summaries (`10_topics/`)

Topics are **cross-cutting** — one topic can span multiple RAW folders.

Typical topics:
- Manuals / Processes
- Test management
- Change management
- Releases
- Glossary topics

```markdown
# <Topic Name>

**As of:** YYYY-MM-DD  
**Sources:** `RAW/01_...`, `RAW/02_...`

## Overview
[2–3 sentences: what does this topic cover, why is it relevant]

## Key Processes / Documents

| Document | Path | Content |
|----------|------|---------|
| Process name | `RAW/01_X/file.md` | Short description |

## Frequently Asked Questions on This Topic
[Optional: top 3–5 questions + brief answers with RAW reference]
```

---

## Phase 4: Build the Glossary (`glossary.md`)

```markdown
# Glossary

## Abbreviations

| Abbrev. | Full Form | Meaning |
|---------|----------|---------|
| ABC | Spelled-out name | Short definition |

## Domain Terms

| Term | Definition | Context |
|------|------------|---------|
| Term | Definition (1 sentence) | Which process/document |
```

**Population strategy:**
1. While creating folder digests: note unfamiliar terms
2. While creating topics: define and link terms
3. Structure glossary by category, not alphabetically (for > 50 entries: alphabetical + categories)

---

## Phase 5: Create the Catalog (`00_catalog.md`)

The catalog is the **only entry point** — it must always be current.

```markdown
# <Project> Context Catalog

**Last updated:** YYYY-MM-DD  
**Source:** `.assets/context/<Project>/RAW`

## Statistics

| Metric | Value |
|--------|-------|
| Original documents | X |
| Digest files | Y |
| Token reduction | ~Z% |

## Quick Navigation

### By Folder

| Folder | Description | Digest |
|--------|-------------|--------|
| 01_Category1 | Short description | [→](20_folders/01_...) |

### By Topic

- [Topic 1](10_topics/topic1.md) — Short description
- [Topic 2](10_topics/topic2.md) — Short description

### Reference

- [Glossary](glossary.md) — X terms
- [Decisions & Constraints](decisions.md)
```

---

## Phase 6: Populate the Decisions File (`decisions.md`)

Document known constraints, scope decisions, and open questions:

```markdown
# Documented Decisions & Constraints

## Scope Decisions

| Decision | Rationale | Date |
|----------|-----------|------|
| What was consciously excluded | Why | YYYY-MM-DD |

## Known Gaps

| Gap | Impact | Workaround |
|-----|--------|------------|
| Missing document/topic | What is missing as a result | Alternative approach |
```

---

## Maintenance: Keeping the Digest Current

### Update Triggers
| Event | What to update |
|-------|---------------|
| New document in RAW | `20_folders/<folder>.digest.md` |
| New version of a document | Digest row + date |
| New domain term discovered | `glossary.md` |
| Contradiction between documents | `decisions.md` |
| New category/folder | `00_catalog.md` + new folder digest |

### Rule of Thumb
**One new RAW document = max. 3–5 minutes of digest update.**  
If it takes longer, the digest process is too complex.

---

## Checklist: Completed Structure

```
✅ RAW/          — All original documents present
✅ 20_folders/   — One .digest.md per RAW folder
✅ 10_topics/    — At least 3–5 topics defined
✅ glossary.md   — All abbreviations explained
✅ decisions.md  — Scope decisions documented
✅ 00_catalog.md — Complete, with statistics and navigation
```
