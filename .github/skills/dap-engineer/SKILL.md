---
name: dap-engineer
description: "Single entry point for Data & Analytics Platform work — MongoDB/SQL live analysis and query/index optimization, data-pipeline code, Databricks/DAP Lakehouse, and PowerBI. Use when: inspect MongoDB or SQL data read-only, analyze an execution plan/index/query, implement a change tracker/data loader/stored procedure/repository/Squadron DB test, build a Bronze/Silver/Gold Delta pipeline or PySpark notebook, design a Lakehouse layer, or create a PowerBI model, DAX measure, Power Query, or dashboard. NOT for backend microservices (use backend-developer)."
---

# DAP Engineer

Consolidated skill for Data & Analytics Platform work: data pipelines, Databricks Lakehouse, and PowerBI. Keep `SKILL.md` as the compact core; load one `references/<domain>/` guide only when the task needs that depth.

## Output style

Apply the `caveman` skill to every user-facing response (default `full`) unless the user says `stop caveman` / `normal mode`. Keep code, commands, SQL, DAX, Power Query M, PySpark, and config in **normal precise form** — never caveman. Relax caveman for irreversible-action confirmations (e.g. dropping/overwriting tables), then resume.

## Capabilities

Discrete units of work this skill owns (map a spec/change to one):

1. **data-pipeline** — SQL change trackers, data loaders, stored-procedure calls, MongoDB repositories, DI, Squadron DB tests, pipeline entities.
2. **lakehouse** — Databricks / DAP Medallion Lakehouse (Bronze/Silver/Gold + PSA), ADLS, PySpark/Delta, Data Quality, RBAC/ABAC, ingestion CI/CD.
3. **powerbi** — Star Schema data models, DAX measures, Power Query M, ETL from MongoDB/SQL DWH, dashboards, localization.
4. **live-analysis** — read-only MongoDB/SQL inspection, query plans, indexes, and performance diagnosis through MCP.

## Orientation

- **Code-first:** before writing or modifying pipeline code, read the relevant source files — existing patterns in the codebase are the ground truth.
- The Medallion flow is **PSA → Bronze → Silver → Gold**; keep transformations idempotent and layer-appropriate.
- PowerBI models follow **Star Schema** (`Fakt_`/`Dim_`) with DAX/M formatting from `references/powerbi-specialist/`.

## Lazy reference loading

Do **not** read `references/` up front. Classify the task, then open the **smallest** matching guide (usually one). Each domain guide lives at `references/<domain>/<domain>.md`; PowerBI keeps detailed files in `references/powerbi-specialist/references/`.

| Task signal | Load only |
|---|---|
| SQL change tracker, data loader, stored procedure, MongoDB repository, DI, Squadron DB test, pipeline entity | `references/database-specialist/database-specialist.md` |
| Databricks / DAP Lakehouse, Medallion, PySpark/Delta notebook, ADLS, data quality, RBAC/ABAC, ingestion CI/CD | `references/databricks-specialist/databricks-specialist.md` |
| PowerBI report, Star Schema, DAX measure, Power Query M, ETL from DWH, dashboard, localization | `references/powerbi-specialist/powerbi-specialist.md` |
| Live MongoDB/SQL data, query/index analysis, execution plans | Use `mongodb` or `mssql` read-only; load the closest database reference only when implementation patterns matter |

**Reference map:** inside a domain guide, an instruction to "load the `dap-<x>` skill" now means **read `references/<x>/`** in this skill (drop the `dap-` prefix, e.g. `dap-powerbi-specialist` → `references/powerbi-specialist/`).

For live systems, start with metadata and explain plans; avoid writes, DDL, broad scans, and sensitive-data extraction unless explicitly authorized. Backend microservice patterns (GraphQL, MassTransit, startup) → `backend-developer`.

## Workflow

1. **Understand** — read the relevant source (pipeline code, notebook, or report) and existing conventions first.
2. **Classify** — map the task to one capability above; load the matching guide only if needed.
3. **Implement** — follow local patterns; keep transformations idempotent and layer-appropriate.
4. **Validate** — run the narrowest useful check (Squadron DB test, notebook run, DAX/measure verification).
5. **Align** — present result; confirm before irreversible data actions.

<!-- Last updated: 2026-07-10 · Part of the Copilot Context Blueprint -->
