#!/usr/bin/env bash
set -euo pipefail

mkdir -p root-cause-lab
cd root-cause-lab

mkdir -p .codex/agents
mkdir -p .codex/skills/incident-intake
mkdir -p .codex/skills/service-slowdown-triage/references
mkdir -p .codex/skills/service-slowdown-triage/scripts
mkdir -p .codex/skills/fd-leak-triage/references
mkdir -p .codex/skills/fd-leak-triage/scripts

mkdir -p bin
mkdir -p templates
mkdir -p collectors/linux
mkdir -p collectors/jvm
mkdir -p collectors/fd
mkdir -p runbooks/service-slowdown
mkdir -p runbooks/fd-leak
mkdir -p docs
mkdir -p prompts
mkdir -p incidents
mkdir -p examples

touch README.md
touch AGENTS.md
touch .gitignore
touch incidents/.gitkeep
