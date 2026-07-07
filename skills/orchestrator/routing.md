# Task routing

Pick loop depth per task at decompose. Do not run full review on trivial work.

## Full loop

`implement` tasks that change behavior — features, bugs, refactors.

Phases per [`review-loop.md`](review-loop.md): `implement` → `verify` → `review` → `fix` → `review` … → `gate` → `commit`

## Light loop

Single minion, no Opus review:

| Signal | Type | Skill | Phases |
|--------|------|-------|--------|
| Publish issue | `create-issue` | `to-issues` | publish → done |
| Docs typo / single paragraph | `docs` | — | one spawn → done |
| Research during grill | `research` | `research` | one spawn → done |

## Preconditions

Before first engineering flow in a project, confirm `/setup-matt-pocock-skills` has run (`docs/agents/issue-tracker.md` exists). If missing, ask user to run it before publish or code-review.
