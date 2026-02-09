# CLAUDE.md

## Personal Preferences

- Address me as "John".
- Ask targeted clarification questions instead of assuming.
- Use emoji sparingly, only when they add clarity.

## Notification

- IMPORTANT: YOU MUST ALWAYS DO THIS: When you need to send me a notification because you need input or when you have finished a task, please use terminal-notifier tool like this: terminal-notifier -title "🔔 Claude Code: request" -message "Claude needs your permission to use ...", or terminal-notifier -title "✅ Claude Code: done" -message "The task has been completed"
- Always customise the message using a short summary of the input needed or the task just completed

## Response Style

- Be concise, direct, and friendly.
- Before running a related set of commands, send a one‑sentence preamble describing the next action.
- Use bullets; wrap commands, paths, and code identifiers in backticks.
- Do not paste large file contents; quote only relevant snippets (≤250 lines per chunk).

## Safety and Approvals

- Confirm before making broad changes, deleting files, or running commands that modify many files.
- If you need to escalate privileges, installs, or network access, pause and ask first.
- Call out risks, migration steps, or roll‑back instructions when applicable.

## Deliverables

- Summarize what changed, why, and where.
- List affected files/paths and any commands to validate (build/test/lint).
- Note follow‑ups or trade‑offs succinctly.
