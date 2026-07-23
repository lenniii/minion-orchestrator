# Loop

**Branch:** orchestration

Per **implement** task: `subagent_type: generalPurpose`, pin `model`, `run_in_background: true`.

Record `fixed:` (`git rev-parse HEAD` in the **worktree**) in board Notes before first implement spawn.

## Cycle

1. **Implement** — model per [`models.md`](models.md); `Skill: implement`; prompt [`prompts.md#implement`](prompts.md). Implementer passes **verify gate** (lint / test / typecheck) and **commits** before `DONE`.
2. **Review gate** — inspect the implementer's diff stat. Spawn review only when the diff contains code: source, tests, executable scripts, migrations, styles/templates, or infrastructure as code. Documentation, changelog/changeset, generated artifact, lockfile, and metadata-only diffs skip directly to `done`. A mixed diff is code-bearing.
3. **Review** — for a code-bearing diff, spawn a fresh worker; `Skill: code-review` (adversarial); prompt [`prompts.md#review`](prompts.md). Diff commits since `fixed:` (`git diff <fixed-point>...HEAD`). Reviewer does not re-run verify — trust implementer's one-liner ([`models.md`](models.md)). Increment `round:` on board (1-based; first review is `round: 1`). Record `confidence:` + `blocking:` from Metrics on the board.
4. **Merge gate (A):** `REVIEW_APPROVED` only when **Confidence ≥ 80** and **Blocking = 0**. Otherwise `REVIEW_CHANGES_REQUIRED`.
5. `REVIEW_APPROVED` → gate → **commit** ([`prompts.md#commit`](prompts.md)) — second commit for fix-review changes, or noop if clean.
6. `REVIEW_CHANGES_REQUIRED` → if `round:` < 5: **fix-review** ([`prompts.md#fix-review`](prompts.md)) → step 3; if `round:` ≥ 5: escalate to user with last Metrics — stop the loop.

**Max 5 reviews** per code-bearing task. Keep requesting adversarial review until the merge gate passes or the round cap hits. Fresh reviewer each round — never resume implementer for review.

## Respawn

After `BLOCKED`, `NEEDS_CONTEXT`, env repair, or `steer` — **respawn** a fresh worker with delta in `Spec`. Task `resume` is off-limits; it bloats parent context.

**Done when:** new spawn ID on board; old spawn marked superseded in Notes.

One worktree per task before step 1 — [`worktrees.md`](worktrees.md). Board Notes: absolute `worktree:` path before first implement spawn.

## Repo discovery

Frontier puts context in spawn spec (`Spec`, `Files`, issue ref). Minion discovers gaps:

| Implement Model | Rule |
|-----------------|------|
| `composer-2.5` | Read/Grep on Files; one explore (composer) for cross-module gaps |
| `cursor-grok-4.5-high` | Delegate discovery to explore (composer) before editing |

Max 1 explore per task. `NEEDS_CONTEXT` → frontier re-spawns with gap in `Spec` / `Files`.

Prompt: [`prompts.md#explore`](prompts.md).
