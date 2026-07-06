---
name: business-business-analyst
description: "Use when evaluating business value, prioritizing initiatives, defining OKRs, analyzing stakeholders, creating business cases, or comparing competitors. Triggers on: OKR, Flight Levels, stakeholder analysis, business case, ROI, NPV, KPI, strategy, portfolio, value stream."
---

# Business Analysis Domain Knowledge

This skill delivers the subject matter and methodology knowledge for the Business Analyst agent. The agent orchestrates — this skill delivers the content depth.

## OKR Framework (Objectives & Key Results)

### Structure

```
Company OKR (Quarter/Year)
├── Objective 1 (qualitative, inspiring)
│   ├── Key Result 1.1 (quantitative, measurable)
│   ├── Key Result 1.2
│   └── Key Result 1.3
└── Objective 2
    ├── Key Result 2.1
    └── Key Result 2.2
```

### Formulation Rules

| Element | Rule | Good Example | Bad Example |
|---------|------|-------------|------------|
| **Objective** | Qualitative, motivating, time-bound | "Our customers experience the best digital financial service in the country" | "Increase revenue by 10%" |
| **Key Result** | Measurable, with number and deadline | "NPS of customer portal rises from 45 to 60 by Q2" | "Improve customer satisfaction" |
| **Key Result** | Outcome, not output | "Avg. self-service mutation completion time drops from 12 to 5 minutes" | "Implement 20 new features" |

### OKR Cycle

| Phase | Duration | Activity |
|-------|----------|---------|
| **Planning** | 2 weeks before quarter | Define objectives and key results, check alignment |
| **Check-in** | Weekly | Update confidence level (0-100%) |
| **Review** | End of quarter | Evaluate goal achievement (0.0–1.0), document learnings |
| **Retrospective** | After review | Improve process, prepare next cycle |

### Scoring

| Score | Rating | Meaning |
|-------|--------|---------|
| 0.0–0.3 | Red | Significantly missed |
| 0.4–0.6 | Yellow | Progress, but goal not reached |
| 0.7–1.0 | Green | Sweet spot (0.7 = ambitious and achieved) |

> **Rule of thumb:** If all OKRs score 1.0, they were not ambitious enough. Target is 0.7.

## Flight Levels (Klaus Leopold)

### The Three Levels

```
┌─────────────────────────────────────────────┐
│  FL 3 — STRATEGY                            │
│  "Are we doing the right things?"           │
│  Portfolio Kanban · OKRs · Investment mix   │
├─────────────────────────────────────────────┤
│  FL 2 — COORDINATION                        │
│  "Are teams working together correctly?"    │
│  Value stream Kanban · Dependencies · Flow  │
├─────────────────────────────────────────────┤
│  FL 1 — OPERATIONAL                         │
│  "Are teams delivering well?"               │
│  Team Kanban · Sprint · WIP limits          │
└─────────────────────────────────────────────┘
```

### Management Instruments per Level

| Level | Board Type | Metrics | Cadence |
|-------|-----------|---------|---------|
| **FL 3** | Portfolio board | Strategic fit, ROI, time-to-market | Monthly/quarterly |
| **FL 2** | Value stream board | Lead time, throughput, blockers | Bi-weekly |
| **FL 1** | Team board | Velocity, cycle time, WIP | Daily/weekly |

### Interaction Between Levels

| From → To | Mechanism | Example |
|-----------|----------|---------|
| FL 3 → FL 2 | Strategic initiative broken into value stream items | "Digital onboarding" → 5 value stream epics |
| FL 2 → FL 1 | Value stream items broken into team tasks | "Onboarding form" → PBIs for 3 teams |
| FL 1 → FL 2 | Blockers and dependencies escalated | "API from Team B not ready" → coordination |
| FL 2 → FL 3 | Strategic insights flow back | "Scope too large" → re-prioritization |

### Typical Dysfunctions

| Dysfunction | Symptom | Countermeasure |
|------------|---------|---------------|
| Only FL 1 | Teams deliver, but the wrong things | Introduce FL 2/3, establish alignment |
| FL 3 without FL 2 | Strategy is not coordinated | Introduce value stream board |
| No WIP limit | Everything at once, nothing finishes | Set WIP limits per flight level |
| No feedback loop | FL 3 decides in vacuum | Regular reviews FL 1→FL 2→FL 3 |

## Stakeholder Analysis

### Influence-Impact Matrix

```
         High Influence
              │
    Keep      │ Manage
    satisfied │ closely
              │
 Low ─────────┼───────── High
 Impact       │         Impact
              │
    Monitor   │ Keep
              │ informed
              │
         Low Influence
```

### Analysis Template

| Stakeholder | Role | Interest | Influence | Impact | Strategy | Communication |
|-------------|------|----------|-----------|--------|----------|--------------|
| [Name] | [Function] | [What is the interest?] | H/M/L | H/M/L | [Engage/Inform/...] | [Channel + cadence] |

### Communication Strategies

