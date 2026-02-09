---
globs: "*.ex, *.exs"
alwaysApply: false
---

# Elixir

## Style
- Format with `mix format`
- Run `mix credo` for static analysis
- Pattern match instead of conditional logic where possible
- Use `{:ok, result}` / `{:error, reason}` tuples for error handling
- Prefer pipelines `|>` for data transformations
- Keep GenServer callbacks simple; extract logic to pure functions

## Testing
- Tests in `test/` directory, matching source structure
- Test files named `*_test.exs` matching implementation files
- Use `describe` blocks for grouping related tests
- Use doctests for simple function examples
