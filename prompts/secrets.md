---
description: Manage encrypted environment variables. Subcommands: list, resolve, local, github, github-infra, caprover, diff, worktree, validate.
---

The /prompts:secrets command manages encrypted environment variables stored in `environments.yml` (SOPS+age encrypted).

## Argument

Accept a required subcommand via $ARGUMENTS, followed by optional flags:

```
/prompts:secrets <subcommand> [--project <name>] [--env <env>] [--dry-run] [--output <path>]
```

Subcommands:
- `list` - List all projects and environments
- `resolve` - Output merged KEY=VALUE pairs (requires --project, --env)
- `local` - Generate .env files for local dev (requires --project, --env)
- `github` - Push project secrets to GitHub Actions (requires --project, --env)
- `github-infra` - Push infrastructure secrets to GitHub Actions
- `caprover` - Generate CapRover env file (requires --project, --env)
- `diff` - Compare resolved vs current targets (requires --project)
- `worktree` - Generate .env files for a worktree (requires --project)
- `validate` - Validate environments.yml schema

## Execution

### Step 1: Parse the argument

Extract the subcommand and flags. If no argument, default to `list`.

Map natural language to subcommands:
- "show me all projects" -> `list`
- "generate env for myapp dev" -> `local --project myapp --env dev`
- "push myapp prod to github" -> `github --project myapp --env prod`

### Step 2: Build and run the command

Construct and run: `bash scripts/sync-env.sh <subcommand> [flags]`

Examples:
```bash
# List all projects
bash scripts/sync-env.sh list

# Resolve myapp prod
bash scripts/sync-env.sh resolve --project myapp --env prod

# Generate local .env
bash scripts/sync-env.sh local --project myapp --env dev --output ./apps/myapp/.env.local

# Dry run github sync (creates MYAPP_PROD_<KEY> secrets)
bash scripts/sync-env.sh github --project myapp --env prod --dry-run

# Push infrastructure secrets (CapRover URLs, global tokens)
bash scripts/sync-env.sh github-infra --dry-run

# Worktree env generation
bash scripts/sync-env.sh worktree --project myapp --output .
```

### Step 3: Present results

Show the command output. If the command fails, check:
1. Is `sops` installed?
2. Is `yq` installed?
3. Does `environments.yml` exist?
4. Is the age key accessible?
