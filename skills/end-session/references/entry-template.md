# Entry Template (standard format)

The on-disk format of a session entry, used when the contract says `format: standard`.
Under `format: native`, read the target file's own header and match it instead.

One log per folder, one entry per session. Skills used in the session are a tag on that
entry, never a reason to write extra files.

## Contents

- Full variant
- Terse variant
- State tags
- Append rules
- Log rotation
- Reading older entries

---

## Full variant

Used when at least one category has content.

```markdown
## YYYY-MM-DD · <folder name> · skills: <a, b>
**Session goal:** <one line>
**Successes:**
- <item>
**Mistakes / wrong turns:**
- [OPEN] <item>
**New roadblocks:**
- [OPEN] <item>
**Solutions found:**
- <item>
**Pattern:** <only when a recurrence was found, e.g. "3rd occurrence of edits made without reading the file first (cf. 2026-06-02, 2026-07-18)">
```

- Empty categories show `(none)`, never omitted: a consistent shape keeps later scans
  cheap and reliable.
- Dates are ISO 8601 (`YYYY-MM-DD`).
- `skills:` lists real skills invoked, excluding routers and this skill; `skills: none`
  if none ran.
- `<folder name>` is the leaf folder name.
- Every line has already passed the evidence, one-off, and secret filters (SKILL.md
  step 1).

## Terse variant

Used when every category is empty after filtering:

```markdown
## YYYY-MM-DD · <folder name> · skills: <a, b> · clean run, nothing notable
```

A clean session costs one line, not fifteen lines of `(none)`.

---

## State tags

Mistake and Roadblock lines carry a lifecycle tag, because the open cap and the promotion
engine both count what is still unresolved.

| Tag | Meaning | Counts against `open-cap`? |
|---|---|---|
| `[OPEN]` | unresolved | yes |
| `[RESOLVED YYYY-MM-DD]` | fixed or no longer relevant | no |
| `[PROMOTED YYYY-MM-DD -> <target>]` | collapsed into a rule (see `promotion.md`) | no |
| `[RETIRED YYYY-MM-DD]` | a rule removed at the cap, kept here as a record | no |
| no tag | **UNTRACKED** line written before this skill was used | no |

Untagged lines are never counted, never bulk-retagged, and never block an append. A folder
that already has a long hand-written log must be able to take its first entry cleanly. Tag
what you write; read what is there; leave the rest alone.

Successes and Solutions carry no tags.

---

## Append rules

- Append at the end, unless the contract says `append: top`.
- Exactly one blank line between entries.
- Before creating a log, run the existing-log check in `contract-spec.md`.
- A new log starts with a one-line H1, a blank line, then the first entry:

```markdown
# Learning log · <folder name>

## 2026-08-26 · <folder name> · skills: none · clean run, nothing notable
```

---

## Log rotation

A log that grows forever gets slower and costlier to scan every session. Rotation keeps the
working log small without losing anything or resetting any count.

Runs in step 3b only when `hygiene-allowed` includes rotating the log (the DEFAULT
CONTRACT does), never under `DEFER` or `nothing`, and never on a file that declares itself a
permanent audit trail.

```
  TRIGGER   the log has more than 300 entries OR is larger than 200 KB
  MOVE      the oldest entries, down to about 150 entries, to
            <log name>-archive.md in the same folder (append to it if it exists;
            the archive keeps the log's H1 with " (archive)" added)
  KEEP      in the working log, directly under its H1, one carry-forward block:

            > **Carried forward from <log name>-archive.md on YYYY-MM-DD:**
            > - <root cause> · <N> occurrences (cf. <dates>) · [OPEN|PROMOTED ...]
            > - ...

            one line for every root cause in the moved entries that has an [OPEN]
            line or a count of 2 or more, plus every PROMOTED stub still at
            status: UNVERIFIED (the stub itself moves back up, unchanged).
```

The recurrence scan reads the carry-forward block, so counts survive rotation. The working
log is snapshotted first (step 3a); the archive is either new (undo moves it to quarantine)
or appended to (undo removes the appended block). Rotation is itemized in the preview with
the number of entries moved.

---

## Reading older entries

Older logs may use other heading separators (an em dash, an en dash, a hyphen) or older
labels. Read all of them tolerantly when scanning. When writing a new entry in a standard
log, use the middle dot `·` shown above. Never rewrite old headings to the new style.
