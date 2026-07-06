---
description: "PowerBI naming conventions, DAX/M formatting standards, and data modeling rules. Apply when creating PowerBI reports, writing DAX measures, Power Query M transformations, or designing Star Schema data models. Triggers: PowerBI, DAX, Power Query, Measure, Star Schema, Fakt_, Dim_, ETL, KPI."
applyTo: "**"
---

# PowerBI Conventions

<!-- Source: Derived from PowerBI Best Practices + Swiss Localization Standards · Last updated: 2026-07-02 -->

## Naming Conventions

### Tables

| Type | Prefix | Example |
|------|--------|---------|
| Fact table | `Fakt_` or `f_` | `Fakt_Revenue`, `f_Transactions` |
| Dimension table | `Dim_` or `d_` | `Dim_Customer`, `d_Date` |
| Helper table (no load) | `_` prefix | `_Parameter`, `_Staging` |
| Calculated table | `Calc_` | `Calc_AgeGroups` |

### Measures

| Type | Pattern | Example |
|------|---------|---------|
| Base aggregation | `[Noun]` | `[Revenue]`, `[Customer Count]` |
| Time comparison | `[Base PY]` / `[Base YTD]` | `[Revenue PY]`, `[Revenue YTD]` |
| Percentage | `[Base %]` | `[Margin %]`, `[Share %]` |
| Formatted | `[Base Display]` | `[Revenue Display]` |
| Helper measure (hidden) | `_` prefix | `_Intermediate` |

### Columns

- Power Query columns: `PascalCase` (`CustomerId`, `BirthDate`, `CountryCode`)
- Calculated columns (DAX): `PascalCase` with `Calc` suffix when needed (`AgeGroupCalc`)
- Sort columns: `[DisplayColumn]Sort` (`AgeGroupSort`)

## Formatting

### DAX

```dax
// Measure name on its own line, VAR declarations indented
MeasureName =
    VAR Value1 = SUM( Table[Column] )
    VAR Value2 = CALCULATE( [Base], Filter )
    RETURN
        DIVIDE( Value1, Value2, 0 )
```

Rules:
- Spaces in table references: `SUM( Table[Column] )` (not `SUM(Table[Column])`)
- Each `VAR` on its own line
- `RETURN` on its own line
- `CALCULATE` filters each on its own line when > 1 filter
- Always `DIVIDE()` instead of `/`

### Power Query M

```powerquery
let
    Source = ...,
    #"Descriptive Step Name" = Table.Transform...(Source, ...),
    Final = Table.SelectRows(...)
in
    Final
```

Rules:
- Descriptive step names (no generic `#"Step 1"`)
- Always specify type declaration in `Table.AddColumn`
- Remove unneeded columns as early as possible

## Localization

> **Example Profile (Switzerland / German):** This profile shows Swiss localization standards.
> For other regions, adapt the formats accordingly.

| Element | Format | Example |
|---------|--------|---------|
| Numbers | Swiss thousands separator (apostrophe) | `1'234'567.89` |
| Date | `dd.MM.yyyy` or `MMMM yyyy` | `17.02.2026` |
| Currency | `CHF` prefix | `CHF 1'234.50` |
| Percentage | One decimal with dot | `42.3%` |
| Language code | Uppercase | `DE`, `FR`, `IT` |

## Data Source Parameters

Define server and database connections as PowerBI parameters:
- Use generic parameter names (e.g. `DWH_Server`, `DWH_Database`)
- Switch environments DEV / TEST / PROD via parameters
