# Loop

Per **implement** task. Coding workers: `subagent_type: generalPurpose`, pin `model`, `run_in_background: true`. Worktree: `shell`. Explore: `explore`.

Record `git rev-parse HEAD` as fixed point in board `Notes` before the first implement spawn.

## Cycle

1. **Implement** — per [`models.md`](models.md): `composer-2.5` mechanical, `glm-5.2-high` UI, `claude-sonnet-5-thinking-high` API/copy; `Skill: implement`. The implementer runs lint / test / typecheck before reporting `DONE`.
2. **Review** — fresh worker each round, `claude-opus-4-8-thinking-high`, `Skill: code-review`
3. `REVIEW_APPROVED` → **gate** (board shows verify pass + review approved) → **commit** worker
4. `REVIEW_CHANGES_REQUIRED` → **fix-review** worker, `Skill: tdd` (re-verify before `DONE`) → step 2

Never resume the implementer for review — always a new worker.

Each implement task gets its own worktree before step 1 — see [`worktrees.md`](worktrees.md). Never share a worktree across tasks.

## Worker prompt — implement

```
Task ID: <id>
Type: implement
Skill: implement
Model: <from models.md>

Spec:
<issue or excerpt>

Files:
- <paths>

Issue: <#123 title, if any>

Working directory:
<worktree path — required>

Constraints:
- Run the project's lint / test / typecheck; fix failures before finishing
- Stop before /code-review and commit

Output:
Summary, Skills loaded, git diff stat, verify result (lint / test / typecheck).
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
```

## Worker prompt — review

```
Task ID: <id>
Type: review
Skill: code-review
Model: claude-opus-4-8-thinking-high

Fixed point: <SHA>
Spec: <full specification>
Verify result: <from implementer output>

Output per code-review skill, then:
STATUS: REVIEW_APPROVED | REVIEW_CHANGES_REQUIRED
Changes:
1. ...
```

## Worker prompt — fix-review

```
Task ID: <id>
Type: fix-review
Skill: tdd
Model: <same tier rules as implement>

Changes:
<verbatim from reviewer>

Skills loaded:
<from implementer>

Constraints:
- Re-run lint / test / typecheck; fix failures before finishing

Output:
Summary of edits, verify result (lint / test / typecheck).
STATUS: DONE | BLOCKED
```

## Worker prompt — commit

```
Task ID: <id>
Type: commit
Skill: implement
Model: glm-5.2-high

Commit only. Conventional message referencing issue ID.
git add only files for this task. Do not push unless spec says to.

Output:
Commit SHA and message.
STATUS: DONE
```
