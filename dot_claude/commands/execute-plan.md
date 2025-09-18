# execute-plan.md

Turn on your plan mode and think hard

## Instructions for Completing the NEXT Unfinished Task in **$ARGUMENTS** Using TDD

Follow these step-by-step instructions to complete ONLY THE NEXT unfinished task in **$ARGUMENTS**. Use a test-driven development (TDD) approach and maintain clear communication with the user.

---

### Step 0: Start Planning


### Step 1: Identify the NEXT Incomplete Task

- Open **$ARGUMENTS**.
- Review the list of tasks and identify the **FIRST task not marked as completed**.
- **STOP** after identifying this single task - do not look at other incomplete tasks.

### Step 2: Validate Task Status

For the single next incomplete task:

- **Double-check** whether it is truly unfinished.
  - If you are uncertain about its status or need clarification, **ask the user** before proceeding.
  - If you confirm the task is already complete, mark it as complete and identify the next incomplete task.

### Step 3: Apply TDD Workflow to This Single Task

For the one confirmed incomplete task:

1. **Write the test(s) first** to define the expected behavior (in line with TDD best practices).
2. **Run the tests** to ensure they fail initially, confirming the feature is not yet implemented.
3. **Implement the functionality** as described in the task.
4. **Re-run the tests** and verify that all tests now pass.
5. **Check for linting and formatting errors** and resolve any issues to ensure code quality.
6. **Update** **$ARGUMENTS** to mark this single task as completed.

### Step 4: Commit Changes

- Commit your changes with a **clear, descriptive commit message** summarizing what was completed.

### Step 5: STOP and Wait for User Direction

- After finishing this ONE task, **STOP completely**.
- Do NOT proceed to any other tasks.
- Wait for explicit user direction before doing anything else.

---

**Notes:**

- Use clear delimiters (such as code blocks or checklist items) in your updates for easy tracking.
- Communicate progress and any uncertainties promptly.
- Maintain high standards for code quality, documentation, and commit messages.

---

Proceed step-by-step, ensuring clarity, quality, and user involvement at each stage.
