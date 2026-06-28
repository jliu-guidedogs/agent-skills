#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILLS_SRC="${REPO_ROOT}/skills"

CORE_SKILLS=(
  thought-companion
  brainstorm-diverge-converge
  socratic
  decision-helper
  idea-evaluator
  grill-me
  deep-understanding
  handoff
  grill-architecture-decisions
)

OPTIONAL_SKILLS=(
  graphify
)

WITH_OPTIONAL=false

usage() {
  cat <<EOF
Usage: $(basename "$0") [--with-optional]

Install agent skills from ${SKILLS_SRC} into ~/.cursor/skills, ~/.claude/skills,
and ~/.agents/skills.

  --with-optional   Also install optional skills (${OPTIONAL_SKILLS[*]})
  --with-graphify   Alias for --with-optional
  -h, --help        Show this help
EOF
}

for arg in "$@"; do
  case "$arg" in
    --with-optional|--with-graphify)
      WITH_OPTIONAL=true
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $arg" >&2
      usage >&2
      exit 1
      ;;
  esac
done

skills_to_install=("${CORE_SKILLS[@]}")
if [[ "$WITH_OPTIONAL" == true ]]; then
  skills_to_install+=("${OPTIONAL_SKILLS[@]}")
fi

install_dir() {
  local target="$1"
  mkdir -p "$target"
  for name in "${skills_to_install[@]}"; do
    local skill="${SKILLS_SRC}/${name}"
    if [[ -f "${skill}/SKILL.md" ]]; then
      ln -sfn "$skill" "${target}/${name}"
      echo "linked ${name} -> ${target}/${name}"
    else
      echo "warning: missing ${skill}/SKILL.md" >&2
    fi
  done
}

echo "Installing core thinking stack (${#CORE_SKILLS[@]} skills)..."
if [[ "$WITH_OPTIONAL" == true ]]; then
  echo "Including optional skills: ${OPTIONAL_SKILLS[*]}"
fi

install_dir "${HOME}/.cursor/skills"
install_dir "${HOME}/.claude/skills"
install_dir "${HOME}/.agents/skills"

echo "Done. Restart Cursor, Claude Code, or start a new agent session to pick up skills."
