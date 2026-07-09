# Shell & CLI

The frontier **never runs terminal commands** in orchestration mode — same rule as files. No `git`, no `gh`, no `npm`, no `docker`, no one-liner "just to check." Spawn a worker and triage its output.

**Exception:** chat-context skills (`grilling`, `to-prd`, `to-issues`) may use `gh` / issue-tracker MCP to **publish** PRDs and issues — see [`frontier.md`](frontier.md). That is not delegation; the skill owns the publish step.

Your tools in orchestration mode: decompose, decide, spawn, **post the board**.

## Delegate to `shell` subagents

| Category | Examples | When |
|----------|----------|------|
| **Git** | `fetch`, `worktree add`, `merge`, `push`, `status`, `log`, `diff` | Worktree setup, landing work, any repo state you need for the board |
| **GitHub (`gh`)** | `pr create`, `pr view`, `pr checks`, `issue list`, `issue view`, `api` | Opening PRs, reading CI, fetching issue context |
| **Package managers** | `npm`, `pnpm`, `yarn`, `pip`, `cargo` | Only when a worker prompt explicitly requires install/build — prefer implementer verify |
| **Containers / infra** | `docker`, `kubectl`, `terraform` | When the spec requires it — never ad-hoc from the frontier |
| **Project scripts** | `make`, `./scripts/*`, `just` | Setup, migrations, codegen — always a worker with a written spec |

**Model:** `composer-2.5` for mechanical shell work (git, gh, worktree). Escalate to `glm-5.2-high` when the shell task needs judgment (merge conflicts, interpreting `gh` errors, choosing PR base branches).

**Explore** stays read-only file search — do not use `explore` for shell commands.

## Frontier anti-patterns

- Running `gh pr create` yourself after workers finish
- `git status` / `git log` to "see what's going on" — spawn shell or read worker output
- Piping `gh issue view` to inform decomposition — spawn first, decompose from worker result
- "Quick" `npm test` to decide if a task is done — that's the implementer's job

## Shell worker prompt

```
Task ID: <id>
Type: shell
Model: composer-2.5

Working directory:
<repo root or worktree path>

Spec:
<exact goal — e.g. "open stacked PR for branch add-auth targeting main">

Commands (if known):
- <ordered list, or "figure out the right gh/git commands">

Constraints:
- Do not edit source files unless the spec says to (e.g. conflict resolution)
- Do not push or open PRs unless the spec says to
- Report full command output needed for triage

Output:
Summary of what ran, key stdout/stderr, URLs (PRs, issues) if any.
STATUS: DONE | BLOCKED
```

## Common flows

### Issue context before decompose

**Orchestration mode** — when the user points you at an issue/PR to **build**, and its body is not already in chat:

1. Spawn `shell` worker: `gh issue view <n> --json title,body,labels` (or `gh pr view …`)
2. Triage → use output to fill task specs on the board
3. Then decompose / spawn implement workers

**Chat-context mode** (`to-prd`, `to-issues`) — you may fetch and publish issues yourself; the thread is the source of truth.

Do **not** decompose from an issue URL alone if the spec depends on content you haven't fetched (via worker in orchestration mode, or directly in chat-context mode).

### Landing work

Per [`worktrees.md`](worktrees.md) — merge and stacked PRs are always `shell` workers. The frontier asks the user which option, then spawns; never runs `git merge` or `gh pr create` directly.

### CI / PR checks

After a PR exists and the user or spec cares about green CI:

1. Spawn `shell`: `gh pr checks <url|number> --watch` (or one-shot status)
2. Triage → update board Notes; spawn fix worker if failed
