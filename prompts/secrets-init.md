---
description: Bootstrap a new repo with encrypted environments.yml and .sops.yaml configuration.
---

The /prompts:secrets-init command bootstraps the current repository with SOPS+age encrypted environment management.

## What it does

1. Checks prerequisites (sops, age, yq)
2. Finds or generates an age keypair
3. Creates `.sops.yaml` from template
4. Creates `environments.yml` from template
5. Encrypts `environments.yml` with SOPS
6. Updates `.gitignore`

## Execution

### Phase 1: Check prerequisites

Run these checks and report any failures:
```bash
command -v sops && command -v age-keygen && command -v yq
```

If any missing: `brew install sops age yq`. Do not proceed until all three are installed.

### Phase 2: Find or create age key

Check for an existing age key:
1. `$SOPS_AGE_KEY_FILE` (if set)
2. `~/.config/sops/age/keys.txt`
3. `~/Projects/keys/environments.age.key`

If found, extract the public key. If not found, ask the user whether to generate a new keypair.

### Phase 3: Check for existing files

Check if `.sops.yaml` or `environments.yml` already exist. If either exists, ask whether to overwrite.

### Phase 4: Create .sops.yaml

Create `.sops.yaml` with the following content, replacing `<AGE_PUBLIC_KEY>` with the actual public key from Phase 2:

```yaml
creation_rules:
  - path_regex: environments\.yml$
    age: "<AGE_PUBLIC_KEY>"
```

Write this to `.sops.yaml` in the current directory.

### Phase 5: Create environments.yml

Ask the user for the project name (suggest the current directory name as default). Create `environments.yml` with the following template:

```yaml
defaults: &defaults
  NODE_ENV: development

projects:
  <PROJECT_NAME>:
    defaults:
      <<: *defaults
    envs:
      dev:
        APP_URL: "http://localhost:3000"
      prod:
        NODE_ENV: production
        APP_URL: "https://<PROJECT_NAME>.example.com"
```

Replace `<PROJECT_NAME>` with the user's answer.

Then encrypt in place:
```bash
sops -e -i environments.yml
```

Verify encryption succeeded by checking the file starts with `sops:`:
```bash
head -1 environments.yml
```

### Phase 6: Update .gitignore

Append secret exclusions if not already present:
```
*.age.key
.env.local
.env*.local
```

### Phase 7: Summary

Print what was created and next steps:
```
Secrets initialized:
  .sops.yaml          - SOPS configuration (commit this)
  environments.yml    - Encrypted env vars (commit this)
  .gitignore          - Updated with secret exclusions

Next steps:
  sops environments.yml              # Edit variables
  /prompts:secrets list              # Show all projects
  /prompts:secrets resolve -p <project> -e dev  # Preview resolved variables
```
