# minion-orchestrator

Cursor orchestrator + minion pattern: a frontier model coordinates work while cheap background minions (GLM) implement, publish, and fix. The orchestrator never reads files, edits code, or runs tests — it only spawns and decides.

Inspired by the [async agent fleet pattern](https://x.com/thdxr/status/2072464584171004005).

## What's in the repo

| Path | Installs to |
|------|-------------|
| `agents/minion.md` | `~/.cursor/agents/minion.md` |
| `skills/orchestrator/` | `~/.cursor/skills/orchestrator/` |

Per-project state lives at `.cursor/orchestrator-state.md` (created at runtime, not shipped).

## Install

From this repo:

```bash
./install.sh
```

This symlinks the agent and skill into your Cursor user config. Re-run after `git pull` — symlinks stay pointed at the repo.

### Manual install

```bash
ln -sf "$(pwd)/agents/minion.md" ~/.cursor/agents/minion.md
ln -sfn "$(pwd)/skills/orchestrator" ~/.cursor/skills/orchestrator
```

## Usage

**Opt in** (orchestrator mode):

- `/orchestrate`
- `orchestrator on`
- Ask to "orchestrate minions"

**Opt out** (normal agent):

- `/direct`
- `no orchestrator` / `skip minions`

## Model stack

| Role | Model |
|------|-------|
| Orchestrator (main agent) | Your frontier model — spawn only |
| Implement / fix / publish / docs | `glm-5.2-high` |
| Review | `claude-opus-4-8-thinking-high` |
| Verify (tests/lint) | `bash` subagent |
| Explore | `explore` + `composer-2.5-fast` |
| Escalation on `BLOCKED` | `composer-2.5` |

## Matt Pocock skills (recommended)

The minion routes to [Matt's skills](https://github.com/mattpocock) for implement, review, and issue publishing:

| Task | Skill |
|------|-------|
| Implement | `implement` |
| Review | `code-review` |
| Fix review | `tdd` |
| Publish issues | `to-issues` |

Run `/setup-matt-pocock-skills` in each project before the first publish or review cycle.

## Flow

```
grill → prd → to-issues (orchestrator)
  → publish minions (background)
  → auto-handoff → implement minions
  → verify (bash) → review (fresh Opus minion)
  → fix-review → … → gate → commit
```

Full loop details: `skills/orchestrator/review-loop.md`.

## Steering

While minions run in the background:

- `what's running?` — status from state board
- `stop task <id>` / `pause task <id>` / `resume task <id>`
- `steer <id>: <instruction>` — append guidance to a running minion

## License

MIT
