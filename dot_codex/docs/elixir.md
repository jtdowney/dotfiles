# Elixir
- Pattern match instead of conditional logic where possible
- Use `{:ok, result}` / `{:error, reason}` tuples for error handling
- Tests in `test/` directory, matching source structure
- Test files named `*_test.exs` matching implementation files
- Use `describe` blocks for grouping related tests
- Prefer pipelines `|>` for data transformations
- Keep GenServer callbacks simple, extract logic to pure functions
