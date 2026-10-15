# Quarantine Spec

Where tidied files and pre-edit snapshots go, how each one is recorded, how it is undone,
and why nothing is ever deleted. **This skill deletes nothing in a project folder.** A file
the hygiene pass wants gone is moved into the workspace quarantine and written into a
manifest. Removal happens only later, after the retention period, with the user's explicit
approval.

## Contents

1. Layout and destinations
2. Bootstrap (conditional)
3. `QUARANTINE.md` template
4. Manifest rows
5. Moving files on each platform
6. Pre-edit snapshots
7. Aging and purge
8. Undo
9. What never enters quarantine

---

## 1. Layout and destinations

One quarantine per workspace root (resolved per `contract-spec.md` section 1):

```
<workspace root>/_quarantine/
├── QUARANTINE.md                         rules + append-only manifest
└── YYYY-MM-DD/
    ├── <path relative to workspace root>          tidied files
    ├── _external/<path minus drive or root>       files from outside the root, same volume
    └── _undo/<relative path>.pre-<HHMMSS>         pre-edit snapshots
```

| Source | Destination |
|---|---|
| a file under the workspace root | `_quarantine/<date>/<path relative to the root>` |
| a file outside the root, same drive or volume | `_quarantine/<date>/_external/<full path, drive letter as a plain folder (`C`, not `C:`)>` |
| a pre-edit snapshot | `_quarantine/<date>/_undo/<path relative to the root>.pre-<HHMMSS>` |

Never cross drives or volumes. If a move would, it does not happen: report it as
`SKIPPED`.

If the workspace root is a git repo, the first time `_quarantine/` is created the preview
suggests adding it to `.gitignore`. Never edit `.gitignore` yourself.

---

## 2. Bootstrap (conditional)

Before the first move or snapshot of a run:

```
  <workspace root>/_quarantine/QUARANTINE.md exists?
    YES -> read it, adopt its columns, APPEND only. Never rewrite its header,
           re-order its columns, or touch a prior row except to annotate it.
    NO  -> create _quarantine/, write QUARANTINE.md from section 3, then move.
```

Never move or snapshot into a quarantine with no manifest: an unrecorded move is a
deletion with extra steps.

---

## 3. `QUARANTINE.md` template

Only for creating a manifest that does not exist.

```markdown
# Quarantine · <workspace root absolute path>

> Files moved here by the `end-session` skill. **Nothing here was deleted.** Each row
> records where a file came from and why it left.
>
> **Retention: 90 days.** After that an item may be purged, but purging is never
> automatic: `end-session` lists expired items and asks for approval every time.
>
> **Undo:** move the file from `Quarantined To` back to `Original Path`, then annotate
> the row `RESTORED <date>`.
>
> **Rows with Reason `pre-edit snapshot` are undo copies** of a file the skill edited.
> Restoring one overwrites the edited file with its earlier contents.
>
> **This manifest is append-only.** Rows are annotated, never deleted.

| Date | Original Path | Quarantined To | Reason | Session Ref |
|---|---|---|---|---|
```

---

## 4. Manifest rows

One row per moved file and one per snapshot.

| Column | Content |
|---|---|
| `Date` | ISO move date, matching the dated folder |
| `Original Path` | absolute path before the move |
| `Quarantined To` | absolute destination, written at move time, never derived later |
| `Reason` | one short clause the user can audit; `pre-edit snapshot` for snapshots |
| `Session Ref` | `<YYYY-MM-DD>T<HHMMSS> <folder name>`: the run's start time, local, 24-hour. With no shell to read the clock, use the date from the environment and a time of `000000` plus a short random suffix (e.g. `000000-k3`), so two runs still never share a ref |

The time in `Session Ref` is required, not decoration. Two runs in the same folder on the
same day are ordinary, and undo selects rows by exact ref; a date-only ref would make one
run's undo restore another run's files.

If an existing manifest uses different columns, read its rows as they are. Do not append
rows of a different shape under its table: add once, at the end of the file, a heading
`### Manifest rows written by end-session` with the five-column header above, and append
under it from then on.

Annotations go at the end of the `Reason` cell, never by deleting a row:
`· RESTORED 2026-08-27`, `· PURGED 2026-11-24 (approved)`,
`· RETENTION EXTENDED to 2027-02-24`.

