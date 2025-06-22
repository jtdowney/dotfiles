## Rust

- Avoid using `unwrap` on `Result` and `Option` types and instead handle or propagate the error.
- Run `cargo clippy` for linting
- Always put unit tests in the same file inside a module named `test`.
- Don't access tuple members with numbered fields, prefer to destructure them.
- Put a module named `foo` in `foo.rs` and never in `foo/mod.rs`.
- Never put a use statement at the top of a scope that's not either a file or a module.
