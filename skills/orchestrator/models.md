# Models

| Role | Model |
|------|-------|
| **Frontier** | `gpt-5.6-sol-max` — dispatch-only; [`frontier.md`](frontier.md) |
| **Worker** | Per routing below |

Record worker model in board `Notes`.

## Route workers

| Work | Model |
|------|-------|
| Bulk / mechanical implement | `composer-2.5` |
| Complex implement / user-facing UI | `glm-5.2-high` |
| Review | `gpt-5.6-terra-extra-high` |
| PRD / issues synthesis | `gpt-5.6-terra-extra-high` |
| Commit | `composer-2.5` |
| PR / `gh` / worktrees / push / issue fetch | `composer-2.5` (`shell`) |
| Minion explore (delegated) | `composer-2.5` (`explore`) |
| Shell — merge conflicts, `gh` judgment | `gpt-5.6-terra-extra-high` (`shell`) |

Composer = first-party pool (exempt Enterprise $0.25/M token rate). Other models = pooled API + token rate.

Implementers verify (lint / test / typecheck) before `DONE` — no separate verify spawn.

`composer-2.5-fast` — explore latency only; 6× token price.

## Escalation

One tier on mediocre output, verify failure, or `BLOCKED`:

`composer-2.5` → `glm-5.2-high` → split or ask user.

Complex implement stays on `glm-5.2-high`; respawn fresh — never `resume` ([`loop.md#respawn`](loop.md)).

Never escalate to Sol — frontier only.

User says "use X" → override for that batch.

Benchmark rationale: [`models-scorecard.md`](models-scorecard.md).
