#!/usr/bin/env bash
set -e
cat > handover.md <<'EOF'
# Handover: finish task B

## 0. How to resume (for the next session)

1. Summarise this file back to the user in one sentence.
2. Keep this file (this is a test).
3. Start the first unchecked action in section 6.

## 6. Next actions

- [ ] Create b.txt containing the word done.
EOF
