---
globs: "*.gleam, gleam.toml"
alwaysApply: false
---

# Gleam
- `let assert` is fine in tests and main but not ok deep in the call tree unless you can prove it is safe
- prefer `use` syntax instead of callbacks
- Always add dependencies with `gleam add` so we get the latest version
- prefer newer assert style in tests (`assert foo == "bar"` over `foo |> should.eq("bar")`)
- DO NOT deeply nest code, use `result.try` and `bool.guard` to return early
