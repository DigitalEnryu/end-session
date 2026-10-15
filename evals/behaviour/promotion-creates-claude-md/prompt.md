---
name: promotion-creates-claude-md
tags: [behaviour]
runs: 1
max_turns: 30
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit]
append_system_prompt: "You are running in a non-interactive test. AskUserQuestion is unavailable. Whenever the end-session skill would ask the user a question, assume the user chose the first option and continue without asking."
---
Earlier you told me a script worked but you had not run it, and it crashed when I ran it. That is the third time you have done this. Create add.py with a function add(a, b) that returns a + b, then:

end session
