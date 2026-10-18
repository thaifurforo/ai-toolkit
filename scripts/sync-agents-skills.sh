#!/usr/bin/env bash
# Sync harness-* skills into the agent skills directory.
# Linux/mac default: ~/.agents/skills
# Windows (Git Bash / WSL): often /c/Users/<you>/.agents/skills or ~/.agents/skills
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/skills"
DEST="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"

if [[ ! -d "$SRC" ]]; then
  echo "error: skills directory not found at $SRC" >&2
  exit 1
fi

mkdir -p "$DEST"

count=0
for d in "$SRC"/harness-*; do
  [[ -d "$d" ]] || continue
  name="$(basename "$d")"
  rm -rf "$DEST/$name"
  cp -a "$d" "$DEST/$name"
  echo "synced $name → $DEST/$name"
  count=$((count + 1))
done

if [[ "$count" -eq 0 ]]; then
  echo "error: no skills/harness-* directories found under $SRC" >&2
  exit 1
fi

echo "Done. Synced $count harness skill(s) to $DEST"
echo "Windows mirror (if applicable): C:\\Users\\<you>\\.agents\\skills\\"
