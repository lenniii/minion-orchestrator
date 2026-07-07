# Models

Two roles — do not conflate:

| Role | Who | Model |
|------|-----|-------|
| **Frontier** | You, running this skill | `claude-fable-5` — orchestrate only, never spawn as a worker |
| **Worker** | Every spawned `generalPurpose` / `shell` / `explore` task | Per rules below |

Record each worker's model in the board `Notes` column.

## Scorecard (workers)

Higher = better. Scores derived from public benchmarks (Jul 2026) — not hand-tuned.

| Model | Cost | Intelligence | Taste | API ($/M in → out) |
|-------|------|--------------|-------|---------------------|
| `composer-2.5` | 10 | 7 | 5† | $0.50 → $2.50 |
| `glm-5.2-high` | 9 | 7 | 9 | $1.40 → $4.40 |
| `composer-2.5-fast` | 7 | 7 | 5† | $3.00 → $15.00 |
| `claude-sonnet-5-thinking-high` | 7 | 8 | 7 | $3.00 → $15.00 ($2 → $10 promo through Aug 2026) |
| `gpt-5.5-low` | 5 | 6 | 5 | $5.00 → $30.00 |
| `claude-opus-4-8-thinking-high` | 4 | 10 | 7 | $5.00 → $25.00 |

† Composer has no Design Arena row — taste estimated.

Frontier `claude-fable-5`: ~$10 → $50, orchestrator only.

### How scores are computed

**Cost** — rank by Cursor [API output $/M](https://cursor.com/docs/models-and-pricing). 10 = cheapest. Composer draws from a separate, more generous pool on individual plans.

**Intelligence** — normalized from [SWE-bench Pro](https://www.morphllm.com/swe-bench-pro) pass@1 (agentic repo fixes):

```
intel = round(6 + (SWE-Pro% − 58.6) / (69.2 − 58.6) × 4)
```

| Model | SWE-Pro % | Intel |
|-------|-----------|-------|
| Opus 4.8 | 69.2 | 10 |
| Sonnet 5 | 63.2 | 8 |
| Composer 2.5 | ~62 | 7 |
| GLM 5.2 | 62.1 | 7 |
| GPT-5.5 | 58.6 | 6 |

Composer ~62 from [AA Coding Agent Index](https://artificialanalysis.ai/articles/cursor-composer-2-5-coding-agent-index). Harness varies — treat as approximate.

**Taste** — normalized from [Design Arena Code: Frontend](https://notes.designarena.ai/how-glm-5-2-beat-fable-5-at-website-design/) Elo (blind human preference on UI code). No benchmark for API design or copy — Sonnet/Opus taste scores are estimates.

| Model | Frontend Elo | Taste |
|-------|--------------|-------|
| GLM 5.2 Max | 1595 | 9 |
| Opus 4.8 Thinking | 1561 | 7 |
| Sonnet 5 | — | 7 (est.) |
| GPT-5.5 | — | 5 (est.) |

When axes conflict: **Intelligence > Taste > Cost**. Cost is the tie-breaker only.

`low` / `thinking-high` change token volume, not per-token price.

## Route workers

| Work | Model | Why |
|------|-------|-----|
| Bulk / mechanical implement | `composer-2.5` | Intel 7, cost 10 |
| User-facing UI | `glm-5.2-high` | Taste 9 on Design Arena |
| User-facing API, copy, UX flows (taste ≥ 7) | `claude-sonnet-5-thinking-high` | Intel 8, taste floor |
| Review | `claude-opus-4-8-thinking-high` | Intel 10, +7 pts SWE-Pro over field |
| Optional second review opinion | `glm-5.2-high` | Intel 7, cheaper than GPT-5.5 |
| Commit, issues, trivial docs | `glm-5.2-high` | Cost 9, sufficient for admin |
| Verify — lint, test, typecheck | `composer-2.5` (`shell` subagent) | Cost 10 |
| Explore — read-only map | `composer-2.5` (`explore` subagent) | Cost 10 |

Use `composer-2.5-fast` when verify/explore latency matters — same intelligence, 6× token price.

Escalate **one tier** on mediocre output, verify failure, or `BLOCKED`:

`composer-2.5` → `glm-5.2-high` → `claude-sonnet-5-thinking-high` → `claude-opus-4-8-thinking-high` → split or ask user.

Defaults, not limits. User says "use X" → override for that batch.
