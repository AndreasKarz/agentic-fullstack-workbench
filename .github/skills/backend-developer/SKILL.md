---
name: backend-developer
description: "Use when implementing .NET microservices: HotChocolate GraphQL APIs, MassTransit consumers/publishers, MongoDB data access, startup/DI, data pipelines, or OpenTelemetry. Triggers on: GraphQL resolvers, ObjectType, DataLoaders, IConsumer, Azure Service Bus, repositories, service startup."
---

# Backend Developer

Guide for developing your .NET microservices. Covers domain-specific patterns, conventions, and shared internal libraries that the LLM does not inherently know.

> **Scope**: This skill covers project-specific patterns and conventions only. For general C# best practices, refer to the CSharpExpert agent. For testing conventions, follow `tests.instructions.md`.

## Architecture Quick Reference

Architecture, layer definitions, dependency rules, and coding standards are defined in `general.instructions.md` (always loaded). The following covers domain-specific patterns only.

**Known domains**: (add your service domain names here, e.g. Contract, Document, Profile, etc.)

### API Stitching Layer

`src/Api/` is the HotChocolate Stitching gateway. It stitches domain GraphQL schemas together and uses `QueryDelegationRewriterBase` to transform queries between schemas.



Never add business logic to the Api layer — it only delegates and rewrites.

## HotChocolate GraphQL Patterns

We follow the **Implementation First** approach: the GraphQL schema is derived from C# code (annotations + descriptors), not from SDL files. Never write `.graphql` schema files — the C# types _are_ the schema.

> For ObjectType, TypeExtensions, DataLoaders, Field Middleware, Translation, and Mutation Conventions → load the `backend-hotchocolate-specialist` skill. It contains all concrete code patterns and conventions.

## MassTransit Consumer Patterns

### Standard Consumer

Mark consumers `sealed`. Use primary constructors for DI. Every consumer **must** include OpenTelemetry tracing and source-generated logging.

### Abstract Base Consumer

For shared consumer logic across message types, use a generic abstract base.

### Consumer Organization

Organize consumers in `Core/Messaging/Consumers/` by category:
- `E2E/CustomerUpdates/` — End-to-end customer update events
- `Fuse/` — Fuse-specific events (invites, codes)
- `FusionIdentity/` — Identity events
- `Integration/` — External integration events

### Request-Response Pattern

For consumers that need to respond:

```csharp
await context.RespondAsync(new AdminResponse { /* ... */ });
```

### Consumer Anti-Patterns

- Never catch and swallow exceptions in consumers — let MassTransit handle retries
- Never use `ILogger` directly — use source-generated `App.Log` methods
- Never skip `App.ActivitySource.StartActivity()` — it breaks distributed tracing
- Never add business logic outside `Core/` layer — consumers orchestrate, not implement

### Publisher Testing

Test publishers with MassTransit `InMemoryTestHarness` + Snapshooter.

## Observability

### OpenTelemetry Tracing

Use your observability utility (e.g. `App.ActivitySource`) for all tracing. Start activities in every consumer/service method:

```csharp
using Activity? activity = App.ActivitySource.StartActivity();
```

Record exceptions on the activity:

```csharp
catch (Exception ex)
{
    activity?.RecordException(ex);
    throw;
}
```

### Source-Generated Logging

Use the `[LoggerMessage]` attribute with `App.Log` — never use `ILogger` directly for structured log messages.

## Service Startup Configuration

### Standard Host Setup

Domain services use a consistent startup pattern. Read the `Startup.cs` of the domain you are working in.

### Confix Configuration

All deployable projects (Host, Worker) use **Confix** for configuration management. `appsettings.json` contains variable references — never hardcode secrets or environment-specific values:

