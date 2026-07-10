# Worktrees

**Branch:** orchestration

One **worktree** per implement task. Parallel tasks never share a directory.

## Dependencies

Spawn only **unblocked** tasks. Independent tasks batch in one turn.

**Stacked base** — when `Blocked by` points at a task with its own worktree, the new worktree branches from **that task's branch** (after blocker is `done` and committed), not from `origin/<base>`.

| Blocked by | Base ref for `git worktree add` |
|------------|----------------------------------|
| — (none) | `origin/<default-branch>` |
| T1 (has `branch:` on board) | T1's `branch:` (local branch name) |

Frontier copies blocker's `branch:` into the worktree-setup spawn as `Base ref:`. Record `based-on: T1` in Notes.

```
# Independent
git worktree add .worktrees/<slug> -b <slug> origin/<base-branch>

# Depends on T1 (T1 done, committed on branch issue-138-foo)
git worktree add .worktrees/<slug> -b <slug> <T1-branch>
```

Do not base a dependent task on `origin/main` when the blocker already advanced the branch in its worktree.

## Setup

Before first implement: shell worktree setup — [`prompts.md#worktree-setup`](prompts.md). Pick base ref per table above. Record in board Notes.

**Slug** (lowercase, hyphens): issue title slug, else task ID (`T3` → `t3`).

Frontier resolves **absolute** worktree path (`<repo-root>/.worktrees/<slug>`) and passes it in every task spawn. Record on board Notes.

## Scoped cwd

Cursor **workspace root** is the main checkout. Prompt text alone does not change Shell cwd — subagents default there; `git status` / `git diff` then run against the wrong branch.

**Scoped** — every Shell call for task work sets Shell `working_directory` to the spawn's absolute worktree path. If `working_directory` is unavailable, prefix git: `git -C <abs-worktree> …`.

Read/Grep may use paths under `.worktrees/<slug>/` from workspace root; still **scoped** git for status, diff, log, commit.

**Preflight** (first Shell call per spawn): `pwd && git branch --show-current && git rev-parse HEAD` with `working_directory` set. **Done when** pwd is the worktree and branch matches board `branch:`.

**Review diff trap:** `git diff <fixed>...HEAD` is empty when implement has not committed (HEAD still at `fixed:`). Reviewers use `git diff <fixed>` from the worktree — see [`prompts.md#review`](prompts.md). Empty diff is not a signal to search the repo; `STATUS: BLOCKED`.

## Notes fields

- `worktree: <abs>/.worktrees/<slug>`
- `branch: <slug>`
- `based-on: <blocker-id>` (if stacked)
- `issue: #123`

## Landing (after close)

Ask user:

1. **Merge** — integration branch, merge in dependency order
2. **Stacked PRs** — one PR per task, stacked bases

Then shell workers ([`shell.md`](shell.md)) — push, `gh pr create`, merge. Frontier dispatches only.
