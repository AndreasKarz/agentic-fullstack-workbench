<!-- Source: consolidated from backend-developer · Know-how: https://masstransit.io · Last updated: 2026-07-10 -->

# MassTransit Messaging

Consumer and publisher patterns for MassTransit + Azure Service Bus.

## Table of Contents

- [Standard Consumer](#standard-consumer)
- [Abstract Base Consumer](#abstract-base-consumer)
- [Consumer Organization](#consumer-organization)
- [Request-Response](#request-response)
- [Anti-Patterns](#anti-patterns)
- [Testing](#testing)

## Standard Consumer

Mark consumers `sealed`. Use primary constructors for DI. Every consumer **must** include OpenTelemetry tracing and source-generated logging.

```csharp
using Activity? activity = App.ActivitySource.StartActivity();
```

## Abstract Base Consumer

For shared consumer logic across message types, use a generic abstract base.

## Consumer Organization

Organize consumers in `Core/Messaging/Consumers/` by category:

- `E2E/CustomerUpdates/` — End-to-end customer update events
- `Fuse/` — Fuse-specific events (invites, codes)
- `FusionIdentity/` — Identity events
- `Integration/` — External integration events

## Request-Response

For consumers that respond:

```csharp
await context.RespondAsync(new AdminResponse { /* ... */ });
```

## Anti-Patterns

- Never catch and swallow exceptions in consumers — let MassTransit handle retries.
- Never use `ILogger` directly — use source-generated `App.Log` methods.
- Never skip `App.ActivitySource.StartActivity()` — it breaks distributed tracing.
- Never add business logic outside `Core/` — consumers orchestrate, not implement.
- Prefer an `enum` over `string` for values that only accept specific tokens — unknown string values cause deadletters.

## Testing

- Test consumers with MassTransit `InMemoryTestHarness` for integration-style coverage.
- Test publishers with `InMemoryTestHarness` + `Snapshooter` for complex message assertions.
- Use `FakeTimeProvider` for time-dependent logic instead of `DateTime.Now` / `DateTimeOffset.UtcNow`.
