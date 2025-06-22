# execute-plan.md

## Instructions for Completing Prompts in **$ARGUMENTS** Using TDD

Follow these step-by-step instructions to systematically complete any unfinished prompts in **$ARGUMENTS**. For each prompt, ensure you use a test-driven development (TDD) approach and maintain clear communication with the user.

---

### Step 1: Identify Incomplete Prompts

- Open **$ARGUMENTS**.
- Review the list of prompts and identify those **not marked as completed**.

### Step 2: Validate Prompt Status

For each prompt you believe is incomplete:

- **Double-check** whether it is truly unfinished.
  - If you are uncertain about its status or need clarification, **ask the user** before proceeding.
  - If you confirm the prompt is already complete, **skip it** and move to the next one.

### Step 3: Apply TDD Workflow

For each confirmed incomplete prompt:

1. **Write the test(s) first** to define the expected behavior (in line with TDD best practices).
2. **Run the tests** to ensure they fail initially, confirming the feature is not yet implemented.
3. **Implement the functionality** as described in the prompt.
4. **Re-run the tests** and verify that all tests now pass.
5. **Check for linting and formatting errors** and resolve any issues to ensure code quality.
6. **Update** **$ARGUMENTS** to mark this prompt as completed.

### Step 4: Commit Changes

- Commit your changes with a **clear, descriptive commit message** summarizing what was completed.

### Step 5: Pause for User Review

- After finishing each prompt, **pause** and await user review or feedback before proceeding.
- Only move to the next unfinished prompt as directed by the user.

---

**Notes:**

- Use clear delimiters (such as code blocks or checklist items) in your updates for easy tracking.
- Communicate progress and any uncertainties promptly.
- Maintain high standards for code quality, documentation, and commit messages.

---

Proceed step-by-step, ensuring clarity, quality, and user involvement at each stage.
