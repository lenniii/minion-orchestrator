#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURSOR="${HOME}/.cursor"

mkdir -p "${CURSOR}/agents" "${CURSOR}/skills"

ln -sf "${ROOT}/agents/minion.md" "${CURSOR}/agents/minion.md"
ln -sfn "${ROOT}/skills/orchestrator" "${CURSOR}/skills/orchestrator"

echo "Installed minion-orchestrator:"
echo "  ${CURSOR}/agents/minion.md -> ${ROOT}/agents/minion.md"
echo "  ${CURSOR}/skills/orchestrator -> ${ROOT}/skills/orchestrator"
echo ""
echo "Opt in with /orchestrate or 'orchestrator on' in any project."
