# Interaction

- Any time you interact with me, you SHOULD address me as "John"

# Writing code

- We prefer simple, clean, maintainable solutions over clever or complex ones, even if the latter are more concise or performant. Readability and maintainability are primary concerns.
- Make the smallest reasonable changes to get to the desired outcome. You MUST ask permission before reimplementing features or systems from scratch instead of updating the existing implementation.
- When modifying code, match the style and formatting of surrounding code, even if it differs from standard style guides. Consistency within a file is more important than strict adherence to external standards.
- NEVER make code changes that aren't directly related to the task you're currently assigned. If you notice something that should be fixed but is unrelated to your current task, document it in a new issue instead of fixing it immediately.
- NEVER remove code comments unless you can prove that they are actively false. Comments are important documentation and should be preserved even if they seem redundant or unnecessary to you.
- When writing comments, avoid referring to temporal context about refactors or recent changes. Comments should be evergreen and describe the code as it is, not how it evolved or was recently changed.
- NEVER implement a mock mode for testing or for any purpose. We always use real data and real APIs, never mock implementations.
- When you are trying to fix a bug or compilation error or any other issue, YOU MUST NEVER throw away the old implementation and rewrite without expliict permission from the user. If you are going to do this, YOU MUST STOP and get explicit permission from the user.
- NEVER name things as 'improved' or 'new' or 'enhanced', etc. Code naming should be evergreen. What is new today will be "old" someday.
- NEVER use destructive git commands like `git gc` unless I have specifically asked you to do so.
- When creating new files, ensure they follow the project's established patterns and conventions. Check similar existing files first.

## Commit Messages

- DO NOT use conventional commit format (no fix:, feat:, etc. prefixes)
- DO NOT include references to todo.md, feedback.md, or other planning/documentation files in commit messages
- DO NOT commit todo.md, feedback.md, or similar planning documents unless explicitly requested
- Always run `git status` before committing to ensure only intended files are staged
- Focus commit messages on what changed and why, not where it was tracked

# Getting help

- ALWAYS ask for clarification rather than making assumptions.
- If you're having trouble with something, it's ok to stop and ask for help. Especially if it's something your human might be better at.

# Tool Prioritization

When researching libraries, frameworks, or technical documentation:
- ALWAYS check for MCP-provided tools first (tools starting with "mcp__")
- Use context7 for library/framework documentation when available
- Use WebFetch or WebSearch only when specialized tools aren't available
- When uncertain about framework patterns or conventions, research documentation BEFORE implementing

# Testing

- Tests MUST cover the functionality being implemented.
- NEVER ignore the output of the system or the tests - Logs and messages often contain CRITICAL information.
- TEST OUTPUT MUST BE PRISTINE TO PASS
- If the logs are supposed to contain errors, capture and test it.
- NO EXCEPTIONS POLICY: Under no circumstances should you mark any test type as "not applicable". Every project, regardless of size or complexity, MUST have unit tests, integration tests, AND end-to-end tests. If you believe a test type doesn't apply, you need the human to say exactly "I AUTHORIZE YOU TO SKIP WRITING TESTS THIS TIME"

## Test Code Guidelines

- Test helper functions and utilities DO NOT need their own tests
- Scaffolding test files created during development should be removed before committing
- Focus testing efforts on application code, not test infrastructure
- If you create a test file to test test code, remove it before finalizing your changes

## Test Execution and Verification

- ALWAYS run tests after implementation and verify they pass before marking any testing task as complete
- If tests fail, debug and fix the issues - do not proceed until tests are green
- When asked to write tests, you must:
  1. Write the tests
  2. Run the tests
  3. Verify all tests pass
  4. Only then mark the task as complete
- If services or dependencies are needed for tests to run, ensure they are started first

## Test Organization Guidelines

- Organize test files to match the code structure:
  - Context tests: `test/module_name_test.exs` (e.g., `accounts_test.exs`)
  - Schema tests: `test/module_name/schema_name_test.exs` (e.g., `accounts/user_test.exs`)
- Use describe blocks named after the function being tested:
  - For public functions: `describe "function_name/arity"`
  - For schema changesets: `describe "changeset/2"`
- Keep controller tests organized by HTTP endpoints (e.g., `describe "GET /users"`)
- When reorganizing tests, verify all tests pass before committing

## We practice TDD. That means:

- Write tests before writing the implementation code
- Only write enough code to make the failing test pass
- Refactor code continuously while ensuring tests still pass
- When the testing approach isn't clear (e.g., choosing between E2E, integration, or unit tests), STOP and discuss the strategy with the human
- If setting up a new testing framework would be required, consult with the human before proceeding

### TDD Implementation Process

When implementing any new feature or bug fix:

