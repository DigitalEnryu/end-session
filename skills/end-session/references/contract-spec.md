# Contract Spec

How `end-session` decides what it may write and what it may touch, in any folder, without
carrying a folder-to-log map. Each folder declares its own terms in its own `CLAUDE.md`,
and the skill reads them at run time. A hand-maintained map of folders to log files goes
stale and silently sends entries to the wrong file, so this skill never keeps one. The
worked examples below illustrate the grammar; nothing resolves by matching a folder name
against them.

## Contents

1. Discovery algorithm (incl. prose shapes, named log paths, the existing-log check, the
   offer lines, workspace root)
2. Contract block format and field meanings
3. The DEFAULT CONTRACT
4. Existing conventions: native formats and log-forbidding folders
5. No-touch list
6. Checklist before any write or move

---

## 1. Discovery algorithm

Run from the current working directory. Stop at the first hit.

```
  START: current folder, walk UP one level at a time toward the root
  [1] nearest CLAUDE.md containing "## Session-End Contract"?
        YES -> use it. Done. No offer line.
  [2] a CLAUDE.md exists up the tree but has no block:
      READ THE NEAREST ONE IN FULL and test it against the six prose shapes.
        any match -> build the contract from that prose, obey it literally;
                     fields the prose is silent on stay at DEFAULT.
                     Offer line: prose-rule wording.
  [3] that CLAUDE.md has no such rule  -> DEFAULT CONTRACT. Offer line: default wording.
  [4] no CLAUDE.md anywhere            -> DEFAULT CONTRACT. Offer line: default wording.
```

| Branch | Tooling |
|---|---|
| [1] | `Glob` for `CLAUDE.md` files up the tree, then `Grep` for `^## Session-End Contract`, nearest first. Read only the matching block |
| [2] | `Read` the nearest `CLAUDE.md` in full. Grep cannot find a rule whose wording you do not already know |

### Why branch [2] is never skipped

Branch [1] only finds a block someone already wrote, so on the first run in most folders
it misses. Falling straight to the DEFAULT CONTRACT then fails in one of two directions:

| What the prose says | What DEFAULT would do | What branch [2] does |
|---|---|---|
| "Only these three files live here, nothing else" | creates a fourth file the folder forbids | `log: NONE`, writes nothing |
| "Learning log: `docs/learning-log.md`" | creates a second `learning-log.md` in the root, orphaning the real one and resetting every recurrence count to zero | writes to `docs/learning-log.md` |

The second failure is the worse one because it looks like success: a file appears, nothing
errors, and the promotion engine quietly starts counting from zero.

### The six prose shapes

Judge meaning, not phrasing.

| # | The prose says something like | Contract built from it |
|---|---|---|
| 1 | it **names a log or learnings file** for this folder: "Learning log: `X`", "log mistakes to `Y`", a tree diagram showing a learning log, "check the learning log before starting" | `log:` = that path (resolved below); rest DEFAULT |
| 2 | "no session logs", "nothing else lives here", "do not add files here" | `log: NONE`, `hygiene-allowed: nothing` |
| 3 | "learnings go in commit messages", "use the CHANGELOG" | `log: GIT` |
| 4 | "this project runs its own hygiene", "do not tidy here" | `hygiene-allowed: DEFER <the named mechanism>`; `log:` still from shape 1 if a log is named |
| 5 | "the log format is described in its own header", "newest entries at top" | `format: native`, `append:` per the prose |
| 6 | "frozen", "dormant", "kept for reference only" | read-only in that folder (section 5.5) |

Shape 1 is the one most often missed, because it is a fact rather than a rule. When the
prose is ambiguous about permission, treat it as forbidding: a skipped write the user can
see beats a file they said not to create.

### Resolving a log path the prose names (shape 1)

```
  1. Collect EVERY mention of a log or learnings file in the whole CLAUDE.md.
     The same log is often named two or three times: in a tree diagram, in a
     labelled line, inside a checklist.
  2. Prefer the mention that carries a directory segment. A bare
     "learning-log.md" in a checklist is shorthand for the full path stated
     elsewhere, not a second log. Between two paths, prefer a labelled
     statement ("Learning log: ...") over a tree diagram.
  3. Resolve it relative to the folder that CLAUDE.md sits in. It may land in a
     subfolder.
  4. Confirm on disk with the existing-log check below.
```

Worked example:

