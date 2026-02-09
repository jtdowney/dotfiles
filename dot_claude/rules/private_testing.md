# Testing

## TDD Workflow
- Use TDD for multi-step features, complex logic, or integrations
- For small/obvious changes, add focused tests covering the change
- Red → Green → Refactor:
  1. Write a specific failing test for the desired behavior
  2. Run to verify it fails for the right reason
  3. Implement the minimal code to pass
  4. Refactor while keeping tests green

## Test Design
- Name tests descriptively: `test_<function>_<scenario>_<expected>`
- Consider property-based tests for complex logic (Hypothesis, PropEr, proptest)
- Keep test output clean; capture and assert expected errors/messages

## Mocking
- Use mocks/fakes at module boundaries for unit tests
- Prefer real dependencies for integration tests
- Avoid external network calls unless approved

## Completion
- All added/affected tests must pass before marking work complete
