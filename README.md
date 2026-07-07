# minion-orchestrator

Cursor skill: a **frontier** model orchestrates background **workers** through an async **inbox**. No custom agent files — workers are `generalPurpose` Task spawns with pinned models.

Inspired by the [async agent fleet pattern](https://x.com/thdxr/status/2072464584171004005).

## Install

```bash
./install.sh
```

Symlinks `skills/orchestrator/` into `~/.cursor/skills/orchestrator`. Re-run after `git pull`.

Manual:

```bash
ln -sfn "$(pwd)/skills/orchestrator" ~/.cursor/skills/orchestrator
```

Task state is posted as a **board** table in chat — updated after every spawn and triage.

## Usage

**Opt in:** `/orchestrate`, `orchestrator on`, or ask to orchestrate workers.

**Opt out:** `/direct`, `no orchestrator`, `skip minions`, `skip workers`.

## Model stack

| Role | Model |
|------|-------|
| Frontier (orchestrator) | `claude-fable-5` |
| Mechanical implement | `composer-2.5` |
| User-facing UI | `glm-5.2-high` |
| User-facing API / copy | `claude-sonnet-5-thinking-high` |
| Review | `claude-opus-4-8-thinking-high` |
| Commit / issues | `glm-5.2-high` |
| Verify / explore | `composer-2.5` (use `composer-2.5-fast` if latency matters) |

Details: `skills/orchestrator/models.md`.

## Flow

```
decompose → spawn workers (background, `generalPurpose`)
  → verify (`shell`) → review (fresh Opus worker)
  → fix-review → … → gate → commit
```

Loop details: `skills/orchestrator/loop.md`. Worktrees: `skills/orchestrator/worktrees.md`.

## License

MIT
