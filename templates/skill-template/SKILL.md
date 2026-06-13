---
name: skill-template
description: Template for creating new agent skills. Use only when scaffolding a new skill in the agent-skills repo.
disable-model-invocation: true
---

# Skill Template

Copy this folder to `skills/<skill-name>/` and replace all placeholders.

## When to use

Activate when the user mentions: `<trigger-term-1>`, `<trigger-term-2>`.

## Workflow

1. Confirm scope and success criteria
2. Gather required inputs
3. Execute the workflow
4. Validate output
5. Summarize what changed or what to do next

## Output format

```markdown
# <Title>

## Summary
<one paragraph>

## Results
- ...

## Next steps
- ...
```

## Additional resources

- Details: [reference.md](reference.md) (create if needed)
- Examples: [examples.md](examples.md) (create if needed)
