# Board

Live task queue — **posted in chat**. User reads status here.

## When to post

**Delta board** (changed rows + one-line summary) — default after spawn and triage.

**Full board** — decompose, steer / stop / pause / resume, close, `what's running?`.

## Format

`## Board` then:

| ID | Type | Phase | Status | Blocked by | Notes |
|----|------|-------|--------|------------|-------|
| T1 | implement | review | in-flight | — | `add-auth` · `/abs/.worktrees/add-auth` · #42 · spawn abc |

**Notes:** worktree, branch, `based-on:` (blocker ID if stacked), `fixed:` (base SHA in worktree), issue #, model, round, spawn ID, verify result, commit SHA.

Keep `done` / `cancelled` rows until close → close summary → drop board.

## Phases

`implement` → `review` → `fix` → `review` … → `gate` → `commit` → `done`

## Gate

After `REVIEW_APPROVED`: board shows verify pass + review approved → spawn commit ([`prompts.md#commit`](prompts.md)).
