# Resume Prompt Template

FULL path only, step 8. The text the user pastes into a fresh session after `/clear`.
Substitute the placeholders and emit it inside a fenced `text` block so it copies cleanly.
The markers are not part of the output.

## Variant A: a handover brief was written (default)

=== TEMPLATE START ===
Resume prior session. Goal: [goal, one line].

1. Read this file in full: [ABSOLUTE PATH TO the brief]
2. Follow its section 0 ("How to resume") exactly: summarise back in 4 sentences or fewer, check for drift against its recorded state, run its check command if it names one, [delete the file | keep the file, it is part of the repo's records], then start the first unchecked action.

Do not load other context unless the brief points to it. Do not summarise this prompt back to me; go straight to step 1.
=== TEMPLATE END ===

The steps are repeated here in short form on purpose: if either the brief or this prompt
gets paraphrased, the other still carries them.

Use the "keep the file" wording only when step 7 placed the brief by a repo's own
convention (rung 1).

## Variant B: no brief (step 7 was skipped)

The next task stands alone in one sentence, so there is no file to read or delete.

=== TEMPLATE START ===
Resume prior session. Goal: [goal, one line]. No handover file was needed.

1. Working folder: [ABSOLUTE PATH]. Load the nearest CLAUDE.md and nothing else.
2. [If git:] Run `git status --porcelain` and confirm the branch is `[branch]` at `[short sha]`. If not, tell me what changed before continuing.
3. First action: [next action, verbatim].
4. If that action is ambiguous given what you can see now, ask ONE question. Otherwise do it.

Do not summarise this prompt back to me; go straight to step 1.
=== TEMPLATE END ===

## Closing line

After the fence, exactly one line (with the plugin note from SKILL.md step 8 when it
applies):

```
Run /clear, paste this in the new session, and you're back where we left off.
```

Print nothing after it.

## Why this order

| Step | Reason |
|---|---|
| Read first | the new session has context before acting |
| Summarise before anything else | the user's proof the file actually loaded; a wrong summary shows while the file still exists |
| Drift check | work done between sessions (by the user or another tool) would otherwise be overwritten |
| Run the stated check | start from a verified state, not a remembered one |
| Delete the one-shot brief | a stale brief later contradicts the code |
| One question at most | catches drift without re-bloating the fresh session |
