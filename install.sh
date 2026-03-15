#!/bin/bash
# QwickApps Codex Plugins Installer
# Installs skills, prompts, and configuration for OpenAI Codex CLI
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
AGENTS_HOME="${AGENTS_HOME:-$HOME/.agents}"

echo "=== QwickApps Codex Plugins Installer ==="
echo ""

# ── Step 1: Verify submodule ────────────────────────────────────
if [ ! -f "$SCRIPT_DIR/shared/plugins/sdlc/.claude-plugin/plugin.json" ]; then
  echo "Initializing git submodule..."
  (cd "$SCRIPT_DIR" && git submodule update --init --recursive)
fi
echo "[1/6] Submodule: OK"

# ── Step 2: Install skills ─────────────────────────────────────
echo ""
echo "Installing skills to $AGENTS_HOME/skills/..."
mkdir -p "$AGENTS_HOME/skills"

skill_count=0
for skill_dir in "$SCRIPT_DIR"/.agents/skills/*/; do
  [ -d "$skill_dir" ] || continue
  skill_name=$(basename "$skill_dir")
  target="$AGENTS_HOME/skills/$skill_name"

  # Remove existing symlink or directory
  if [ -L "$target" ]; then
    rm "$target"
  elif [ -d "$target" ]; then
    echo "  Warning: $target exists and is not a symlink, skipping"
    continue
  fi

  ln -s "${skill_dir%/}" "$target"
  skill_count=$((skill_count + 1))
done
echo "[2/6] Skills: $skill_count installed"

# ── Step 3: Install prompts ────────────────────────────────────
echo ""
echo "Installing prompts to $CODEX_HOME/prompts/..."
mkdir -p "$CODEX_HOME/prompts"

prompt_count=0
for prompt_file in "$SCRIPT_DIR"/prompts/*.md; do
  [ -f "$prompt_file" ] || continue
  prompt_name=$(basename "$prompt_file")
  cp "$prompt_file" "$CODEX_HOME/prompts/$prompt_name"
  prompt_count=$((prompt_count + 1))
done
echo "[3/6] Prompts: $prompt_count installed"

# ── Step 4: Install rules ──────────────────────────────────────
echo ""
echo "Installing rules to $CODEX_HOME/rules/..."
mkdir -p "$CODEX_HOME/rules"

rule_count=0
for rule_file in "$SCRIPT_DIR"/rules/*; do
  [ -f "$rule_file" ] || continue
  rule_name=$(basename "$rule_file")
  cp "$rule_file" "$CODEX_HOME/rules/$rule_name"
  rule_count=$((rule_count + 1))
done
echo "[4/6] Rules: $rule_count installed"

# ── Step 5: Config guidance ─────────────────────────────────────
echo ""
echo "[5/6] Configuration"
echo ""
echo "  To use agent personas, merge the following into your config.toml:"
echo "    $SCRIPT_DIR/config/sdlc-agents.toml"
echo ""
echo "  For a complete setup, see:"
echo "    $SCRIPT_DIR/config/full-setup.toml"
echo ""

# ── Step 6: Copy AGENTS.md to home if not exists ────────────────
if [ -f "$SCRIPT_DIR/AGENTS.md" ] && [ ! -f "$AGENTS_HOME/AGENTS.md" ]; then
  cp "$SCRIPT_DIR/AGENTS.md" "$AGENTS_HOME/AGENTS.md"
  echo "[6/6] Copied AGENTS.md to $AGENTS_HOME/"
else
  echo "[6/6] AGENTS.md: skipped (already exists or source missing)"
fi

# ── Summary ─────────────────────────────────────────────────────
echo ""
echo "=== Installation Complete ==="
echo ""
echo "  Skills:  $skill_count (in $AGENTS_HOME/skills/)"
echo "  Prompts: $prompt_count (in $CODEX_HOME/prompts/)"
echo "  Rules:   $rule_count (in $CODEX_HOME/rules/)"
echo ""
echo "Quick start:"
echo "  codex                          # Start Codex CLI"
echo "  /prompts:feature \"add auth\"    # Run a feature workflow"
echo "  /prompts:bug \"login broken\"    # Investigate a bug"
echo "  /prompts:commit                # Commit with validation gates"
echo ""
echo "Sync shared content from ai-sdlc-workflows:"
echo "  bash $SCRIPT_DIR/scripts/sync-shared.sh"
