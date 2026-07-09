# Shell & CLI

**Branch:** orchestration | planning (publish step)

**Dispatch-only frontier** — spawn `shell` workers for every CLI touch. Prompt: [`prompts.md#shell`](prompts.md).

## Delegate

| Category | Examples |
|----------|----------|
| **Git** | fetch, worktree, merge, push, status, log, diff |
| **GitHub** | pr create/view/checks, issue view/list, api |
| **Package managers** | npm, pnpm, yarn, pip, cargo — when spec requires |
| **Scripts** | make, ./scripts/*, just |

**Model:** `composer-2.5` default. `gpt-5.6-terra-extra-high` for merge conflicts, `gh` judgment, PR base choice.

**Commit** (`git add` + message) — separate worker type [`prompts.md#commit`](prompts.md), not shell.

Explore = read-only files — not shell.

## Flows

### Issue body before decompose

Issue/PR URL in chat but body not loaded:

1. Shell: `gh issue view <n> --json title,body,labels`
2. Triage STATUS → fill task spec / `Files:`
3. Decompose / spawn implement

### Issue fetch for implement

Spawn spec carries issue ref; minion or shell fetches body if needed — not frontier.

### Landing work

[`worktrees.md`](worktrees.md) — merge or stacked PRs via shell workers after user chooses.

### CI checks

Shell: `gh pr checks …` → triage → fix worker if failed.

### Planning publish

After user approves PRD/issue draft → shell publishes to tracker ([`frontier.md`](frontier.md)).
