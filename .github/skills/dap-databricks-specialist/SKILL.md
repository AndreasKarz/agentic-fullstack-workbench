---
name: dap-databricks-specialist
description: "Databricks / Data & Analytics Platform (DAP) engineering: Medallion Lakehouse (Bronze/Silver/Gold + PSA), ADLS storage layout, PySpark/Delta notebooks, Data Quality Framework, RBAC/ABAC, CI/CD for ingestion. Use for: DAP, Databricks, Lakehouse, Delta table, PySpark notebook, ingestion pipeline, Bronze/Silver/Gold, medallion, ADLS, data product, data quality checks, Unity Catalog, ABAC/RBAC on data."
---

# Databricks / Data & Analytics Platform (DAP)

Engineering guidance for the **Data & Analytics Platform (DAP)** — a Databricks-based Lakehouse. Load when building or reviewing ingestion pipelines, notebooks, Delta tables, data products, or data-governance rules on DAP.

## Architecture — Medallion Lakehouse

| Layer | Purpose |
|-------|---------|
| **Ingestion (Bronze-Landing)** | Raw incoming data, as-is. Short retention (~30 days). |
| **Archive (Cold)** | Long-term raw storage, infinite retention (Azure Cold tier). Bidirectional with Ingestion (reload/reprocess). |
| **Lakehouse** | Core analytic layers: **PSA** (Persistent Staging Area / Bronze-Lake) → **Silver** (cleansed & conformed) → **Gold** (curated, business-ready). Hot, infinite. |
| **Export** | Curated hot layer for downstream consumers. |

Flow: `Ingestion ⇄ Archive` · `Ingestion → PSA → Silver → Gold → Export`.

## Storage (ADLS)

Four dedicated storage accounts by function: **ingest** · **archive** · **lakehouse** · **export**. Follow the environment naming pattern used by the platform (DEV/TEST/PROD). Never hardcode account names in notebooks — resolve from config/secrets.

## Development

- **Notebooks:** Python / PySpark; Delta Lake tables. Keep transformations idempotent and re-runnable.
- **Ingestion pattern:** land raw → validate → write to Bronze/PSA → transform to Silver → aggregate to Gold. Schedule via Databricks Workflows.
- **Data Quality Framework:** apply DQ checks on source data before promoting a layer (completeness, validity, schema). Block promotion on failure.
- **Dev container:** use the platform's dev container for a consistent toolchain.

## Security & Governance

- **Roles:** the platform separates **technical capability roles** (Account Admin, Platform Admin, Platform Engineer, Data Engineer, Data Scientist, Viewer) from **data-access roles**. Request least-privilege.
- **RBAC + ABAC:** enforce role-based and attribute-based access control; respect information barriers across data domains.
- **Read-only by default:** user groups are read-only; changes/deletions go through monitored CI/CD via **service principals**.
- **Governance concepts:** Data Product, Data Domain Owner, PII Classification, Data Lineage, Data Quality, Access Control. Comply with data-protection requirements (DSG/GDPR).

## CI/CD & Testing

- Ingestion code is fully CI/CD-integrated: unit + integration tests must pass before deploy; failed tests block deployment.
- Target **≥ 80 % coverage** for Python functions in ingestion notebooks.
- Use mock connections + test data for unit tests; verify connectivity (ADLS, APIs, DBs) in integration tests.
- Deploy objects/data via service principals only (no manual prod changes).

## Anti-Patterns

- Hardcoded storage account names, secrets, or connection strings in notebooks.
- Skipping DQ checks before promoting a layer.
- Writing to Gold directly from raw without Silver conforming.
- Broad data access instead of least-privilege / ABAC.

## Know-how

- Databricks on Azure: https://learn.microsoft.com/azure/databricks/
- Medallion architecture: https://learn.microsoft.com/azure/databricks/lakehouse/medallion
- Delta Lake: https://docs.delta.io/

<!-- Source: Internal DAP documentation, generically abstracted · Last updated: 2026-07-02 -->
