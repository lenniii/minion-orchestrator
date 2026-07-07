# Shell lane

Deterministic checks — **bash subagent**, not minion. No LLM reasoning for lint/typecheck/test runs.

## When

After implement or fix-review minion reports `DONE`, before review spawn.

## Spawn

`subagent_type: bash`, `run_in_background: true`

```
Run verification for task <id>:
- typecheck (project command)
- lint if configured
- relevant test file(s) or test pattern from spec

Report: pass/fail per command with output summary. Do not fix failures.
```

Store result in state board `Notes` as `verify: pass` or `verify: fail`.

## On fail

Orchestrator decides per [`escalation.md`](escalation.md) — re-spawn implement or fix-review minion with failure output. Do not spawn review until `verify: pass`.
