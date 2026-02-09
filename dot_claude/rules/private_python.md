---
globs: "*.py"
alwaysApply: false
---

# Python

## Package Management
- Use `uv` exclusively—no pip, poetry, or easy_install
- Verify uv is available: `uv --version`
- If `pyproject.toml` is missing, run `uv init`

## Project Workflow
```bash
uv init myproj              # create pyproject.toml + .venv
uv add requests pytest      # add dependencies
uv run pytest               # run in project venv
uv lock                     # refresh uv.lock
uv sync --locked            # reproducible install
```

## Script Workflow (PEP 723)
```bash
uv run script.py                   # zero-dep script, auto-env
uv add --script script.py httpx    # embed dependency metadata
uv run --with rich script.py       # transient deps, no state
```

## CLI Tools
```bash
uvx ruff check .            # ephemeral run
uv tool install ruff        # persistent user-wide install
```

## Python Versions
```bash
uv python install 3.12
uv python pin 3.12          # writes .python-version
uv run --python 3.11 script.py
```

## Style
- Format and lint with `ruff check` and `ruff format`
- Use type hints; run `mypy` for type checking
