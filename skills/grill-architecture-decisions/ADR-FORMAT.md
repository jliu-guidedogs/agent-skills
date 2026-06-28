# ADR Format

ADRs live in `docs/adr/` and use sequential numbering: `0001-slug.md`, `0002-slug.md`, etc.

Create the `docs/adr/` directory lazily - only when the first ADR is needed.

## Template

```md
# {Short title of the decision}

{1-3 sentences: what's the context, what did we decide, and why.}
```

That's it. An ADR can be a single paragraph. The value is in recording *that* a decision was made and *why* - not in filling out sections.

## Optional sections

Only include these when they add genuine value. Most ADRs won't need them.

- **Status** frontmatter (`proposed | accepted | deprecated | superseded by ADR-NNNN`) - useful when decisions are revisited
- **Considered Options** - only when the rejected alternatives are worth remembering
- **Consequences** - only when non-obvious downstream effects need to be called out
- **Decision Drivers** - only when constraints are not obvious from the code or ticket

## Numbering

Scan `docs/adr/` for the highest existing number and increment by one.

## When to offer an ADR

All three of these must be true:

1. **Hard to reverse** - the cost of changing your mind later is meaningful
2. **Surprising without context** - a future reader will look at the code and wonder "why on earth did they do it this way?"
3. **The result of a real trade-off** - there were genuine alternatives and you picked one for specific reasons

If a decision is easy to reverse, skip it - you'll just reverse it. If it's not surprising, nobody will wonder why. If there was no real alternative, there's nothing to record beyond "we did the obvious thing."

## What qualifies

- **Architectural shape.** "We're using a modular monolith." "The write model is event-sourced, the read model is projected into Postgres."
- **Boundaries and ownership.** "Customer data is owned by the Customer context; other contexts reference it by ID only." The explicit no-s are as valuable as the yes-s.
- **Integration patterns between contexts.** "Ordering and Billing communicate via domain events, not synchronous HTTP."
- **Data and consistency choices.** Storage engine, source of truth, eventual consistency, replication, tenancy, retention, and migration strategy.
- **Security and trust boundaries.** Auth provider, token model, secrets boundary, audit model, tenant isolation, encryption approach, or compliance-driven constraints.
- **Runtime and deployment topology.** Monolith vs services, regions, queues, workers, serverless, edge, networking, disaster recovery, and rollback strategy.
- **Operability decisions.** SLOs, observability approach, alerting ownership, incident response model, and support boundaries.
- **Technology choices that carry lock-in.** Database, message bus, auth provider, cloud platform, deployment target, framework, or vendor choice. Not every library - just the ones that would be expensive to swap out.
- **Deliberate deviations from the obvious path.** "We're using manual SQL instead of an ORM because X." Anything where a reasonable reader would assume the opposite.
- **Constraints not visible in the code.** "We can't use AWS because of compliance requirements." "Response times must be under 200ms because of the partner API contract."
- **Rejected alternatives when the rejection is non-obvious.** If you considered GraphQL and picked REST for subtle reasons, record it - otherwise someone will suggest GraphQL again in six months.

## What usually does not qualify

- Local implementation details that can be changed safely in one pull request
- Routine dependency updates
- Style conventions already enforced by tooling
- Choices with no meaningful alternative
- Temporary experiments that have not been accepted
