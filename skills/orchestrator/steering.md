# Steering

Control in-flight background work without blocking the conversation.

## Commands (user → orchestrator)

| User says | Action |
|-----------|--------|
| "what's running?" | Read state board; summarize `in-flight` |
| "stop task \<id\>" | Set `Status: cancelled`; do not spawn dependents |
| "pause task \<id\>" | Set `Status: paused` |
| "resume task \<id\>" | Resume agent by ID from state board `Agent` column |
| "steer \<id\>: \<instruction\>" | Resume agent with new instruction appended |

## On steer / resume

```
Resume agent <agent_id>.

Steer: <instruction>

Continue task <id> from state board spec.
```

## Cancelled tasks

Mark `Phase: cancelled` in state board. Skip `blocked_by` dependents or re-plan.
