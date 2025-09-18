# Personal Preferences

- Address me as "John".
- Ask targeted clarification questions instead of assuming.
- Emoji are fine for emphasis, used sparingly.

# Operating Environment

- Structural search first: use ast-grep (`sg --lang <lang> -p '<pattern>'`).
- Text search second: use ripgrep (`rg -n` with sensible globs). Avoid `grep`/`find` unless explicitly requested.
- File I/O: Prefer Read and LS tools. If unavailable, use small, bounded shell reads (e.g., `sed -n '1,200p' <file>` or `rg -n` with line numbers). Avoid dumping large files.
- Batch related tool calls to reduce latency and noise.
- Assume a sandboxed FS and restricted network. Ask before writes, installs, or external calls.

# Response Style

- Be concise, direct, and friendly.
- Before running a related set of commands, send a one‑sentence preamble describing the next action.
- Use bullets; wrap commands, paths, and code identifiers in backticks.
- Do not paste large file contents; quote only relevant snippets (≤250 lines per chunk).

# Code Style

- Prefer simple, maintainable solutions; make the smallest change that satisfies the requirement.
- Match the existing style and conventions in each file.
- No inline code comments unless requested; module docs/docstrings are acceptable.
- Preserve existing comments unless clearly wrong; if wrong, flag them in your summary rather than deleting silently.
- No destructive git operations without explicit permission.

# Testing

- Use TDD for multi‑step features, complex logic, or integrations; for small/obvious changes, add focused tests covering the change.
- Red → Green → Refactor:
  1) Write a specific failing test for the desired behavior.
  2) Run to verify it fails for the right reason.
  3) Implement the minimal code to pass.
  4) Refactor while keeping tests green.
- Mocking: Use mocks/fakes at module boundaries for unit tests. Prefer real dependencies for integration tests. Avoid external network calls unless approved.
- Keep test output clean; capture and assert expected errors/messages.
- All added/affected tests must pass before marking work complete.

# Tool Usage

- Prefer MCP tools when available (`mcp__*`); use `context7` for library docs if present.
- Use `mcp__grep__searchGitHub` for examples/patterns when appropriate.
- Use Task for repo‑wide searches and structured explorations; use Read directly for 2–3 specific files.
- If shell‑only: default to `sg` for structural queries and `rg` for text search. Avoid `cat`, `head`, `tail`, and `ls` unless Read/LS are unavailable.
- Never fabricate URLs. Only use URLs provided by the user or well‑known, relevant programming docs. Ask if uncertain.

# Task Management (TodoWrite)

- Use TodoWrite for any task with 3+ steps, multiple file modifications, complex implementation, or systematic debugging.
- States: pending → in_progress → completed, with exactly one in_progress at a time.
- Create todos at start, update status in real time, and add tasks discovered during implementation.

# Git Commits

- Conventional commits; imperative mood, present tense.
- Limit subject line to 50 characters.
- Run `git status` before committing.
- Do not reference todo.md or feedback.md in commits.

# Safety and Approvals

- Confirm before making broad changes, deleting files, or running commands that modify many files.
- If you need to escalate privileges, installs, or network access, pause and ask first.
- Call out risks, migration steps, or roll‑back instructions when applicable.

# Deliverables

- Summarize what changed, why, and where.
- List affected files/paths and any commands to validate (build/test/lint).
- Note follow‑ups or trade‑offs succinctly.

# Technology‑Specific

- @docs/rust.md
- @docs/golang.md
- @docs/elixir.md
