# Skill authoring conventions

## One skill, one job

Each folder under `skills/` solves a single workflow. Split broad domains (e.g. "all of Salesforce") into focused skills.

## SKILL.md requirements

```yaml
---
name: skill-name          # lowercase, hyphens, max 64 chars
description: ...          # third person; WHAT + WHEN + trigger terms
disable-model-invocation: true
---
```

- **Description** is the discovery API. Include words users actually say.
- Default `disable-model-invocation: true` unless the skill should load automatically from context.

## File layout

| File | Use for |
|------|---------|
| `SKILL.md` | Workflow, checklist, output contract, links |
| `reference.md` | Long tables, API details, version-specific notes |
| `examples.md` | Input/output examples |
| `scripts/` | Deterministic commands (validators, generators) |

Keep `SKILL.md` under 500 lines. Link supporting files one level deep only.

Validate all skill frontmatter without external packages:

```bash
python3 scripts/validate-skills.py
```

The repository validator accepts the cross-agent invocation fields used here, including
`disable-model-invocation`, `user-invocable`, `argument-hint`, and `trigger`.

## Degrees of freedom

- **High** - prose guidelines (code review, planning)
- **Medium** - templates and pseudocode (reports, handoffs)
- **Low** - scripts for fragile or repeatable steps (mapping validation)

## Do not

- Put secrets or org credentials in skills
- Mix unrelated domains in one skill
- Bury critical rules at the end of a long file
- Use Windows-style paths (`scripts\foo.py`)

## Naming

Prefer domain prefixes for related skills:

- `workflow-*` - general agent workflows
- `sf-*` - Salesforce platform (future)
- `migration-*` - data migration reviews (future)

## Thinking stack

The core install (`./scripts/install-personal.sh` or `scripts\install-personal.bat`) ships eight skills orchestrated by `thought-companion`. Optional skills (e.g. `graphify`) require `--with-optional` and may need extra tooling — document that in the README.
