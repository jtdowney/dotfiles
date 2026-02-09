# Rust Testing Patterns

## Test Organization

Unit tests in same file under `mod test`:
```rust
#[cfg(test)]
mod test {
    use super::*;

    #[test]
    fn parses_valid_input() {
        let result = parse("valid");
        assert!(result.is_ok());
    }
}
```

Integration tests in `tests/` directory.

## Property-Based Testing (quickcheck)

Use `quickcheck` for properties. Good candidates:
- Roundtrip: `decode(encode(x)) == x`
- Idempotence: `normalize(normalize(x)) == normalize(x)`
- Invariants: property holds for all valid inputs

```rust
use quickcheck::quickcheck;

quickcheck! {
    fn roundtrip(input: String) -> bool {
        let encoded = encode(&input);
        let decoded = decode(&encoded).unwrap();
        decoded == input
    }
}
```

For custom types, derive `Arbitrary`:
```rust
use quickcheck::{Arbitrary, Gen};

impl Arbitrary for MyType {
    fn arbitrary(g: &mut Gen) -> Self {
        MyType {
            field: String::arbitrary(g),
        }
    }
}
```

## Snapshot Testing (insta)

Use `insta` for multi-line outputs, JSON structures, error messages:

```rust
use insta::assert_snapshot;

#[test]
fn error_message_snapshot() {
    let error = format_error(SomeError::new("details"));
    assert_snapshot!(error);
}
```

Run `cargo insta review` to accept/review snapshots.

## Dependencies

```bash
cargo add --dev quickcheck quickcheck_macros insta
```
