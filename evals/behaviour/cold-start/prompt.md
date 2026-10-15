---
name: cold-start
tags: [behaviour]
runs: 1
max_turns: 30
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit]
append_system_prompt: "You are running in a non-interactive test. AskUserQuestion is unavailable. Whenever the end-session skill would ask the user a question, assume the user chose the first option and continue without asking."
---
Create a file notes.txt containing the word hello.

end session
