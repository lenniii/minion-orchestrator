# Review loop

Per **implement** task. **Background-first** — async inbox, never barrier-wait.

Track per [`state.md`](state.md). Route trivial tasks per [`routing.md`](routing.md).

## Before batch

1. Record `git rev-parse HEAD` per task as **fixed point** in `Notes`
2. Parallel implement on same repo → [`worktrees.md`](worktrees.md) first

## Cycle

All spawns: `run_in_background: true`. **Fresh reviewer every round** — never resume the implementer for review.

1. **Implement** — `/minion` `implement`, `glm-5.2-high`, `Skill: implement`
2. **Verify** — `bash` subagent per [`shell-lane.md`](shell-lane.md)
3. **Review** — new `/minion` `review`, `claude-opus-4-8-thinking-high`, `Skill: code-review`
4. `REVIEW_APPROVED` → **Gate** (orchestrator checks state board) → **Commit** minion
5. `REVIEW_CHANGES_REQUIRED` → **Fix** — `/minion` `fix-review`, `glm-5.2-high`, `Skill: tdd` → step 2

Cap at 5 review rounds — [`escalation.md`](escalation.md).

**Done when:** task `Phase: done` with commit reported or user waived commit.

## Spawn prompt — implement

```
Task ID: <id>
Type: implement
Skill: implement

Spec:
<issue or PRD excerpt>

Files:
- <paths>

Working directory:
<worktree path if parallel, else repo root>

Constraints:
- Do NOT run /code-review or commit

Output:
Summary, Skills loaded, git diff stat.
```

## Spawn prompt — review

Always a **new** minion — never resume implementer's agent ID.

```
Task ID: <id>
Type: review
Skill: code-review

Fixed point: <SHA from Notes>
Spec source: <issue URL/body or PRD path>

Original spec:
<full specification>

Verify result:
<bash subagent summary>

Output:
## Standards / ## Spec per code-review skill.
Then STATUS: REVIEW_APPROVED or REVIEW_CHANGES_REQUIRED with Changes list.
```

## Spawn prompt — fix-review

```
Task ID: <id>
Type: fix-review
Skill: tdd

Changes:
<verbatim from reviewer>

Skills loaded:
<from implementer>

Original spec:
<spec>

Working directory:
<worktree path if set>

Output:
Summary of edits.
```

## Spawn prompt — commit

After gate passes:

```
Task ID: <id>
Type: implement
Skill: implement

Spec:
Commit only. Message from issue/spec.

Constraints:
- git add only files for this task
- commit with conventional message referencing issue ID
- do not push unless spec says to

Output:
Commit SHA and message.
```
