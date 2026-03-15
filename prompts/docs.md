---
description: Documentation updates. Identifies what changed, updates relevant docs (README, CHANGELOG, API docs), and verifies accuracy against code.
---

The /prompts:docs command keeps documentation accurate and synchronized with the codebase.

## Argument

Accept an optional argument via $ARGUMENTS: the topic or file to document. If not provided, derive the scope from the current branch or recent changes.

## Workflow

### Step 1: Identify Scope

Determine what needs documenting:

1. If an argument was provided, use it as the scope.
2. If on a feature branch, run `git diff main...HEAD --name-only` to find changed files.
3. If an issue number is in context (e.g., from the branch name), retrieve that issue and use it to infer the scope.
4. If none of the above apply, ask the user what to document.

### Step 2: Assess Documentation Scope

For the identified scope, check which need updates (read each file first):

- README.md: setup instructions, features list, configuration reference, environment variables
- CHANGELOG.md: new version entry if following a code change
- API documentation: new or changed endpoints, updated request/response shapes
- Code comments: non-obvious logic, public API surface

Use Grep to search for references to the changed symbols or features across existing documentation.

### Step 3: Write Updates

For each document identified:
1. Read the current content.
2. Identify what is outdated or missing by comparing against the actual code.
3. Write the update.

Rules:
- Verify every file path, function signature, and behavior claim against the actual code
- Include code examples only if they can be verified against the implementation
- Keep documentation minimal and accurate

### Step 4: Verify Accuracy

Cross-reference every factual claim in the updated documentation against the code.

### Step 5: Stage and Commit

Stage only documentation files. Use a `docs:` conventional commit prefix. Ask the user for approval before committing.
