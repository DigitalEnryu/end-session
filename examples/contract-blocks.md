# Example Session-End Contract blocks

Paste one into a folder's `CLAUDE.md` and adjust. Every field is optional; anything left
out falls back to the default (see the README).

## A normal project

```markdown
## Session-End Contract
- log: docs/learning-log.md
- format: standard
- append: bottom
- open-cap: 20 · promotion after 3 recurrences into CLAUDE.md · rule-cap 15
- hygiene-allowed: curate this log; rotate this log; quarantine *.tmp files under scratch/
- never-touch: data/, config/production.yaml
```

## A folder that must stay exactly as it is (no logs)

For example a notes or practice folder where only a fixed set of files belongs.

```markdown
## Session-End Contract
- log: NONE
- hygiene-allowed: nothing
- never-touch: everything in this folder
```

## A repo that keeps its lessons in git

```markdown
## Session-End Contract
- log: GIT
- hygiene-allowed: nothing
```

The skill then suggests the lesson for your next commit message or CHANGELOG instead of
creating a log.

## A repo with its own cleanup machinery

The skill still writes the session entry to the named log, but tidies nothing: the repo's
own scripts own that.

```markdown
## Session-End Contract
- log: docs/build-log/learning-log.md
- format: native
- append: bottom
- open-cap: none
- hygiene-allowed: DEFER to the repo's own cleanup scripts. No file tidy here.
- never-touch: config/live.yaml, KILL, anything under scripts/
```

Add a sentence in the same `CLAUDE.md` saying where session records go (for example
"handoff notes are dated files under `docs/build-log/`") and the handover brief will be
written there, named that way.

## A faster-learning folder

```markdown
## Session-End Contract
- open-cap: 20 · promotion after 2 recurrences into CLAUDE.md · rule-cap 10
```
