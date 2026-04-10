---
name: simplify-loop
description: Adversarial simplify loop — iteratively simplifies changed files with an Editor agent checked by a Reviewer agent. Bash-enforced max 3 epochs.
allowed-tools: Bash
---

Run the simplify loop script. This will iteratively simplify changed files vs master using adversarial Editor + Reviewer agents.

Find and run `review-pipeline/scripts/simplify-loop.sh` relative to this plugin's installation directory. The plugin root is two levels up from this SKILL.md file.

Run it with Bash. Example:
```bash
~/agents/claude-skills/review-pipeline/scripts/simplify-loop.sh
```

Environment variables you can set before running:
- `MAX_EPOCHS` (default: 3) — maximum loop iterations
- `BASE_BRANCH` (default: master) — branch to diff against
- `MAX_TURNS` (default: 30) — max agentic turns per call
