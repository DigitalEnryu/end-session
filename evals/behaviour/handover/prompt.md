---
name: handover
tags: [behaviour]
runs: 1
max_turns: 30
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit]
append_system_prompt: "You are running in a non-interactive test. AskUserQuestion is unavailable. Whenever the end-session skill would ask the user a question, assume the user chose the first option and continue without asking."
---
Create todo.md listing three tasks: A, B and C. We have finished A. For task B we decided to use SQLite instead of Postgres, because the laptop has no Docker; we tried Postgres in Docker first and it failed to start. Task B also needs the schema from task A, which lives in schema.sql. The next session should do task B.

handover
