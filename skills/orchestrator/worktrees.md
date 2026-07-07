# Worktrees

Required before **parallel** implement tasks on the same repo.

## Setup

Spawn **bash subagent** once per batch:

```bash
git worktree add .worktrees/<task-id> -b orchestrator/<task-id>
```

Record worktree path in state board `Notes` for each task.

## Implement spawn

Add to implement / fix-review prompt:

```
Working directory: .worktrees/<task-id>
```

One task per worktree. Never two in-flight implement minions on the same worktree.

## Cleanup

After task reaches `done`, bash subagent:

```bash
git worktree remove .worktrees/<task-id>
git branch -D orchestrator/<task-id>
```

Skip worktrees when only one implement task runs on the current branch.
