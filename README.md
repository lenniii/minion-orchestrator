# minion-orchestrator

A tiny, harness-agnostic **multi-model delegation** skill.

It does not prescribe boards, worktrees, review loops, or Cursor-specific task types. The main thread owns planning, verification, integration, and user communication. Delegates/minions are used only as model-specific helpers.

Worker personas are bundled inside the skill under `skills/orchestrator/personas/` so persona prompts, delegation policy, and model routing version together. Do not depend on a separate `~/.pi/agent/agents/` catalogue.

## Install

```bash
./install.sh codex       # ~/.codex/skills/orchestrator
./install.sh cursor      # ~/.cursor/skills/orchestrator
./install.sh pi          # ~/.pi/agent/skills/orchestrator
./install.sh dir <path>  # any skills directory
```

If no target is given, `install.sh` auto-detects a known harness or uses `$MINION_SKILLS_DIR`.

## Usage

Ask for delegation explicitly:

- `/orchestrate`
- `delegate this`
- `use minions`
- `use <provider/model> for this part`

Opt out:

- `/direct`
- `skip minions`
- `handle this yourself`

## Configuration

Each project can choose its own provider with a repo-local `.minion-models.md`.

Start from a baseline:

```bash
cp baselines/openai-codex/.minion-models.md .minion-models.md
# or
cp baselines/cursor/.minion-models.md .minion-models.md
```

The config follows the same shape as the Claude/Fable delegation pattern:

1. **Frontier → Minion** — when the session model is the frontier/planner, delegate downward.
2. **Escalation** — when the session model is a worker, handle the task yourself and escalate only on genuine competence gaps.
3. **Alias block** — concrete models for `frontier`, `fast`, `code`, `deep`, and `critic`.

Provider-specific mappings live in `skills/orchestrator/models.md` and the baseline files.

## Files

| File | Purpose |
|------|---------|
| `skills/orchestrator/SKILL.md` | Entry point |
| `skills/orchestrator/delegation.md` | Delegation policy |
| `skills/orchestrator/models.md` | Provider/model alias configuration |
| `skills/orchestrator/personas/` | Worker persona prompt contracts |
| `baselines/openai-codex/.minion-models.md` | Codex baseline |
| `baselines/cursor/.minion-models.md` | Cursor baseline |

## License

MIT
