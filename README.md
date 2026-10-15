# end-session for Claude Code

Created by Rueben Looi. MIT licensed.

A Claude Code skill that closes a session properly. Say **"end session"** and Claude writes
down what it learned, in a log that lives in your project folder. Say **"handover"** and it
also writes a brief and a ready-to-paste prompt, so a fresh session picks up exactly where
this one stopped.

The part that matters most: **when Claude makes the same mistake three times in a folder,
the lesson becomes a rule in that folder's `CLAUDE.md`, and later sessions check whether
the rule actually stopped the mistake.** Rules that work are marked HELD. Rules that do not
are marked FAILED and flagged to you, never silently repeated.

---

## What happens when you say it

```
"end session"                          "handover"
  1. reads this conversation             1-4. everything "end session" does
  2. reads your folder's rules           5.   works out the next task
  3. writes ONE log entry                6.   writes handover.md
  4. shows what it wrote + "undo"        7.   prints a resume prompt to paste
     (asks nothing, most of the time)         after /clear
```

A typical first run in a brand-new folder:

```
╔══════════════════════════════════════════════════════════════╗
║  END-SESSION · WRITTEN                                       ║
║  RESULT      01 WRITES · 00 MOVES · 00 PROMOTIONS            ║
║  PATH        SHORT                                           ║
║  CONTRACT    DEFAULT                                         ║
║  LOG         /home/you/projects/webapp/learning-log.md       ║
╚══════════════════════════════════════════════════════════════╝
▌ LOG_CREATED  Created /home/you/projects/webapp/learning-log.md
▌ ⚠️ This folder has no Session-End Contract. Used defaults. Want one added?
  →  SAY `undo` IF ANY OF THIS IS WRONG
```

---

## Install

### As a plugin (recommended)

In Claude Code:

```
/plugin marketplace add DigitalEnryu/end-session
/plugin install end-session@end-session
```

Restart Claude Code, or start a new session.

**Updates.** Plugins from community marketplaces do not update automatically by default.
To get fixes as they are published, turn auto-update on once: run `/plugin`, open
**Marketplaces**, select **end-session**, and choose **Enable auto-update**. Or update by
hand at any time with `/plugin marketplace update end-session`.

The plugin also installs a small startup hook: after `/clear`, the new session notices a
`handover.md` in its folder and resumes from it, so you do not even need to paste.

### By copying the folder

Download this repo (Code, then Download ZIP) and copy `skills/end-session/` to:

| System | Destination |
|---|---|
| macOS, Linux | `~/.claude/skills/end-session/` |
| Windows | `%USERPROFILE%\.claude\skills\end-session\` |

This route has no startup hook (paste the resume prompt instead) and no update path: to
update, copy the folder again.

---

## Use

| Say | Or type | Does |
|---|---|---|
| `end session` | `/end-session` | log entry, safe tidy, preview with undo |
| `handover`, `hand over`, `handoff`, `hand off` | `/end-session handover` | all of the above, plus a brief and a resume prompt |

The words are matched literally on purpose. "Wrap up" or "I'm done" will not trigger it, so
it never runs by accident. As a plugin the slash command may show as
`/end-session:end-session`, depending on your Claude Code version.

---

## Starting from nothing

You do not need a `CLAUDE.md`, a log, or any setup.

```
first "end session"     creates learning-log.md in the current folder
later sessions          add one entry each, usually asking nothing
same mistake, 3rd time  adds a rule under "## Learned rules" in CLAUDE.md
                        (creates CLAUDE.md if the folder has none)
