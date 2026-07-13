---
name: dap-database-specialist
description: "Use when implementing data-pipeline code: SQL change trackers, data loaders, stored procedure calls, MongoDB repositories, DI registration, Squadron database tests, and new pipeline entities. Triggers on: SqlChangeTracker, SqlDataLoader, IMongoCollection, BulkWriteAsync, MongoResource, SqlServerResource."
---

# Database Specialist — Data Pipeline

Implement and troubleshoot data-pipeline code: change-tracker jobs, data-loader configurations, SQL stored procedure integration, MongoDB repository patterns, and database tests.

> **Code-first rule**: Before writing or modifying pipeline code, always read the relevant source files first. The paths below tell you where to look. Follow existing patterns in the codebase — they are the ground truth.

> **Scope**: data pipeline implementation only.
> - For **MongoDB analysis, indexing strategy, and query optimization** → use `dap-engineer` with read-only `afw-mongodb` MCP calls.
> - For **SQL Server query optimization, execution plans, and schema design** → use `dap-engineer` with read-only `afw-mssql` MCP calls.
> - For general backend patterns (GraphQL, MassTransit, Startup) → `backend-developer` skill.
> - For tests → follow the matching domain skill and nearby project test patterns.

## Architecture Overview

```
SQL Server (Stored Procedures)
  → SqlChangeTracker (Quartz job, Cron)
    → Extract keys
      → MongoDB (store keys, transactions)
        → DomainProcessor (transformation)
          → MongoDB (store snapshots, hashes)
```

### Key Paths

| Area | Path |
|---|---|
| SQL Client & Execution | `src/DataAccess/` |
| SQL Configurations | `src/Abstractions/Configuration/` |
| Change Tracker & Loader | `src/Core/ChangeTracker/`, `src/Core/Loader/` |
| MongoDB Repositories | `src/Repository/` |
| DI Registration | `src/Core/DataPipelineCoreCollectionExtensions.cs` |
| Domain Configuration | `src/Repository/ConfigureDomainSettings.cs` |
| Tests | `test/` |

## MS SQL Server

### SqlClient

`SqlClient.cs` in `src/DataAccess/` — read the source for implementation details. Key characteristics:

- Uses `Microsoft.Data.SqlClient` (not `System.Data.SqlClient`)
- `CommandType.StoredProcedure` — exclusively stored procedures, no inline SQL
- `CommandTimeout` = 10 minutes
- Polly `WaitAndRetry(3, retryAttempt => TimeSpan.FromSeconds(5))` for transient errors
- Streaming via `IAsyncEnumerable<SqlTable>` with optional batching
- Internal `SqlExecutionContext` holds connection string, SP name, parameters, and batching config

### Two SQL Client Types

| Client | Implements | Batching | Purpose |
|---|---|---|---|
| `SqlChangeTrackerClient` | `ISqlChangeTrackerClient` | Yes | Periodic change detection via Cron |
| `SqlDataLoaderClient` | `ISqlDataLoaderClient` | No | Full entity data loading |

### SQL Configurations

Read `SqlChangeTrackerConfiguration` and `SqlLoaderConfiguration` in `src/Abstractions/Configuration/`. Key rules:

- `SqlChangeTrackerConfiguration` implements `IChangeTrackerConfiguration` — `CronSchedule` default is `"0 {0} * ? * * *"` (placeholder `{0}` replaced with minute value)
- `SqlLoaderConfiguration` implements `ILoaderConfiguration` — supports TVP via `QueryParameterTypeName`
- Both call `Resolve(ConnectionsOptions)` to resolve connection strings — connections are **never** stored directly, always resolved via `Pipeline_Connections`

## Change Tracker Pipeline

### SqlChangeTrackerJob

Attributes: `[DisallowConcurrentExecution, PersistJobDataAfterExecution]`. Extends `TrackableJob`.

Pipeline flow:

1. Load domain configuration
2. Fetch current transaction ID from MongoDB
3. Execute stored procedure with transaction ID
4. Extract changed keys
5. Store keys in MongoDB (`{entity}_keys`)
6. Store new transaction ID in MongoDB (`{entity}_transactions`)
7. Trigger DomainProcessor

OpenTelemetry tracing with `Activity` and `datapipeline.changetracker.*` tags is mandatory.

### Domain Configuration

`ConfigureDomainSettings.cs` uses the `_t` discriminator field for polymorphic type resolution:

```
DomainSettings:Configurations → Array of configurations
  → _t field determines type:
    - SqlLoaderConfiguration
    - RestLoaderConfiguration
    - GraphQLLoaderConfiguration
    - SqlChangeTrackerConfiguration
    - ServiceBusChangeTrackerConfiguration
    - FieldKeyServiceBusChangeTrackerConfiguration
```

### Configuration Sections