```
  CLAUDE.md   ~/projects/webapp/CLAUDE.md
  mentions    (a) tree line:   learning-log.md   <- mistakes tracker
              (b) "**Learning log:** `docs/learning-log.md`"
              (c) "Log any mistakes to `learning-log.md`"
  step 2      (b) has a directory and is a labelled statement; (a) and (c) are shorthand
  step 3      resolved log = ~/projects/webapp/docs/learning-log.md
  step 4      the file exists. Write there.
```

### The existing-log check (before writing to ANY log path)

Runs whichever branch produced the contract, DEFAULT included.

```
  The resolved log path does not exist yet? Glob one level deep under the folder:
      <folder>/learning-log.md       <folder>/*-learnings.md
      <folder>/*/learning-log.md     <folder>/*/*-learnings.md
  exactly one hit  -> use it as log:, say so in the preview in one line
  several hits     -> prefer one the prose names, else the largest (the one in
                      use); name the others in the preview. Create nothing.
  none             -> create the resolved path. The only case a log is created.
```

### The offer lines

Exactly one line in the preview, worded as an offer, at most once per session:

```
⚠️ This folder has no Session-End Contract. Used defaults. Want one added?
⚠️ This folder has no Session-End Contract. Followed its CLAUDE.md prose. Want a block added?
```

Never add a block on your own initiative: that edits a live `CLAUDE.md` outside the
hygiene scope. Offer, then wait to be asked.

### Workspace root (for quarantine placement)

Resolve silently, first match wins:

```
  1. an ancestor of the current folder (inclusive) already containing _quarantine/
  2. the git repository root, if the folder is inside a git repo
  3. the highest ancestor on the same drive or volume that directly contains a
     CLAUDE.md
  4. the current folder
```

The user's home directory, anything above it, and a drive root are never the workspace
root, whatever rules 1 to 3 find: a `_quarantine/` or `CLAUDE.md` sitting there belongs to
the user's global setup, not to this project. If a rule lands on one of them, skip to the
next rule. Never pick a location on a different drive or volume from the files being moved.

---

## 2. Contract block format

```markdown
## Session-End Contract
- log: <relative path | NONE | GIT>
- format: <standard | native>
- append: <bottom | top>
- open-cap: <N | none> · promotion after <N> recurrences into <target file> · rule-cap <N>
- hygiene-allowed: <enumerated actions | DEFER <named mechanism> | nothing>
- never-touch: <enumerated no-go paths for this folder>
```

### `log:` and `hygiene-allowed:` are independent

Where lessons go and what may be tidied are separate questions. A project can log to a
real path while forbidding any tidy. `DEFER` belongs to `hygiene-allowed:` only; a contract
that says `log: DEFER` is malformed: read it as `hygiene-allowed: DEFER`, treat `log:` as
unset, and resolve `log:` from the prose scan before falling back to DEFAULT.

Worked example, a trading bot repo that runs its own tidy scripts:

```markdown
## Session-End Contract
- log: docs/build-log/learning-log.md
- format: native
- append: bottom
- open-cap: none
- hygiene-allowed: DEFER to the repo's own cleanup scripts. No file tidy here.
- never-touch: config/live.yaml, KILL, anything under scripts/
```

This reads: write the session entry into the existing `docs/build-log/learning-log.md`,
and touch nothing else.

### Field meanings

| Field | Value | Meaning |
|---|---|---|
| `log` | relative path | write the session entry there |
| | `NONE` | this folder forbids learning logs; durable facts go where the `CLAUDE.md` says |
| | `GIT` | lessons belong in commit messages and the CHANGELOG; never create a log |
| `format` | `standard` | use `entry-template.md` |
| | `native` | the target file's own header is the spec: match its structure, order, field names and separators. Never normalize old entries |
| `append` | `bottom` / `top` | newest entry at the end or the start |
| `open-cap` | `N` / `none` | max Mistake plus Roadblock lines this skill tagged `[OPEN]`; untagged lines never count |
| | `promotion after N into <target>` | recurrence count that triggers promotion (default 3) and the file the rule goes into (default: nearest `CLAUDE.md`) |
| | `rule-cap N` | max rules in the target's `## Learned rules` section (default 15) |
| `hygiene-allowed` | enumerated list | the ONLY tidy actions allowed; "curate this log" and "rotate this log" are separate items |
| | `DEFER <mechanism>` | no file tidy, no curation, no rotation; `log:` still applies |
| | `nothing` | no tidy of any kind; `log:` still applies |
| `never-touch` | enumerated list | folder-specific no-gos, added on top of section 5 |

