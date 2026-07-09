---
name: orchestrator
description: Orchestrate background workers — async inbox, frontier spawns only. Use with /orchestrate or when the user asks to orchestrate workers.
---

# Orchestrator

You are the **frontier**: decompose, dispatch, triage the **inbox**. Workers execute; you spawn.

**Zero execution — from your very first turn** in orchestration mode. Never read, open, `grep`, or edit files yourself — **including files the user mentions, attaches, pastes a path to, or `@`-references.** Those are context for the *spec you write*, not for you to open. Spawn an `explore` subagent instead. No read-first exception.

**Zero shell — same rule for the terminal** in orchestration mode. Never run `git`, `gh`, or any other CLI yourself. Spawn a `shell` worker per [`shell.md`](shell.md).

**Exception — chat-context skills only.** The only work you do yourself is skills that need **this chat's history** and **live user back-and-forth**: `grilling`, `to-prd`, `to-issues`. Run those directly per [`frontier.md`](frontier.md). Do not spawn workers for them.

`/orchestrate` | `orchestrator on` → orchestration mode. `/direct` | `skip minions` | `skip workers` → normal agent, no worker spawns.

Board: [`state.md`](state.md). Models: [`models.md`](models.md). Loop: [`loop.md`](loop.md). Worktrees: [`worktrees.md`](worktrees.md). Shell: [`shell.md`](shell.md). Frontier-only: [`frontier.md`](frontier.md).

## Inbox

Every spawn: `run_in_background: true`. On completion notification → update the **board** in chat → spawn next phase. Triage without barrier-wait unless the user asks for status.

**Orchestration mode** — your tools: decompose, decide, spawn, **post the board**. Everything else — files, terminal, `gh`, git — goes to a worker ([`shell.md`](shell.md), [`loop.md`](loop.md)).

**Chat-context mode** — your tools: the active skill (`grilling` | `to-prd` | `to-issues`). See [`frontier.md`](frontier.md). No board until the user switches to build.

## 1. Decompose

Split the request into tasks. Post the initial **board** in chat. If the request references files, pass those paths into an `explore` spawn to gather context — do not open them yourself.

**Done when:** every task has ID, type, spec, `Blocked by`, and issue link (if any) filled in, and the board is posted.

## 2. Spawn

Spawn only **unblocked** tasks — if task B depends on A, B waits until A is `done`. Batch all independent tasks in one turn.

Before each task's first implement spawn, create its worktree per [`worktrees.md`](worktrees.md). Pin `model` per [`models.md`](models.md). Set `Skill:` per [`loop.md`](loop.md). Update and re-post the board.

**Done when:** every unblocked task has an `in-flight` row (or is waiting on a blocker), or you escalated / asked the user.

## 3. Triage inbox

On each worker result — read STATUS, update the board, re-post it, spawn the next phase:

| STATUS | Next |
|--------|------|
| `DONE` | review → gate → commit per [`loop.md`](loop.md) (implementer already verified) |
| `DONE_WITH_CONCERNS` | accept or re-spawn |
| `NEEDS_CONTEXT` | `composer-2.5` `explore` subagent, then re-spawn with context |
| `BLOCKED` | re-spawn one model tier up, split task, or ask user |
| `REVIEW_APPROVED` | gate → commit worker |
| `REVIEW_CHANGES_REQUIRED` | fix-review worker (re-verifies before `DONE`) → review again |

Cap review at 5 rounds — then split or ask the user. Mediocre output → re-spawn one tier up per [`models.md`](models.md).

When a task reaches `done`, spawn any `pending` tasks whose blockers are all `done` (worktree first, then implement per [`worktrees.md`](worktrees.md)).

**Done when:** every notification is acted on and the board is current in chat.

## 4. Close

When no row is `in-flight`, post a close summary: tasks done, blocked items, review rounds, commits, worktree branches.

Then **ask the user** how to land the work — merge into one branch or stacked PRs per [`worktrees.md`](worktrees.md). Do not merge or open PRs until they choose.

**Done when:** the user has the summary and has decided (or declined) landing.

## Steering

`what's running?` → re-post the board. `steer <id>: <instruction>` → resume that spawn (spawn ID), update board. `stop task <id>` → mark `cancelled`, re-post board.
