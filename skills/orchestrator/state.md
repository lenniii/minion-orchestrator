# Board

The **board** is the live task queue — **posted in chat**, not hidden in a file. The user reads status here.

## When to post

Post the full board after every state change:

- decompose (initial board)
- each spawn
- each inbox triage
- steer / stop / pause / resume
- close

`what's running?` → re-post the current board.

## Format

Lead with `## Board`, then a table:

| ID | Type | Phase | Status | Blocked by | Notes |
|----|------|-------|--------|------------|-------|
| T1 | implement | review | in-flight | — | `add-auth` · worktree `.worktrees/add-auth` · #42 |
| T2 | implement | pending | pending | T1 | `auth-tests` · #43 |

**Columns**

- **ID** — short label (`T1`, `auth-fix`)
- **Type** — `implement` | `review` | `fix-review` | `docs` | `commit` …
- **Phase** — current step in [`loop.md`](loop.md)
- **Status** — `pending` | `in-flight` | `done` | `blocked` | `paused` | `cancelled`
- **Blocked by** — task IDs that must be `done` before this task spawns (`—` if none)
- **Notes** — worktree path, branch, issue #, model, round, spawn ID (for steer/resume), verify result, commit SHA

Keep rows for `done` and `cancelled` tasks until close — then move outcomes into the close summary and drop the board.

## Phases

`implement` → `verify` → `review` → `fix` → `review` … → `gate` → `commit` → `done`

## Gate

After `REVIEW_APPROVED`: confirm on the board that verify passed and review approved, then spawn commit worker.
