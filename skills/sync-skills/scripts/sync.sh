#!/usr/bin/env bash
# Report skill repo sync state and install links. Read-only unless --link.
# Usage: sync.sh [--link] [extra-repo-path ...]
set -u
LINK=0
[ "${1:-}" = "--link" ] && { LINK=1; shift; }
DESTS=("$HOME/.claude/skills" "$HOME/.agents/skills")
[ -n "${SKILL_DESTS:-}" ] && read -ra DESTS <<< "$SKILL_DESTS"  # for testing

# Repos = extra args + git repos that existing install links point into.
repos=("$@")
for dest in "${DESTS[@]}"; do
  for entry in "$dest"/*; do
    [ -L "$entry" ] && [ -e "$entry" ] || continue
    root=$(git -C "$(readlink "$entry")" rev-parse --show-toplevel 2>/dev/null) && repos+=("$root")
  done
done
repos=($(printf '%s\n' "${repos[@]}" | sort -u))

echo "## Repos"
for repo in "${repos[@]}"; do
  git -C "$repo" fetch -q origin 2>/dev/null || echo "FETCH-FAILED $repo"
  branch=$(git -C "$repo" branch --show-current)
  counts=$(git -C "$repo" rev-list --left-right --count "HEAD...origin/main" 2>/dev/null || echo "? ?")
  echo "$repo  branch=$branch  ahead=${counts%%[[:space:]]*}  behind=${counts##*[[:space:]]}"
  git -C "$repo" status --short | sed 's/^/  DIRTY /'
done

echo "## Skills"
for repo in "${repos[@]}"; do
  for skill in "$repo"/skills/*/; do
    skill=${skill%/}; name=$(basename "$skill")
    if [ ! -f "$skill/SKILL.md" ]; then echo "NO-SKILL-MD $skill"; continue; fi
    fm=$(sed -n '2,/^---$/p' "$skill/SKILL.md" | sed -n 's/^name: *//p' | tr -d '"')
    [ "$fm" = "$name" ] || echo "NAME-MISMATCH $skill (frontmatter: $fm)"
    for dest in "${DESTS[@]}"; do
      target="$dest/$name"
      if [ -L "$target" ]; then
        [ "$(readlink "$target")" = "$skill" ] || echo "POINTS-ELSEWHERE $target -> $(readlink "$target") (repo: $skill)"
      elif [ -e "$target" ]; then
        echo "PLAIN-DIR $target (repo has $skill)"
      elif [ $LINK = 1 ]; then
        mkdir -p "$dest" && ln -s "$skill" "$target" && echo "LINKED $target"
      else
        echo "MISSING $target"
      fi
    done
  done
done

echo "## Broken links and local-only skills"
for dest in "${DESTS[@]}"; do
  for entry in "$dest"/*; do
    if [ -L "$entry" ]; then
      [ -e "$entry" ] || echo "BROKEN $entry -> $(readlink "$entry")"
    elif [ -f "$entry/SKILL.md" ] && ! git -C "$entry" rev-parse 2>/dev/null; then
      echo "LOCAL-ONLY $entry (not in any repo, not backed up)"
    fi
  done
done
echo "## Done"
