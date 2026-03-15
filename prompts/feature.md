---
description: Full SDLC feature development. Creates a GitHub issue, runs through requirements, design, planning, implementation, review, documentation, and commit phases.
---

The /prompts:feature command runs a full SDLC cycle for a new feature.

## Argument

Accept an optional argument via $ARGUMENTS: the feature description. If not provided, ask the user what feature they want to build before proceeding.

## Phases

### Phase 1: Requirements

Load `$tracking-issues` to create a new GitHub issue with the label `feature`. If the user provided an issue number instead of a description, link to the existing issue rather than creating a new one.

Load `$brainstorming` to explore the user's intent. Ask the user to clarify:
- Scope: what is in and out of scope
- Acceptance criteria: what does done look like
- Constraints: performance, security, compatibility requirements
- Affected surfaces: frontend, backend, database, API

Do not proceed to design until scope is agreed.

### Phase 2: Design

Continue with brainstorming's design phase to produce a technical approach.

For frontend work, also load `$designing-ux` to address UI/UX considerations, component structure, and user flow.

For complex features with significant architectural impact, use /plan to present the design to the user and get explicit sign-off before proceeding to planning.

Document design decisions with rationale. For significant architectural decisions, document an Architecture Decision Record (ADR) in `docs/adrs/`.

### Phase 3: Planning

Load `$writing-plans` to produce a detailed implementation plan.

Create a checklist of bite-sized tasks. Each task must:
- Be independently completable
- Have a clear definition of done
- Follow TDD: test first, then implementation
- Be small enough to complete in one focused session

Each task's done criteria must include: build passes, tests pass, lint passes, no regressions.

### Phase 4: Implementation

Load `$creating-worktree` to set up an isolated workspace for the feature branch.

For the execution strategy, choose based on task complexity:
- Use `$delegating-tasks` to dispatch a subagent per task when tasks are independent and well-defined
- Use `$executing-plans` for batch execution when tasks are tightly coupled

For each task during implementation:
1. Load `$writing-tests` to write tests before the implementation
2. Implement the minimum code to make tests pass
3. Load `$securing-code` to identify and address security concerns
4. Verify the task's definition of done before marking it complete

Apply validation gates after each task: build must pass, tests must pass, no regressions.

### Phase 5: Review

Load `$requesting-review` to dispatch a code review. The review covers correctness, security, performance, and adherence to codebase conventions.

Address all blocking review comments before proceeding.

Load `$verifying-completion` for an evidence-based completion check. Verify:
- All acceptance criteria from Phase 1 are met
- All tasks are marked complete
- Build and test suite pass in a production-like environment
- No regressions in related functionality

### Phase 6: Documentation

Update documentation:
- Update or create user-facing documentation for the feature
- Update API documentation if interfaces changed
- Update the README if the feature changes setup or configuration
- Add inline code comments for non-obvious logic

Documentation must reflect the final implemented state, not the design.

### Phase 7: Commit and PR

Load `$finishing-branch` to finalize the branch.

Reference the GitHub issue number in every commit message using `#N` notation. The PR description must:
- Link to the issue with `Closes #N`
- Summarize what changed and why
- Include the test plan used to verify the feature
- List any known limitations or follow-up work

Run full validation before creating the PR. Do not create the PR until all validation passes.
