---
description: 'General coding standards and company tech-stack orientation. Always on.'
applyTo: '**'
---

# General Standards

## Coding

- Prefix private class members with underscore (`_field`).
- Prefer explicit type declarations over implicit typing (avoid `var` unless the type is obvious).
- Use descriptive, full names — avoid abbreviations.
- Make only changes that are directly requested or clearly necessary; avoid over-engineering (no unrequested features, refactors, comments, or error handling for impossible cases).
- Read files before modifying; understand existing code before changing it.

## Company Tech-Stack (Orientierung)

- **Backend:** .NET 8/10, C# 12, HotChocolate GraphQL (Fusion-Gateway), MassTransit + Azure Service Bus, MongoDB.Driver, EF Core (SQL Server), Quartz.NET, WorkflowCore, Redis, Polly, OpenTelemetry. Config via **Confix**, Build via **NUKE**.
- **Test (.NET):** xUnit + FluentAssertions + Moq (strict) + Squadron (Testcontainers) + Snapshooter (Snapshot).
- **Frontend:** React 18/19, TypeScript, your Component Design System, Relay GraphQL, Yarn 4, Biome, Vite, Playwright/Vitest; CopilotKit + Next.js.
- **Data / Analytics:** Azure Data Factory, SQL Server, MongoDB, **Databricks / DAP** (Medallion-Lakehouse Bronze/Silver/Gold), PowerBI.
- **Environments:** A / UAT / PAV.

> Repo-specific details (schemas, pipelines, naming conventions) live in the respective project's `.github/`, **not** here. This context is cross-project.