---

## 5. Moving files on each platform

Quote every path. Create the destination folder first.

| Platform | Move | Copy (snapshots) |
|---|---|---|
| macOS, Linux, Git Bash on Windows | `mkdir -p "<dest dir>" && mv -n "<src>" "<dest>"` | `mkdir -p "<dir>" && cp -p "<src>" "<dest>"` |
| Windows PowerShell | `New-Item -ItemType Directory -Force -Path '<dest dir>' \| Out-Null; Move-Item -LiteralPath '<src>' -Destination '<dest>'` | same, with `Copy-Item` |

After every move, list both the source and destination folders to confirm the file
actually moved. A command that returned no error is not proof.

**No shell available?** A snapshot is a copy, so it can still be made: `Read` the file and
`Write` its exact contents to the snapshot path. A move cannot be done safely without a
shell; report it as `SKIPPED` rather than imitating it with write-then-delete.

**Cloud-synced folders** (Google Drive, OneDrive, Dropbox, iCloud): re-read every written
or moved file right after the operation. Sync clients can silently revert a change. If it
did not land, try once more; if it still has not, stop and report.

**Windows device names.** A file literally named `nul`, `con`, `prn`, `aux`, `com1` to
`com9`, or `lpt1` to `lpt9` cannot be moved by its ordinary path; the move silently targets
the device instead. It needs the `\\?\` extended-path prefix, and that prefix gets mangled
when passed through a Bash command line. The one reliable way: write a small `.ps1` with
the Write tool, build the prefix inside it from character codes
(`[char]92 + [char]92 + '?' + [char]92`), and run it with
`powershell -NoProfile -File <script>`. If that fails, report the file as `SKIPPED`.

---

## 6. Pre-edit snapshots

A snapshot is what makes an edit undoable. Before the first modifying write to a file in a
run (curation, rotation, promotion, rule merge or retirement, stub stamp, top-of-file
insertion):

```
  1. destination = _quarantine/<date>/_undo/<path relative to root>.pre-<HHMMSS>
     (<HHMMSS> is the run's start time, the same one in the Session Ref)
  2. create the parent folder
  3. COPY the file there. The live file stays in place.
  4. append a manifest row, Reason = pre-edit snapshot
  5. on a cloud-synced folder, re-read the snapshot to confirm it landed
  6. only then edit
```

One snapshot per file per run: it holds the state before the run, which is what undo
needs. If the snapshot fails, the edit does not happen; report it as `SKIPPED`.

---

## 7. Aging and purge

Every run (SKILL.md step 3e): list rows older than 90 days with no `PURGED` or
`RETENTION EXTENDED` annotation. Ask nothing then.

Immediately after the preview (step 5), if any are expired, ask once:

```
  Question:  N quarantined items passed their 90-day retention. Purge them?
  Options:   Purge all N | Keep all, re-check next session |
             Extend retention | Let me pick individually
```

Purging always needs this explicit answer. With no answer, nothing is purged. On an
approved purge, delete only the quarantined copies, then annotate each row
`· PURGED <date> (approved)`. The rows stay forever.

---

## 8. Undo

Honoured on the user's next turn.

```
  1. Read QUARANTINE.md. Select rows whose Session Ref EXACTLY equals this run's ref.
  2. For each row, move Quarantined To back to Original Path (use section 5).
       If a different file now sits at Original Path, stop and ask.
       Exception: pre-edit snapshot rows are MEANT to overwrite the edited file.
  3. Annotate the row "· RESTORED <date>". Never delete the row.
  4. Confirm one line per restored file, with absolute paths.
```

A pure append snapshots nothing; reversing it means removing the appended block, which
needs the entry text from the preview. If that has scrolled out of context, say so plainly
and offer to show the end of the file so the user can point at the block.

---

## 9. What never enters quarantine

The full list is `contract-spec.md` section 5. In short: credentials and secret files,
kill switches and lock files of running systems, databases in use, permanent audit trails
(every `QUARANTINE.md` included), files a `CLAUDE.md` protects in words, generated and
vendored files, anything in a FROZEN or DORMANT folder, and anything not enumerated in the
contract's `hygiene-allowed`.
