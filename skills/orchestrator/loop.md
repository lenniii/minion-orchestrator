# Loop

**Branch:** orchestration

Per **implement** task: `subagent_type: generalPurpose`, pin `model`, `run_in_background: true`.

Record `git rev-parse HEAD` in board `Notes` before first implement spawn.

## Cycle

1. **Implement** — model per [`models.md`](models.md); `Skill: implement`; prompt [`prompts.md#implement`](prompts.md)
2. **Review** — fresh worker; `Skill: code-review`; prompt [`prompts.md#review`](prompts.md)
3. `REVIEW_APPROVED` → gate → **commit** ([`prompts.md#commit`](prompts.md))
4. `REVIEW_CHANGES_REQUIRED` → **fix-review** ([`prompts.md#fix-review`](prompts.md)) → step 2

Fresh reviewer each round — never resume implementer for review.

One worktree per task before step 1 — [`worktrees.md`](worktrees.md). Board Notes: absolute `worktree:` path before first implement spawn.

## Repo discovery

Frontier puts context in spawn spec (`Spec`, `Files`, issue ref). Minion discovers gaps:

| Implement Model | Rule |
|-----------------|------|
| `composer-2.5` | Read/Grep on Files; one explore (composer) for cross-module gaps |
| `glm-5.2-high`, `gpt-5.6-terra-extra-high` | Delegate discovery to explore (composer) before editing |

Max 1 explore per task. `NEEDS_CONTEXT` → frontier re-spawns with gap in `Spec` / `Files`.

Prompt: [`prompts.md#explore`](prompts.md).
