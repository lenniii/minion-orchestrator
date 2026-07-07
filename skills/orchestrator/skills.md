# Skills

Orchestrator sets `Skill:` per task type.

## Fixed routing

| Task type | Skill | Notes |
|-----------|-------|-------|
| `implement` | `implement` | Stop before `/code-review` and commit |
| `review` | `code-review` | Fresh minion each round; may spawn subagents |
| `fix-review` | `tdd` | Apply reviewer changes test-first |
| `create-issue` | `to-issues` | Publish phase |
| `research` | `research` | Grill-phase reading legwork |
| `commit` | `implement` | Commit only after gate |

## Fallback — ask-matt

When `Skill:` omitted and type ambiguous: read `~/.agents/skills/ask-matt/SKILL.md`, load chosen skills.

## Paths

`~/.agents/skills/<name>/SKILL.md` → `.cursor/skills/` → `~/.cursor/skills/`

Missing → `NEEDS_CONTEXT`.

## Report

Implement / fix-review / commit:

```
Skills loaded:
- <name>
```

Review: STATUS after `code-review` aggregation.
