#!/bin/bash
input=$(cat)

REMAINING=$(echo "$input" | jq -r '.context_window.remaining_percentage // 0' | cut -d. -f1)
CWD=$(echo "$input" | jq -r '.cwd')
DIR=$(basename "$CWD")
if [ "$DIR" = "sequence-platform-api" ]; then
  DIR="backend"
fi
BRANCH=$(git -C "$CWD" --no-optional-locks branch --show-current 2>/dev/null)

# Strip known prefixes from branch name
if [ -n "$BRANCH" ]; then
  BRANCH="${BRANCH#kyle/}"
  BRANCH="${BRANCH#kylewaldner/}"
  BRANCH="${BRANCH#kylewaldner02/}"
  # Truncate to 37 chars + "..." if longer
  if [ ${#BRANCH} -gt 37 ]; then
    BRANCH="${BRANCH:0:37}..."
  fi
fi

if [ "$REMAINING" = "0" ]; then
  if [ -n "$BRANCH" ]; then
    printf '\033[36m%s\033[0m \033[35m%s\033[0m \033[33m...\033[0m' "$DIR" "$BRANCH"
  else
    printf '\033[36m%s\033[0m \033[33m...\033[0m' "$DIR"
  fi
else
  if [ -n "$BRANCH" ]; then
    printf '\033[36m%s\033[0m \033[35m%s\033[0m \033[33m%s%% context remaining\033[0m' "$DIR" "$BRANCH" "$REMAINING"
  else
    printf '\033[36m%s\033[0m \033[33m%s%% context remaining\033[0m' "$DIR" "$REMAINING"
  fi
fi
