---
globs: "*.rs, Cargo.toml"
alwaysApply: false
---

# Rust

## Cargo
- Always add dependencies with `cargo add` so we get the latest version

## Style
- Format with `cargo +nightly fmt -v -- --config-path ~/code/myrustfmt.toml`
- Run `cargo clippy` before committing
- No `unwrap`—handle or propagate errors
- Destructure tuples; don't use `.0`, `.1`
- Prefer functional style with iterators over loops
- `use` only at file/module scope

## Structure
- Modules: `foo.rs` not `foo/mod.rs`
- Unit tests in same file under `mod test`
- Use `cargo add` for dependencies (gets latest version)
