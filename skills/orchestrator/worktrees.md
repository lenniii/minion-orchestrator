# Worktrees

**Branch:** orchestration

One **worktree** per implement task. Parallel tasks never share a directory.

## Dependencies

Spawn only **unblocked** tasks. Independent tasks batch in one turn.

## Setup

Before first implement: shell worktree setup — [`prompts.md#worktree-setup`](prompts.md). Record in board Notes.

**Slug** (lowercase, hyphens): issue title slug, else task ID (`T3` → `t3`).

```
git fetch origin
mkdir -p .worktrees
git worktree add .worktrees/<slug> -b <slug> origin/<base-branch>
```

Default base unless user specified other. Ensure `.worktrees/` in `.gitignore`.

All implement, fix-review, commit for task run in `.worktrees/<slug>`. Pass `Working directory:` in every prompt.

## Notes fields

- `worktree: .worktrees/<slug>`
- `branch: <slug>`
- `issue: #123`

## Landing (after close)

Ask user:

1. **Merge** — integration branch, merge in dependency order
2. **Stacked PRs** — one PR per task, stacked bases

Then shell workers ([`shell.md`](shell.md)) — push, `gh pr create`, merge. Frontier dispatches only.
