# Question Bank: an inference checklist

**This is a checklist for NOT asking.** The skill infers from the transcript and asks only
what the transcript genuinely cannot answer. Most runs ask nothing. A run that asks two
questions has usually not read its own history closely enough.

## How to use it

```
  for each row below, run the transcript test:
    answered      -> fill the field from the transcript, verbatim. Do not ask.
    not answered  -> not material to what is written?  drop it
                     material?                          candidate to ask
```

Then sort the candidates by section 3, keep only as many as the run's remaining budget
allows, and ask them in ONE batched `AskUserQuestion` call at step 2b (together with the
pre-write gate if it fires). Options come from the transcript: real decisions, real
blockers, real dead ends. Use `multiSelect` where several answers can be true.

## 1. The budget

One budget of 4 questions for the whole run, shared by every question:

| # | Question | Fires when | Step |
|---|---|---|---|
| 1 | pre-write gate: `Proceed` / `Not yet, keep working` | the run will modify or move existing content | 2b |
| 2 | inference questions from this bank | something material is not in the transcript | 2b, same call as 1 |
| 3 | expired-quarantine purge | expired items exist | 5 |
| 4 | next task, and handover folder if unclear | FULL path only | 6, one call |

Never fire four separate single-question calls. The abort option belongs to the gate only:
by step 5 the writes have happened, so the honest reversal is `undo`, not an abort.

## 2. The checklist

`SHORT` items can matter on the "end session" path (they feed the log entry). `FULL` items
only matter when a handover brief is written.

| ID | Fills | Do NOT ask if | Ask only when |
|---|---|---|---|
| Q-DEAD-END `SHORT` | Mistakes · brief §4 | the failure and its reason are visible in the tool history or the user's words | something clearly failed but why is not on the record |
| Q-PIN-DECISION `SHORT` | Solutions · brief §3 | each decision has a stated reason | a decision with no stated reason would be re-argued next time |
| Q-BLOCKER `SHORT` | Roadblocks · brief §5 | the session ended cleanly, or the blocker was named | work stopped mid-thread with no stated reason |
| Q-EXTERNAL-STATE `SHORT` | Roadblocks · brief §5 | nothing long-running was started | a deploy, job, upload, or background process was started and its state is unknown |
| Q-VERIFICATION `SHORT` | Successes · brief §5 | verification ran and its output is in the transcript | something is called done with no evidence it was checked |
| Q-PINNED-ANSWER `SHORT` | Solutions · brief §3 | the hard-won fact is already written to a file | an expensive finding exists only in chat |
| Q-CONFIDENCE `SHORT` | Mistakes · brief §5 | non-trivial changes were verified or accepted | changes landed with neither |
| Q-SCOPE-DROP `FULL` | brief §4 | every subtopic reached a conclusion | a subtopic was abandoned without a word |
| Q-PERSON-CONTEXT `FULL` | brief §3 | no person's decision or deadline gates the next step | someone's reply or deadline gates it and is not written down |
| Q-FILE-DRIFT-RISK `FULL` | brief §7 | every discussed edit was applied by a tool call | edits were left for the user to make by hand |
| Q-NEXT-IS-SAME `FULL` | brief §6 | the user stated the next task | "continue this" vs "start something else" is genuinely unclear |
| Q-DEPENDENCY `FULL` | brief §5 | the next action can start immediately | it waits on a system, job, or person |
| Q-PRIORITY-RESET `FULL` | brief §6 | no context switch was signalled | the user mentioned something more urgent elsewhere |

## 3. Priority when trimming to the remaining budget

```
  1  Q-DEAD-END         costs the most to relearn
  2  Q-PIN-DECISION     stops the next session re-arguing
  3  Q-BLOCKER          decides whether the next action can even start
  4  Q-EXTERNAL-STATE   invisible state causes the worst surprises
  5  Q-NEXT-IS-SAME     only when the next task is genuinely unclear
  .. the rest, in table order
```

## 4. Question wording, if one must be asked

| ID | Question |
|---|---|
| Q-DEAD-END | Anything we tried that did NOT work and the next session should avoid? |
| Q-PIN-DECISION | Which decisions from this session must be kept, and what is the reason behind each? |
| Q-BLOCKER | What is blocking progress right now, if anything, and what would unblock it? |
| Q-EXTERNAL-STATE | Is anything running or half-finished outside this conversation (a deploy, a job, an upload)? |
| Q-VERIFICATION | Is anything "done" but not yet checked (tests not run, deploy not verified)? |
| Q-PINNED-ANSWER | Did I give you an answer this session that you want kept as a fact? |
| Q-CONFIDENCE | Anything from this session you are unsure was right and want double-checked? |
| Q-SCOPE-DROP | Anything we explored that is no longer worth carrying forward? |
| Q-PERSON-CONTEXT | Are we waiting on anyone, or is there a deadline tied to a person? |
| Q-FILE-DRIFT-RISK | Will you edit any files by hand before the next session? |
| Q-NEXT-IS-SAME | Is the next session continuing this thread, or starting something else? |
| Q-DEPENDENCY | Is anything we are waiting on before work can resume? |
| Q-PRIORITY-RESET | Should the next session start on something more urgent than this thread? |

Whatever the user answers goes into the written file unchanged. A vague answer to a
next-action question ("not sure", "you decide") becomes the literal action
`Read handover.md, then ask the user where to start.` Never invent a next action.
