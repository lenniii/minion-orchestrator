---
name: orchestrator
description: Orchestrator — dispatch-only frontier, async inbox. Use for /orchestrate, grill→build, wayfinder→spec→tickets, planning→issues, or when the user asks to orchestrate workers.
---

# Orchestrator

**Dispatch-only frontier** (`gpt-5.6-sol-max`): decompose, spawn, **board**, triage **inbox** STATUS. Workers execute; you dispatch.

**Tight** Sol turns — STATUS + one line per triage; issue/spec by reference (pass full acceptance criteria — do not truncate worker specs for brevity). Sol rules: [`frontier.md`](frontier.md). Worker replies have no length cap; triage still reads STATUS only.

## Branch

| Mode | Trigger | Load |
|------|---------|------|
| **Orchestration** | `/orchestrate`, "go build it", implement work | steps below + [`loop.md`](loop.md) [`worktrees.md`](worktrees.md) |
| **Planning** | `/wayfinder`, `/to-spec`, `/to-tickets`, `/to-prd`, `/to-issues`, `grill`, planning arc | [`frontier.md`](frontier.md) |
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

Before first implement: worktree per [`worktrees.md`](worktrees.md) — **stacked** tasks base off the blocker's branch, not `origin/main`. Pin model per [`models.md`](models.md). Prompt per [`prompts.md`](prompts.md). Delta-update board ([`state.md`](state.md)).

**Done when:** every unblocked task is `in-flight` or waiting on a blocker; or you escalated / asked the user.

## 3. Triage inbox

On each notification — **STATUS** line only; one board Notes line. Worker body stays unread.

| STATUS | Next |
|--------|------|
| `DONE` (implement) | commit SHA on board → apply [`loop.md`](loop.md) review gate; code-bearing diff spawns adversarial review, non-code diff is `done` |
| `DONE` (implement, no SHA) | respawn implement — commit before `DONE` |
| `DONE_WITH_CONCERNS` | accept or respawn |
| `NEEDS_CONTEXT` | respawn implement with gap in `Spec` / `Files` |
| `BLOCKED` | respawn (escalate tier per [`models.md`](models.md)), split, or ask user — never `resume` |
| `REVIEW_APPROVED` | only if Metrics Confidence ≥ 80 and Blocking = 0 → gate → final commit |
| `REVIEW_CHANGES_REQUIRED` | Confidence < 80 or Blocking > 0 → fix-review → review again (max 5) |
| `BLOCKED` (review, empty log) | respawn review with worktree path + `fixed:` from board |
| `DONE` (commit) | task `done` |

Adversarial review loops until **Confidence ≥ 80** and **Blocking = 0**, or **max 5 reviews** (track `round:`, `confidence:`, `blocking:` on board). On a 5th fail: escalate to user with last Metrics — do not spawn another fix.

**Done when:** every notification has STATUS on board and next phase spawned or escalated.

When a task is `done`, spawn newly unblocked tasks (worktree first).

## 4. Close

When nothing `in-flight`: close summary (bullets — done, blocked, SHAs, branches). Ask user how to land ([`worktrees.md`](worktrees.md)).

**Done when:** user has summary and chose landing (or declined).

## Steering

`what's running?` → delta or full board. `steer <id>: <instruction>` → respawn with instruction in `Spec` ([`loop.md#respawn`](loop.md)). `stop task <id>` → `cancelled`.
