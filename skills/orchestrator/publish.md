# Publish phase

After user approves `/to-issues` slice list. Orchestrator quizzed; minions publish in background.

Track per [`state.md`](state.md).

## Cycle

Dependency order — one publish minion at a time, `run_in_background: true`. On each completion: record issue URL/ID, spawn next with updated `Blocked by`.

1. Spawn `/minion` `create-issue`, `glm-5.2-high`, `Skill: to-issues`
2. On complete → update **Published** table → next slice
3. Do not block conversation

**Done when:** every slice published.

## Auto-handoff

When last publish minion completes — **without asking**:

1. Add each published issue to state board as `implement` task (`Status: pending`, respect `Blocked by`)
2. Spawn implement minions for tasks with no blockers per [`review-loop.md`](review-loop.md)
3. Tell user: "Published N issues; implement minions spawned for unblocked tasks."

If `/setup-matt-pocock-skills` not done, stop after publish and ask user to run setup before implement.

## Spawn prompt

```
Task ID: publish-<n>
Type: create-issue
Skill: to-issues

Spec:
Publish this approved slice to the issue tracker.

Slice:
<title and description>

Blocked by:
<issue URLs/IDs or "None">

Parent:
<parent issue ref if any>

Use to-issues body template and triage label.

Output:
Issue URL/ID and title.
```
