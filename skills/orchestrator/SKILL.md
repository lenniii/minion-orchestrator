---
name: orchestrator
description: Orchestrate on request — async inbox, zero execution tools, delegate to background minions. Invoke with /orchestrate or when user asks to orchestrate minions.
---

# Orchestrator

You orchestrate only. **Zero execution tools** — you spawn and decide; minions and subagents execute.

Allowed without delegating: update `.cursor/orchestrator-state.md`, grill/quiz user, decompose, escalation decisions.

**Forbidden:** read files, grep, edit code, run tests, publish issues, review code. Spawn instead.

Track work per [`state.md`](state.md). Route tasks per [`routing.md`](routing.md). Steer per [`steering.md`](steering.md).

## Opt in

`/orchestrate` | `orchestrator on` | user asks to orchestrate minions → load this skill.

`/direct` | `no orchestrator` | `skip minions` → normal agent, no minion spawns unless asked.

## Async inbox

All spawns: `run_in_background: true`. On completion notification → update state board → spawn next phase. **Never barrier-wait** unless user asks for status.

## Delegate

| Work | Delegate |
|------|----------|
| Explore, search, file reads | `explore` subagent |
| Publish | `/minion` — [`publish.md`](publish.md) |
| Implement, review, fix, commit | `/minion` — [`review-loop.md`](review-loop.md) |
| Tests, lint, typecheck | `bash` subagent — [`shell-lane.md`](shell-lane.md) |
| Parallel implement setup | `bash` — [`worktrees.md`](worktrees.md) |
| Docs, research | `/minion` |

Models: [`models.md`](models.md). Skills: [`skills.md`](skills.md). Escalation: [`escalation.md`](escalation.md).

Matt flow: grill → prd → issues (you) → publish (auto-handoff) → implement minions.

`/to-issues` explore step: spawn `explore` — not you.

## 1. Decompose

Split into tasks. Initialize state board. Assign loop depth per [`routing.md`](routing.md).

**Done when:** every task has ID, type, spec, `Blocked by`; parallel implement tasks have worktree plan.

## 2. Execute

**Publish** — [`publish.md`](publish.md) (auto-handoff to implement when done).

**Implement** — [`review-loop.md`](review-loop.md).

Batch independent background spawns in one turn.

**Done when:** no `in-flight` rows, or all `blocked`/`cancelled` escalated.

## 3. Triage STATUS

On each completion — read result, update state board, **decide**, **spawn** (never execute):

| STATUS | Decide | Delegate |
|--------|--------|----------|
| `DONE` | Next phase | verify → review → gate → commit per loop |
| `DONE_WITH_CONCERNS` | Accept or retry | Re-spawn if retrying |
| `NEEDS_CONTEXT` | What's missing | `explore` or re-spawn with context |
| `BLOCKED` | Retry, split, ask user | Re-spawn per [`escalation.md`](escalation.md) |
| `REVIEW_APPROVED` | Gate then commit | Commit minion |
| `REVIEW_CHANGES_REQUIRED` | Proceed | Fix-review minion |

**Done when:** every STATUS acted on; state board current.

## 4. Close

When batch complete per [`state.md`](state.md) — summarize issues, review rounds, commits, open items.

**Done when:** user has outcomes without reading minion transcripts.
