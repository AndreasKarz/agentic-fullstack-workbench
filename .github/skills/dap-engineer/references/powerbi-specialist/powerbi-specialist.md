---
name: dap-powerbi-specialist
description: "Use when creating PowerBI reports, designing Star Schema data models, writing DAX measures, optimizing Power Query M, planning ETL from MongoDB/SQL Server DWH, or designing dashboards. Triggers on: PowerBI, DAX, Power Query, measure, slicer, KPI, visualization."
---

# PowerBI Report Engineering

Support professional creation of PowerBI reports — from data source to finished visualization.

## Data Source Infrastructure

| Source | Technology | MCP Server | Access Pattern |
|--------|-----------|-----------|--------------|
| Operational data | MongoDB | `mongodb` | Aggregation pipelines, schema analysis |
| Data warehouse | SQL Server | `mssql` | Views, stored procedures, direct queries |
| Documentation | Microsoft Docs | `microsoft-docs` | DAX/M reference, best practices |

## MCP Server Usage

### MongoDB (Explore Source Data)

```
1. `mongodb` list databases          → Available databases
2. `mongodb` list collections        → Collections in DB
3. `mongodb` collection schema       → Understand field structure
4. `mongodb` aggregate               → Aggregate/transform data
5. `mongodb` find                    → Take samples
6. `mongodb` count                   → Check data volume
```

### SQL Server (Explore DWH)

```
1. `mssql` list databases            → Available databases
2. `mssql` list tables               → Tables in DWH
3. `mssql` describe table            → Columns, types, constraints
4. `mssql` get relationships         → Foreign key relationships
5. `mssql` sample data               → Check samples
6. `mssql` list views                → Available views
7. `mssql` analyze data distribution → Analyze value distribution
8. `mssql` list indexes              → Performance-relevant indexes
```

### Microsoft Docs (Reference)

```
1. `microsoft-docs` docs search        → Search DAX/M functions
2. `microsoft-docs` code sample search → Find code examples
3. `microsoft-docs` docs fetch         → Load full documentation
```

## ETL Pipeline Design

### Layer Architecture (MongoDB → DWH → PowerBI)

```
┌─────────────┐    ┌──────────────────┐    ┌──────────────────┐
│  MongoDB    │───▶│  SQL Server DWH  │───▶│  PowerBI Report  │
│ (Operational)│    │  (Staging/Facts) │    │  (Import/DQ)     │
└─────────────┘    └──────────────────┘    └──────────────────┘
     Source              Transform              Present
```

| Layer | Responsibility | Tool |
|-------|--------------|------|
| **Bronze** (Raw) | 1:1 copy from source | Data pump / staging |
| **Silver** (Clean) | Cleaned, typed, deduplicated | SQL Server views/SP |
| **Gold** (Serve) | Star schema, measures, KPIs | PowerBI data model |

### Decision: Import vs. DirectQuery

| Criterion | Import | DirectQuery |
|-----------|--------|-------------|
| Data volume < 1 GB | ✅ Preferred | Possible |
| Real-time needed | ❌ | ✅ Preferred |
| Complex DAX calculations | ✅ Performant | ⚠️ Slow |
| Data volume > 1 GB | ⚠️ Check | ✅ Preferred |

## Data Modeling

### Star Schema (Gold Standard)

```
         ┌──────────┐
         │  DimDate  │
         └─────┬────┘
               │
┌──────────┐   │   ┌──────────┐
│DimCustomer├──┼───┤ DimProduct│
└──────────┘   │   └──────────┘
               │
         ┌─────┴────┐
         │ FactTable │
         └───────────┘
```

Rules:
- Fact tables contain only keys and measures (numeric)
- Dimension tables contain descriptive attributes
- Relationships: Dimension (1) → Fact (*)
- Filter direction: single-directional (dimension → fact)
- Bidirectional filters only for M:M bridge tables (and then with caution)

### Detailed References

- **DAX patterns and function reference:** See [references/dax-patterns.md](references/dax-patterns.md)
- **Power Query M transformations:** See [references/power-query-m.md](references/power-query-m.md)
- **Visualizations and report design:** See [references/visualisierungen.md](references/visualisierungen.md)

## Quality Check

Before completing every report, verify:

| # | Check Point | Method |
|---|------------|--------|
| 1 | Data model: star schema correct? | Check model view |
| 2 | Relationships: no ambiguity? | All paths unambiguous |
| 3 | Measures: filter context correct? | Validate with test data |
| 4 | Performance: no unnecessary columns imported? | Performance Analyzer |
| 5 | Slicers: sorting correct? | Sort column assigned |
| 6 | Formatting: numbers/date/currency in correct format? | Spot checks |
| 7 | Colors: design system colors followed? | Check color palette |
| 8 | Accessibility: alt texts present? | Check every visual |

<!-- Last updated: 2026-07-02 · Part of the Copilot Context Blueprint -->
