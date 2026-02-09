# Go
- Handle errors explicitly, don't ignore with `_`
- Use early returns to reduce nesting
- Tests in `*_test.go` files in same package
- Keep tests compact, no extraneous test files
- Test files named same as implementation (e.g., `foo.go` → `foo_test.go`)
- Prefer table-driven tests with subtests
- Use `context.Context` as first parameter
- Interfaces defined where used, not where implemented