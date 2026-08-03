# Model/provider configuration

Use provider-local `.minion-models.md` files so the delegation policy stays harness-agnostic.

## Config shape

Each project config should have three sections:

1. **Frontier → Minion** — when the session model is the frontier/planner, delegate downward.
2. **Escalation** — when the session model is a worker, handle the task yourself and escalate only on genuine competence gaps.
3. **Alias block** — concrete models for the provider.

## Aliases

```yaml
frontier: strongest planner/orchestrator model
fast:     cheap/mechanical worker
code:     normal implementation worker
deep:     strongest implementation/reasoning worker
critic:   adversarial review worker
```

A provider may map multiple aliases to the same concrete model. If a harness cannot choose models per delegate, treat aliases as intent hints and use the current session model.

## Provider resolution

Use the first available source:

1. explicit user instruction, e.g. "use Cursor for this repo" or "send review to Kimi"
2. project-local `.minion-models.md`
3. visible harness/session facts, e.g. environment variables or active model name
4. baseline files in `baselines/<provider>/.minion-models.md`
5. ask once, or do not delegate

Do not assume one project's provider applies to another project.

## Baselines

### OpenAI Codex

Path: `baselines/openai-codex/.minion-models.md`

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
```

Codex baseline uses only the GPT-5.6 family: Sol as the Fable-like frontier, Sol/Terra as Opus-like deep/critic, and Luna/Terra as Sonnet-like fast/code. Research: `research/openai-model-role-equivalents.md`.

### Cursor

Path: `baselines/cursor/.minion-models.md`

```yaml
provider: cursor
frontier: gpt-5.6-sol-max
fast: composer-2.5
code: composer-2.5
deep: cursor-grok-4.5-high
critic: kimi-k3
```

Cursor baseline uses Sol as frontier, Composer as mechanical/code minion, Grok for hard implementation/UI, and Kimi K3 for critique.

## Project-local config

Copy a baseline into a repo root:

```bash
cp baselines/openai-codex/.minion-models.md .minion-models.md
# or
cp baselines/cursor/.minion-models.md .minion-models.md
```

Then edit model names for that project.

## Choosing delegation mode from the session model

- session model matches `frontier`: use Frontier → Minion mode
- session model matches `fast`/`code`/`deep`/`critic`: use Escalation mode
- unknown session model: default to Escalation mode and delegate sparingly
