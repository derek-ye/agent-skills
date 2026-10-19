---
name: simplify-loop
description: Compatibility entry point for a focused simplification pass using Derek's code preferences. Use for cleanup requests; no longer launches a Claude CLI shell loop.
---

# Simplify changed code

Use [derek-code-pass](../derek-code-pass/SKILL.md) on the requested scope and run
checks appropriate to actual edits. No worthwhile edits is a valid result. Do not
repeatedly rewrite code to satisfy stylistic reviewer preferences.

If review was also requested, continue through
[code-review-loop](../code-review-loop/SKILL.md). Review the full candidate even if
simplification made no edits; an empty unstaged diff does not mean an empty branch
diff. Report cleanup and verification separately from review status.
