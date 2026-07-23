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
- Answer the question; be as thorough as the evidence needs — no length cap

Output:
Answer body (tables, citations, paths OK), then STATUS.
STATUS: DONE | BLOCKED
```

## implement

```
Task ID: <id>
Type: implement
Skill: implement
Model: <from models.md>

Spec:
<issue body or full acceptance criteria — do not truncate for brevity>

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
- **Verify gate:** lint / test / typecheck must pass before `DONE` — work is not done until verify passes
- **Commit** before DONE — `git add` task files, conventional message referencing issue ID. Do not push.
- Stop before review — orchestrator spawns review; do not run `/code-review`
- Insufficient context → STATUS: NEEDS_CONTEXT (name the gap)

Output:
Commit SHA + message, verify result, diff stat; note concerns or gaps if any. Be thorough when useful — no length cap.
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
```

## review

```
Task ID: <id>
Type: review
Skill: code-review
Model: gpt-5.6-terra-high

Fixed point: <SHA>
Spec: <acceptance criteria for this task only>
Commits since fixed: <from implementer git log>
Verify result: <one line>

Worktree (absolute):
<worktree path>

Constraints:
- **Scoped:** all git — Shell `working_directory` = worktree path ([`worktrees.md#scoped-cwd`](worktrees.md))
- Do not run lint / test / typecheck — implementer passed verify gate before `DONE`; `Verify result` is informational only ([`models.md`](models.md))
- Run adversarial `/code-review` against fixed point; end with Metrics (scoring in code-review step 5)
- Diff committed work per code-review step 1:
  - `git diff <fixed-point>...HEAD` and `git log <fixed-point>..HEAD --oneline`
- If `git diff HEAD --stat` is non-empty (fix-review round): also review `git diff HEAD`

Preflight (mandatory, in order — stop on first failure):
1. Shell `working_directory` = worktree path; `pwd && git branch --show-current`
2. `git rev-parse <fixed-point>`
3. `git log <fixed-point>..HEAD --oneline` OR `git diff HEAD --stat` — at least one must be non-empty
4. If step 3 empty: re-run once with `working_directory` set; if still empty → `STATUS: BLOCKED` (include cwd, branch, fixed point)
5. **Do not** search branches, reflog, other worktrees, parent repos, or grep for feature terms to "find" the diff

Output:
STATUS line first, then Metrics (required — score per code-review step 5), then Changes if not approved.
**Merge gate:** `REVIEW_APPROVED` iff Confidence ≥ 80 **and** Blocking = 0; else `REVIEW_CHANGES_REQUIRED`.
If `REVIEW_CHANGES_REQUIRED`: blocking findings under `Changes:` (cite axis). Be exhaustive when findings warrant it — no length cap.
STATUS: REVIEW_APPROVED | REVIEW_CHANGES_REQUIRED | BLOCKED
## Metrics
Confidence to merge: <0–100>
Standards: <0–100> (<n> findings: <hard> hard, <judgement> judgement)
Spec: <0–100> (<n> findings) | skipped
Blocking: <count>
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
- **Verify gate:** re-run lint / test / typecheck before `DONE`
- Do not commit — post-review commit handles it

Output:
Verify result + `git diff HEAD --stat`; note what you fixed. Be thorough when useful — no length cap.
STATUS: DONE | BLOCKED
```

## commit

Post-review — **second commit**. Runs after `REVIEW_APPROVED`.

```
Task ID: <id>
Type: commit
Skill: implement
Model: composer-2.5

Fixed point: <SHA>
Issue: <#123, if any>

Working directory (absolute):
<worktree path>

Commit fix-review changes — git add task files + conventional message referencing issue ID.
If working tree clean after approval: `STATUS: DONE` with final SHA (implement commit stands).
Do not push unless spec says to.

Constraints:
- **Scoped:** every Shell/git call — `working_directory` = path above ([`worktrees.md#scoped-cwd`](worktrees.md))

Output:
Commit SHA (or "unchanged" + HEAD SHA).
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
Outcome + key command output; include diagnostics when something failed or was non-obvious. Be thorough when useful — no length cap.
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
Worktree path, branch, base SHA (and any setup notes if useful).
STATUS: DONE | BLOCKED
```

## prd

```
Task ID: <id>
Type: prd
Skill: to-prd
Model: gpt-5.6-terra-high

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

## spec

Main-flow sibling of `prd` — ask-matt path uses `/to-spec` then `/to-tickets`.

```
Task ID: <id>
Type: spec
Skill: to-spec
Model: gpt-5.6-terra-high

Context:
<grilling decisions, constraints, linked wayfinder decisions — structured brief, not chat dump>

Explore summary:
<from explore worker, or "none">

Seams (if pre-agreed):
<list, or "propose at highest existing seam">

Constraints:
- Synthesize — do not interview user (frontier confirms seams)
- Prefer existing seams; propose new ones only at the highest point; ideal count is one
- Do not publish
- Unclear seams → STATUS: NEEDS_USER_INPUT
- Use project glossary / ADR vocabulary from explore summary

Output:
1. Proposed seams (short list for frontier confirm)
2. Full spec markdown (to-spec template: Problem, Solution, User Stories, Implementation Decisions, Testing Decisions, Out of Scope, Further Notes)
STATUS: DONE | NEEDS_USER_INPUT
```

