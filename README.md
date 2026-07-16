# minion-orchestrator

Cursor skill: a **dispatch-only frontier** orchestrates background **workers** through an async **inbox**. Workers are `generalPurpose` Task spawns with pinned models.

Inspired by the [async agent fleet pattern](https://x.com/thdxr/status/2072464584171004005).

## Install

```bash
./install.sh
```

Symlinks `skills/orchestrator/` into `~/.cursor/skills/orchestrator`. Re-run after `git pull`.

## Usage

**Opt in:** `/orchestrate`, `orchestrator on`, grill→build, planning→issues.

**Opt out:** `/direct`, `skip minions`, `skip workers`.

## Model stack

| Role | Model |
|------|-------|
| Frontier | `gpt-5.6-sol-max` |
| Mechanical / explore / commit / shell | `composer-2.5` |
| Hard implement / PRD / issues | `gpt-5.6-terra-high` |
| UI | `cursor-grok-4.5-high` |
| Review | `claude-opus-4-8-thinking-high` |

Details: `skills/orchestrator/models.md`. Benchmarks: `models-scorecard.md`.

## Skill layout

| File | Purpose |
|------|---------|
| `SKILL.md` | Steps + branch detection |
| `frontier.md` | Sol dispatch rules, planning |
| `loop.md` | Implement cycle, repo discovery |
| `prompts.md` | Worker spawn templates |
| `models.md` | Routing + escalation |
| `state.md` | Board format |
| `shell.md` | CLI delegation |
| `worktrees.md` | Parallel worktrees |

## Flow

```
decompose → spawn (background) → implement → review → fix → … → commit
```

Planning: grill → PRD/issues workers → publish → `/orchestrate`.

## License

MIT
