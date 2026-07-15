# Model scorecard

Reference only — not needed at spawn time. Jul 2026 benchmarks.

## CursorBench 3.2 (agentic coding)

| Model | Score | Cost/task | API ($/M in → out) |
|-------|-------|-----------|---------------------|
| `composer-2.5` | 56.1% | $0.44 | $0.50 → $2.50 |
| `gpt-5.6-terra-high` | 59.2% | $1.36 | $2.50 → $15.00 |
| `glm-5.2-high` | 51.5% | $1.19 | $1.40 → $4.40 |
| `claude-opus-4-8-thinking-high` | 58.0% | $3.15 | $5.00 → $25.00 |
| `gpt-5.6-sol-max` (frontier) | 67.2% | $5.22 | $5.00 → $30.00 |

Opus High maps to CursorBench Opus 4.8 High; Max effort ≈ 62.3%.

## Taste (UI only)

Design Arena Frontend Elo — GLM 5.2 Max 1595 → route UI to `glm-5.2-high` despite lower CursorBench agent score.

## Routing precedence (implement)

CursorBench score > taste > cost. GLM exception for UI.
