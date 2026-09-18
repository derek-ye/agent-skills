# Agent skills

Canonical repository: https://github.com/derek-ye/agent-skills

Edit reusable skills in `skills/` here. Local agent installations should link to this checkout instead of maintaining independent copies. Git pull/push synchronizes the checkout with GitHub; symlinks do not fetch remote changes.

## Codex

Codex supports individual skill-directory symlinks under `~/.agents/skills`. For a new skill, run this from the repository root, replacing `skill-name`:

```sh
ln -s "$PWD/skills/skill-name" "$HOME/.agents/skills/skill-name"
```

If the destination already exists, inspect it first; preserve independent edits rather than overwriting it. Keep built-in skills and unrelated installed skills in their existing locations.

## Claude Code

The same skill directory can be linked under `~/.claude/skills`:

```sh
ln -s "$PWD/skills/skill-name" "$HOME/.claude/skills/skill-name"
```

The existing review-loop skills invoke Claude-based scripts; linking them into Codex does not convert their execution engine to Codex. Resolve script paths from this repository's real checkout, not the symlink location. Historical `~/agents/claude-skills` examples refer to the old checkout.

## Skills

- `work-priority-summary`: concise work inventory with overall summary, project relevance, dependencies and attention recommendations.
- `review-pipeline`, `code-review-loop`, `simplify-loop`: existing Claude-backed review workflows.

- `ponytail`: upstream minimal-code skill by DietrichGebert; source and MIT license in its directory.
- `update-weekly-todos`: maintain concise Obsidian weekly action lists with ordering and context links.
