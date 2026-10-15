# Handover Template

FULL path only, step 7. Fill it yourself. Replace every `[bracketed placeholder]` and drop
the brackets. Keep every section; write `_(none)_` under a heading with nothing to record.
The file's content starts after `=== TEMPLATE START ===` and ends before
`=== TEMPLATE END ===`; the markers are not written.

Rules for the whole file:

- Absolute paths everywhere. Point at code as `path:line` rather than pasting it: the next
  session can open the file, and pasted copies go stale.
- The secret filter (SKILL.md step 1) runs over the finished text before it is written.
- Anything the user said that lands here is carried verbatim.
- Bias toward more detail here and less in the resume prompt: the brief is where fidelity
  lives.

=== TEMPLATE START ===
# Handover: [goal, one line]

**Created:** [ISO 8601 timestamp with offset]
**Working folder:** [absolute path of the folder this file lives in]
**Session length:** about [N] exchanges

## 0. How to resume (for the next session)

1. Read this whole file, then summarise back to the user in 4 sentences or fewer: the goal,
   what was done, and the next action. Synthesise; do not restate sections.
2. Check for drift. [If git:] Run `git status --porcelain` and `git rev-parse --short HEAD`
   in the working folder and compare with section 7. If anything differs, tell the user
   what changed before doing anything else. [If not git: "Re-read each file in section 7
   before editing it."]
3. [If section 6 names a check, e.g. a test command:] Run `[command]` and report the result
   before starting new work.
4. [Rungs 2 to 5:] Delete this file: [`rm "<absolute path>"` on macOS or Linux, or
   `Remove-Item "<absolute path>"` on Windows]. Confirm in one line.
   [Rung 1: "Keep this file. It is part of the repo's records: [the repo's supersede rule]."]
5. If anything here is ambiguous or contradicts what you now see, ask ONE question.
   Otherwise start the first unchecked action in section 6.

## 1. Goal

**Original (session start):** [first substantive user request, one sentence]
**Final:** [the goal carried forward]
**Drift note:** [one sentence, or "none"]

## 2. What was done

One bullet each: verb, artefact, absolute path.

- [Edited `/abs/path/foo.ts:40-72` to add X]
- [Created `/abs/path/bar.md` with Y]
- [Ran `<command>`: <one-line result>]

## 3. Decisions to keep

Each decision records the decision AND the reason. Without the reason, the next session
re-argues settled questions.

**Session-scoped** (true for this thread of work only):

- **Decision:** [X over Y]. **Why:** [reason, with a `path:line` or the user's stated preference]

**Durable** (outlives this task):

- **Decision:** [X over Y]. **Why:** [reason]. **Proposed home:** [absolute path to the CLAUDE.md or memory file]

Every durable decision also appears in the preview as a `PROPOSED_DURABLE_WRITE`, because a
standing rule recorded only in a one-shot file gets lost.

## 4. Dead ends: do not retry

- [Tried A. Failed because B. Do not retry unless C changes.]

## 5. Open questions

**Blocking the next step:**
- [question]

**Can wait:**
- [question]

## 6. Next actions

The first unchecked box is the first thing the next session does after section 0.

- [ ] [first action, verbatim from step 6, specific: "add X to `/abs/path/foo.ts`", not "work on auth"]
- [ ] [second action, if any]

**Check before new work:** [a command that proves the current state, e.g. `npm test`, or "none"]

## 7. State at handover

**Git:** [branch `<name>` at `<short sha>` · <N> uncommitted files · <N> unpushed commits] or ["not a git repo"]

**Uncommitted or changed files** (best-effort, from this session's tool calls; cross-checked
with `git status` when available):

- [/abs/path/file1.ts (edited)]
- [/abs/path/file2.md (created)]

## 8. Context to load

- [absolute path to the nearest CLAUDE.md]
- [absolute path to the learning log, if this session promoted a rule]
- [other files this session relied on]
=== TEMPLATE END ===

---

## Notes for the executing model

| Rule | Detail |
|---|---|
| Archive first | rungs 2 to 5: if `handover.md` exists, rename it to `handover-archived-<ISO timestamp>.md` before writing. That rename relocates existing content, so the step 2b gate must have been answered `Proceed` |
| Rung 1 | a repo's own convention decides location, name, and lifecycle: archive nothing, keep the file (section 0 step 4 says so), and never commit, push, or `git mv` |
| Undo | moving the new brief to quarantine and un-archiving whatever it displaced. Never a delete |
| Never | write the brief into `~/.claude/` or any other global location |
| Skip | if the next task stands alone in one sentence, write no brief; use the no-brief resume variant |
| Auto-load | with the plugin installed, a SessionStart hook tells the next session to follow section 0 when it finds `handover.md` in its starting folder. Section 0 must therefore be complete on its own |
