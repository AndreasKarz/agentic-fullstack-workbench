---
name: backend-developer
description: "Single entry point for .NET/C# backend microservice work — C# design & async, HotChocolate GraphQL (ChilliCream), MassTransit + Azure Service Bus messaging, MongoDB data access, service startup/DI/Confix, OpenTelemetry, scaffolding a new service, and strict backend code review. Use when: implement backend feature, GraphQL resolver/ObjectType/TypeExtension/DataLoader/mutation convention/stitching/Fusion gateway/secure IDs, IConsumer/publisher/request-response, MongoDB repository, startup/DI/health checks, SOLID/async/await/CancellationToken/records/ValueTask/error handling/performance, scaffold new microservice (Abstractions/Core/DataAccess/GraphQL/Host/Worker), or backend/PR/architect code review."
---

# Backend Developer

Consolidated skill for developing .NET microservices with HotChocolate GraphQL, MassTransit, MongoDB, and Confix. Keep `SKILL.md` as the compact core; load one `references/` file only when the task needs that depth.

## Output style

Apply the `caveman` skill to every user-facing response (default `full`) unless the user says `stop caveman` / `normal mode`. Keep code, commands, schema, config, commit/PR text, and generated artifacts in **normal precise form** — never caveman. Relax caveman for security warnings and irreversible-action confirmations, then resume.

## Capabilities

Discrete units of work this skill owns (map a spec/change to exactly one):

1. **csharp** — C#/.NET design, async, error handling, performance, .NET checklist.
2. **graphql** — HotChocolate schema, resolvers, DataLoaders, stitching/Fusion gateway.
3. **messaging** — MassTransit consumers/publishers on Azure Service Bus.
4. **persistence** — MongoDB repositories and health checks.
5. **startup** — Host/Worker startup, DI, Confix config, OpenTelemetry.
6. **scaffolding** — new domain microservice from Abstractions to Worker.
7. **review** — strict backend code review against team standards.

## Architecture quick reference

Layers, dependency rules, and coding standards live in `general.instructions.md` (always loaded); test conventions in `tests.instructions.md`. This skill adds domain patterns only.

- Layer flow: `Abstractions → Core → {DataAccess, GraphQL} → Host`; `Worker → {Abstractions, Core}`.
- `src/Api/` is the HotChocolate **stitching/Fusion gateway** — delegates and rewrites only, **no business logic**.
- **Implementation-first** GraphQL: the C# types *are* the schema. Never write `.graphql` SDL files.
- No HotChocolate packages outside the `GraphQL` layer.

## Lazy reference loading

Do **not** read `references/` up front. Classify the task, then open the **smallest** matching file (usually one). If the task is covered by the core rules below, open nothing.

| Task signal | Load only |
|---|---|
| C# design, SOLID, async/await, `CancellationToken`, error handling, performance, records, `ValueTask`, .NET checklist | `references/csharp-dotnet.md` |
| ObjectType, TypeExtension, DataLoader, field middleware, mutation conventions, stitching, Fusion gateway, secure IDs, schema build failure | `references/hotchocolate.md` |
| `IConsumer`, publisher, request-response, Azure Service Bus, retries/deadletters | `references/masstransit.md` |
| MongoDB repository, `IMongoCollection<T>`, health checks, `ID<T>` | `references/mongodb.md` |
| Startup, DI, Confix (`$secret:`/`$shared:`/`$local:`), OpenTelemetry, source-gen logging, Worker/pipeline, auth, REST+GraphQL | `references/startup-observability.md` |
| Scaffold a new service/domain (Abstractions/Core/DataAccess/GraphQL/Host/Worker) | `references/service-scaffolding.md` |
| Code review / PR review / architect review of current branch | `references/code-review.md` |

For MongoDB **analysis/indexing/query optimization** → `MongoDB Expert` agent. For **SQL/data-pipeline** change trackers/loaders → `dap-database-specialist`. For **Relay client** GraphQL → `fullstack-graphql-expert`.

## Core rules (apply without loading references)

- **Read before writing** — the existing `Startup.cs`, repository, resolver, or consumer in the target domain is the ground truth. Infer conventions; do not invent them.
- **GraphQL**: implementation-first `[ObjectType<T>]` + source-generated `[DataLoader]`; built-in mutation conventions (no hand-written Input/Payload types); query-level resolvers stay in `Query.cs`.
- **Messaging**: consumers are `sealed`, use primary-constructor DI, start `App.ActivitySource.StartActivity()`, and never swallow exceptions (let MassTransit retry). `enum` over `string` for constrained values → avoids deadletters.
- **Observability**: `[LoggerMessage]` + `App.Log` for structured logging — never `ILogger` directly; `activity?.RecordException(ex)` then rethrow.
- **Config**: Confix only — `appsettings.json` holds `$secret:`/`$shared:`/`$local:` refs; never hardcode secrets or environment values.
- **Persistence**: repositories implement `Abstractions` interfaces over `IMongoCollection<T>`; `ID<T>` for identifiers; register `AddMongoHealthCheck()`.
- **Tests**: `MockBehavior.Strict`; `MethodName_Scenario_ExpectedBehavior`; `InMemoryTestHarness` + `Snapshooter` for messaging; `FakeTimeProvider` for time. Follow `tests.instructions.md`.
- **Security**: no secrets in code; auth policy per endpoint; never forward all headers (use the header-propagation extension).

## Workflow

1. **Understand** — check TFM/C# version, `global.json`, `Directory.*.props`, and existing patterns in the target domain.
2. **Classify** — map the task to one capability above; load the matching reference only if needed.
3. **Execute** — small, compilable steps; run `get_errors` after each.
4. **Validate** — build + relevant tests; verify schema builds for GraphQL changes.
5. **Align** — present result; confirm before irreversible actions.

<!-- Last updated: 2026-07-10 · Part of the Copilot Context Blueprint -->
