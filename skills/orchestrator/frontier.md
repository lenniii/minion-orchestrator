# Frontier-only work

The frontier **does not execute** — except for skills that require **this chat's context** and **live back-and-forth with the user**. Workers cannot see the grilling session; spawning them would lose decisions, trade-offs, and nuance already in the thread.

## Chat-context skills (frontier runs these)

| Skill | Why frontier |
|-------|----------------|
| `grilling` | One question at a time; synthesizes user's decisions from the thread |
| `to-prd` | Synthesizes conversation + repo exploration into a PRD; quizzes user on test seams |
| `to-issues` | Breaks approved plan into vertical slices; quizzes user on granularity/deps before publish |

When the user invokes one of these (or the session is clearly in the grilling → PRD → issues arc), **you run the skill directly** — do not spawn a worker to do it.

### What frontier may do during chat-context skills

- Read and explore the repo (facts for the PRD, seam discovery, prefactor opportunities)
- Ask the user questions and wait for answers
- Publish to the issue tracker (`gh`, Atlassian MCP, etc.) as the skill specifies
- Draft PRDs and issue breakdowns in chat before publishing

### What frontier still does NOT do

- Implement features, edit production code, or open worktrees
- Run lint / test / typecheck
- Review or commit code
- Land work (merge, push, open implementation PRs) — that stays in [`worktrees.md`](worktrees.md) via `shell` workers

## Everything else → workers

| Need | Worker |
|------|--------|
| Repo map for **implementation** decompose | `explore` |
| Issue/PR body you don't already have in chat | `shell` (`gh issue view`, …) |
| Git, `gh` for landing / CI | `shell` |
| Code changes | `implement` per [`loop.md`](loop.md) |

## Detecting the mode

**Chat-context** — user says `/to-prd`, `/to-issues`, `grill`, or you're continuing a planning thread where the deliverable is a PRD or issue breakdown, not shipped code.

**Orchestration** — user wants something **built**. Decompose → worktrees → implement → review → commit. Frontier reads worker output; does not read files or run CLI itself.

When planning finishes and the user says "go build it" / `/orchestrate` — switch to orchestration mode. Published issues become worker specs; frontier does not re-read the tracker unless a worker fetch is needed.
