# HotChocolate v16 Backend Reference

## Official Docs

Fetch latest docs via `fetch_webpage`: `https://chillicream.com/docs/hotchocolate`.

Key doc pages:
- https://chillicream.com/docs/hotchocolate/v16/defining-a-schema/object-types
- https://chillicream.com/docs/hotchocolate/v16/defining-a-schema/queries
- https://chillicream.com/docs/hotchocolate/v16/defining-a-schema/mutations
- https://chillicream.com/docs/hotchocolate/v16/defining-a-schema/relay
- https://chillicream.com/docs/hotchocolate/v16/fetching-data/dataloader

## Project Conventions

### Package Version

HotChocolate **16.0.0-p.11.41** (pre-release). Packages managed in `Directory.Packages.props`.

### Architecture Layers

```
AdoMate.Api          → GraphQL types, operations, service registration
AdoMate.Application  → Services, data loaders, business logic
AdoMate.Domain       → Entities, value objects, repository interfaces
AdoMate.Infrastructure → Repository implementations (MongoDB)
```

### Source Generators (Annotation-Based API)

HotChocolate v16 uses **source generators** via `HotChocolate.Types.Analyzers`. This means:

- Object types use `[ObjectType<T>]` on `static partial class`
- The `Module.cs` file is auto-generated — **do not edit manually**
- Query / Mutation operations use `[Query]` / `[Mutation]` attributes on static methods

### Relay Compliance

The server is configured for Relay compliance:

```csharp
.AddGlobalObjectIdentification()   // node(id) and nodes(ids) queries
.AddDefaultNodeIdSerializer(useUrlSafeBase64: true)  // Opaque IDs
.AddMutationConventions()          // Input/Payload wrappers
```

Every entity that appears in the schema MUST have a `[NodeResolver]` to satisfy the `Node` interface.

### ID Handling

- Use `[ID<T>]` attribute on `Guid` parameters to indicate Relay global IDs
- The serializer handles encoding/decoding between opaque string IDs and internal `Guid` values
- UUID scalar uses format `'D'` (e.g., `550e8400-e29b-41d4-a716-446655440000`)

### Mutation Pattern

With `.AddMutationConventions()`, mutations automatically get:
- `<MutationName>Input` input type wrapping parameters
- `<MutationName>Payload` payload type wrapping return value

```csharp
public static class MyMutations
{
    [Mutation]
    [Error<EntityNotFoundException>]
    public static async Task<MyEntity> UpdateMyEntityAsync(
        [ID<MyEntity>] Guid id,
        string name,
        IMyService service,
        CancellationToken cancellationToken)
    {
        return await service.UpdateAsync(id, name, cancellationToken);
    }
}
```

### Error Handling

Use `[Error<TException>]` attribute on mutations to expose typed errors in the schema. This follows the HotChocolate mutation conventions pattern.

### Schema Export

Schema is auto-exported to `src/frontend/schema.graphql` on startup:

```csharp
.ExportSchemaOnStartup(
    schemaFileName: "../../../../src/frontend/schema.graphql",
    skipIf: builder.Environment.IsProduction() ||
            Environment.GetEnvironmentVariable("IS_IN_TEST") == "1")
```

### Connection/Pagination Pattern (Cursor-Based)

For paginated lists, use the `[UsePaging]` attribute:

```csharp
[Query]
[UsePaging]
public static async Task<IQueryable<MyEntity>> GetMyEntitiesAsync(
    IMyService service,
    CancellationToken cancellationToken)
{
    return await service.GetQueryableAsync(cancellationToken);
}
```

This generates a Relay-compliant connection type with `edges`, `nodes`, `pageInfo`.
