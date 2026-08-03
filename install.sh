#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${ROOT}/skills/orchestrator"

usage() {
  cat <<'USAGE'
Usage:
  ./install.sh codex            # ~/.codex/skills/orchestrator
  ./install.sh cursor           # ~/.cursor/skills/orchestrator
  ./install.sh pi               # ~/.pi/agent/skills/orchestrator
  ./install.sh dir <path>       # <path>/orchestrator

Environment:
  MINION_SKILLS_DIR=/path/to/skills  # used when no target is given
USAGE
}

warn_legacy_pi_personas() {
  local legacy_dir="${HOME}/.pi/agent/agents"
  if [[ -d "${legacy_dir}" ]]; then
    echo "Note: orchestrator personas are bundled in the skill at personas/."
    echo "      Legacy Pi personas in ${legacy_dir} are not used by this installer."
  fi
}

link_into() {
  local skills_dir="$1"
  mkdir -p "${skills_dir}"
  ln -sfn "${SRC}" "${skills_dir}/orchestrator"
  echo "Installed minion-orchestrator:"
  echo "  ${skills_dir}/orchestrator -> ${SRC}"
}

TARGET="${1:-auto}"
case "${TARGET}" in
  codex)
    link_into "${HOME}/.codex/skills"
    ;;
  cursor)
    link_into "${HOME}/.cursor/skills"
    ;;
  pi)
    link_into "${HOME}/.pi/agent/skills"
    ;;
  dir)
    if [[ $# -lt 2 ]]; then
      usage >&2
      exit 2
    fi
    link_into "$2"
    ;;
  auto)
    if [[ -n "${MINION_SKILLS_DIR:-}" ]]; then
      link_into "${MINION_SKILLS_DIR}"
    elif [[ -d "${HOME}/.codex" ]]; then
      link_into "${HOME}/.codex/skills"
    elif [[ -d "${HOME}/.pi/agent" ]]; then
      link_into "${HOME}/.pi/agent/skills"
    elif [[ -d "${HOME}/.cursor" ]]; then
      link_into "${HOME}/.cursor/skills"
    else
      echo "Could not auto-detect a harness skills directory." >&2
      usage >&2
      exit 2
    fi
    ;;
  -h|--help|help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown target: ${TARGET}" >&2
    usage >&2
    exit 2
    ;;
esac

echo ""
warn_legacy_pi_personas
echo ""
echo "Opt in with /orchestrate or 'orchestrator on'."
