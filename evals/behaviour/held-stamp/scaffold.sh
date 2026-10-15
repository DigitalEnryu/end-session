#!/usr/bin/env bash
set -e
cat > CLAUDE.md <<'EOF'
# test

## Learned rules

<!-- Maintained by the end-session skill. Max 15. -->

- Run a script before saying it works. <!-- end-session · promoted 2026-08-26 · evidence: learning-log.md 2026-06-02, 2026-07-18, 2026-08-26 -->
EOF
cat > learning-log.md <<'EOF'
# Learning log · test

## 2026-06-02 · test · skills: none
**Session goal:** Write a CSV parser.
**Successes:**
- (none)
**Mistakes / wrong turns:**
- [PROMOTED 2026-08-26 -> CLAUDE.md] Said a script worked without running it · 3rd occurrence (cf. 2026-06-02, 2026-07-18, 2026-08-26) · rule: "Run a script before..." · status: UNVERIFIED
**New roadblocks:**
- (none)
**Solutions found:**
- (none)
EOF
