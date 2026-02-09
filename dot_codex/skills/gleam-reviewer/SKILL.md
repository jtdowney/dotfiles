---
name: gleam-reviewer
description: Review Gleam code for idiomatic patterns and best practices. Triggers when user says "review this code", "review this", or asks for code review on Gleam files. Also use proactively after writing or modifying Gleam code to catch issues before the user asks.
---

# Gleam Code Review

Review Gleam code against these guidelines and suggest improvements.

## Function Design

- Prefer small, composable functions over large blocks of code
- Functions should do one thing well
- Extract complex logic into named helper functions

## Control Flow

- Avoid deep nesting; use `result.try` and `bool.guard` for early returns
- Prefer composable pipelines (`|>`) over excessive `use` syntax
- Use `use` for callbacks, but don't overuse it—pipelines are often clearer

```gleam
// Prefer pipeline
items
|> list.filter(is_valid)
|> list.map(transform)

// Over nested use
use item <- list.filter_map(items)
// ...
```

## Error Handling

- Never return `Option(t)` from a function; use `Result(t, Nil)` instead
- `let assert` is acceptable in tests and `main`; in library code it's acceptable if provably safe, but prefer explicit error handling when a reasonable alternative exists
- Handle errors explicitly with `result.try`, `result.map`, or pattern matching

## Test Style

- Use newer assert style: `assert foo == "bar"` over `foo |> should.equal("bar")`
- Use `qcheck.run` for property-based tests

## Comments

- Avoid extraneous comments that duplicate what the code does—they get outdated quickly
- If code needs a comment to explain what it does, rewrite the code to be clearer instead
- Comments are helpful only when something is especially tricky or noteworthy for a special reason
- Good: `// PKCS#7 padding requires block alignment` (explains *why*, not *what*)
- Bad: `// Loop through the list and filter valid items` (just describes the code)

## Review Output

For each issue found:
1. Quote the problematic code
2. Explain the issue briefly
3. Show the suggested fix
