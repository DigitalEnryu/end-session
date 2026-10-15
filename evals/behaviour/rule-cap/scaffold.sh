#!/usr/bin/env bash
set -e
cat > CLAUDE.md <<'EOF'
# test

## Learned rules

<!-- Maintained by the end-session skill. Max 15. -->

- Rule number 1: always check thing 1 before step 1. <!-- end-session · promoted 2026-02-11 · evidence: learning-log.md 2026-01-02 -->
- Rule number 2: always check thing 2 before step 2. <!-- end-session · promoted 2026-03-12 · evidence: learning-log.md 2026-01-03 -->
- Rule number 3: always check thing 3 before step 3. <!-- end-session · promoted 2026-04-13 · evidence: learning-log.md 2026-01-04 -->
- Rule number 4: always check thing 4 before step 4. <!-- end-session · promoted 2026-05-14 · evidence: learning-log.md 2026-01-05 -->
- Rule number 5: always check thing 5 before step 5. <!-- end-session · promoted 2026-06-15 · evidence: learning-log.md 2026-01-06 -->
- Rule number 6: always check thing 6 before step 6. <!-- end-session · promoted 2026-07-16 · evidence: learning-log.md 2026-01-07 -->
- Rule number 7: always check thing 7 before step 7. <!-- end-session · promoted 2026-08-17 · evidence: learning-log.md 2026-01-08 -->
- Rule number 8: always check thing 8 before step 8. <!-- end-session · promoted 2026-01-18 · evidence: learning-log.md 2026-01-09 -->
- Rule number 9: always check thing 9 before step 9. <!-- end-session · promoted 2026-02-10 · evidence: learning-log.md 2026-01-01 -->
- Rule number 10: always check thing 10 before step 10. <!-- end-session · promoted 2026-03-11 · evidence: learning-log.md 2026-01-02 -->
- Rule number 11: always check thing 11 before step 11. <!-- end-session · promoted 2026-04-12 · evidence: learning-log.md 2026-01-03 -->
- Rule number 12: always check thing 12 before step 12. <!-- end-session · promoted 2026-05-13 · evidence: learning-log.md 2026-01-04 -->
- Rule number 13: always check thing 13 before step 13. <!-- end-session · promoted 2026-06-14 · evidence: learning-log.md 2026-01-05 -->
- Rule number 14: always check thing 14 before step 14. <!-- end-session · promoted 2026-07-15 · evidence: learning-log.md 2026-01-06 -->
- Rule number 15: always check thing 15 before step 15. <!-- end-session · promoted 2026-08-16 · evidence: learning-log.md 2026-01-07 -->
EOF
cat > learning-log.md <<'EOF'
# Learning log · test

## 2026-01-01 · test · skills: none
**Session goal:** Old rules.
**Successes:**
- (none)
**Mistakes / wrong turns:**
- [PROMOTED 2026-02-11 -> CLAUDE.md] root cause 1 · 3rd occurrence · rule: "Rule number 1..." · status: HELD 2026-09-02
- [PROMOTED 2026-03-12 -> CLAUDE.md] root cause 2 · 3rd occurrence · rule: "Rule number 2..." · status: HELD 2026-09-03
- [PROMOTED 2026-04-13 -> CLAUDE.md] root cause 3 · 3rd occurrence · rule: "Rule number 3..." · status: HELD 2026-09-04
- [PROMOTED 2026-05-14 -> CLAUDE.md] root cause 4 · 3rd occurrence · rule: "Rule number 4..." · status: HELD 2026-09-05
- [PROMOTED 2026-06-15 -> CLAUDE.md] root cause 5 · 3rd occurrence · rule: "Rule number 5..." · status: HELD 2026-09-06
- [PROMOTED 2026-07-16 -> CLAUDE.md] root cause 6 · 3rd occurrence · rule: "Rule number 6..." · status: HELD 2026-09-07
- [PROMOTED 2026-08-17 -> CLAUDE.md] root cause 7 · 3rd occurrence · rule: "Rule number 7..." · status: HELD 2026-09-08
- [PROMOTED 2026-01-18 -> CLAUDE.md] root cause 8 · 3rd occurrence · rule: "Rule number 8..." · status: HELD 2026-09-09
- [PROMOTED 2026-02-10 -> CLAUDE.md] root cause 9 · 3rd occurrence · rule: "Rule number 9..." · status: HELD 2026-09-01
- [PROMOTED 2026-03-11 -> CLAUDE.md] root cause 10 · 3rd occurrence · rule: "Rule number 10..." · status: HELD 2026-09-02
- [PROMOTED 2026-04-12 -> CLAUDE.md] root cause 11 · 3rd occurrence · rule: "Rule number 11..." · status: HELD 2026-09-03
- [PROMOTED 2026-05-13 -> CLAUDE.md] root cause 12 · 3rd occurrence · rule: "Rule number 12..." · status: HELD 2026-09-04
- [PROMOTED 2026-06-14 -> CLAUDE.md] root cause 13 · 3rd occurrence · rule: "Rule number 13..." · status: HELD 2026-09-05
- [PROMOTED 2026-07-15 -> CLAUDE.md] root cause 14 · 3rd occurrence · rule: "Rule number 14..." · status: HELD 2026-09-06
- [PROMOTED 2026-08-16 -> CLAUDE.md] root cause 15 · 3rd occurrence · rule: "Rule number 15..." · status: HELD 2026-09-07
**New roadblocks:**
- (none)
**Solutions found:**
- (none)

## 2026-06-02 · test · skills: none
**Session goal:** Write a CSV parser.
**Successes:**
- (none)
**Mistakes / wrong turns:**
- [OPEN] Said a script worked without running it; it crashed when the user ran it.
**New roadblocks:**
- (none)
**Solutions found:**
- (none)

## 2026-07-18 · test · skills: none
**Session goal:** Fix the date formatter.
**Successes:**
- (none)
**Mistakes / wrong turns:**
- [OPEN] Said a script worked without running it; it crashed when the user ran it.
**New roadblocks:**
- (none)
**Solutions found:**
- (none)

EOF
