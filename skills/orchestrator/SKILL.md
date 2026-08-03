---
name: orchestrator
description: Simple harness-agnostic multi-model delegation. Use for /orchestrate, delegate this, use minions, or explicit requests to route work to another model/provider.
---

# Multi-model delegation

This skill is intentionally small. It provides routing rules and model/provider configuration; it does **not** impose a project-management workflow.

When triggered, read:

1. [`delegation.md`](delegation.md) — Frontier → Minion and Escalation rules
2. [`models.md`](models.md) — role aliases and provider selection
3. [`personas/README.md`](personas/README.md) — available worker personas
4. project config: `.minion-models.md` in the current repo, if present

## Core rule

The main thread owns:

- understanding the user's request
- planning the work
- deciding what to delegate
- integrating results
- verification
- user communication

Delegates/minions return compact syntheses: findings, diffs, patches, guidance, or blockers. Never ask delegates to dump raw logs or take over the conversation.

## Provider selection

On orchestration start, always ask the user which **session provider** to use for this run (for example: `openai-codex`, `cursor`, or another provider) before spawning delegates.

Resolve provider/model mappings in this order:

1. Explicit user instruction in the current chat
2. Project-local `.minion-models.md`
3. Harness/session facts if visible, e.g. provider/model environment variables
4. Baseline files under `baselines/<provider>/.minion-models.md`
5. Global defaults in [`models.md`](models.md)
6. If still unknown, ask once or handle directly without delegation

Different projects may use different providers. Do not assume the provider from another repo applies here.

## Minimal loop

1. Decide whether delegation is useful.
2. Resolve aliases: `frontier`, `fast`, `code`, `deep`, `critic`.
3. Choose the worker persona from `personas/` independently from the model alias.
4. Delegate only the subproblem, with an explicit `model` when the harness supports it.
5. Ask for compact output.
6. Verify/integrate in the main thread.
7. Report to the user yourself.

Opt out on `/direct`, `skip minions`, or `handle this yourself`.
