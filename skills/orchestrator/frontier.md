# Frontier

**Branch:** planning | orchestration (dispatch rules apply to both)

**Dispatch-only frontier** on `gpt-5.6-sol-max`. **Tight** turns: board, spawn specs, STATUS triage, short user Q&A.

## Sol may do (only these)

| Work | Behaviour |
|------|-----------|
| **`grilling`** | One question at a time; workers cannot see the thread — includes wayfinder destination, breadth-first chart, and HITL ticket Q&A |
| **User Q&A** | Confirm seams, slice granularity, map/ticket drafts, approve/reject — one question per turn |
| **Dispatch** | Decompose, write spawn specs, triage STATUS + one line, post board |

Sol spawns workers only — no `ReadFile`, `Grep`, `Shell`, or repo reads. Paths in spawn `Files:`; issue bodies via shell worker or issue ref in spec.

## Workers handle everything else

Files, explore, CLI, synthesis, implement, review, commit, publish → spawn per [`models.md`](models.md) [`prompts.md`](prompts.md) [`shell.md`](shell.md).

PRD / spec / tickets / wayfinder-chart synthesis → Terra worker when context fits spawn prompt ([`prompts.md`](prompts.md)). Sol quizzes drafts; `shell` publishes after approval.

**Wayfinder Q&A lives on the frontier.** Destination grill, breadth-first chart, and HITL tickets (`grilling` / `prototype` / HITL `task`) are Sol ↔ user in this chat — one question per turn. Never spawn a worker to answer for the human. AFK only: `wayfinder-chart` draft, `wayfinder-research`, `wayfinder-record`, publish shell.

## Planning workflow

**On-ramp — foggy / multi-session** (`/wayfinder`): when the way to the destination isn't visible yet. Decisions, not deliverables. Run the whole on-ramp **inside the orchestrator** (Sol Q&A + worker AFK). When the map clears → hand off to `/to-spec` (never skip straight to `/implement` unless the effort turned out small).

```
wayfinder chart (Sol Q&A in this chat): grill destination + breadth-first frontier
  → wayfinder-chart worker (terra) — draft map + tickets [`prompts.md#wayfinder-chart`](prompts.md)
  → Sol: confirm Destination / Notes / ticket set (short)
  → shell: create map (`wayfinder:map`) + child tickets + wire blocking
  → spawn wayfinder-research per research ticket (parallel) [`prompts.md#wayfinder-research`](prompts.md)

wayfinder work (Sol Q&A in this chat — one HITL ticket at a time; research may parallel):
  → shell/explore: load map (low-res); claim frontier ticket
  → HITL (grilling / prototype / HITL task): Sol drives live with user here
  → AFK research: wayfinder-research worker
  → AFK task: shell (or Sol hands user a precise checklist)
  → wayfinder-record: resolution comment + close + Decisions-so-far; graduate fog → new tickets
  → when no tickets remain: hand off → to-spec worker below
```

Preferred main flow (ask-matt) — idea already holdable in one session, or wayfinder map just cleared:

```
grill (Sol, tight)  — or Context: wayfinder Decisions-so-far + Destination
  → explore worker (composer) if spec/tickets need repo facts
  → to-spec worker (terra) — context in prompt [`prompts.md#spec`](prompts.md)
  → Sol: confirm seams / spec (short)
  → to-tickets worker (terra) — approved spec in prompt [`prompts.md#tickets`](prompts.md)
  → Sol: confirm granularity / deps (short)
  → shell (composer): publish
  → /orchestrate
```

Alternate (legacy `to-prd` / `to-issues`):

```
grill (Sol, tight)
  → explore worker (composer) if PRD/issues need repo facts
  → to-prd worker (terra) — context in prompt
  → Sol: confirm seams / PRD (short)
  → to-issues worker (terra) — approved PRD in prompt
  → Sol: confirm granularity / deps (short)
  → shell (composer): publish
  → /orchestrate
```

**Keep on Sol** when live back-and-forth cannot batch — mid-grill, **all wayfinder Q&A**, first-pass slice quiz. Do not bounce the user to a separate `/wayfinder` session for questions the frontier can ask here.
## Orchestration dispatch

Sol writes spawn specs; minions explore if needed ([`loop.md`](loop.md)). Do not spawn explore from frontier for implement work.

Worktree spawns: absolute path + **scoped** Shell cwd ([`worktrees.md#scoped-cwd`](worktrees.md)).

## Mode detection

**Planning** — deliverable is wayfinder map/decisions, spec/tickets (or legacy PRD/issues), not shipped code.

**Orchestration** — user wants code built. Published issues become worker specs.

"Go build it" / `/orchestrate` → orchestration. Foggy greenfield / huge feature → `/wayfinder` first.