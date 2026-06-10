#!/usr/bin/env bash
# Approximate usage stats for a skill from local Claude Code transcripts.
# Counts are session-level greps, not telemetry — treat as directional.
# Can take a minute on large transcript histories.
set -euo pipefail
NAME="${1:?usage: usage-stats.sh <skill-name>}"
PROJECTS="$HOME/.claude/projects"
SKILL_DIR="$HOME/.claude/skills/$NAME"

count_sessions() {
  grep -rlE "$1" "$PROJECTS" --include='*.jsonl' 2>/dev/null | wc -l | tr -d ' '
}

echo "skill: $NAME"
echo "sessions invoking the skill: $(count_sessions "Launching skill: $NAME|\"skill\": ?\"$NAME\"")"
if [ -d "$SKILL_DIR/references" ]; then
  echo "sessions reading each reference file:"
  for f in "$SKILL_DIR"/references/*.md; do
    [ -e "$f" ] || continue
    echo "  $(count_sessions "$NAME/references/$(basename "$f")")  $(basename "$f")"
  done
fi
