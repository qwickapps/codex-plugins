---
description: Code quality assessment. Reviews code, PRs, or diffs for security, quality, patterns, and correctness. Outputs issues with file:line, severity, and fix recommendations.
---

The /prompts:review command performs a thorough code quality assessment. Never auto-comment on PRs without explicit user approval.

## Argument

Accept an optional argument via $ARGUMENTS: a PR number, branch name, or file paths. If no argument, review staged and unstaged changes.

## Workflow

### Step 1: Identify Scope

**PR number (e.g., `123` or `#123`):**
- `gh pr view 123` and `gh pr diff 123`

**Branch name:**
- `git diff main...branch-name`

**File paths:**
- Read each specified file

**No argument:**
- `git diff --staged` and `git diff`
- If both empty, ask the user what to review

### Step 2: Gather Context

Identify test files associated with the changed code. If reviewing a PR, read the PR description. Use Grep to find existing patterns in the codebase.

### Step 3: Assess

Evaluate across five dimensions. For each finding, note file:line, dimension, severity, and a concrete fix recommendation.

**Security** — OWASP Top 10 checklist: input validation, output encoding, authentication, authorization, injection, sensitive data exposure.

Load `$securing-code` for deeper security analysis if the code touches auth or data access paths.

**Quality** — DRY violations, YAGNI violations, naming, readability, error handling, dead code.

**Patterns** — Consistency with codebase conventions (verified by Grep).

**Correctness** — Logic errors, off-by-one, race conditions, null dereferences, type mismatches.

**Testing** — Missing tests, trivial tests, missing edge cases.

### Step 4: Output Findings

Present findings ordered by severity:

```
[SEVERITY] file:line
Description: What the issue is and why it matters.
Fix: Concrete recommendation.
```

Severity levels: CRITICAL, HIGH, MEDIUM, LOW.

Summary: total issues by severity, overall assessment (Approve / Approve with comments / Request changes), key strengths.

### Step 5: Post to PR (optional)

If reviewing a PR, ask the user whether to post findings as a PR review comment. Wait for explicit approval. Never auto-post.
