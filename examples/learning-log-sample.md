# Learning log · webapp

## 2026-06-02 · webapp · skills: none
**Session goal:** Add pagination to the orders API.
**Successes:**
- Cursor-based pagination shipped with tests.
**Mistakes / wrong turns:**
- [PROMOTED 2026-08-26 -> CLAUDE.md] Claimed a change worked without running the test suite · 3rd occurrence (cf. 2026-06-02, 2026-07-18, 2026-08-26) · rule: "Run `npm test` before saying a change..." · status: UNVERIFIED
**New roadblocks:**
- (none)
**Solutions found:**
- The ORM's `cursor()` helper avoids the offset scan on large tables.

## 2026-07-18 · webapp · skills: none · clean run, nothing notable

## 2026-08-26 · webapp · skills: frontend-design
**Session goal:** Redesign the order detail page.
**Successes:**
- New layout approved by the user.
**Mistakes / wrong turns:**
- (none)
**New roadblocks:**
- [OPEN] Storybook build fails on Node 22; pinned to Node 20 for now.
**Solutions found:**
- (none)
**Pattern:** 3rd occurrence of claiming a change worked without running tests (cf. 2026-06-02, 2026-07-18). Promoted to CLAUDE.md.