| Section | Purpose |
|---|---|
| `Pipeline_Connections` | Named connection strings (name/value) |
| `Pipeline_Database` | MongoDB ConnectionString + DatabaseName |
| `Pipeline_Messaging` | Service Bus configuration |
| `Pipeline_Audit` | Audit settings |
| `DomainSettings:Configurations` | Loader and tracker definitions |
| `DomainSettings:HostSettings` | Host-specific settings |

## MongoDB

### MongoConventions — Critical Rule

**Every repository** must call `MongoConventions.Init()` in its static constructor:

```csharp
public class MyRepository
{
    static MyRepository()
    {
        MongoConventions.Init();
    }
}
```

### Collection Naming Convention

Collections are dynamically named by entity type:

| Collection | Pattern | Purpose |
|---|---|---|
| `{EntityType.Name}_snapshots` | Typed (`Snapshot`) | Domain entity snapshots |
| `{EntityType.Name}_keys` | `BsonDocument` | Source entity keys queue |
| `{EntityType.Name}_transactions` | `BsonDocument` | Change tracker transactions |
| `{EntityType.Name}_audit_keys` | Typed (`PipelineAuditEntry`) | Pipeline audit entries |
| `{EntityType.Name}_hashes` | Legacy | Hash storage (legacy) |
| `__domains` | Typed (`DomainConfiguration`) | Domain configurations |
| `__settings` | Typed (`HostSettings`) | Host settings |

System collections (`__domains`, `__settings`) use double underscore prefix.

### Repository Classes

Read the source in `src/Repository/` for current implementation patterns:

| Repository | Collection(s) | Access Pattern |
|---|---|---|
| `SourceRepository` | `_transactions`, `_keys` | `IMongoCollection<BsonDocument>` — BsonDocument-based |
| `DomainEntityRepository` | `_snapshots`, `_hashes` | Typed `Snapshot` + BsonDocument — bulk upsert via `ReplaceOneModel`, indexes on Key/Hash/Key+Version |
| `ConfigurationRepository` | `__domains` | Typed — `IMemoryCache` with 1-day expiration |
| `AuditRepository` | `_audit_keys` | Typed `PipelineAuditEntry` — compound index on Attempt+Key |

Key patterns to follow from existing code:
- `BulkWriteAsync` with `IsOrdered = false` for bulk deletes
- `ReplaceOneModel` with `IsUpsert = true` for bulk upserts
- `IAsyncCursor` with `BatchSize = 1000` for streaming large data
- `BsonSerializer.Deserialize<T>()` for BsonDocument-to-type conversion

> **Compatibility note**: Avoid `$literal` syntax — not supported on MongoDB Server < 4.4 with MongoDB.Driver > 3.x.

## DI Registration

Read `DataPipelineCoreCollectionExtensions.cs` for current registrations. Key extension methods:

| Method | Registers |
|---|---|
| `AddDataPipelineCore()` | SqlChangeTracker, ServiceBusChangeTracker, etc. |
| `AddDomains<TDomainReference>()` | ConnectionsOptions, DomainsResolver |
| `AddScheduling()` | Quartz jobs: SqlChangeTrackerJob, AuditJob, DomainProcessorJob |

Config binding: `ConnectionsOptions` is bound from `Pipeline_Connections` section.

## Database Tests

### Squadron Resources

| Resource | Purpose |
|---|---|
| `MongoResource` | Standalone MongoDB for simple tests |
| `MongoReplicaSetResource` | MongoDB Replica Set (for transactions/change streams) |
| `SqlServerResource<SqlServerOptions>` | SQL Server container |

Use `IClassFixture<MongoResource>` and/or `IClassFixture<SqlServerResource<SqlServerOptions>>` for test classes. For end-to-end pipeline tests, combine both fixtures.

Read existing tests in `test/` for current setup patterns — especially fixture loading via `CreateDatabaseFromFilesOptions` and config overrides for `Pipeline_Database` and `Pipeline_Connections`.

Use `Snapshooter.Xunit` (`result.MatchSnapshot()`) for deterministic result verification.

## Checklist for New Entities

When setting up a new data pipeline entity:

1. **SQL Stored Procedure** — Ensure the SP exists and returns the expected columns
2. **SqlLoaderConfiguration** — Define loader configuration with correct SP and connection
3. **SqlChangeTrackerConfiguration** — Define tracker with SP, Cron schedule, and connection
4. **ConnectionsOptions** — Register named connection string in `Pipeline_Connections`
5. **MongoDB Collections** — Created automatically, but verify indexes
6. **Domain-specific indexes** — Define on `Entity.*` fields when queries are needed
7. **Tests** — Repository tests with Squadron + Snapshooter, system tests with both DBs

<!-- Last updated: 2026-07-02 · Part of the Copilot Context Blueprint -->
