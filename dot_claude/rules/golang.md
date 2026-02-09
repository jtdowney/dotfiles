---
globs: "*.go"
alwaysApply: false
---

# Go

## Style
- Format with `gofmt` or `go fmt`
- Run `golangci-lint run` for static analysis
- Handle errors explicitly; don't ignore with `_`
- Wrap errors with `fmt.Errorf("context: %w", err)`
- Use early returns to reduce nesting
- Use `context.Context` as first parameter
- Interfaces defined where used, not where implemented

## Testing
- Tests in `*_test.go` files in same package
- Test files named same as implementation (`foo.go` → `foo_test.go`)
- Prefer table-driven tests with subtests
- Keep tests compact, no extraneous test files
