#!/bin/bash
# Sync shared content from ai-sdlc-workflows into codex-plugins
# Usage: sync-shared.sh [rules|agents|templates|references|all] [source-base-dir]
# Default source: ~/Projects/ai-sdlc-workflows/shared
set -euo pipefail

WHAT="${1:-all}"
SOURCE_BASE="${2:-${HOME}/Projects/ai-sdlc-workflows/shared}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"
REPO_ROOT="${SCRIPT_DIR}/.."

if [ ! -d "$SOURCE_BASE" ]; then
  echo "Error: ai-sdlc-workflows not found at: $SOURCE_BASE"
  echo "Clone it first: gh repo clone qwickapps/ai-sdlc-workflows ~/Projects/ai-sdlc-workflows"
  exit 1
fi

sync_content() {
  local type="$1"
  local src="$SOURCE_BASE/$type"
  local target="$REPO_ROOT/$type"
  local pattern="${2:-*.md}"

  if [ ! -d "$src" ]; then
    echo "Warning: $src not found, skipping"
    return
  fi

  mkdir -p "$target"
  find "$src" -maxdepth 1 -name "$pattern" -exec cp {} "$target/" \;
  count=$(find "$target" -maxdepth 1 -name "$pattern" | wc -l | tr -d ' ')
  echo "Synced $count $type files"
}

sync_references() {
  local target="$REPO_ROOT/references"
  mkdir -p "$target"

  # Sync references from claude-plugins submodule
  for ref_dir in "$REPO_ROOT"/shared/plugins/*/references/; do
    if [ -d "$ref_dir" ]; then
      find "$ref_dir" -maxdepth 1 -name "*.md" -exec cp {} "$target/" \;
    fi
  done

  # Also check skill-level references
  for ref_dir in "$REPO_ROOT"/shared/plugins/*/skills/*/references/; do
    if [ -d "$ref_dir" ]; then
      find "$ref_dir" -maxdepth 1 -name "*.md" -exec cp {} "$target/" \;
    fi
  done

  count=$(find "$target" -maxdepth 1 -name "*.md" | wc -l | tr -d ' ')
  echo "Synced $count reference files"
}

case "$WHAT" in
  rules)      sync_content rules "*.md" ;;
  agents)     sync_content agents "*.md" ;;
  templates)  sync_content templates "*.md" ;;
  references) sync_references ;;
  all)
    sync_content rules "*.md"
    sync_content agents "*.md"
    sync_content templates "*.md"
    sync_references
    ;;
  *)
    echo "Usage: $0 [rules|agents|templates|references|all]"
    exit 1
    ;;
esac

echo "Done."
