# QwickApps Codex Plugins

SDLC discipline, quality gates, and engineering workflows for [OpenAI Codex CLI](https://github.com/openai/codex).

Part of the QwickApps multi-tool AI ecosystem — same skills and workflows available across Claude Code, OpenClaw, and Codex.

## Quick Start

### Option 1: Install all skills at once

```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/qwickapps/codex-plugins.git ~/codex-plugins
cd ~/codex-plugins

# Install skills to ~/.agents/skills/, AGENTS.md to ~/.codex/, prompts to ~/.codex/prompts/
bash install.sh

# Start using in any project
codex
$brainstorming    # Skills are invoked with $name
```

### Option 2: Install individual skills via $skill-installer

Inside Codex CLI:
```
$skill-installer install https://github.com/qwickapps/codex-plugins/tree/master/.agents/skills/writing-tests
$skill-installer install https://github.com/qwickapps/codex-plugins/tree/master/.agents/skills/debugging
```

### Option 3: Project-level (check into your repo)

```bash
# Copy specific skills into your project
mkdir -p .agents/skills
cp -r ~/codex-plugins/.agents/skills/writing-tests .agents/skills/
cp -r ~/codex-plugins/.agents/skills/debugging .agents/skills/
# Codex auto-discovers skills in .agents/skills/
```

### Where things go

| Content | Location | Discovery |
|---------|----------|-----------|
| Skills | `~/.agents/skills/` | Auto-discovered globally |
| Skills (project) | `.agents/skills/` | Auto-discovered per repo |
| AGENTS.md | `~/.codex/AGENTS.md` | Read on every session start |
| AGENTS.md (project) | `AGENTS.md` in repo root | Read per project |
| Prompts | `~/.codex/prompts/` | Invoked via `/prompts:name` (deprecated — use skills instead) |
| Config | `~/.codex/config.toml` | Merged with project `.codex/config.toml` |

## What's Included

### Prompts (11)

Codex slash commands invoked via `/prompts:<name>`. Note: custom prompts are [deprecated](https://developers.openai.com/codex/custom-prompts/) in favor of skills. These prompts still work but may be converted to skills in a future release.

| Prompt | Purpose |
|--------|---------|
| `/prompts:feature` | Full SDLC feature development (requirements → design → plan → implement → review → docs → commit) |
| `/prompts:bug` | Bug investigation and fix (root cause → regression test → fix → verify) |
| `/prompts:chore` | Maintenance tasks (dependency updates, CI fixes, config changes) |
| `/prompts:commit` | Controlled commit with validation gates (build, test, lint) |
| `/prompts:docs` | Documentation updates verified against code |
| `/prompts:refactor` | Code restructuring with behavior preservation tests |
| `/prompts:release` | Version release management (changelog, migration guide, tag) |
| `/prompts:research` | Deep technical investigation with evidence-based findings |
| `/prompts:review` | Code quality assessment (security, quality, patterns, correctness, testing) |
| `/prompts:secrets` | Manage encrypted environment variables (SOPS+age) |
| `/prompts:secrets-init` | Bootstrap encrypted secrets for a new repo |

### Skills (38)

Skills load automatically based on context. They provide deep procedural knowledge for specific techniques.

#### SDLC (23)

| Skill | When it activates |
|-------|-------------------|
| `brainstorming` | Starting a new feature, unclear scope |
| `closing-sprint` | Ending a sprint cycle |
| `creating-worktree` | Starting isolated workspace |
| `debugging` | Bug or unexpected behavior |
| `delegating-tasks` | Independent tasks for parallel execution |
| `deploying` | CI/CD, Docker, environment promotion |
| `designing-ux` | Building user-facing interfaces |
| `estimating-effort` | Effort estimates before commitment |
| `executing-plans` | Batch execution of implementation plans |
| `finishing-branch` | Implementation complete, ready to merge |
| `getting-started` | Session start, system orientation |
| `optimizing-performance` | Performance profiling and optimization |
| `parallelizing-work` | Multiple independent investigations |
| `planning-release` | Release preparation and versioning |
| `receiving-review` | Evaluating review feedback |
| `requesting-review` | Dispatching code review |
| `securing-code` | Auth, API endpoints, input handling |
| `starting-sprint` | Beginning a new sprint |
| `tracking-issues` | GitHub issue creation and management |
| `verifying-completion` | Evidence-based completion checks |
| `writing-plans` | Breaking designs into implementation tasks |
| `writing-skills` | Creating new skills for plugins |
| `writing-tests` | TDD: RED-GREEN-REFACTOR cycle |

#### Cloud (5)

| Skill | Purpose |
|-------|---------|
| `planning-infrastructure` | Gather cloud infrastructure requirements |
| `provisioning-oci` | Create Oracle Cloud VMs via OCI CLI |
| `configuring-services` | Install software on VMs (CapRover, PostgreSQL, OpenClaw) |
| `setting-up-dns` | Create Cloudflare DNS records |
| `setting-up-free-services` | Set up free SaaS accounts (R2, Supabase, Upstash, Resend) |

#### Deploy (2)

| Skill | Purpose |
|-------|---------|
| `provisioning` | Set up CapRover apps and gateways |
| `troubleshooting` | Debug deployment failures and health checks |

#### Dev Guide (4)

| Skill | Purpose |
|-------|---------|
| `use-stack` | Choose and configure QwickApps stack components |
| `qwickapps-cms` | Payload CMS integration via @qwickapps/cms |
| `qwickapps-server` | Gateway layer via @qwickapps/server |
| `qwickapps-react-framework` | Frontend app shell via @qwickapps/react-framework |

#### UX Design (3)

| Skill | Purpose |
|-------|---------|
| `frontend-design` | UI/UX design patterns and accessibility |
| `find-component` | Find existing framework components |
| `extend-framework` | Extend the component framework |

#### Secrets (1)

| Skill | Purpose |
|-------|---------|
| `env-management` | SOPS+age encrypted environment management |

### Agent Personas (8)

Behavioral profiles loaded during specific workflow phases:

| Persona | Role | When active |
|---------|------|-------------|
| Architect | Design, ADRs, impact analysis | Design phases |
| Coder | Implementation, TDD, clean code | Implementation phases |
| Reviewer | Quality assessment | Review phases |
| DevOps | CI/CD, infrastructure | Deployment |
| Quality Engineer | Test strategy, quality gates | Test planning |
| Product Manager | Requirements, user stories | Requirements gathering |
| Engineering Manager | Sprint planning, coordination | Planning |
| Tech Writer | Documentation | Documentation phases |

### Starlark Rules

`rules/sdlc.rules` — enforces validation gates before commits (Codex equivalent of pre-commit hooks).

## How Sharing Works

```
ai-sdlc-workflows/shared/        ← Rules, agents, templates (synced via scripts/sync-shared.sh)
    ├── rules/      (10 .md)
    ├── agents/     (8 .md + .yml)
    └── templates/  (10 .md)

claude-plugins/                   ← Skills, commands, scripts (git submodule at shared/)
    └── plugins/
        ├── sdlc/skills/    (23 skills)
        ├── cloud/skills/   (5 skills)
        ├── deploy/skills/  (2 skills)
        ├── dev-guide/skills/ (4 skills)
        ├── ux-design/skills/ (3 skills)
        └── secrets/skills/ (1 skill)

codex-plugins (this repo)
    ├── .agents/skills/    ← Symlinks to shared/plugins/*/skills/*
    ├── prompts/           ← Adapted from claude-plugins commands
    ├── templates/         ← Synced from ai-sdlc-workflows
    └── shared/            ← Git submodule → claude-plugins
```

Two content sources feed this repo:
- **claude-plugins** (git submodule at `shared/`): provides SKILL.md files via symlinks
- **ai-sdlc-workflows** (synced via `scripts/sync-shared.sh`): provides rules, agents, and templates

Skills use the open [Agent Skills](https://github.com/anthropics/agent-skills) standard (SKILL.md format) — portable across Claude Code, Codex, and GitHub Copilot.

## Configuration

### Agent Personas

Merge agent definitions into `~/.codex/config.toml` or your project's `.codex/config.toml`:

```toml
# From config/sdlc-agents.toml
[agents.architect]
model = "o3"
model_reasoning_effort = "high"
description = "Senior software architect. Propose approaches with trade-offs, document decisions using ADR format."

[agents.coder]
model = "codex-mini"
model_reasoning_effort = "medium"
description = "Senior software engineer. Follow TDD, write clean minimal code following existing patterns."
```

See `config/full-setup.toml` for all 8 agent personas.

### Syncing Shared Content

Sync rules, agents, templates, and references from `ai-sdlc-workflows`:

```bash
# Requires: gh repo clone qwickapps/ai-sdlc-workflows ~/Projects/ai-sdlc-workflows
bash scripts/sync-shared.sh          # Sync everything
bash scripts/sync-shared.sh rules    # Sync just rules
bash scripts/sync-shared.sh templates # Sync just templates
```

## Directory Structure

```
codex-plugins/
├── AGENTS.md                    # Session guidance (Codex equivalent of CLAUDE.md)
├── install.sh                   # Setup script
├── .agents/skills/              # 38 skill directories (symlinked to shared/)
│   ├── brainstorming/
│   │   ├── SKILL.md             # Symlink → shared/plugins/sdlc/skills/brainstorming/SKILL.md
│   │   └── agents/openai.yaml   # Codex-specific metadata
│   └── ...
├── prompts/                     # 11 Codex slash commands
│   ├── feature.md
│   ├── bug.md
│   └── ...
├── rules/                       # Starlark execution policies
│   └── sdlc.rules
├── config/                      # Ready-to-use config.toml snippets
│   ├── sdlc-agents.toml
│   └── full-setup.toml
├── templates/                   # Synced from ai-sdlc-workflows
├── references/                  # Synced from claude-plugins + ai-sdlc-workflows
├── scripts/
│   └── sync-shared.sh
└── shared/                      # Git submodule → claude-plugins
```

## Requirements

- [OpenAI Codex CLI](https://github.com/openai/codex) installed
- Git (for submodules)
- `gh` CLI (for issue tracking workflows)

## License

MIT
