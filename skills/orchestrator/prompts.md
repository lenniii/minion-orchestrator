# Worker prompts

Spawn templates. Pin `model` per [`models.md`](models.md). Every spawn: `run_in_background: true`.

## explore

Minion-delegated or planning repo facts. Always `composer-2.5`, `subagent_type: explore`.

```
Task ID: <id>
Type: explore
Model: composer-2.5

Working directory:
<repo root or worktree path>

Question:
<specific question — not "map entire repo">

Scope (optional):
- <paths>

Constraints:
- Read-only
- Answer only; ≤30 lines

Output:
Summary (modules, entry points, patterns, test commands as relevant).
STATUS: DONE | BLOCKED
```

## implement

```
Task ID: <id>
Type: implement
Skill: implement
Model: <from models.md>

Spec:
<issue or excerpt — ≤15 lines>

Files:
- <paths>

Issue: <#123 title, if any>

Working directory:
<worktree path — required>

Constraints:
- Edit only Files (+ direct imports/callers)
- Non-composer Model + context beyond Files → ONE explore (composer-2.5), then edit
- Composer Model → Read/Grep on Files first; explore only for cross-module gaps
- Max 1 explore per task
- Lint / test / typecheck before DONE
- Stop before review and commit
- Insufficient context → STATUS: NEEDS_CONTEXT (one line)

Output:
Summary (≤2 sentences), diff stat, verify result.
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
```

## review

```
Task ID: <id>
Type: review
Skill: code-review
Model: claude-opus-4-8-thinking-high

Fixed point: <SHA>
Spec: <acceptance criteria for this task only>
Changed files: <from implementer diff stat>
Verify result: <one line>

Output per code-review skill, then:
STATUS: REVIEW_APPROVED | REVIEW_CHANGES_REQUIRED
Changes:
1. ...
```

## fix-review

```
Task ID: <id>
Type: fix-review
Skill: tdd
Model: <same tier as implement>

Changes:
<verbatim from reviewer>

Working directory:
<worktree path>

Constraints:
- Edit only reviewer files (+ direct fixes)
- Re-run lint / test / typecheck

Output:
Summary, verify result.
STATUS: DONE | BLOCKED
```

## commit

```
Task ID: <id>
Type: commit
Skill: implement
Model: composer-2.5

Working directory:
<worktree path>

Commit only — git add + conventional message referencing issue ID.
git add only this task's files. Do not push unless spec says to.

Output:
Commit SHA and message.
STATUS: DONE
```

## shell

```
Task ID: <id>
Type: shell
Model: composer-2.5

Working directory:
<repo root or worktree>

Spec:
<exact goal>

Commands (if known):
- <ordered list, or "figure out commands">

Constraints:
- Do not edit source unless spec says (e.g. conflict resolution)
- Do not push / open PRs unless spec says

Output:
Summary, key output, URLs if any.
STATUS: DONE | BLOCKED
```

## worktree-setup

```
Task ID: <id>
Type: worktree-setup
Model: composer-2.5

Branch name: <slug>
Base branch: <default branch>

Commands:
git fetch origin
git worktree add .worktrees/<slug> -b <slug> origin/<base>

Output:
Worktree path, branch name, base SHA.
STATUS: DONE | BLOCKED
```

## prd

```
Task ID: <id>
Type: prd
Skill: to-prd
Model: gpt-5.6-terra-extra-high

Context:
<grilling decisions, constraints — structured brief, not chat dump>

Explore summary:
<from explore worker, or "none">

Seams (if pre-agreed):
<list, or "propose assumptions">

Constraints:
- Synthesize — do not interview user
- Do not publish
- Unclear seams → STATUS: NEEDS_USER_INPUT

Output:
Full PRD markdown.
STATUS: DONE | NEEDS_USER_INPUT
```

## issues

```
Task ID: <id>
Type: issues
Skill: to-issues
Model: gpt-5.6-terra-extra-high

Approved plan:
<PRD or spec>

Explore summary:
<optional>

Constraints:
- Draft tracer-bullet slices + issue bodies — do not publish
- Do not quiz user; frontier confirms
- Skip to-issues steps 4–5 (quiz, publish)

Output:
Numbered slices (title, blocked-by, stories) + issue body each.
STATUS: DONE | NEEDS_USER_INPUT
```