| Prefix | Source | Example |
|---|---|---|
| `$secret:` | Azure Key Vault | `"$secret:FusionAdvisor.Api.Db.ConnectionString"` |
| `$shared:` | Shared-Config git repo | `"$shared:Common.Security.Fusion.Authority"` |
| `$local:` | `variables.{A,UAT,PAV}.json` | `"$local:Db.DatabaseName"` |

String interpolation: `"{{$shared:Common.Proxy.Url}}your-service-api/"`

Confix files per Host/Worker project: `.confix.project`, `variables.A.json`, `variables.UAT.json`, `variables.PAV.json`, and `confix/components/` with `.confix.component` per config section.

### Shared Internal Libraries

| Library | Purpose |
|---|---|
| `*.Security.Authentication.JwtBearer` | JWT Bearer auth setup |
| `*.Health.*` | Health check extensions (Mongo, etc.) |
| `*.Observability.*` | `App.ActivitySource`, `App.Log` (structured logging) |
| `*.Shared.*` | Domain-specific shared code |

### Authentication & Authorization

- Use `AddJwtBearerAuthentication(Configuration)` for auth setup
- Define authorization policies for specific endpoints (e.g., Invites, NeoInvites, MyLifeInvites)
- Swagger UI configured with Bearer token support

### REST + GraphQL Coexistence

Some services expose both REST (controllers + Swagger) and GraphQL. This pattern is useful for services that need to serve external API consumers alongside GraphQL clients.

### NSwag-Generated Clients

External API clients live in `ServiceReferences/Generated/`. Never edit generated files. Register via DI and consume through the generated client interfaces.

## Worker / Pipeline Integration

When your service has a background Worker that runs a data sync pipeline (e.g. SQL → MongoDB), follow these generic patterns:

### API Host (GraphQL + REST)

Use your service's `Program.cs` entry point pattern. Each domain service typically follows a consistent startup convention — read the existing `Startup.cs` or `Program.cs` for the actual pattern.

### Worker Host

Background workers use a similar entry point but configure the pipeline instead of the HTTP layer. Follow the same DI registration pattern as the API host.

### Messaging

Register sender/receiver in DI using your messaging library's extension methods:

```csharp
services.AddPipelineReceiver<MyWorker>();
services.AddPipelineSender();
```

Use message sender interfaces (e.g. `IMessageSender<T>`) for sending messages.

### Tenant / Module Structure

If your service uses a tenant/module pattern, organize under `src/Tenants/` or `src/Modules/` accordingly.

### Partial Program Pattern

For environment-specific configuration, use partial classes:
- `Program.cs` — Shared entry point
- `Program.Dev.cs` — Development-only configuration
- `Program.Prod.cs` — Production configuration

### Shared Config

Shared appsettings live in shared config directories (e.g. `_Links/`). These contain common settings injected by the config tool (Confix).

## MongoDB Data Access

### Repository Pattern

Repositories implement interfaces from `Abstractions` and use `IMongoCollection<T>` directly. Follow existing patterns in the domain you are working in.

### Health Checks

Always register MongoDB health checks:

```csharp
services.AddHealthChecks()
    .AddMongoHealthCheck();
```

## Testing Domain-Specific Code

Follow `tests.instructions.md` for general testing conventions. Additional domain-specific patterns:

### HotChocolate Middleware Testing

Use `DummyMiddlewareContext` / `DummyContext` implementing `IMiddlewareContext` / `IResolverContext`:

```csharp
DummyMiddlewareContext context = new();
context.SetResult(testData);
context.SetScopedContextData("key", value);

await middleware.Invoke(context);

context.Result.Should().BeEquivalentTo(expected);
```

### MassTransit Consumer Testing

Use `InMemoryTestHarness` for integration-style tests. Combine with `Snapshooter` for complex message assertions.

### Time-Dependent Logic

Use `FakeTimeProvider` to control time in tests instead of `DateTime.Now` or `DateTimeOffset.UtcNow`.

<!-- Last updated: 2026-07-02 · Part of the Copilot Context Blueprint -->