## issues

```
Task ID: <id>
Type: issues
Skill: to-issues
Model: gpt-5.6-terra-high

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

## tickets

Main-flow sibling of `issues` — ask-matt path after an approved `/to-spec`.

```
Task ID: <id>
Type: tickets
Skill: to-tickets
Model: gpt-5.6-terra-high

Approved spec:
<full approved to-spec body, or path + explore summary that fetched it>

Explore summary:
<optional — glossary / ADR / prefactor notes>

Constraints:
- Draft tracer-bullet vertical slices — each demoable, one context window, with blocking edges
- Prefactor tickets first when needed; wide refactors → expand–contract sequence (not forced vertical)
- Do not quiz user; frontier confirms granularity / deps
- Do not publish — skip to-tickets steps 4–5
- No stale file paths or code snippets (prototype decision snippets OK if noted)

Output:
Numbered list, each ticket:
- Title
- Blocked by (or "None")
- What it delivers (end-to-end behaviour)
- Acceptance criteria (checkbox list)
STATUS: DONE | NEEDS_USER_INPUT
```

## wayfinder-chart

On-ramp when the effort is too foggy for one-session `/to-spec`. Drafts the **shared map** + decision tickets — decisions, not deliverables. Sol already ran destination + breadth-first Q&A in the orchestrator chat; this worker only synthesizes. Sol confirms the draft; `shell` publishes to the tracker.

```
Task ID: <id>
Type: wayfinder-chart
Skill: wayfinder
Model: gpt-5.6-terra-high

Destination (from Sol grill):
<one or two lines — what reaching the end of this map looks like>

Notes (from Sol grill):
<domain; skills every session should consult; standing preferences>

Frontier decisions (from breadth-first grill):
<sharp questions takeable now — title + type + one-line Question each>

Fog (Not yet specified):
<in-scope but not yet sharp enough to ticket>

Out of scope:
<ruled beyond the destination, if any>

Explore summary:
<optional>

Constraints:
- Skill: wayfinder — **chart** mode only; do not resolve tickets
- Draft map body + child ticket drafts — do not publish (frontier confirms, shell creates)
- Each ticket: title, wayfinder type (research | prototype | grilling | task), Question body, proposed Blocked by (titles)
- Ticket when the question is sharp; fog stays in Not yet specified
- Refer by ticket **name**, never bare ids
- If no fog and the whole journey fits one session → STATUS: NEEDS_USER_INPUT (suggest skip map → to-spec)

Output:
1. Map draft (Destination, Notes, Decisions so far empty, Not yet specified, Out of scope)
2. Numbered ticket drafts (name, type, HITL|AFK, Question, Blocked by)
STATUS: DONE | NEEDS_USER_INPUT
```

## wayfinder-research

AFK resolve of one `wayfinder:research` ticket. Findings file + resolution text for shell to post/close.

```
Task ID: <id>
Type: wayfinder-research
Skill: research
Model: gpt-5.6-terra-high

Map: <map issue name + URL/id>
Ticket: <ticket name + URL/id>
Question:
<verbatim ## Question from the ticket>

Working directory (absolute):
<repo root>

Constraints:
- Skill: research — primary sources only; cite each claim
- Write findings Markdown on a throwaway `research/<slug>` branch (or repo convention); return path
- Do not close the ticket or edit the map — shell does that after STATUS
- One ticket only

Output:
Findings path + resolution answer (gist for Decisions-so-far + pointer to findings). Be as thorough as the research warrants — no length cap.
STATUS: DONE | BLOCKED
```

## wayfinder-record

Shell after a ticket resolves (HITL on Sol or AFK worker). Posts resolution, closes ticket, updates map index; optionally creates newly graduated tickets.

```
Task ID: <id>
Type: wayfinder-record
Model: composer-2.5

Working directory (absolute):
<repo root>

Map: <map name + URL/id>
Ticket: <ticket name + URL/id>
Resolution:
<answer comment body — or path to research findings + gist>

Graduate (optional):
<new ticket drafts to create, or "none">
Fog to clear (optional):
<Not yet specified lines to remove, or "none">

Constraints:
- **Scoped:** Shell `working_directory` = path above
- Post resolution comment on ticket; close ticket; append one Decisions-so-far line on map (name-link — gist); never restate full decision on the map
- Create-then-wire any Graduate tickets; clear graduated fog lines
- Refer by **name** in map/comments

Output:
Ticket closed + map updated; new ticket names if any. Include command/API notes when useful — no length cap.
STATUS: DONE | BLOCKED
```
