#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURSOR="${HOME}/.cursor"

mkdir -p "${CURSOR}/skills"

ln -sfn "${ROOT}/skills/orchestrator" "${CURSOR}/skills/orchestrator"

echo "Installed minion-orchestrator:"
echo "  ${CURSOR}/skills/orchestrator -> ${ROOT}/skills/orchestrator"
echo ""
echo "Opt in with /orchestrate or 'orchestrator on' in any project."
