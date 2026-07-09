# Worktrees

Every implement task that touches the repo gets its own **worktree**. Parallel tasks never share a working directory.

## Dependencies

Spawn only **unblocked** tasks. A task with `Blocked by: T1` stays `pending` until T1 is `done` — then spawn it in the next batch.

Independent tasks spawn in the same turn (async inbox).

## Worktree per task

Before the first **implement** spawn on a task, run a `composer-2.5` `shell` subagent to create the worktree. Record branch name and path on the board `Notes`.

**Branch / worktree name** (slug, lowercase, hyphens):

1. Issue tracker title or slug when the task links an issue (e.g. `add-auth-callback`)
2. Else orchestrator task ID (e.g. `T3` → `t3`)

```
git fetch origin
mkdir -p .worktrees
git worktree add .worktrees/<slug> -b <slug> origin/<base-branch>
```

Use the repo's default branch as `<base-branch>` unless the user specified another. Add `.worktrees/` to the project `.gitignore` if not already present.

All implement, fix-review, and commit work for that task runs inside `.worktrees/<slug>`. Pass `Working directory:` in every worker prompt.

## Board

Track per task in `Notes`:

- `worktree: .worktrees/<slug>`
- `branch: <slug>`
- `issue: #123` (if any)

## After all tasks are done

When every row is `done` or `cancelled` and nothing is `in-flight` — **ask the user** before merging or opening PRs:

> All tasks complete. How do you want to land the work?
> 1. **Merge** — combine every branch into one integration branch
> 2. **Stacked PRs** — one PR per task, stacked (each PR bases on the previous task's branch)

Do not merge or open PRs until the user chooses.

### Option 1 — merge everything

Spawn `composer-2.5` `shell` subagent:

- Create integration branch from default base
- Merge each task branch in dependency order (`Blocked by` topo sort)
- Resolve conflicts or report `BLOCKED` with details
- Output: integration branch name, merge SHAs

### Option 2 — stacked PRs

Spawn one `composer-2.5` `shell` worker per task (or one worker with ordered steps), in dependency order. The frontier does **not** run `git push` or `gh pr create` — see [`shell.md`](shell.md).

- Push each task branch
- `gh pr create`: first PR targets default base; each next PR targets the previous task's branch
- PR title/body references issue ID when present
- Output: PR URLs in task order

## Shell prompt — create worktree

```
Task ID: <id>
Type: worktree-setup

Branch name: <slug from issue title or task ID>
Base branch: <default branch>

Commands:
git fetch origin
git worktree add .worktrees/<slug> -b <slug> origin/<base>

Output:
Worktree path, branch name, base SHA.
STATUS: DONE | BLOCKED
```
