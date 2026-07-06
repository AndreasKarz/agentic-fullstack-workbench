---
name: backend-hotchocolate-specialist
description: "Use when implementing advanced HotChocolate server patterns: stitching, Fusion gateway, TypeExtensions, field middleware, QueryDelegationRewriter, mutation conventions, secure IDs, error handling, ObjectType/InputType conventions. For Relay client work, use fullstack-graphql-expert."
---

# HotChocolate Specialist

Concrete patterns and conventions for HotChocolate GraphQL in your .NET backend. Complements the `HotChocolate.Expert` agent (which owns workflow and architecture overview).

> **Self-update rule**: Always fetch the latest official docs before applying patterns.

## Keeping Knowledge Current

HotChocolate evolves rapidly. Always fetch the latest docs before applying patterns:

### For Schema Design / API Patterns

```
1. Use microsoft_docs_search for ".NET GraphQL HotChocolate <topic>"
2. Fetch https://chillicream.com/docs/hotchocolate/v16/defining-a-schema/object-types
3. For DataLoaders: Fetch https://chillicream.com/docs/hotchocolate/v16/fetching-data/batching/dataloader
```

### For Fusion Gateway

```
1. Fetch https://chillicream.com/docs/fusion/v16
```

### General Rule

If online docs contradict patterns below, **the online docs win** — they represent the latest state. Update your implementation accordingly and inform the user of the deviation.

## Code Patterns

### ObjectType Definitions

Always use the implementation-first approach: annotate a `static partial` class with `[ObjectType<T>]`. HotChocolate's default naming and nullability conventions handle the overwhelming majority of cases without any extra configuration.

```csharp
[ObjectType<Customer>]
public static partial class CustomerType
{
    public static string GetDisplayName([Parent] Customer customer)
        => $"{customer.FirstName} {customer.LastName}";
}
```

> **Code-first (`ObjectType<T>` with descriptors) is almost never needed.** Only reach for it if you have a concrete, unavoidable reason that cannot be solved with annotations or HotChocolate's defaults.

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

Always use the source-generated `[DataLoader]` approach. The source generator derives the class and interface name from the method: `GetContractByIdAsync` → `ContractByIdDataLoader` + `IContractByIdDataLoader`.

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

> **Manual `BatchDataLoader<TKey, TValue>` class inheritance is almost never needed.** Only use it when you have a concrete, unavoidable reason the source generator cannot cover.

### Mutation Conventions

Use HotChocolate's built-in mutation conventions with dedicated Input/Output types.

### Field Middleware

Chain middleware on fields using `FieldDelegate` and `IMiddlewareContext`.

### Secure Object Identifiers

Use `SecureObjectIdentifier` with `ISecureContextResolver` for ID obfuscation.

## Conventions

| Convention | Rule |
|---|---|
| Approach | Always implementation-first (annotations + source generators). Code-first (`ObjectType<T>` descriptors) almost never needed — HotChocolate's defaults cover the vast majority of cases. SDL-first never. |
| Secure IDs | `SecureObjectIdentifier` with `ISecureContextResolver` |
| Introspection | Disabled on UAT/q and PAV/p environments. To be controlled via `appsettings.json` ($local confix variables). |
| Mutations | Always use mutation conventions. No Input types or Payload types should be defined manually. |
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
| Direct DB access from GraphQL layer | Access data through `Core` services |
| SDL-first schema definition | Always use implementation-first (annotations + source generators) |
| Code-first (`ObjectType<T>` descriptors) without a concrete unavoidable reason | Use implementation-first; HotChocolate's defaults handle naming, nullability, and typing |
| `AddGraphQL()` without `AddApplicationService<T>()` (v16) | Always cross-register required app services |

## HotChocolate Testing

### Schema Build Test

```csharp
[Fact]
public async Task Schema_ShouldBuildSuccessfully()
{
    IRequestExecutor executor = await new ServiceCollection()
        .AddGraphQLServer()
        .AddTypes()
        .BuildRequestExecutorAsync();

    ISchema schema = executor.Schema;
    schema.Should().NotBeNull();
    schema.ToString().MatchSnapshot();
}
```

> **Tip**: Search for `Schema_ShouldBuildSuccessfully` or `BuildRequestExecutorAsync` in the domain you are working on for a domain-specific schema build test.

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

Use `DummyMiddlewareContext` / `DummyContext`:

```csharp
DummyMiddlewareContext context = new();
context.SetResult(testData);
context.SetScopedContextData("locale", "de");

await middleware.Invoke(context);

context.Result.Should().BeEquivalentTo(expected);
```

<!-- Last updated: 2026-07-02 · Part of the Copilot Context Blueprint -->