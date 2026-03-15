---
description: Code restructuring with behavior preservation. Creates a GitHub issue, analyzes impact, writes behavior preservation tests, restructures code, and verifies no behavior change.
---

The /prompts:refactor command ensures restructuring preserves existing behavior. Do not restructure any code before behavior preservation tests are written and passing.

## Argument

Accept an optional argument via $ARGUMENTS: what to refactor. If not provided, ask the user what they want to restructure and why.

## Phases

### Phase 1: Analysis

Load `$tracking-issues` to create a new GitHub issue with the label `refactor`.

Load `$brainstorming` for impact analysis. Use all available tools to identify the full blast radius:
- Search the codebase to trace all code paths that touch the target code
- Use Grep to find all consumers, callers, and importers
- Use Read to inspect integration points

Document the impact analysis: all affected components with file:line references, all consumers, all dependencies, integration points.

Present the impact analysis to the user and get explicit agreement on scope.

### Phase 2: Plan

Load `$writing-plans` to produce a detailed restructuring plan.

Document before and after structure. Create a checklist where each task includes the structural change and behavior preservation check. Tasks must be sequenced so each one leaves the codebase working.

### Phase 3: Implementation

Load `$creating-worktree` to set up an isolated workspace.

Load `$writing-tests` to write behavior preservation tests BEFORE any restructuring begins. The behavior preservation tests must:
- Exercise every externally observable behavior of the code being restructured
- Cover all consumers identified in Phase 1
- Cover edge cases identified during analysis
- Pass against the current (pre-restructure) code

Run tests to confirm they pass before restructuring. If any test fails before restructuring, STOP and ask how to proceed.

For each task:
1. Make the structural change
2. Run the full behavior preservation test suite
3. Run the full existing test suite
4. Build must pass, all tests must pass

If any behavior preservation test fails after a structural change: STOP immediately, do not continue to the next task, identify which behavior changed (file:line), fix the structural change to restore the behavior, re-run all tests before continuing.

### Phase 4: Verification

Load `$verifying-completion`. Produce evidence of behavior preservation.

### Phase 5: Commit

Load `$finishing-branch`. The PR description must:
- Link to the issue with `Closes #N`
- State what was restructured and the motivation
- List the behavior preservation tests written and where they live
- Confirm that no behavior changed (with reference to the passing test suite)
- List any known follow-up work

Close the issue on merge. Do not close it before the PR is merged.
