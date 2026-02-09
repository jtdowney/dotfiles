# Gleam Testing Patterns

## Test Style

Prefer the newer assert style:
```gleam
// Good
assert result == expected
assert list.length(items) == 3

// Avoid
result |> should.equal(expected)
```

## Exact Matching

Match full values, not substrings. Avoid `string.contains` in assertions:
```gleam
// Good - exact match
assert result == Error(ParseError("apu and apv must be distinct"))

// Avoid - partial match hides regressions
let assert Error(ParseError(msg)) = result
assert string.contains(msg, "must be distinct")
```

Partial matches can miss:
- Typos or wording changes
- Missing context in error messages
- Accidental message truncation

## Property-Based Testing (qcheck)

Use `qcheck` for properties. Good candidates:
- Roundtrip: `decode(encode(x)) == x`
- Idempotence: `normalize(normalize(x)) == normalize(x)`
- Invariants: property holds for all valid inputs

```gleam
import qcheck

pub fn roundtrip_property_test() {
  qcheck.run(
    qcheck.default_config(),
    qcheck.string(),
    fn(input) {
      let encoded = encode(input)
      let assert Ok(decoded) = decode(encoded)
      assert decoded == input
    },
  )
}
```

Generators:
- `qcheck.string()` - arbitrary strings
- `qcheck.int()` - arbitrary integers
- `qcheck.string_from(qcheck.alphanumeric_ascii_codepoint())` - constrained strings
- `qcheck.list(generator)` - lists of generated values

## Snapshot Testing (birdie)

Use `birdie` for multi-line outputs, JSON structures, error messages:

```gleam
import birdie

pub fn error_message_snapshot_test() {
  let error = format_error(SomeError("details"))
  birdie.snap(error, "formatted error message")
}
```

Run `gleam run -m birdie` to accept/review snapshots.

## Test Organization

- Test file mirrors source: `src/foo/bar.gleam` → `test/foo/bar_test.gleam`
- Integration tests in `test/integration/`
- Shared fixtures in `test/support/`
- Test functions end with `_test`

## Dependencies

```bash
gleam add --dev qcheck birdie
```
