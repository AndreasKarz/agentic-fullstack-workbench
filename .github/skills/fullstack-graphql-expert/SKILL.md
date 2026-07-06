---
name: fullstack-graphql-expert
description: "GraphQL schema design and Relay frontend specialist for HotChocolate v16 projects. Use when: GraphQL schema design, node types, queries, mutations, subscriptions, cursor-based pagination, Relay fragments, fragment composition, Relay colocation, Thinking in Relay, Relay compiler, useFragment, useLazyLoadQuery, Relay hooks, DataLoaders. For stitching, Fusion gateway, QueryDelegationRewriter, mutation conventions, or secure IDs — use hotchocolate-specialist instead."
---

# GraphQL Expert

Full-stack GraphQL skill for this project's **HotChocolate v16** backend and **Relay** frontend.

## When to Use

- Adding or modifying GraphQL types, queries, mutations, or subscriptions
- Creating Relay node types with global object identification
- Writing data loaders for batching
- Designing frontend components with Relay fragments
- Reviewing GraphQL schema design for Relay compliance
- Pagination (cursor-based connections)

## Documentation Sources

Before writing any code, **always** fetch the latest docs:

- **HotChocolate v16**: Use `fetch-global` MCP to fetch `https://chillicream.com/docs/hotchocolate`
- **Relay**: Use `fetch-global` MCP to fetch `https://relay.dev/docs`

## Backend — HotChocolate v16

Follow the patterns in [./references/hotchocolate.md](./references/hotchocolate.md).

### Key Principles

1. **Source-generated types** — Use `[ObjectType<T>]` partial static classes (annotation-based + source generators), not fluent `ObjectType<T>` overrides
2. **Relay Global Object Identification** — Every entity exposed to the frontend MUST implement `Node` via `[NodeResolver]` + `[ID<T>]`
3. **Operations as static classes** — Queries/Mutations are static methods annotated with `[Query]` / `[Mutation]`
4. **DataLoaders** — Use `BatchDataLoader<TKey, TValue>` from GreenDonut for N+1 prevention
5. **Mutation conventions** — Enabled via `.AddMutationConventions()`; follow input/payload pattern automatically
6. **Schema export** — Schema auto-exports to `src/frontend/schema.graphql` on startup (non-prod)

### Type Registration Pattern

All types are auto-discovered via source generators. The module is registered in `Program.cs`:

```csharp
builder.AddAdoMateGraphQL(); // in GraphQLServiceCollectionExtensions
```

The builder configures:
- `.AddGlobalObjectIdentification()` — Relay `node` / `nodes` queries
- `.AddDefaultNodeIdSerializer(useUrlSafeBase64: true)` — URL-safe opaque IDs
- `.AddMutationConventions()` — Auto input/payload wrapping
- `.AddType(new UuidType('D'))` — UUID scalar format

### Adding a New Entity Type

```csharp
// 1. Domain entity must extend Entity<Guid>
public class MyEntity : Entity<Guid>
{
    public string Name { get; set; }
}

// 2. Object type with node resolver
[ObjectType<MyEntity>]
public static partial class MyEntityType
{
    [NodeResolver]
    public static async Task<MyEntity?> GetByIdAsync(
        Guid id,
        IMyEntityService service,
        CancellationToken cancellationToken)
        => await service.GetByIdAsync(id, cancellationToken);

    // Custom resolved fields
    public static string GetDisplayName([Parent] MyEntity entity)
        => entity.Name.ToUpperInvariant();
}

// 3. Query operations
public static class MyEntityOperations
{
    [Query]
    public static async Task<IReadOnlyList<MyEntity>> GetMyEntitiesAsync(
        IMyEntityService service,
        CancellationToken cancellationToken)
        => await service.GetAllAsync(cancellationToken);

    [Query]
    public static async Task<MyEntity> GetMyEntityByIdAsync(
        [ID<MyEntity>] Guid id,
        IMyEntityService service,
        CancellationToken cancellationToken)
        => await service.GetByIdAsync(id, cancellationToken);
}
```

### Adding a DataLoader

```csharp
public sealed class MyEntityByIdDataLoader(
    IBatchScheduler batchScheduler,
    IAdoMateDbContext db,
    DataLoaderOptions? options = null)
    : BatchDataLoader<Guid, MyEntity>(batchScheduler, options ?? new DataLoaderOptions())
{
    protected override async Task<IReadOnlyDictionary<Guid, MyEntity>> LoadBatchAsync(
        IReadOnlyList<Guid> keys,
        CancellationToken cancellationToken)
    {
        var entities = await db.MyEntities.GetManyAsync(keys, cancellationToken);
        return entities.ToDictionary(e => e.Id);
    }
}
```

## Frontend — Relay

Follow the patterns in [./references/relay.md](./references/relay.md).

### Thinking in Relay — Core Principles

These principles from the Relay architecture guide ALL frontend GraphQL decisions:

1. **Data requirements are colocated with components** — Each component declares exactly which data it needs via a **fragment**. Never pass GraphQL data as props between unrelated components.

2. **Fragments are the unit of composition** — Just as React composes UI from components, Relay composes data requirements from fragments. A parent component spreads child fragments, never fetching data on behalf of children.

3. **Queries are entry points, not data owners** — Only route-level or page-level components define `useLazyLoadQuery`. All other components consume data through fragments spread by their parents.

4. **The component is the source of truth for its data** — If a component needs a field, it adds it to its own fragment. If it no longer needs it, it removes it. No coordination with parent components needed.

5. **Global object identification via Node** — All entities use Relay's `node` interface. The backend provides opaque IDs; the frontend never constructs or parses them.

### Fragment-Per-Component Pattern (MANDATORY)

Every component that displays data MUST declare its own fragment:

