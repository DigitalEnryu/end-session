#!/usr/bin/env bash
# SessionStart hook for the end-session plugin.
#
# If a handover.md sits in the folder the session starts in, tell Claude to resume
# from it. When there is no handover.md this prints nothing, so it costs no context.
# It only checks that the file exists and how old it is; it never reads its contents.

dir="${CLAUDE_PROJECT_DIR:-$PWD}"
file="$dir/handover.md"

[ -f "$file" ] || exit 0

# Fresh means modified within the last 24 hours (1440 minutes).
if [ -n "$(find "$file" -mmin -1440 2>/dev/null)" ]; then
  msg="end-session: a handover brief exists at $file, written in the last 24 hours. Before replying to the user's first message, read it and follow its section 0 (How to resume). If the user's first message is clearly about something else, mention the brief in one line and ask whether to resume from it."
else
  msg="end-session: an older handover brief exists at $file (more than 24 hours old). Do not act on it yet. In your first reply, mention it in one line and ask whether to resume from it, since it may be stale."
fi

# Escape backslashes and double quotes so the message is valid JSON.
esc=$(printf '%s' "$msg" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g')

printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$esc"
exit 0