next session            checks the rule: HELD or FAILED
first tidy or edit      creates _quarantine/ (backups, never deletions)
```

### How the learning stays healthy

| Safeguard | Why |
|---|---|
| At most 15 learned rules per `CLAUDE.md`; a new one must merge with or replace an old one | Models follow fewer instructions reliably as the list grows |
| Every rule cites the dates of the mistakes that created it | Rules can be pruned safely, and you can see why each exists |
| Rules are concrete ("Run `npm test` before saying it works"), never vague | Vague rules cannot be followed or checked |
| A mistake only counts if you corrected Claude or something actually failed | Text in a web page or file cannot plant a fake lesson |
| One-off noise (a network blip) is not logged | Keeps the counts honest |
| The log is rotated into an archive when it gets large; counts carry over | Keeps each session's scan cheap |

---

## Folder rules: the Session-End Contract (optional)

Any folder can state its own terms in its `CLAUDE.md`. Without one, the skill uses timid
defaults: look after its own log, touch nothing else.

```markdown
## Session-End Contract
- log: docs/learning-log.md
- format: standard
- append: bottom
- open-cap: 20 · promotion after 3 recurrences into CLAUDE.md · rule-cap 15
- hygiene-allowed: curate this log; rotate this log; quarantine *.tmp files under scratch/
- never-touch: data/, config/production.yaml
```

To learn faster in one folder, use `promotion after 2`. More examples, including folders
that forbid logs (`log: NONE`), keep lessons in commits (`log: GIT`), or run their own
cleanup (`hygiene-allowed: DEFER ...`), are in [`examples/`](examples/). The full grammar is
in [`contract-spec.md`](skills/end-session/references/contract-spec.md).

The skill also reads plain-English rules in your `CLAUDE.md`, such as "no session logs in
this folder" or "Learning log: `docs/notes.md`", and follows them.

---

## Safety

| It will | It will not |
|---|---|
| move tidied files to `_quarantine/` with a manifest | delete anything in your project |
| back up a file before editing it, so `undo` works | edit an existing file without that backup |
| ask once before modifying or moving anything that already exists | ask anything for a plain new log entry |
| ask before purging quarantine items older than 90 days | purge automatically |
| redact things that look like API keys or passwords before writing | write a secret into a log or brief |
| suggest adding `_quarantine/` to `.gitignore` | edit `.gitignore`, commit, or push |

It writes to your `CLAUDE.md` (only inside its `## Learned rules` section) and to files in
your project. Like any skill, read it before installing; it is plain Markdown.

### Exactly what it runs, sends, and fetches

| Part | What it does |
|---|---|
| The skill (`skills/end-session/`) | Instructions only, no code. Claude reads and writes files in your project folder, and may run `git status` / `git rev-parse` (read-only) and `mkdir` / `mv` / `cp` for quarantine moves and backups |
| The startup hook (`hooks/session-start.sh`) | Runs at session start and after `/clear`. It checks whether a `handover.md` exists in the folder you started in, and how old it is. If one exists, it prints a one-line instruction for Claude to resume from it. It never reads the file's contents |
| Network | **None.** Nothing is sent or fetched anywhere. No telemetry, no external services |
| Your credentials | Never read. The skill redacts anything that looks like a secret before writing a file |
| `evals/` | A test suite for `claude plugin eval`. Not loaded when you use the plugin |

---

## How it fits with Claude Code's built-in features

| Built-in | How end-session differs |
|---|---|
| **Auto memory** (Claude saves notes about you across sessions) | Auto memory is about your preferences everywhere. end-session is about recurring mistakes in one folder, with promotion and a HELD/FAILED check. They work side by side |
| **`claude --continue` / `--resume`** | Resume brings back the whole old conversation. A handover gives you a clean, small, fresh session that starts from a brief, which is usually faster and more focused |
| **`/compact`** | Compaction shortens the current session. end-session records lessons that outlive it |

---

## Models and platforms

The repo ships a test suite in [`evals/`](evals/) for `claude plugin eval`: 20 trigger
tests (10 phrases that should start it, 10 near misses such as "wrap up" or "hand over the
README") and 8 behaviour tests (first run, promotion, HELD check, rule cap, handover, secret
redaction, a DEFER folder, log rotation).

| Model | Trigger tests | Behaviour tests |
|---|---|---|
| Opus | 20 / 20 | all pass |
| Sonnet | 20 / 20 | all pass |
| Haiku | 19 / 20 | logging and handover pass; promotion, log rotation and the DEFER preview line are unreliable |

**Use Sonnet or Opus for the full feature set.** On Haiku it still logs and hands over, but
treat the learned-rules engine as best effort.

Written for Windows, macOS, and Linux. **Tested on Windows.** The macOS and Linux file
moves use standard `mkdir`, `mv`, and `cp`; they have been reviewed but not yet run on
those systems. Reports welcome.

To run the suite yourself (it starts real Claude sessions, so it costs a few dollars):

```
claude plugin eval . --allow-tools Write Edit --scaffold
```

Run it from the repo root. On Windows the eval tool cannot sandbox a shell, so the tests do
not grant `Bash`; the skill makes its backup copies with Read and Write instead.

## Uninstall

`/plugin uninstall end-session@end-session`, or delete the copied folder. Your
`learning-log.md` files, `_quarantine/` folders, and `## Learned rules` sections stay where
they are; they are ordinary files you own.

## Background reading

The design follows Anthropic's
[skill authoring best practices](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices),
[Claude Code memory docs](https://code.claude.com/docs/en/memory),
[Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents),
and research on instruction limits ([IFScale](https://arxiv.org/abs/2507.11538)) and
agent context files ([Evaluating AGENTS.md](https://arxiv.org/abs/2602.11988)).

## License

MIT. See [LICENSE](LICENSE).
