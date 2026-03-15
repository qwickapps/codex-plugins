---
description: Version release management. Determines version bump, generates changelog, creates migration guide if needed, tags release, and creates GitHub release.
---

The /prompts:release command manages the full release process.

## Argument

Accept an optional argument via $ARGUMENTS: a version number (e.g., `1.4.0`) or bump type (`major`, `minor`, `patch`, `prerelease`). If not provided, determine the version bump from evidence.

## Phases

### Phase 1: Gather Changes

Load `$planning-release`.

Collect changes since the last release tag:
```
git log $(git describe --tags --abbrev=0)..HEAD --oneline
```

Identify breaking changes: look for `!` after the type or `BREAKING CHANGE:` footers.

### Phase 2: Version Strategy

If no version was specified, present the evidence and recommended bump type. Ask the user to confirm.

### Phase 3: Changelog

Generate a changelog grouped by: Breaking Changes, Features, Bug Fixes, Chores. Each entry must reference its issue or PR number. Write to `CHANGELOG.md`.

### Phase 4: Migration Guide

If major version bump, write a migration guide with before/after code examples for each breaking change.

### Phase 5: Pre-release Checklist

Run build, tests, check for open release-blocker issues, run dependency audit. If any gate fails, STOP.

### Phase 6: Tag and Release

Present the full release summary. Wait for explicit user approval.

Once approved:
- Bump version: `npm version <version>` or `pnpm version <version>`
- Push tag: `git push --follow-tags`
- Create GitHub release: `gh release create <tag> --title "<tag>" --notes-file <changelog-section>`
- For pre-releases, add the `--prerelease` flag to the `gh release create` command.

### Phase 7: Post-release

Load `$deploying` if deployment is needed.

Close the release milestone if one exists:
- `gh api repos/:owner/:repo/milestones` to find it
- `gh api --method PATCH repos/:owner/:repo/milestones/<number> -f state=closed`

Report the completed release: tag name, GitHub release URL, and any deployment status.
