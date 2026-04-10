---
name: code-review-loop
description: Adversarial code review loop — iteratively reviews and fixes architectural/best-practices issues with Reviewer + Editor agents. Bash-enforced max 3 epochs.
allowed-tools: Bash
---

Run the code review loop script. This will iteratively review changed files vs master for architectural and best-practices issues using adversarial Reviewer + Editor agents.

Find and run `review-pipeline/scripts/code-review-loop.sh` relative to this plugin's installation directory. The plugin root is two levels up from this SKILL.md file.

Run it with Bash. Example:
```bash
~/agents/claude-skills/review-pipeline/scripts/code-review-loop.sh
```

Environment variables you can set before running:
- `MAX_EPOCHS` (default: 3) — maximum loop iterations
- `BASE_BRANCH` (default: master) — branch to diff against
- `MAX_TURNS` (default: 30) — max agentic turns per call
