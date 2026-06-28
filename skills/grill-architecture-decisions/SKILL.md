---
name: grill-architecture-decisions
description: Grilling session for architecture decisions that challenges a plan against code, constraints, terminology, and existing docs, then records resolved language and ADRs inline. Use when the user wants to stress-test architecture, system design, boundaries, data ownership, integrations, infrastructure, security, operability, or technology choices.
disable-model-invocation: true
---

# Grill Architecture Decisions

<what-to-do>

Interview me relentlessly about every aspect of this architecture decision until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time, waiting for feedback on each question before continuing.

If a question can be answered by exploring the codebase, explore the codebase instead.

</what-to-do>

<supporting-info>

## Decision scope

Use this skill for architecture decisions of any kind:

- System boundaries, service boundaries, bounded contexts, ownership, and module structure
- Data modeling, data ownership, storage choices, consistency, migrations, and retention
- Integration style, API shape, eventing, messaging, contracts, and failure handling
- Security, privacy, identity, authorization, auditability, compliance, and threat boundaries
- Runtime architecture, deployment topology, infrastructure, scaling, reliability, and disaster recovery
- Observability, SLOs, alerting, operations, supportability, and incident response
- Build-vs-buy choices, platform choices, framework choices, and vendor lock-in
- Team ownership, delivery constraints, rollout strategy, backward compatibility, and cost

## Domain awareness

During codebase exploration, also look for existing documentation:

### File structure

Most repos have a single context:

```text
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

If a `CONTEXT-MAP.md` exists at the root, the repo has multiple contexts. The map points to where each one lives:

```text
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          <- system-wide decisions
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                 <- context-specific decisions
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

Create files lazily - only when you have something to write. If no `CONTEXT.md` exists, create one when the first term is resolved. If no `docs/adr/` exists, create it when the first ADR is needed.

## During the session

### Frame the architecture decision

Before drilling into options, pin down the decision boundary:

- What exactly is being decided, and what is explicitly out of scope?
- Who or what owns the decision once made?
- What constraints are hard constraints versus preferences?
- What would make the decision obviously wrong later?
- How reversible is it, and what would reversal cost?

### Walk the dependency tree

Architecture choices usually depend on other choices. Resolve prerequisites first. If the user asks "Should we use events?", check whether the service boundary, consistency model, failure model, and ownership model are clear enough to answer.

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `CONTEXT.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y - which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' - do you mean the Customer, Organization, Tenant, or User? Those are different things."

### Discuss concrete scenarios

Stress-test the architecture with specific scenarios. Invent scenarios that probe edge cases, failure modes, ownership boundaries, scaling limits, rollout paths, and operational burden.

### Compare real alternatives

Do not let the session collapse into validating the first idea. For each meaningful decision, keep at least two plausible alternatives alive until the trade-off is clear. Include the "do nothing" or "simpler default" option when it is credible.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code treats Billing as the source of Customer credit state, but you just said Customer owns it - which is right?"

### Update CONTEXT.md inline

When a term, boundary, or ownership concept is resolved, update `CONTEXT.md` right there. Don't batch these up - capture them as they happen. Use the format in [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

`CONTEXT.md` should be totally devoid of implementation details. Do not treat `CONTEXT.md` as a spec, a scratch pad, or a repository for implementation decisions. It is a glossary and boundary language document.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse** - the cost of changing your mind later is meaningful
2. **Surprising without context** - a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** - there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md).

</supporting-info>