```typescript
// PromptCard.tsx
import { graphql, useFragment } from 'react-relay';
import type { PromptCard_prompt$key } from './__generated__/PromptCard_prompt.graphql';

// Fragment is named: <ComponentName>_<propName>
const PromptCardFragment = graphql`
  fragment PromptCard_prompt on PromptDefinition {
    id
    name
    path
    versionInfo {
      version
      status
    }
  }
`;

interface PromptCardProps {
  prompt: PromptCard_prompt$key; // Always type with the $key type
}

export function PromptCard({ prompt }: PromptCardProps) {
  const data = useFragment(PromptCardFragment, prompt);

  return (
    <div>
      <h3>{data.name}</h3>
      <p>{data.path}</p>
      <span>v{data.versionInfo?.version}</span>
    </div>
  );
}
```

### Fragment Composition — Parent Spreads Child Fragments

```typescript
// PromptList.tsx
import { graphql, useFragment } from 'react-relay';
import { PromptCard } from './PromptCard';
import type { PromptList_prompts$key } from './__generated__/PromptList_prompts.graphql';

const PromptListFragment = graphql`
  fragment PromptList_prompts on Query {
    prompts {
      id
      ...PromptCard_prompt  # Spread the child's fragment
    }
  }
`;

interface PromptListProps {
  query: PromptList_prompts$key;
}

export function PromptList({ query }: PromptListProps) {
  const data = useFragment(PromptListFragment, query);

  return (
    <div>
      {data.prompts.map((prompt) => (
        <PromptCard key={prompt.id} prompt={prompt} />
      ))}
    </div>
  );
}
```

### Page-Level Query (Entry Point)

```typescript
// PromptsPage.tsx
import { graphql, useLazyLoadQuery } from 'react-relay';
import { PromptList } from './PromptList';
import type { PromptsPageQuery } from './__generated__/PromptsPageQuery.graphql';

const promptsPageQuery = graphql`
  query PromptsPageQuery {
    ...PromptList_prompts  # Spread fragment, don't fetch fields
  }
`;

export function PromptsPage() {
  const data = useLazyLoadQuery<PromptsPageQuery>(promptsPageQuery, {});

  return <PromptList query={data} />;
}
```

### Relay Project Config

```json
{
  "src": "./src",
  "schema": "./schema.graphql",
  "language": "typescript",
  "artifactDirectory": "./src/__generated__",
  "eagerEsModules": true
}
```

Generated types go to `src/__generated__/`. Run the Relay compiler after schema or query changes:

```bash
yarn relay
```

### Fragment Naming Convention

**`<ComponentName>_<propName>`** — This is enforced by the Relay compiler:
- `PromptCard_prompt` — for a `prompt` prop on `PromptCard`
- `PromptList_prompts` — for a `prompts` prop on `PromptList`
- `PromptDetail_prompt` — for a `prompt` prop on `PromptDetail`

### Rules — Do NOT Violate

| Rule | Why |
|------|-----|
| Never use `useLazyLoadQuery` in non-page components | Breaks data colocation; creates waterfalls |
| Never pass raw GraphQL response objects as props | Use fragment refs (`$key` types) instead |
| Never duplicate fields across sibling fragments | Each component owns its fields; Relay deduplicates at query time |
| Always use `useFragment` in components that display data | Enables granular re-renders and data masking |
| Always type fragment refs with the generated `$key` type | Ensures type safety and compiler validation |
| Name fragments `ComponentName_propName` | Required by Relay compiler convention |

## Schema & Development Hints

### Schema File

`src/frontend/schema.graphql` is **auto-generated** by the backend API on startup (non-production only). Never edit it manually.

To regenerate the schema after backend GraphQL changes:
1. Restart the `adomate-api` resource via Aspire (`mcp_aspire_execute_resource_command`)
2. The schema file is automatically updated on startup
3. Run `yarn relay` in `src/frontend/` to regenerate Relay types

### Direct GraphQL Calls (e.g., via curl or HTTP tools)

A **bearer token** is required for all GraphQL requests. To obtain one:

1. Get a token from the token-provider service: `GET /token` (use the token-provider resource URL from Aspire)
2. POST to the API's `/graphql` endpoint (use the adomate-api resource URL from Aspire, typically `http://localhost:5002/graphql`)

Example:
```bash
# 1. Get a bearer token
TOKEN=$(curl -s http://localhost:5017/token | jq -r '.token')

# 2. Execute a GraphQL query
curl -X POST http://localhost:5002/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"query": "{ me { displayName email } }"}'
```

> **Note:** The frontend dev server proxy handles token injection automatically — this is only needed for direct HTTP calls.

## Workflow

### Adding a New GraphQL Feature (Full Stack)

1. **Domain model** — Create/update entity in `AdoMate.Domain` extending `Entity<Guid>`
2. **Repository** — Add repository interface + MongoDB implementation in `AdoMate.Infrastructure`
3. **Service** — Add service interface in `AdoMate.Application`, implementation
4. **Object type** — Create `[ObjectType<T>]` partial class with `[NodeResolver]` in `AdoMate.Api/GraphQL/`
5. **Operations** — Add `[Query]` / `[Mutation]` static methods in operations class
6. **DataLoader** — Add `BatchDataLoader` if entity is referenced by other types
7. **Build backend** — `dotnet build` to generate schema export
8. **Run Relay compiler** — `yarn relay` in frontend to generate types
9. **Page query** — Add `useLazyLoadQuery` at the page/route level
10. **Component fragments** — Create components with colocated fragments using `useFragment`
11. **Compose** — Parent components spread child fragments; never fetch on behalf of children

<!-- Last updated: 2026-07-02 · Part of the Copilot Context Blueprint -->