**Enumerated means enumerated.** "curate this log" does not authorize moving a stray file.
"quarantine dated scratch files under `tmp/`" does not authorize touching other `tmp/` files.

---

## 3. The DEFAULT CONTRACT

Used on branches [3] and [4] only, after branch [2] has run. Deliberately timid: an
unknown folder gets its own log looked after and nothing else touched.

```markdown
## Session-End Contract  (DEFAULT, implied, never written to disk)
- log: learning-log.md           (folder root, created on first write)
- format: standard
- append: bottom
- open-cap: 20 · promotion after 3 recurrences into the nearest CLAUDE.md · rule-cap 15
- hygiene-allowed: curate this log; rotate this log. Nothing else.
- never-touch: everything else.
```

If no `CLAUDE.md` exists to promote into, `promotion.md` says how one is created.

---

## 4. Existing conventions

Folders often have conventions that predate this skill. They reach it through a block or
through the prose scan; either way the skill follows them literally and does not
"improve" them.

| Pattern | Contract |
|---|---|
| a practice folder with no logs (e.g. `notes/chess/`) | `log: NONE`, `hygiene-allowed: nothing` |
| a repo whose lessons live in commits | `log: GIT` |
| a repo with its own cleanup machinery (e.g. `bots/trader/`) | real `log:` path plus `hygiene-allowed: DEFER ...` |
| a log with its own entry format described in its header | `format: native` |
| an audit trail, newest first | `append: top`, and the file is in `never-touch` for curation |

Under `format: native`, read tolerantly and write in the file's own style. Never rewrite
old entries to a new style: that is churn with no reader.

---

## 5. No-touch list (applies everywhere)

A contract can add to this list. A contract can never subtract from it.

### 5.1 Secrets and live-system controls

- Credentials of any kind: `.env*`, `*.pem`, `*.key`, `id_rsa*`, `secrets.*`,
  `credentials.*`, token files, password stores, and anything a `CLAUDE.md` calls a
  credential store. Never echo, copy, move, or quote a secret value.
- Kill switches, stop files, and lock files that control a running process (for example a
  file named `KILL`, `STOP`, or `*.lock` next to a live service).
- Databases and spreadsheets currently open or written by a running process.

Moving one of these is an operational event, not tidying.

### 5.2 Permanent audit trails

A file whose header says its rows are never deleted is never curated, collapsed,
re-ordered, rotated, or quarantined. Every `QUARANTINE.md` manifest is one. The test is the
header, not the filename. Append only, and only if the contract authorizes appending.

### 5.3 Files a CLAUDE.md protects in words

"kept for reference", "do not move", "frozen, not removed", or equivalent: no-touch.

### 5.4 Generated and vendored files

Build output, vendored dependencies, lockfiles, and anything a `CLAUDE.md` calls generated
or a mirror. Drift there is fixed by re-running whatever generates it, never by tidying.

### 5.5 Frozen and dormant folders

A `CLAUDE.md` declaring FROZEN or DORMANT makes the skill read-only there: no hygiene, no
log write, no promotion. The entry goes to the workspace root's log, and the preview says
why.

### 5.6 Recurrence-count chains

Log lines like `3rd occurrence (cf. 2026-05-02, 2026-06-11)` carry a rolled-up count. When
curation collapses the entries they cite, the count and cited dates must survive. Losing
them resets the promotion clock.

---

## 6. Checklist before any write or move

```
  [ ] Contract resolved, and I know which branch produced it
  [ ] Branch [2] ran in full if branch [1] missed, all six shapes tested
  [ ] The existing-log check ran before creating any log
  [ ] An existing QUARANTINE.md is appended to, never overwritten
  [ ] Offer line raised at most once, if applicable
  [ ] For tidy actions: named in hygiene-allowed, and hygiene-allowed is not DEFER
  [ ] The path is not in never-touch or section 5
  [ ] Nothing is being deleted
  [ ] The destination is on the same drive or volume as the source
  [ ] For modify or move actions: the step 2b gate was answered Proceed
  [ ] For modify actions: a snapshot exists on disk with a manifest row
  [ ] The secret filter ran on every text I am about to write
```

If any box fails, the action does not happen. Report it as `SKIPPED` in the preview: a
skipped action the user can see beats a silent one they cannot.
