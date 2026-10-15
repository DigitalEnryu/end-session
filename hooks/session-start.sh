#!/usr/bin/env bash
# SessionStart hook for the end-session plugin.
#
# If a handover.md sits in the folder the session starts in, tell Claude to resume
# from it. When there is no handover.md this prints nothing, so it costs no context.
# It reads no environment variables and no file contents, and sends nothing anywhere:
# it only checks, by relative path, whether handover.md exists and how old it is.

[ -f handover.md ] || exit 0

# Fresh means modified within the last 24 hours (1440 minutes).
if [ -n "$(find handover.md -mmin -1440 2>/dev/null)" ]; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"end-session: a handover brief (handover.md) exists in this folder, written in the last 24 hours. Before replying to the user'"'"'s first message, read it and follow its section 0 (How to resume). If the user'"'"'s first message is clearly about something else, mention the brief in one line and ask whether to resume from it."}}'
else
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"end-session: an older handover brief (handover.md, more than 24 hours old) exists in this folder. Do not act on it yet. In your first reply, mention it in one line and ask whether to resume from it, since it may be stale."}}'
fi
exit 0
