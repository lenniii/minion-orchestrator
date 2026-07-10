# Worker prompts

Spawn templates. Pin `model` per [`models.md`](models.md). Every spawn: `run_in_background: true`.

## explore

Minion-delegated or planning repo facts. Always `composer-2.5`, `subagent_type: explore`.

```
Task ID: <id>
Type: explore
Model: composer-2.5

Working directory (absolute):
<repo root or worktree path>

Question:
<specific question — not "map entire repo">

Scope (optional):
- <paths>

Constraints:
- Read-only
- **Scoped:** Shell `working_directory` = path above ([`worktrees.md#scoped-cwd`](worktrees.md))
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

Working directory (absolute):
<worktree path — required>

Constraints:
- **Scoped:** every Shell call — `working_directory` = path above; preflight pwd/branch/HEAD ([`worktrees.md#scoped-cwd`](worktrees.md))
- Edit only Files (+ direct imports/callers)
- Non-composer Model + context beyond Files → ONE explore (composer-2.5), then edit
- Composer Model → Read/Grep on Files first; explore only for cross-module gaps
- Max 1 explore per task
- Lint / test / typecheck before DONE
- Stop before review and commit
- Insufficient context → STATUS: NEEDS_CONTEXT (one line)

Output:
Summary (≤2 sentences), `git diff <fixed-point> --stat`, verify result.
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

Worktree (absolute):
<worktree path>

Constraints:
- **Scoped:** all git — Shell `working_directory` = worktree path ([`worktrees.md#scoped-cwd`](worktrees.md))
- **Pre-commit review** — overrides code-review step 1 diff command. Implement has not committed; use working-tree diff:
  - `git diff <fixed-point> --stat` and `git diff <fixed-point>`
  - Do **not** use `git diff <fixed-point>...HEAD` (empty when HEAD == fixed point)

Preflight (mandatory, in order — stop on first failure):
1. Shell `working_directory` = worktree path; `pwd && git branch --show-current`
2. `git rev-parse <fixed-point>`
3. `git diff <fixed-point> --stat` — must be non-empty and match Changed files
4. If step 3 empty: re-run once with `working_directory` set; if still empty → `STATUS: BLOCKED` (one line: cwd, branch, fixed point, implementer stat)
5. **Do not** search branches, reflog, other worktrees, parent repos, or grep for feature terms to "find" the diff

Output per code-review skill (using diff from step 3), then:
STATUS: REVIEW_APPROVED | REVIEW_CHANGES_REQUIRED | BLOCKED
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

Working directory (absolute):
<worktree path>

Constraints:
- **Scoped:** every Shell call — `working_directory` = path above ([`worktrees.md#scoped-cwd`](worktrees.md))
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

Working directory (absolute):
<worktree path>

Commit only — git add + conventional message referencing issue ID.
git add only this task's files. Do not push unless spec says to.

Constraints:
- **Scoped:** every Shell/git call — `working_directory` = path above ([`worktrees.md#scoped-cwd`](worktrees.md))

Output:
Commit SHA and message.
STATUS: DONE
```

## shell

```
Task ID: <id>
Type: shell
Model: composer-2.5

Working directory (absolute):
<repo root or worktree>

Spec:
<exact goal>

Commands (if known):
- <ordered list, or "figure out commands">

Constraints:
- **Scoped:** every Shell call — `working_directory` = path above ([`worktrees.md#scoped-cwd`](worktrees.md))
- Do not edit source unless spec says (e.g. conflict resolution)
- Do not push / open PRs unless spec says

Output:
Summary, key output, URLs if any.
STATUS: DONE | BLOCKED
```

## worktree-setup

Runs from **repo root** (not the new worktree). Subsequent spawns use the worktree absolute path.

```
Task ID: <id>
Type: worktree-setup
Model: composer-2.5

Working directory (absolute):
<repo root>

Branch name: <slug>
Base ref: <origin/<base-branch> | <blocker-branch> — see worktrees.md Dependencies>

Commands:
git fetch origin
git worktree add .worktrees/<slug> -b <slug> <Base ref>

Constraints:
- **Scoped:** Shell `working_directory` = repo root above

Output:
Absolute worktree path, branch name, base SHA.
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
