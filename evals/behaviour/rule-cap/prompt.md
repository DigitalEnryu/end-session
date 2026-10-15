---
name: rule-cap
tags: [behaviour]
runs: 1
max_turns: 30
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit]
append_system_prompt: "You are running in a non-interactive test. AskUserQuestion is unavailable. Whenever the end-session skill would ask the user a question, assume the user chose the first option and continue without asking."
---
Earlier you told me a script worked but you had not run it, and it crashed when I ran it. That is the third time. Create add.py with add(a, b), then:

end session
