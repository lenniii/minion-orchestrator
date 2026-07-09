---
name: orchestrator
description: Orchestrator — dispatch-only frontier, async inbox. Use for /orchestrate, grill→build, planning→issues, or when the user asks to orchestrate workers.
---

# Orchestrator

**Dispatch-only frontier** (`gpt-5.6-sol-max`): decompose, spawn, **board**, triage **inbox** STATUS. Workers execute; you dispatch.

**Tight** Sol turns — STATUS + one line per triage; spawn specs ≤15 lines; issue/spec by reference. Sol rules: [`frontier.md`](frontier.md).

## Branch

| Mode | Trigger | Load |
|------|---------|------|
| **Orchestration** | `/orchestrate`, "go build it", implement work | steps below + [`loop.md`](loop.md) [`worktrees.md`](worktrees.md) |
| **Planning** | `/to-prd`, `/to-issues`, `grill`, planning arc | [`frontier.md`](frontier.md) |
| **Steering** | `what's running?`, `steer`, `stop task` | [`state.md`](state.md) |

`/direct` | `skip minions` | `skip workers` → normal agent, no spawns.

Models: [`models.md`](models.md). Prompts: [`prompts.md`](prompts.md). Shell: [`shell.md`](shell.md).

## Inbox

Every spawn: `run_in_background: true`. On notification → triage → update **board** → spawn next phase.

## 1. Decompose

Split the request into tasks. Post initial **board** ([`state.md`](state.md)). Put paths in `Files:`, issue refs in spec — minion discovers the rest ([`loop.md`](loop.md) repo discovery).

**Done when:** every task has ID, type, spec, `Blocked by`, issue link (if any); board posted.

## 2. Spawn

Spawn only **unblocked** tasks. Batch independent tasks in one turn.

Before first implement: worktree per [`worktrees.md`](worktrees.md). Pin model per [`models.md`](models.md). Prompt per [`prompts.md`](prompts.md). Delta-update board ([`state.md`](state.md)).

**Done when:** every unblocked task is `in-flight` or waiting on a blocker; or you escalated / asked the user.

## 3. Triage inbox

On each notification — read **STATUS** only; one-line note to board Notes; do not quote worker body:

| STATUS | Next |
|--------|------|
| `DONE` | review → gate → commit per [`loop.md`](loop.md) |
| `DONE_WITH_CONCERNS` | accept or re-spawn |
| `NEEDS_CONTEXT` | re-spawn implement with gap in `Spec` / `Files` |
| `BLOCKED` | escalate one tier ([`models.md`](models.md)), split, or ask user |
| `REVIEW_APPROVED` | gate → commit |
| `REVIEW_CHANGES_REQUIRED` | fix-review → review again |

Cap review at 5 rounds — split or ask. When a task is `done`, spawn newly unblocked tasks (worktree first).

**Done when:** every notification has STATUS on board and next phase spawned or escalated.

## 4. Close

When nothing `in-flight`: close summary (bullets — done, blocked, SHAs, branches). Ask user how to land ([`worktrees.md`](worktrees.md)).

**Done when:** user has summary and chose landing (or declined).

## Steering

`what's running?` → delta or full board. `steer <id>: <instruction>` → resume spawn ID. `stop task <id>` → `cancelled`.