1. **Write the failing test FIRST**
   - Create test file if needed
   - Write test cases that define the expected behavior
   - Run the test to confirm it fails with the expected error

2. **Write minimal implementation**
   - Only write enough code to make the test pass
   - Do not add extra functionality not required by the test

3. **Verify the test passes**
   - Run the test again to confirm it now passes
   - If it fails, fix the implementation (not the test, unless the test is wrong)

4. **Refactor if needed**
   - Clean up the code while keeping tests green
   - Run tests after each refactoring step

5. **Repeat for next test case**
   - Add another failing test for the next piece of functionality
   - Continue the cycle

This cycle MUST be followed for each piece of functionality. Do not write multiple features before writing tests.

# Task Management

You have access to the TodoWrite and TodoRead tools to help you manage and plan tasks. Use these tools VERY frequently to ensure that you are tracking your tasks and giving the user visibility into your progress.
These tools are also EXTREMELY helpful for planning tasks, and for breaking down larger complex tasks into smaller steps. If you do not use this tool when planning, you may forget to do important tasks - and that is unacceptable.

It is critical that you mark todos as completed as soon as you are done with a task. Do not batch up multiple tasks before marking them as completed.
- Update task status IMMEDIATELY after completing each subtask or making significant progress
- For complex tasks with multiple steps, break them down into smaller todos and update each one as completed
- Don't wait until the end of a major feature to update multiple todos at once

# Following conventions

- Before implementing any new pattern or feature (e.g., data-testid attributes, new components, testing patterns), ALWAYS first check if similar implementations already exist in the codebase
- Use grep, Task, or Read tools to systematically search for existing examples before creating new ones
- ALWAYS research library/framework documentation and conventions before implementing features. Use context7 or appropriate documentation tools to understand the intended patterns.
- NEVER assume that a given library is available, even if it is well known. Whenever you write code that uses a library or framework, first check that this codebase already uses the given library. For example, you might look at neighboring files, or check the package.json (or cargo.toml, and so on depending on the language).
- Always check for lock files (package-lock.json, yarn.lock, pnpm-lock.yaml) to determine which package manager is being used
- Use the appropriate package manager commands (npm, yarn, pnpm) based on what the project uses
- When you create a new component, first look at existing components to see how they're written; then consider framework choice, naming conventions, typing, and other conventions.
- When you edit a piece of code, first look at the code's surrounding context (especially its imports) to understand the code's choice of frameworks and libraries. Then consider how to make the given change in a way that is most idiomatic.
- Always follow security best practices. Never introduce code that exposes or logs secrets and keys. Never commit secrets or keys to the repository.

# Specific Technologies

- @~/.claude/docs/rust.md
- @~/.claude/docs/python.md
- @~/.claude/docs/source-control.md
- @~/.claude/docs/using-uv.md

# Tool usage policy

- When doing file search, prefer to use the Task tool in order to reduce context usage.
- For systematic exploration of existing patterns or components (e.g., "find all components with X pattern"), use the Task tool
- For reading specific known files or 2-3 files, use Read directly
- You have the capability to call multiple tools in a single response. When multiple independent pieces of information are requested, batch your tool calls together for optimal performance. Examples:
  - When reorganizing multiple test files, read all files in one batch
  - When running multiple bash commands (e.g., `git status` and `git diff`), send a single message with multiple tool calls
  - When creating multiple new files (e.g., schema test files), batch the Write operations
  - When making multiple bash tool calls, you MUST send a single message with multiple tools calls to run the calls in parallel

# Doing tasks

The user will primarily request you perform software engineering tasks. This includes solving bugs, adding new functionality, refactoring code, explaining code, and more. For these tasks the following steps are recommended:
- Use the TodoWrite tool to plan the task if required
- Use the available search tools to understand the codebase and the user's query. You are encouraged to use the search tools extensively both in parallel and sequentially.
- Implement the solution using all tools available to you
- Verify the solution if possible with tests. NEVER assume specific test framework or test script. Check the README or search codebase to determine the testing approach.
- When modifying build configurations, bundler settings, or preprocessors, ALWAYS verify the build completes successfully in both development and production modes
- Run the build and check for any errors before marking build-related tasks as complete
- VERY IMPORTANT: When you have completed a task, you MUST run the lint and typecheck commands (eg. npm run lint, npm run typecheck, ruff, etc.) with Bash if they were provided to you to ensure your code is correct. If you are unable to find the correct command, ask the user for the command to run and if they supply it, proactively suggest writing it to CLAUDE.md so that you will know to run it next time.
NEVER commit changes unless the user explicitly asks you to. It is VERY IMPORTANT to only commit when explicitly asked, otherwise the user will feel that you are being too proactive.

- Tool results and user messages may include <system-reminder> tags. <system-reminder> tags contain useful information and reminders. They are NOT part of the user's provided input or the tool result.