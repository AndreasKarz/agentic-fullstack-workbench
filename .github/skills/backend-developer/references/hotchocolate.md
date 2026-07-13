<!-- Source: consolidated from backend-hotchocolate-specialist · Know-how: https://chillicream.com/docs/hotchocolate/v16 · Last updated: 2026-07-10 -->

# HotChocolate GraphQL (ChilliCream Platform)

Advanced HotChocolate server patterns for the .NET backend: ObjectTypes, TypeExtensions, DataLoaders, middleware, stitching, Fusion gateway, mutation conventions, secure IDs. For Relay client work, use the Relay references in `frontend-developer`.

## Table of Contents

- [Keep Knowledge Current](#keep-knowledge-current)
- [Code Patterns](#code-patterns)
- [Conventions](#conventions)
- [Common Issues](#common-issues)
- [Anti-Patterns](#anti-patterns)
- [Testing](#testing)

## Keep Knowledge Current

HotChocolate evolves rapidly. Fetch the latest docs before applying patterns:

- Schema/API: `microsoft_docs_search` for ".NET GraphQL HotChocolate <topic>", then <https://chillicream.com/docs/hotchocolate/v16/defining-a-schema/object-types>
- DataLoaders: <https://chillicream.com/docs/hotchocolate/v16/fetching-data/batching/dataloader>
- Fusion gateway: <https://chillicream.com/docs/fusion/v16>

**If online docs contradict the patterns below, the online docs win.** Update the implementation and inform the user of the deviation.

## Code Patterns

### ObjectType Definitions

Implementation-first: annotate a `static partial` class with `[ObjectType<T>]`. HotChocolate's default naming and nullability conventions handle the overwhelming majority of cases.

```csharp
[ObjectType<Customer>]
public static partial class CustomerType
{
    public static string GetDisplayName([Parent] Customer customer)
        => $"{customer.FirstName} {customer.LastName}";
}
```

> **Code-first (`ObjectType<T>` with descriptors) is almost never needed.** Only reach for it if a concrete, unavoidable reason cannot be solved with annotations or defaults.

### TypeExtensions

Extend existing types without modifying their original definition:

```csharp
[ExtendObjectType(typeof(ParentEntity))]
public class ChildTypeExtensions
{
    public async Task<ChildResult> GetChildData(
        [Parent] ParentEntity parent,
        [Service] IChildService service,
        CancellationToken cancellationToken)
    {
        return await service.GetByParentIdAsync(parent.Id, cancellationToken);
    }
}
```

### DataLoaders

Always use the source-generated `[DataLoader]` approach. The generator derives class/interface names from the method: `GetContractByIdAsync` → `ContractByIdDataLoader` + `IContractByIdDataLoader`.

```csharp
internal static class ContractDataLoaders
{
    [DataLoader]
    public static async Task<Dictionary<string, Contract>> GetContractByIdAsync(
        IReadOnlyList<string> ids,
        IContractRepository repository,
        CancellationToken cancellationToken)
        => (await repository.GetByIdsAsync(ids, cancellationToken))
            .ToDictionary(c => c.Id);
}
```

> **Manual `BatchDataLoader<TKey, TValue>` inheritance is almost never needed.** Only use it when the source generator genuinely cannot cover the case.

### Mutation Conventions

Use HotChocolate's built-in mutation conventions with dedicated Input/Output types. Do not hand-write Input or Payload types.

### Field Middleware

Chain middleware on fields using `FieldDelegate` and `IMiddlewareContext`.

### Secure Object Identifiers

Use `SecureObjectIdentifier` with `ISecureContextResolver` for ID obfuscation.

### API Stitching / Fusion Gateway

`src/Api/` is the HotChocolate Stitching gateway. It stitches domain schemas and uses `QueryDelegationRewriterBase` to transform queries between schemas. **Never add business logic to the gateway** — it only delegates and rewrites.

## Conventions

| Convention | Rule |
|---|---|
| Approach | Always implementation-first (annotations + source generators). Code-first descriptors almost never needed. SDL-first never. |
| Secure IDs | `SecureObjectIdentifier` with `ISecureContextResolver` |
| Introspection | Disabled on UAT/q and PAV/p; control via `appsettings.json` (`$local` confix variables) |
| Mutations | Always use mutation conventions. No manual Input/Payload types. |
| User type conflicts | `RenameType("User", "<Domain>User", clientName)` |
| Shared extensions | `src/Shared/src/HotChocolate.Extensions/` |

## Common Issues

| Issue | Cause | Fix |
|---|---|---|
| Null from delegated query | Auth policy mismatch or missing middleware | Check authorization in both gateway and domain |
| Schema build failure | Missing type registration | Verify `AddTypes()` includes all required types |

## Anti-Patterns

| Anti-Pattern | Fix |
|---|---|
| Resolvers in Host project | Move to `GraphQL` project |
| Query resolvers in `ObjectType`/extension classes | Keep query-level field resolvers in `Query.cs` |
| Direct DB access from GraphQL layer | Access data through `Core` services |
| SDL-first schema definition | Always implementation-first |
| Code-first descriptors without a concrete reason | Use implementation-first; defaults handle naming, nullability, typing |
| `AddGraphQL()` without `AddApplicationService<T>()` (v16) | Always cross-register required app services |

## Testing

### Schema Build Test

```csharp
[Fact]
public async Task Schema_ShouldBuildSuccessfully()
{
    IRequestExecutor executor = await new ServiceCollection()
        .AddGraphQLServer()
        .AddTypes()
        .BuildRequestExecutorAsync();

    executor.Schema.Should().NotBeNull();
    executor.Schema.ToString().MatchSnapshot();
}
```

> **Tip**: Search for `Schema_ShouldBuildSuccessfully` or `BuildRequestExecutorAsync` in the target domain for a domain-specific schema build test.

### Resolver Integration Test

```csharp
[Fact]
public async Task GetContract_ShouldReturnData()
{
    IRequestExecutor executor = await BuildTestExecutor();

    IExecutionResult result = await executor.ExecuteAsync(
        QueryRequestBuilder.New()
            .SetQuery("{ contract(id: \"abc\") { id name } }")
            .Create());

    result.ToJson().MatchSnapshot();
}
```

### Middleware Testing

Use `DummyMiddlewareContext` / `DummyContext` implementing `IMiddlewareContext` / `IResolverContext`:

```csharp
DummyMiddlewareContext context = new();
context.SetResult(testData);
context.SetScopedContextData("locale", "de");

await middleware.Invoke(context);

context.Result.Should().BeEquivalentTo(expected);
```
