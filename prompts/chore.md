---
description: Maintenance and cleanup tasks. Lighter workflow for dependency updates, CI fixes, config changes, and other non-feature work that still needs discipline.
---

The /prompts:chore command provides disciplined maintenance without full feature ceremony. Issue tracking and verification are still required.

## Argument

Accept an optional argument via $ARGUMENTS: a description of the chore. If not provided, ask the user what maintenance work needs to be done before proceeding.

## Workflow

### Step 1: Define Scope

Load `$tracking-issues` to create a new GitHub issue with the label `chore`. If the user provided an existing issue number, link to it.

If the scope is ambiguous, ask the user:
- What specifically needs to change
- What is out of scope for this chore
- Whether there are any compatibility or environment constraints

Restate the agreed scope explicitly before proceeding.

### Step 2: Implementation

Choose the approach based on the type of chore.

**Dependency updates:**
- Identify the dependency and the target version
- Check the package's changelog for breaking changes
- Update the dependency in `package.json`, run `pnpm install` (or `npm install`) to update the lockfile, run the full test suite immediately after updating

**CI/CD changes:**
- Load `$deploying` for context on the deployment pipeline
- Read the relevant CI configuration files before making any changes
- Make the minimum change needed

**Configuration changes:**
- Read the existing configuration before modifying it
- Verify consistency across environments

**Code cleanup:**
- Load `$writing-tests` if the cleanup touches behavior
- Make the minimum change needed
- Run linting after cleanup

Load `$creating-worktree` to set up an isolated workspace if the change involves code or configuration files.

### Step 3: Verification

Load `$verifying-completion`.

Run build, tests, and lint. If any gate fails, STOP and show the exact failure output.

### Step 4: Commit and Close

Commit with `chore:` conventional commits prefix. Reference the issue number.

Commit message example: `chore: update eslint to v9 (#88)`

The PR description must include:
- What changed and the motivation
- What was verified
- Any follow-up work

Close the GitHub issue on merge. Do not close it before the PR is merged.
