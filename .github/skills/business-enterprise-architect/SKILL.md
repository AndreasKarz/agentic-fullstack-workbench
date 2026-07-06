---
name: business-enterprise-architect
description: "Generic Enterprise Architecture reviews and decisions: architecture layers (Business/Application/Data/Technology), capability mapping, ADRs, trade-off analysis, quality attributes, and standards-compliance checks against provided standards. Use for: architecture review, EA review, architecture decision record, ADR, capability map, solution architecture, non-functional requirements trade-off, Well-Architected, reference architecture, C4 model."
---

# Enterprise Architect (generic)

Review and shape solution/enterprise architecture in a **framework-neutral** way. Load for architecture reviews, decision records, capability mapping, or standards-compliance checks. Governance frameworks and standard sources are **provided per engagement** — none are hardcoded here.

## Architecture Layers

Assess across the four layers and their interactions:

| Layer | Concerns |
|-------|----------|
| **Business** | Capabilities, value streams, processes, stakeholders, outcomes |
| **Application** | Services, APIs, integration, ownership boundaries |
| **Data** | Domains, ownership, lineage, classification (PII), quality, governance |
| **Technology** | Hosting, runtime, networking, security, operations, cost |

## Review Method

1. **Scope & context** — goals, constraints, drivers, quality attributes (NFRs) with thresholds.
2. **Capability mapping** — map the solution to business capabilities; find gaps/overlaps.
3. **Standards compliance** — check against the **standards the user provides** (internal EA standards, reference architectures, cloud Well-Architected). Load them from an attachment, a URL, or a linked workspace folder — do **not** assume a specific governance source.
4. **Trade-off analysis** — evaluate options against quality attributes; document as **ADRs** (context → decision → consequences). Mark unverifiable claims as `ANNAHME:`.
5. **Report** — concise compliance report: findings, risks, recommendations, decisions.

## Decision Records (ADR)

Use a lightweight ADR format: `status · date · deciders · context · options · decision · consequences`. Keep IDs sequential (`0001-…`).

## Diagrams

Delegate diagramming to the `drawio` skill (or Mermaid) — C4 (Context/Container/Component), sequence, deployment, ER.

## Accessing Governance / SharePoint Sources

This skill does **not** hardcode SharePoint or governance repositories. To use such sources as context, **sync the SharePoint folder to OneDrive and add it to the VS Code workspace** (see the repo README), then reference the local files. Alternatively pass documents as attachments.

## Quality Attributes (checklist)

Performance · Scalability · Availability/Reliability · Security · Maintainability · Observability · Cost · Compliance/Data-Protection.

## Know-how

- Azure Well-Architected Framework: https://learn.microsoft.com/azure/well-architected/
- C4 model: https://c4model.com/
- ADR: https://adr.github.io/
