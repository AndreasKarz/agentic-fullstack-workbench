<!-- Source: consolidated from backend-developer · Last updated: 2026-07-10 -->

# Startup, Configuration & Observability

Service startup, Confix configuration, dependency injection, OpenTelemetry, and worker/pipeline integration.

## Table of Contents

- [Standard Host Setup](#standard-host-setup)
- [Confix Configuration](#confix-configuration)
- [Shared Internal Libraries](#shared-internal-libraries)
- [Authentication & Authorization](#authentication--authorization)
- [REST + GraphQL Coexistence](#rest--graphql-coexistence)
- [Worker / Pipeline Integration](#worker--pipeline-integration)
- [Observability](#observability)

## Standard Host Setup

Domain services use a consistent startup pattern. Read the `Startup.cs` / `Program.cs` of the domain being worked on — it is the ground truth.

## Confix Configuration

All deployable projects (Host, Worker) use **Confix** for configuration. `appsettings.json` contains variable references — never hardcode secrets or environment-specific values.

| Prefix | Source | Example |
|---|---|---|
| `$secret:` | Azure Key Vault | `"$secret:FusionAdvisor.Api.Db.ConnectionString"` |
| `$shared:` | Shared-Config git repo | `"$shared:Common.Security.Fusion.Authority"` |
| `$local:` | `variables.{A,UAT,PAV}.json` | `"$local:Db.DatabaseName"` |

String interpolation: `"{{$shared:Common.Proxy.Url}}your-service-api/"`.

Confix files per Host/Worker: `.confix.project`, `variables.A.json`, `variables.UAT.json`, `variables.PAV.json`, and `confix/components/` with one `.confix.component` per config section.

## Shared Internal Libraries

| Library | Purpose |
|---|---|
| `*.Security.Authentication.JwtBearer` | JWT Bearer auth setup |
| `*.Health.*` | Health check extensions (Mongo, etc.) |
| `*.Observability.*` | `App.ActivitySource`, `App.Log` (structured logging) |
| `*.Shared.*` | Domain-specific shared code |

## Authentication & Authorization

- Use `AddJwtBearerAuthentication(Configuration)` for auth setup.
- Define authorization policies per endpoint (e.g., Invites, NeoInvites, MyLifeInvites) — one endpoint per consumer to prevent misuse.
- Swagger UI configured with Bearer token support.
- Never forward ALL headers — use the dedicated header-propagation extension; the Security Package handles Cookie and Authorization headers.

## REST + GraphQL Coexistence

Some services expose both REST (controllers + Swagger) and GraphQL for external API consumers alongside GraphQL clients.

**NSwag-generated clients** live in `ServiceReferences/Generated/`. Never edit generated files. Register via DI and consume through the generated interfaces.

## Worker / Pipeline Integration

Background workers use a similar entry point to the API host but configure the pipeline instead of the HTTP layer. Follow the same DI registration pattern.

### Messaging registration

```csharp
services.AddPipelineReceiver<MyWorker>();
services.AddPipelineSender();
```

Send messages through sender interfaces (e.g., `IMessageSender<T>`).

### Structure

- Tenant/module pattern: organize under `src/Tenants/` or `src/Modules/`.
- Partial `Program` pattern for environment-specific config: `Program.cs` (shared), `Program.Dev.cs`, `Program.Prod.cs`.
- Shared appsettings live in shared config directories (e.g., `_Links/`), injected by Confix.

## Observability

### OpenTelemetry Tracing

Start activities in every consumer/service method and record exceptions:

```csharp
using Activity? activity = App.ActivitySource.StartActivity();

try
{
    // ...
}
catch (Exception ex)
{
    activity?.RecordException(ex);
    throw;
}
```

### Source-Generated Logging

Use the `[LoggerMessage]` attribute with `App.Log` — never use `ILogger` directly for structured log messages.
