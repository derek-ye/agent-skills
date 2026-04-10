---
name: review-pipeline
description: Full adversarial review pipeline — runs simplify-loop then code-review-loop sequentially. Bash-enforced convergence with max 3 epochs per phase.
allowed-tools: Bash
---

Run the full review pipeline. This runs two phases sequentially:
1. **Simplify loop** — iteratively simplifies changed files
2. **Code review loop** — iteratively reviews and fixes architectural issues

Find and run `review-pipeline/scripts/review-pipeline.sh` relative to this plugin's installation directory. The plugin root is two levels up from this SKILL.md file.

Run it with Bash. Example:
```bash
~/agents/claude-skills/review-pipeline/scripts/review-pipeline.sh
```

Environment variables you can set before running:
- `MAX_EPOCHS` (default: 3) — maximum loop iterations per phase
- `BASE_BRANCH` (default: master) — branch to diff against
- `MAX_TURNS` (default: 30) — max agentic turns per call

After the pipeline completes, review all changes with `git diff master`.
