# Board

Live task queue — **posted in chat**. User reads status here.

## When to post

**Delta board** (changed rows + one-line summary) — default after spawn and triage.

**Full board** — decompose, steer / stop, close, `what's running?`, new-chat handoff.

## Format

`## Board` then:

| ID | Type | Phase | Status | Blocked by | Notes |
|----|------|-------|--------|------------|-------|
| T1 | implement | review | in-flight | — | `add-auth` · `/abs/.worktrees/add-auth` · #42 · spawn abc |

**Notes:** worktree, branch, `based-on:` (blocker ID if stacked), `fixed:` (base SHA in worktree), issue #, model, `round:` (review count, max 5), `confidence:` / `blocking:` (from latest review Metrics), spawn ID, verify result, commit SHA.

Keep `done` / `cancelled` rows until close → close summary → drop board.

## Phases

`implement` (+commit) → `review` → `fix` → `review` … (max 5 reviews) → `gate` → `commit` (final) → `done`

## Gate

After `REVIEW_APPROVED` (Confidence ≥ 80 and Blocking = 0): board shows verify pass + Metrics → spawn **final commit** ([`prompts.md#commit`](prompts.md)) for fix-review changes or noop if clean.
