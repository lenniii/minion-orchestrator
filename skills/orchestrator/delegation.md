# Delegation policy

Use delegation only when it clearly improves cost, latency, quality, or parallelism. The main thread remains responsible for the task.

## Role aliases

| Alias | Use |
|-------|-----|
| `frontier` | Strongest planner/orchestrator model: decides, delegates, integrates, talks to user |
| `fast` | Mechanical work: codebase exploration, lookups, simple edits, tests, docs, CLI facts |
| `code` | Normal implementation: focused features, bug fixes, routine refactors |
| `deep` | Complex implementation: multi-file features, tricky refactors, hard debugging, architecture calls |
| `critic` | Review: adversarial inspection of a completed plan/diff against standards and spec |

Pass the concrete model explicitly in every delegate/Agent call when the harness supports a `model` parameter. If it does not, include the alias/model intent in the prompt.

## Worker personas

Personas are bundled with this skill under [`personas/`](personas/), not installed as global Pi agent files. Treat persona and model as orthogonal choices:

- choose a **persona** for authority, permissions, and output contract: `scout`, `planner`, `implementer`, `reviewer`, or `verifier`
- choose a **model alias** for capability/cost: `fast`, `code`, `deep`, or `critic`

When spawning a worker, include [`personas/shared.md`](personas/shared.md) plus the specific persona file in the worker prompt, or explicitly tell the worker to read them from the installed orchestrator skill. Do not rely on `~/.pi/agent/agents/` being present.

Typical pairings:

| Task | Persona | Model alias |
|------|---------|-------------|
| codebase reconnaissance | `scout` | `fast` |
| implementation planning | `planner` | `code` or `deep` |
| bounded coding change | `implementer` | `code` or `deep` |
| adversarial review | `reviewer` | `critic` |
| validation checks | `verifier` | `fast` or `code` |

## Frontier → Minion mode

When the session model matches the configured `frontier` model:

- plan and decide in the main thread
- send mechanical tasks to `fast`
- send normal implementation to `code`
- send hard subproblems to `deep`
- send completed work to `critic` when review is valuable
- integrate and verify yourself

Do not delegate user communication.

## Escalation mode

When the session model is `fast`, `code`, `deep`, or `critic`, handle the task yourself by default. Escalate upward only on a genuine competence gap:

- low confidence after inspecting the problem
- repeated failure on the same subproblem
- architecture/design judgement above your tier
- debugging that requires deeper cross-system reasoning
- user explicitly asks for a stronger model

Never escalate reflexively. Never escalate mechanical work.

## Output contract for delegates

Delegates return compact syntheses, not raw dumps.

Good outputs:

- findings with file paths and line references
- small patch/diff
- implementation summary + tests run
- decision recommendation with tradeoffs
- blocker with exact missing context

Bad outputs:

- full file dumps
- unfiltered grep output
- long terminal logs without diagnosis
- vague confidence statements
- messages intended for the user

## Verification

The main thread verifies before telling the user work is done. Verification may include tests, typecheck, lint, manual inspection, or asking a `critic` model to review — but ownership stays with the main thread.
