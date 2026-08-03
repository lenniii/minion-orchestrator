# OpenAI GPT-5.6 equivalents for Fable / Opus / Sonnet delegation

Date: 2026-07-31

## Question

What OpenAI GPT-5.6 model configuration is closest to the Claude-style delegation stack:

- **Fable** — frontier/planner/orchestrator
- **Opus** — complex implementation / hard debugging / architecture / critique
- **Sonnet** — mechanical work / exploration / routine edits

## Primary sources consulted

- OpenAI model docs: <https://platform.openai.com/docs/models>
- OpenAI reasoning guide: <https://platform.openai.com/docs/guides/reasoning>
- OpenAI text generation guide: <https://platform.openai.com/docs/guides/text>
- OpenAI latest-model guide for GPT-5.6: <https://platform.openai.com/docs/guides/latest-model?model=gpt-5.6>

## Source facts

OpenAI's model docs say that if unsure where to start, use **GPT-5.6 Sol**, described as the flagship model for complex reasoning and coding. They recommend **GPT-5.6 Terra** to balance intelligence and cost, and **GPT-5.6 Luna** for cost-sensitive, high-volume workloads. The same docs describe GPT-5.6 Sol as a frontier model for complex professional work, Terra as balancing intelligence and cost, and Luna as optimized for cost-sensitive workloads. Source: OpenAI model docs.

OpenAI's model docs list these API IDs and costs:

| Model | Official positioning | API ID | Input | Output | Context | Max output |
|-------|----------------------|--------|-------|--------|---------|------------|
| GPT-5.6 Sol | Frontier model for complex professional work | `gpt-5.6-sol`; alias `gpt-5.6` | $5 / MTok | $30 / MTok | 1.05M | 128K |
| GPT-5.6 Terra | Balances intelligence and cost | `gpt-5.6-terra` | $2 / MTok | $12 / MTok | 1.05M | 128K |
| GPT-5.6 Luna | Optimized for cost-sensitive workloads | `gpt-5.6-luna` | $0.20 / MTok | $1.20 / MTok | 1.05M | 128K |

Source: OpenAI model docs.

The reasoning guide says to start with `gpt-5.6` for most reasoning workloads; use `gpt-5.6-sol` with `reasoning.mode: pro` for the highest-intelligence API option on challenging problems that can tolerate latency; use `gpt-5.6-terra` for lower cost; and `gpt-5.6-luna` for lowest cost and latency. Source: OpenAI reasoning guide.

The reasoning guide says `reasoning.effort` guides how much the model thinks. Lower effort favors speed and lower token usage; higher effort thinks more completely for higher-quality responses. It positions:

- `low` for efficient reasoning with modest latency increase; tool-use, planning, search, multi-step decisions while optimizing speed/cost.
- `medium` for quality and reliability with planning, complex reasoning, judgement; default for most workloads; includes agentic coding and long-horizon delegation.
- `high` for hard reasoning, complex debugging, deep planning, and high-value tasks where quality matters more than latency.
- `xhigh` for deep research, asynchronous workflows, security/code review, and challenging coding workflows.
- `max` for the most complex tasks.

Source: OpenAI reasoning guide.

The reasoning guide says GPT-5.6 supports standard and pro reasoning modes in the Responses API. `standard` is default; `pro` does more model work for difficult tasks and increases token usage/cost. Source: OpenAI reasoning guide.

The text guide recommends the Responses API for reasoning models, saying reasoning models perform better and demonstrate higher intelligence when used with Responses. Source: OpenAI text generation guide.

## Recommended GPT-5.6 analogy

| Claude role | Delegation alias | GPT-5.6 equivalent | Why |
|-------------|------------------|--------------------|-----|
| Fable | `frontier` | `gpt-5.6-sol`, usually `reasoning.effort: high`; use `reasoning.mode: pro` only for hardest/stalled planning | Official flagship/frontier model for complex reasoning and coding. |
| Opus | `deep` / `critic` | `gpt-5.6-sol` with `high|xhigh`; `gpt-5.6-terra` with `high` when cost matters | Sol is the highest-intelligence family member; high/xhigh are explicitly for hard debugging, code review, and challenging coding. |
| Sonnet | `fast` / `code` | `gpt-5.6-luna` with `low` for mechanical work; `gpt-5.6-terra` with `medium` for routine coding | Luna is cost-sensitive/low-latency; Terra balances intelligence and cost for normal implementation. |

## Baseline config

```yaml
provider: openai-codex
frontier: gpt-5.6-sol
fast: gpt-5.6-luna
code: gpt-5.6-terra
deep: gpt-5.6-sol
critic: gpt-5.6-sol
reasoning:
  frontier: high
  fast: low
  code: medium
  deep: high
  critic: xhigh
pro_mode:
  frontier: only for stalled/high-value planning
  deep: only for hardest implementation/debugging
  critic: only for high-stakes review
```