| Quadrant | Strategy | Measures |
|----------|---------|---------|
| **Manage closely** (H/H) | Active collaboration | Regular meetings, co-decision, early involvement |
| **Keep satisfied** (H/L) | Manage expectations | Status updates, clear escalation path, no surprises |
| **Keep informed** (L/H) | Create transparency | Newsletter, dashboard access, open office hours |
| **Monitor** (L/L) | Minimal | General project updates |

## Business Case Methodology

### Assessment Dimensions

| Dimension | KPI Examples | Measurement Method |
|-----------|-------------|-------------------|
| **Revenue growth** | New customers, cross-selling rate, ARPU | CRM data, contract management |
| **Customer retention** | Churn rate, NPS, retention rate | Customer portal analytics, surveys |
| **Efficiency** | Process time, FTE savings, automation rate | Process monitoring, time tracking |
| **Risk/compliance** | Audit findings, incident rate, regulatory breaches | Audit reports, regulatory filings |

### Financial Metrics

| Metric | Formula | Interpretation |
|--------|---------|---------------|
| **ROI** | (Benefit − Cost) / Cost × 100% | > 0% = profitable |
| **Payback** | Investment / annual net benefit | In months, < 24 months desirable |
| **NPV** | Σ (Cashflow_t / (1+r)^t) − Investment | > 0 = value-creating |
| **TCO (5Y)** | CapEx + (5 × OpEx p.a.) | Total cost of ownership over 5 years |

### Cost Structure

| Cost Type | Category | Typical Magnitude |
|-----------|---------|------------------|
| License costs | CapEx | One-time or annual (SaaS) |
| Implementation | CapEx | Project duration × day rates |
| Operations & support | OpEx | 15-25% of implementation costs p.a. |
| Training | CapEx | 1-3 days per user group |
| Change management | CapEx | 5-10% of implementation costs |

## Regulatory Framework

> **Example Profile (Switzerland):** This section uses Swiss regulatory context (FINMA/DSG) as an example.
> For other domains, replace with applicable local standards.

### Relevant Regulations

| Regulation | Authority | Relevance for Business Analysis |
|------------|----------|--------------------------------|
| **FINMA circulars** | FINMA | Governance, risk management, IT security, outsourcing |
| **Data protection law (2023)** | Data Protection Authority | Data privacy, consents, data processing, retention |
| **Insurance supervision** | FINMA | Insurance-specific requirements |
| **Financial services / intermediaries** | FINMA | Financial services, advisory obligations |

### Data Protection Checklist for Business Cases

- [ ] Data processing purpose defined and documented
- [ ] Legal basis for data processing identified
- [ ] Data protection impact assessment (DPIA) required? (profiling, sensitive data)
- [ ] Data retention and deletion regulated
- [ ] Information obligations towards data subjects fulfilled
- [ ] Data processors (third parties) contractually regulated
- [ ] Data export abroad reviewed (adequacy decision)

## Competitive Analysis

### Competitive Analysis Template

| Aspect | Us | Competitor A | Competitor B | Differentiation |
|--------|----|--------------|--------------|--------------------|
| [Feature] | [Status] | [Status] | [Status] | [Opportunity/Risk] |

### Digital Maturity Axes

| Axis | Description | Measurement Criteria |
|------|------------|---------------------|
| **Self-service** | What can the customer do themselves? | Mutations, claim reporting, documents |
| **Personalization** | How individual is the experience? | Recommendations, context, pre-fill |
| **Integration** | How seamless are the channels? | Omni-channel, SSO, data transfer |
| **Transparency** | How understandable is the information? | Language clarity, visualization |

## Decision Templates

### Option Comparison (Template)

| Criterion | Weight | Option A | Option B | Do Nothing |
|-----------|--------|----------|----------|------------|
| Strategic fit | 30% | [1-5] | [1-5] | [1-5] |
| Business value (NPV) | 25% | [1-5] | [1-5] | [1-5] |
| Implementation risk | 20% | [1-5] | [1-5] | [1-5] |
| Time-to-market | 15% | [1-5] | [1-5] | [1-5] |
| Regulatory compliance | 10% | [1-5] | [1-5] | [1-5] |
| **Weighted score** | 100% | **[Σ]** | **[Σ]** | **[Σ]** |

> **Rule:** Always present at least 2 options + "do nothing". "Do nothing" also has costs (opportunity costs, technical debt, competitive disadvantage).

### RACI Matrix (Template)

| Activity | Responsible | Accountable | Consulted | Informed |
|----------|------------|-------------|-----------|----------|
| Create business case | BA | PO | Stakeholders | PMO |
| Approve budget | – | Sponsor | Finance | PO, BA |
| Define requirements | RE | PO | BA, Dev | Test |
| Implement solution | Dev | Tech Lead | Architect | BA, PO |
| Conduct acceptance | Test | PO | BA | Stakeholders |

<!-- Last updated: 2026-07-02 · Part of the Copilot Context Blueprint -->