# Model scorecard

Reference only — not needed at spawn time. Jul 2026 benchmarks.

## CursorBench 3.2 (agentic coding)

| Model | Score | Cost/task | API ($/M in → out) |
|-------|-------|-----------|---------------------|
| `composer-2.5` | 56.1% | $0.44 | $0.50 → $2.50 |
| `gpt-5.6-terra-high` | 59.2% | $1.36 | $2.50 → $15.00 |
| `cursor-grok-4.5-high` | 66.7%* | $1.51 | $2.00 → $6.00 |
| `claude-opus-4-8-thinking-high` | 58.0% | $3.15 | $5.00 → $25.00 |
| `gpt-5.6-sol-max` (frontier) | 67.2% | $5.22 | $5.00 → $30.00 |

Opus High maps to CursorBench Opus 4.8 High; Max effort ≈ 62.3%.

## Taste (UI only)

Grok 4.5 trained on Cursor interaction data — route UI and complex implement to `cursor-grok-4.5-high`.

\* CursorBench score discounted — earlier Cursor codebase snapshot was in training data ([Cursor blog](https://cursor.com/blog/grok-4-5)).

## Routing precedence (implement)

CursorBench score > taste > cost. Grok 4.5 for complex implement / UI.
