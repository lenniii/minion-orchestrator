# Escalation

You **decide**. Minions **execute**. Never unblock with your own tools.

## Decide → delegate

| Situation | You decide | Delegate |
|-----------|------------|----------|
| `NEEDS_CONTEXT` | Missing context | `explore` or re-spawn with context |
| `BLOCKED` | Retry, split, ask user | Re-spawn per [`models.md`](models.md) |
| `verify: fail` | Retry implement or fix | Re-spawn with bash output |
| 5 review rounds | Split, stronger model, ask user | New spawns |
| User `steer` / `stop` | Apply instruction | [`steering.md`](steering.md) |

## You never

- Read files, grep, edit, test, publish, review yourself
- Resume implementer agent for review — always fresh review minion

## Re-spawn prompt tail

```
Escalation: <decision>
Prior failure: <STATUS and reason>
```

Update state board `Notes`.

## Ask the user

Ambiguous spec, architectural fork, cap hit — ask first. Do not spawn until answered.
