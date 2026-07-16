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
| Complex implement / user-facing UI | `cursor-grok-4.5-high` |
| Review | `gpt-5.6-terra-high` |
| PRD / issues synthesis | `gpt-5.6-terra-high` |
| Commit | `composer-2.5` |
| PR / `gh` / worktrees / push / issue fetch | `composer-2.5` (`shell`) |
| Minion explore (delegated) | `composer-2.5` (`explore`) |
| Shell — merge conflicts, `gh` judgment | `gpt-5.6-terra-high` (`shell`) |

Composer = first-party pool (exempt Enterprise $0.25/M token rate). Other models = pooled API + token rate.

**Verify gate** — implementers and fix-review run lint / test / typecheck before `DONE`; reviewers do not. No separate verify spawn.

`composer-2.5-fast` — explore latency only; 6× token price.

## Escalation

One tier on mediocre output, verify failure, or `BLOCKED`:

`composer-2.5` → `cursor-grok-4.5-high` → split or ask user.

Complex implement stays on `cursor-grok-4.5-high`; respawn fresh — never `resume` ([`loop.md#respawn`](loop.md)).

Never escalate to Sol — frontier only.

User says "use X" → override for that batch.

Benchmark rationale: [`models-scorecard.md`](models-scorecard.md).
