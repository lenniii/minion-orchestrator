# Model routing

Pick `model` on each Task spawn. Minion default (`glm-5.2-high`) is fallback only.

## Review loop roles

| Role | Type | Model | Skill |
|------|------|-------|-------|
| Implement | `implement` | `glm-5.2-high` | `implement` |
| Review | `review` | `claude-opus-4-8-thinking-high` | `code-review` |
| Fix review | `fix-review` | `glm-5.2-high` | `tdd` |

Review stays frontier — judgment-heavy. Everything else stays on GLM.

## Ad-hoc minions

| Signal | Model |
|--------|-------|
| Publish, docs, research, grep-and-edit | `glm-5.2-high` |
| Multi-file integration | `glm-5.2-high` |
| Codebase exploration | built-in `explore`, `composer-2.5-fast` |

### Multi-file integration

Work that must **coordinate changes across several files** so they still fit together — not one isolated edit. Examples:

- Wire API + handler + UI + tests for one feature
- Refactor a type used in many call sites
- Fix-review that touches 3+ files from reviewer findings
- Implement task explicitly spanning multiple modules

Still `glm-5.2-high` — same model, broader scope in the spawn prompt.

## Escalation tiers

Orchestrator decides; minion executes.

| Decision | Model |
|----------|-------|
| Default (all minion work) | `glm-5.2-high` |
| `BLOCKED` after GLM retry | `composer-2.5` |
| Repeated review failure | `composer-2.5` implement; review stays Opus |
| Exploration | built-in `explore`, `composer-2.5-fast` |

Never escalate to yourself — only to a different minion or subagent spawn.
