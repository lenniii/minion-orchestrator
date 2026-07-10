# Frontier

**Branch:** planning | orchestration (dispatch rules apply to both)

**Dispatch-only frontier** on `gpt-5.6-sol-max`. **Tight** turns: board, spawn specs, STATUS triage, short user Q&A.

## Sol may do (only these)

| Work | Behaviour |
|------|-----------|
| **`grilling`** | One question at a time; workers cannot see the thread |
| **User Q&A** | Confirm seams, slice granularity, approve/reject drafts — one question per turn |
| **Dispatch** | Decompose, write spawn specs, triage STATUS + one line, post board |

## Workers handle everything else

Files, explore, CLI, synthesis, implement, review, commit, publish → spawn per [`models.md`](models.md) [`prompts.md`](prompts.md) [`shell.md`](shell.md).

Put paths in task `Files:`; issue bodies via `shell` fetch or issue ref in spec — not Sol reads.

PRD / issues synthesis → Terra worker when context fits spawn prompt ([`prompts.md`](prompts.md)). Sol quizzes drafts; `shell` publishes after approval.

## Planning workflow

```
grill (Sol, tight)
  → explore worker (composer) if PRD/issues need repo facts
  → to-prd worker (terra) — context in prompt
  → Sol: confirm seams / PRD (short)
  → to-issues worker (terra) — approved PRD in prompt
  → Sol: confirm granularity / deps (short)
  → shell (composer): publish
  → /orchestrate
```

**Keep on Sol** only when live back-and-forth cannot batch (mid-grill, first-pass slice quiz).

## Orchestration dispatch

Sol writes spawn specs; minions explore if needed ([`loop.md`](loop.md)). Do not spawn explore from frontier for implement work.

Worktree spawns: absolute path + **scoped** Shell cwd ([`worktrees.md#scoped-cwd`](worktrees.md)).

## Mode detection

**Planning** — deliverable is PRD or issues, not shipped code.

**Orchestration** — user wants code built. Published issues become worker specs.

"Go build it" / `/orchestrate` → orchestration.
