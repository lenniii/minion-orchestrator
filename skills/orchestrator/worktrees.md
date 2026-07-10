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

Frontier resolves **absolute** worktree path (`<repo-root>/.worktrees/<slug>`) and passes it in every task spawn. Record on board Notes.

## Scoped cwd

Cursor **workspace root** is the main checkout. Prompt text alone does not change Shell cwd — subagents default there; `git status` / `git diff` then run against the wrong branch.

**Scoped** — every Shell call for task work sets Shell `working_directory` to the spawn's absolute worktree path. If `working_directory` is unavailable, prefix git: `git -C <abs-worktree> …`.

Read/Grep may use paths under `.worktrees/<slug>/` from workspace root; still **scoped** git for status, diff, log, commit.

**Preflight** (first Shell call per spawn): `pwd && git branch --show-current && git rev-parse HEAD` with `working_directory` set. **Done when** pwd is the worktree and branch matches board `branch:`.

## Notes fields

- `worktree: <abs>/.worktrees/<slug>`
- `branch: <slug>`
- `issue: #123`

## Landing (after close)

Ask user:

1. **Merge** — integration branch, merge in dependency order
2. **Stacked PRs** — one PR per task, stacked bases

Then shell workers ([`shell.md`](shell.md)) — push, `gh pr create`, merge. Frontier dispatches only.
