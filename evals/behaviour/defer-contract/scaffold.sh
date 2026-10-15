#!/usr/bin/env bash
set -e
mkdir -p docs/build-log scratch
cat > CLAUDE.md <<'EOF'
# bot

## Session-End Contract
- log: docs/build-log/learning-log.md
- format: standard
- append: bottom
- open-cap: none
- hygiene-allowed: DEFER to the repo's own cleanup scripts. No file tidy here.
- never-touch: anything under scripts/
EOF
cat > docs/build-log/learning-log.md <<'EOF'
# Learning log · bot

## 2026-09-01 · bot · skills: none · clean run, nothing notable
EOF
echo junk > scratch/old.tmp
