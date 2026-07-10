<!-- Source: consolidated from backend-service-scaffolder · Last updated: 2026-07-10 -->

# Service Scaffolding

Scaffold a complete .NET domain microservice following the established project structure. Read `general.instructions.md` for architecture rules and layer definitions first.

## Table of Contents

- [Workflow](#workflow)
- [Project Structure](#project-structure)
- [Project References](#project-references)
- [Layer Templates](#layer-templates)
- [Validation & Checklist](#validation--checklist)

## Workflow

Confirm the service name and scope with the user before starting.

### Step 1: Gather Requirements
1. **Service name** — PascalCase domain name (e.g., `Consultation`, `ContractInternal`).
2. **Layers needed** — default all (Abstractions, Core, DataAccess, GraphQL, Host, Worker). Some skip Worker.
3. **Database** — MongoDB (default), SQL Server, or both.
4. **Messaging** — MassTransit consumers needed? (yes/no).
5. **GraphQL only or REST+GraphQL** — default GraphQL only.

## Project Structure

```
src/{ServiceName}/
├── src/
│   ├── Abstractions/   {ServiceName}.Abstractions.csproj
│   ├── Core/           {ServiceName}.Core.csproj
│   ├── DataAccess/     {ServiceName}.DataAccess.csproj
│   ├── GraphQL/        {ServiceName}.GraphQL.csproj
│   ├── Host/           {ServiceName}.Host.csproj
│   └── Worker/         {ServiceName}.Worker.csproj      ← optional
└── test/
    ├── Core.Tests/       {ServiceName}.Core.Tests.csproj
    ├── DataAccess.Tests/ {ServiceName}.DataAccess.Tests.csproj
    ├── GraphQL.Tests/    {ServiceName}.GraphQL.Tests.csproj
    └── Worker.Tests/     {ServiceName}.Worker.Tests.csproj   ← if Worker exists
```

## Project References

| Project | References |
|---|---|
| **Abstractions** | None (leaf) |
| **Core** | → Abstractions |
| **DataAccess** | → Abstractions, Core |
| **GraphQL** | → Abstractions, Core |
| **Host** | → Abstractions, Core, DataAccess, GraphQL |
| **Worker** | → Abstractions, Core |
| **Core.Tests** | → Core, Abstractions |
| **DataAccess.Tests** | → DataAccess, Core, Abstractions |
| **GraphQL.Tests** | → GraphQL, Core, Abstractions |

## Layer Templates

### Abstractions

```csharp
// Models/{ServiceName}Entity.cs
namespace YourCompany.YourProduct.{ServiceName};

public record {ServiceName}Entity(
    ID<{ServiceName}Entity> Id,
    string Name);
```

```csharp
// Interfaces/I{ServiceName}Repository.cs
namespace YourCompany.YourProduct.{ServiceName};

public interface I{ServiceName}Repository
{
    Task<{ServiceName}Entity?> GetByIdAsync(
        ID<{ServiceName}Entity> id,
        CancellationToken cancellationToken);
}
```

### Core

```csharp
// Services/{ServiceName}Service.cs
public sealed class {ServiceName}Service(
    I{ServiceName}Repository _repository)
{
    public async Task<{ServiceName}Entity?> GetByIdAsync(
        ID<{ServiceName}Entity> id,
        CancellationToken cancellationToken)
        => await _repository.GetByIdAsync(id, cancellationToken);
}
```

```csharp
// DependencyInjection/{ServiceName}CoreServiceCollectionExtensions.cs
namespace Microsoft.Extensions.DependencyInjection;

public static class {ServiceName}CoreServiceCollectionExtensions
{
    public static IServiceCollection Add{ServiceName}Core(
        this IServiceCollection services)
    {
        services.AddScoped<{ServiceName}Service>();
        return services;
    }
}
```

### DataAccess (MongoDB)

See `mongodb.md` for the repository and DI-registration templates (`Add{ServiceName}DataAccess`).

### GraphQL

```csharp
// Queries/{ServiceName}Queries.cs
[QueryType]
public static class {ServiceName}Queries
{
    public static async Task<{ServiceName}Entity?> Get{ServiceName}ByIdAsync(
        ID<{ServiceName}Entity> id,
        [Service] {ServiceName}Service service,
        CancellationToken cancellationToken)
        => await service.GetByIdAsync(id, cancellationToken);
}
```

Prefer the implementation-first `[ObjectType<T>]` approach for types (see `hotchocolate.md`).

### Host

Create `Startup.cs` plus the Confix files (`.confix.project`, `appsettings.json` with `$secret:/$shared:/$local:` refs, `variables.{A,UAT,PAV}.json`, `confix/components/`). See `startup-observability.md`. Read an existing Host for reference.

```csharp
public void ConfigureServices(IServiceCollection services)
{
    services.AddJwtBearerAuthentication(Configuration);
    services.Add{ServiceName}Core();
    services.Add{ServiceName}DataAccess(Configuration);
    services.AddGraphQLServer().AddTypes();
    services.AddHealthChecks().AddMongoHealthCheck();
}

public void Configure(IApplicationBuilder app)
{
    app.UseRouting();
    app.UseAuthentication();
    app.UseAuthorization();
    app.UseEndpoints(endpoints =>
    {
        endpoints.MapGraphQL();
        endpoints.MapHealthChecks("/_health/live");
        endpoints.MapHealthChecks("/_health/ready");
    });
}
```

### Test Projects

Mirror production layers. Follow `tests.instructions.md`; use `MockBehavior.Strict`.

```csharp
public class {ServiceName}ServiceTests
{
    private readonly Mock<I{ServiceName}Repository> _repository = new(MockBehavior.Strict);
    private readonly {ServiceName}Service _sut;

    public {ServiceName}ServiceTests()
        => _sut = new {ServiceName}Service(_repository.Object);

    [Fact]
    public async Task GetByIdAsync_EntityExists_ReturnsEntity()
    {
        ID<{ServiceName}Entity> id = ID<{ServiceName}Entity>.New();
        {ServiceName}Entity expected = new(id, "Test");
        _repository
            .Setup(r => r.GetByIdAsync(id, It.IsAny<CancellationToken>()))
            .ReturnsAsync(expected);

        {ServiceName}Entity? result = await _sut.GetByIdAsync(id, CancellationToken.None);

        Assert.Equal(expected, result);
    }
}
```

## Validation & Checklist

1. `dotnet build` on the new service.
2. `dotnet test` on the test projects.
3. Verify layer dependencies (no circular references).
4. Verify no HotChocolate packages in Core/Abstractions.

- [ ] All projects compile
- [ ] Layer dependency rules respected
- [ ] `ID<T>` used for entity IDs
- [ ] Health checks registered (`/_health/live`, `/_health/ready`)
- [ ] MongoDB health check added
- [ ] DI extensions follow `Add{ServiceName}{Layer}()` naming
- [ ] Test projects mirror production layers
- [ ] Mocks use `MockBehavior.Strict`
- [ ] Confix files created (`.confix.project`, `variables.*.json`, `confix/components/`)
- [ ] `appsettings.json` uses `$secret:`, `$shared:`, `$local:` — no hardcoded secrets
- [ ] No HotChocolate references outside GraphQL layer
