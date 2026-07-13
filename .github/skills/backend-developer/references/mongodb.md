<!-- Source: consolidated from backend-developer + backend-service-scaffolder · Know-how: https://www.mongodb.com/docs/drivers/csharp/current/ · Last updated: 2026-07-10 -->

# MongoDB Data Access

Repository and health-check patterns for `MongoDB.Driver`. For live analysis, indexing strategy, and query optimization, use `dap-engineer` with read-only `mongodb` MCP calls. For data-pipeline change trackers/loaders, use `dap-engineer` → `references/database-specialist/`.

## Repository Pattern

Repositories implement interfaces from `Abstractions` and use `IMongoCollection<T>` directly. Use `ID<T>` for entity identifiers. Follow existing patterns in the target domain.

```csharp
public sealed class ContractRepository : IContractRepository
{
    private readonly IMongoCollection<ContractEntity> _collection;

    public ContractRepository(IMongoDatabase database)
    {
        _collection = database.GetCollection<ContractEntity>("contracts");
    }

    public async Task<ContractEntity?> GetByIdAsync(
        ID<ContractEntity> id,
        CancellationToken cancellationToken)
    {
        FilterDefinition<ContractEntity> filter =
            Builders<ContractEntity>.Filter.Eq(x => x.Id, id);

        return await _collection
            .Find(filter)
            .FirstOrDefaultAsync(cancellationToken);
    }
}
```

## DI Registration

```csharp
public static IServiceCollection AddContractDataAccess(
    this IServiceCollection services, IConfiguration configuration)
{
    services.AddMongoDataAccess(configuration);
    services.AddScoped<IContractRepository, ContractRepository>();
    return services;
}
```

## Health Checks

Always register MongoDB health checks:

```csharp
services.AddHealthChecks()
    .AddMongoHealthCheck();
```
