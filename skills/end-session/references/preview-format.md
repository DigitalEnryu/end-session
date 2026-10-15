# Preview Format

The step 5 preview. **It is a report of what was already written, not a request for
approval.** It exists so the user can see exactly what happened and say `undo` if any of it
is wrong. This styling is for the chat only; what goes to disk is the plain format in
`entry-template.md`. Never write this visual into a file.

## Contents

1. Glyphs
2. Header
3. Summary and metrics
4. Category sections
5. Actions block and conditional lines
6. Expired quarantine block
7. Footer

---

## 1. Glyphs

Fixed meanings, used consistently:

| Glyph | Means |
|---|---|
| `✓` | success |
| `✗` | mistake or wrong turn |
| `⚠` | roadblock |
| `💡` | solution found |
| `📒` | a file this skill wrote |
| `⬆` | a promotion into a CLAUDE.md |
| `📦` | moved to quarantine, or a snapshot |
| `🔒` | needs explicit approval |

Box-drawing goes inside code fences so it aligns. Content lines go outside fences, prefixed
with `▌`, so wrapping, bold, and inline code render normally. Counts are zero-padded to two
digits.

---

## 2. Header (verdict first)

```
╔══════════════════════════════════════════════════════════════╗
║  END-SESSION · WRITTEN                                       ║
║  ──────────────────────────────────────────────────────      ║
║  RESULT      {NN} WRITES · {NN} MOVES · {NN} PROMOTIONS      ║
║  DATE        {YYYY-MM-DD}                                    ║
║  PATH        {SHORT | FULL}                                  ║
║  SCOPE       {folder name}                                   ║
║  CONTRACT    {CONTRACT_BLOCK | PROSE_RULE | DEFAULT}         ║
║  LOG         {absolute path | NONE | GIT}                    ║
║  TIDY        {scope | DEFER {mechanism} | NONE}              ║
╚══════════════════════════════════════════════════════════════╝
```

`LOG` and `TIDY` are separate rows because `log:` and `hygiene-allowed:` are independent.
`DEFER` never appears on the `LOG` row.

---

## 3. Summary and metrics

```
>>> SESSION_SUMMARY
    {1 to 3 line summary of the session's arc}

>>> SESSION_METRICS
    [✓]  SUCCESSES        {NN}
    [✗]  WRONG_TURNS      {NN}
    [⚠]  ROADBLOCKS       {NN}
    [💡] SOLUTIONS         {NN}
    [📒] FILES_WRITTEN     {NN}
    [⬆]  PROMOTIONS        {NN}
    [📦] QUARANTINED       {NN}
    [📦] UNDO_SNAPSHOTS    {NN}
```

---

## 4. Category sections

Always all four, in this order, divider inside a fence:

```
══════════════════════════════════════════════════════════════
[ 01 ] ▌ ✓  SUCCESSES                                     [NN]
══════════════════════════════════════════════════════════════
```

Indices and names: `01 ✓ SUCCESSES` · `02 ✗ MISTAKES / WRONG TURNS` ·
`03 ⚠ NEW ROADBLOCKS` · `04 💡 SOLUTIONS FOUND`. Items below the divider, outside the fence:

```
▌ **`HEADLINE_IN_SNAKE_CASE`**
▌ Body in sentence case. Inline `code` for paths and terms.
```

An empty section is a single `▌ (none)`. A direct user quote renders as
`> [USER]: "verbatim quote"`.

---

## 5. Actions block

Everything written or moved, each with an absolute path. Nothing summarized away.

```
══════════════════════════════════════════════════════════════
[ 05 ] ▌ 📒  ACTIONS_TAKEN                                [NN]
══════════════════════════════════════════════════════════════
```

```
▌ **`UNDO_SNAPSHOT`** 📦  `{live path}` -> `{_undo snapshot path}`. Manifest row written.
▌ **`LOG_APPEND`**  Appended 1 entry to `{path}`.
▌ **`LOG_CREATED`**  Created `{path}` (no log existed).
▌ **`LOG_CURATION`**  {what was merged, collapsed, or corrected}. Counts preserved.
▌ **`LOG_ROTATION`**  Moved {N} oldest entries to `{archive path}`. Counts carried forward.
▌ **`PROMOTION`** ⬆  Rule added to `{path}`: "{rule}". Evidence: {dates}. Status: UNVERIFIED.
▌ **`RULE_MERGED`** ⬆  "{rule}" now also covers "{new root cause}".
▌ **`RULE_RETIRED`**  "{rule}" removed at the cap ({status}); recorded in `{log path}`.
▌ **`CLAUDE_MD_CREATED`**  Created `{path}` to hold the first learned rule.
▌ **`PROMOTION_VERIFIED`**  "{root cause}" -> HELD {date}.
▌ **`QUARANTINE_MOVE`** 📦  `{original}` -> `{destination}`. Reason: {reason}.
▌ **`HANDOVER_WRITTEN`**  `{path}`.
```

Every edit to an existing file has an `UNDO_SNAPSHOT` line. The undo offer depends on them.

### Conditional lines (only when they apply)

| Condition | Line |
|---|---|
| a rule's root cause recurred | `PROMOTION_FAILED` ⚠, the rule, the date, and: not re-promoted, needs a look |
| a promotion was skipped (cap, budget, no target) | `SKIPPED` with the rule text so the user can apply it |
| open cap reached on this skill's own `[OPEN]` lines | `OPEN_CAP`, and what was resolved or promoted before appending |
| no contract block | the offer line from `contract-spec.md`, once |
| tidy deferred | `TIDY_DEFERRED` with the mechanism; no tidy, curation, or rotation ran; the entry still went to `LOG` |
| brief placed by a repo's own convention | `DEFERRED_CONVENTION` with the path, and that committing is that repo's own step |
| secrets redacted | `REDACTED` with the count and which file. Never the values |
| `_quarantine/` created inside a git repo | `GITIGNORE_SUGGESTION`: add `_quarantine/` to `.gitignore` |
| an action ran without an on-disk undo record | `NOT_UNDOABLE` with the path and why |
| folder FROZEN or DORMANT | `READ_ONLY_FOLDER`, and where the entry went instead |
| any action refused | `SKIPPED` with the path and the rule that blocked it |
| FULL path, durable decision | `PROPOSED_DURABLE_WRITE` with the decision, its reason, and the target path |

---

## 6. Expired quarantine block (only when items are expired)

```
══════════════════════════════════════════════════════════════
[ 06 ] ▌ 🔒  EXPIRED_QUARANTINE                           [NN]
══════════════════════════════════════════════════════════════
```

```
▌ `{original path}` · quarantined {YYYY-MM-DD} · {N} days over
```

Then the purge question (SKILL.md step 5). Purging is never automatic.

---

## 7. Footer

```
──────────────────────────────────────────────────────────────
  →  SAY `undo` IF ANY OF THIS IS WRONG
──────────────────────────────────────────────────────────────
```

If any action appeared as `NOT_UNDOABLE`, name it instead of covering the whole run:

```
──────────────────────────────────────────────────────────────
  →  SAY `undo` IF ANY OF THIS IS WRONG
  →  EXCEPT {path}: NO UNDO RECORD, SEE NOT_UNDOABLE ABOVE
──────────────────────────────────────────────────────────────
```

An undo offer the skill cannot honour is worse than none.

SHORT path: the footer is the last thing emitted, apart from the purge question. FULL path:
the resume prompt follows.
