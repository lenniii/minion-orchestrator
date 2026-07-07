# State board

Durable queue in `.cursor/orchestrator-state.md`. Update on every spawn, completion, steer, or cancel.

## Initialize

```markdown
# Orchestrator state

Updated: <ISO timestamp>

## Tasks

| ID | Type | Phase | Agent | Round | Blocked by | Status | Started | Notes |
|----|------|-------|-------|-------|------------|--------|---------|-------|

## Published

| Slice | Issue | URL |
|-------|-------|-----|
```

## Columns

- **Agent** — subagent ID from spawn (for resume/steer)
- **Round** — review loop iteration (1–5)
- **Blocked by** — task IDs that must be `done` first
- **Status** — `in-flight` | `done` | `blocked` | `paused` | `cancelled`
- **Started** — ISO timestamp
- **Notes** — fixed-point SHA, worktree path, `verify: pass|fail`, escalation decisions

## Phases

`implement` → `verify` → `review` → `fix` → `review` … → `gate` → `commit` → `done`

Also: `publish` | `explore` | `cancelled` | `paused`

## Async inbox

On background completion notification:

1. Read minion/subagent result
2. Update state board row
3. Spawn next phase per [`review-loop.md`](review-loop.md) or [`publish.md`](publish.md)
4. **Do not block** — continue other work or conversation

Never wait synchronously for minions unless user explicitly asks for status.

## Batch complete

When no row has `Status: in-flight`:

1. Summarize all `done` and `blocked` tasks for the user
2. List published issue URLs
3. Note review rounds and commits per task ID

## Gate

Orchestrator-only phase after `REVIEW_APPROVED`: read state board, confirm verify passed + review approved, then spawn commit minion. No file reads — trust minion outputs.
