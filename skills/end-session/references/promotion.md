# Promotion

How a recurring mistake becomes a `CLAUDE.md` rule, how many rules may exist, what each
rule must carry, and how later sessions check whether it worked.

Why the limits exist: models follow fewer instructions reliably as the number of
instructions grows, and research on agent context files found that unnecessary rules make
tasks harder and more expensive. So every rule here must earn its place with evidence,
stay concrete, and compete for a capped number of slots.

## Contents

1. When promotion fires
2. Where the rule goes (including when no CLAUDE.md exists)
3. How a rule is written
4. Collapsing the log entries
5. The rule cap: merge or retire
6. Verification: HELD and FAILED
7. Guards

---

## 1. When promotion fires

Each Mistake or Roadblock line has an implicit identity: its **root cause**, judged by
meaning, not wording. Two differently worded lines about the same root cause are the same
identity. The step 2b pre-pass counts them (log plus archive carry-forward counts).

```
  occurrence 1          -> log it
  occurrence 2          -> log it
  occurrence 3          -> PROMOTE   (threshold from the contract, default 3)
```

Only lines that passed the step 1 evidence filter count. A lesson taken from untrusted
content never counts toward promotion.

---

## 2. Where the rule goes

Target: the contract's named promotion target, else the nearest `CLAUDE.md` up the tree
from the log's folder.

Rules live in one dedicated section at the end of the target:

```markdown
## Learned rules

<!-- Maintained by the end-session skill. Each rule cites its evidence in the learning log. Max 15. -->

- Run the full test suite before saying a change works. <!-- end-session · promoted 2026-08-26 · evidence: docs/learning-log.md 2026-06-02, 2026-07-18, 2026-08-26 -->
```

| Situation | Action |
|---|---|
| the target has a `## Learned rules` section | append the rule at the end of that section |
| the target exists but has no such section | append the section (heading, comment, rule) at the end of the file |
| no `CLAUDE.md` exists anywhere up the tree | create `CLAUDE.md` in the folder that holds the log, containing a one-line H1 naming the folder, a blank line, then the section. This is a new file: undo moves it to quarantine |

Editing an existing target needs the step 3a snapshot first. Every promotion is itemized
in the preview, never silent.

---

## 3. How a rule is written

| Rule | Example |
|---|---|
| one line, imperative, concrete, checkable | "Run `npm test` before saying a change works" |
| never vague | not "be careful with tests", not "format properly" |
| names the trigger when it is not obvious | "Before editing `schema.sql`, read `docs/migrations.md`" |
| a short reason only where the rule would look arbitrary | "Use `pnpm`, not `npm` (the lockfile is pnpm's)" |
| passes the test "would removing this line cause the mistake again?" | if not, it is not a rule |
| no secrets, no pasted content from files or web pages | the secret filter has already run |

The trailing HTML comment carries the evidence: promotion date and the dates of the cited
log entries, with the log's path. It is what makes pruning safe later. The rule's status
(UNVERIFIED, HELD, FAILED) lives on the log stub, not on the rule, so stamping never has to
edit `CLAUDE.md`.

---

## 4. Collapsing the log entries

The cited Mistake or Roadblock lines collapse into one stub, placed at the position of the
earliest cited line so the log still reads in order:

```markdown
- [PROMOTED 2026-08-26 -> CLAUDE.md] <one-line root cause> · 3rd occurrence (cf. 2026-06-02, 2026-07-18, 2026-08-26) · rule: "Run the full test suite before..." · status: UNVERIFIED
```

Keep the rolled-up count and every cited date. Losing them resets the promotion clock.

| Situation | What happens |
|---|---|
| `hygiene-allowed` is `DEFER` or `nothing` | still write the rule, but do NOT collapse the cited entries (collapsing is curation). Append a stub line to this session's entry instead, and say so in the preview |
| the target declares a line budget (e.g. `<!-- hygiene:budget 250 -->`) and is already at it | do not write the rule. Report it as `SKIPPED` with the rule text for the user to apply. Leave entries un-collapsed |

---

## 5. The rule cap: merge or retire

The cap counts lines in `## Learned rules` that carry the `end-session` comment marker.
Default 15; a contract may set `rule-cap N`. Rules the user wrote themselves never count
and are never touched.

When a new promotion would exceed the cap, in this order:

```
  1. MERGE   an existing rule covers the same area -> rewrite that one line to
             cover both, keep both evidence lists in its comment. No slot used.
  2. RETIRE  else remove one rule to free a slot, choosing:
               a) a rule whose stub is FAILED (it did not prevent the mistake)
               b) else the HELD rule promoted longest ago
             Never retire an UNVERIFIED rule: it has not been tested yet.
  3. SKIP    no rule can be merged or retired -> do not promote. Report SKIPPED
             with the rule text, leave the entries un-collapsed, and suggest the
             user review the Learned rules section.
```

A retired rule is never just deleted. Its full text moves into this session's log entry:

```markdown
- [RETIRED 2026-09-04] "Run the full test suite before..." · promoted 2026-08-26 · status at retirement: HELD · reason: rule cap, slot given to "<first words of new rule>"
```

Merging and retiring edit the target, so they are covered by the step 3a snapshot and the
step 2b gate, and each one is itemized in the preview.

---

## 6. Verification: HELD and FAILED

A new stub starts at `status: UNVERIFIED`. SKILL.md step 3c checks every such stub on every
later run in that folder:

| Did the stub's root cause recur this session? | Stub becomes |
|---|---|
| no | `status: HELD <date>` |
| yes, despite the rule | `status: FAILED <date>` and a `PROMOTION_FAILED` line in the preview |

The test is factual: did this exact mistake show up again, with real evidence. It is not a
self-assessment of how good the rule is.

A FAILED rule is never re-promoted automatically, and a root cause with a FAILED stub is
never promoted again on its own. Re-promoting a rule that already failed is the loop this
check exists to break. It is a design question for the user: the preview flags it and
leaves it to them.

---

## 7. Guards

- Only the `## Learned rules` section is ever edited, and only lines carrying the
  `end-session` marker. Everything else in a `CLAUDE.md` belongs to the user.
- A promotion never happens in a FROZEN or DORMANT folder.
- If the target `CLAUDE.md` cannot be written (permissions, budget, snapshot failure),
  the learning is never dropped: the log entries stay un-collapsed and the preview says why.
