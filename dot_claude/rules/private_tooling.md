# Tooling

## Operating Environment

- Structural search first: use ast-grep (`sg --lang <lang> -p '<pattern>'`).
  - Instead of the Search tool use ast-grep to find things like function and member names.
- Text search second: use ripgrep (`rg -n` with sensible globs). Avoid `grep`/`find` unless explicitly requested.
- File I/O: Prefer Read and LS tools. If unavailable, use small, bounded shell reads (e.g., `sed -n '1,200p' <file>` or `rg -n` with line numbers). Avoid dumping large files.
- Batch related tool calls to reduce latency and noise.
- Assume a sandboxed FS and restricted network. Ask before writes, installs, or external calls.

## Tool Usage

- Prefer MCP tools when available (`mcp__*`); use `mcp__context7` for library docs if present.
- Use `mcp__grep__searchGitHub` for examples/patterns when appropriate.
- Use Task for repo‑wide searches and structured explorations; use Read directly for 2–3 specific files.
- If shell‑only: default to `sg` for structural queries and `rg` for text search. Avoid `cat`, `head`, `tail`, and `ls` unless Read/LS are unavailable.
- Never fabricate URLs. Only use URLs provided by the user or well‑known, relevant programming docs. Ask if uncertain.

## Task Management (TodoWrite)

- Use TodoWrite for any task with 3+ steps, multiple file modifications, complex implementation, or systematic debugging.
- States: pending → in_progress → completed, with exactly one in_progress at a time.
- Create todos at start, update status in real time, and add tasks discovered during implementation.
