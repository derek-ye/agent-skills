# Review Pipeline Plugin — Design Spec

## Context

Currently, running code simplification and code review in Claude Code is a manual, sequential process: invoke `/simplify`, review the output, invoke a code reviewer, fix findings, re-review. This is repetitive and interruptible. The goal is to automate this into a self-correcting loop with adversarial prompting that converges on clean code, packaged as a standalone Claude Code plugin that can be shared across projects.

**Key design decisions from brainstorming:**
- Two-agent adversarial architecture (Editor + Reviewer) — not three. The separation that matters is "the thing that changes code" vs "the thing that judges changes."
- Bash-enforced loops — the agent cannot control iteration count. Bash `for` loops guarantee max epochs.
- Adversarial prompts create tension without adding agents — the Editor knows it will be checked, the Reviewer knows it will be evaluated on calibration.
- Three composable skills: `/simplify-loop`, `/code-review-loop`, `/review-pipeline` (runs both).

## Repository Structure

```
claude-review-pipeline/
├── .claude-plugin/
│   └── plugin.json                # Plugin manifest
├── package.json                   # Node metadata
├── README.md
├── skills/
│   ├── simplify-loop/
│   │   └── SKILL.md               # Thin wrapper → invokes scripts/simplify-loop.sh
│   ├── code-review-loop/
│   │   └── SKILL.md               # Thin wrapper → invokes scripts/code-review-loop.sh
│   └── review-pipeline/
│       └── SKILL.md               # Thin wrapper → invokes scripts/review-pipeline.sh
├── scripts/
│   ├── simplify-loop.sh           # Bash-enforced simplify loop
│   ├── code-review-loop.sh        # Bash-enforced code review loop
│   └── review-pipeline.sh         # Orchestrator: runs both sequentially
└── prompts/
    ├── editor-simplify.md          # System prompt: simplify editor agent
    ├── reviewer-simplify.md        # System prompt: simplify reviewer agent
    ├── editor-review.md            # System prompt: code review editor agent
    └── reviewer-review.md          # System prompt: code review reviewer agent
```

## Skills

### `/simplify-loop`

**Purpose:** Iteratively simplify changed files until the reviewer says they're clean.

**Invocation:** `/simplify-loop` in Claude Code, or `scripts/simplify-loop.sh` directly.

**SKILL.md:** Thin wrapper that tells Claude to run `scripts/simplify-loop.sh` via Bash tool.

### `/code-review-loop`

**Purpose:** Iteratively review and fix architectural/best-practices issues until clean.

**Invocation:** `/code-review-loop` in Claude Code, or `scripts/code-review-loop.sh` directly.

**SKILL.md:** Thin wrapper that tells Claude to run `scripts/code-review-loop.sh` via Bash tool.

### `/review-pipeline`

**Purpose:** Run simplify-loop then code-review-loop sequentially.

**Invocation:** `/review-pipeline` in Claude Code, or `scripts/review-pipeline.sh` directly.

**SKILL.md:** Thin wrapper that tells Claude to run `scripts/review-pipeline.sh` via Bash tool.

## Scripts

### `scripts/simplify-loop.sh`

```bash
#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
MAX_EPOCHS=${MAX_EPOCHS:-3}
BASE_BRANCH=${BASE_BRANCH:-master}
BUDGET_PER_CALL=${BUDGET_PER_CALL:-2.00}
MAX_TURNS=${MAX_TURNS:-15}

CHANGED_FILES=$(git diff "$BASE_BRANCH" --name-only --diff-filter=ACMR | grep -E '\.(ts|tsx|js|jsx|css)$' || true)

if [ -z "$CHANGED_FILES" ]; then
    echo "No changed files vs $BASE_BRANCH. Nothing to simplify."
    exit 0
fi

echo "=== Simplify Loop ==="
echo "Changed files: $(echo "$CHANGED_FILES" | wc -l | tr -d ' ')"
echo "Max epochs: $MAX_EPOCHS"

for epoch in $(seq 1 "$MAX_EPOCHS"); do
    echo ""
    echo "--- Epoch $epoch/$MAX_EPOCHS ---"

    # Editor pass: simplify the changed files
    echo "[Editor] Simplifying..."
    claude -p \
        --effort max \
        --model opus \
        --max-turns "$MAX_TURNS" \
        --max-budget-usd "$BUDGET_PER_CALL" \
        --allowedTools "Read,Edit,Glob,Grep,Bash(git diff*)" \
        --append-system-prompt-file "$PLUGIN_DIR/prompts/editor-simplify.md" \
        --output-format text \
        "Simplify the following changed files. Focus on reducing complexity, removing duplication, and cleaning up patterns. Files: $CHANGED_FILES"

    # Check if editor made any changes
    DIFF=$(git diff)
    if [ -z "$DIFF" ]; then
        echo "[Reviewer] No changes made by editor. Clean."
        break
    fi

    # Reviewer pass: judge the diff
    echo "[Reviewer] Reviewing changes..."
    VERDICT=$(git diff "$BASE_BRANCH" | claude -p \
        --effort max \
        --model opus \
        --max-turns 5 \
        --max-budget-usd "$BUDGET_PER_CALL" \
        --allowedTools "Read,Glob,Grep" \
        --append-system-prompt-file "$PLUGIN_DIR/prompts/reviewer-simplify.md" \
        --output-format text \
        "Review this diff for simplification quality. Respond with ONLY one of:
         - 'CLEAN' if changes are good and no further simplification needed
         - 'NEEDS_WORK: <specific feedback>' if more work is needed")

    echo "[Reviewer] Verdict: $VERDICT"

    if echo "$VERDICT" | grep -qi "^CLEAN"; then
        echo "Clean after $epoch epoch(s)."
        break
    fi

    if [ "$epoch" -eq "$MAX_EPOCHS" ]; then
        echo "Reached max epochs ($MAX_EPOCHS). Stopping."
    fi
done

echo ""
echo "=== Simplify Loop Complete ==="
echo "Review changes with: git diff $BASE_BRANCH"
```

### `scripts/code-review-loop.sh`

```bash
#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
MAX_EPOCHS=${MAX_EPOCHS:-3}
BASE_BRANCH=${BASE_BRANCH:-master}
BUDGET_PER_CALL=${BUDGET_PER_CALL:-2.00}
MAX_TURNS=${MAX_TURNS:-15}

CHANGED_FILES=$(git diff "$BASE_BRANCH" --name-only --diff-filter=ACMR | grep -E '\.(ts|tsx|js|jsx|css)$' || true)

if [ -z "$CHANGED_FILES" ]; then
    echo "No changed files vs $BASE_BRANCH. Nothing to review."
    exit 0
fi

echo "=== Code Review Loop ==="
echo "Changed files: $(echo "$CHANGED_FILES" | wc -l | tr -d ' ')"
echo "Max epochs: $MAX_EPOCHS"

for epoch in $(seq 1 "$MAX_EPOCHS"); do
    echo ""
    echo "--- Epoch $epoch/$MAX_EPOCHS ---"

    # Reviewer pass FIRST: find architectural/best-practices issues
    echo "[Reviewer] Reviewing for architecture and best practices..."
    FINDINGS=$(git diff "$BASE_BRANCH" | claude -p \
        --effort max \
        --model opus \
        --max-turns 10 \
        --max-budget-usd "$BUDGET_PER_CALL" \
        --allowedTools "Read,Glob,Grep" \
        --append-system-prompt-file "$PLUGIN_DIR/prompts/reviewer-review.md" \
        --output-format text \
        "Review this diff for architectural and best-practices issues. Respond with ONLY one of:
         - 'CLEAN' if the code follows good practices and no issues found
         - A numbered list of specific, actionable findings to fix")

    echo "[Reviewer] Findings: $FINDINGS"

    if echo "$FINDINGS" | grep -qi "^CLEAN"; then
        echo "Clean after $epoch epoch(s)."
        break
    fi

    # Editor pass: fix the findings
    echo "[Editor] Fixing findings..."
    claude -p \
        --effort max \
        --model opus \
        --max-turns "$MAX_TURNS" \
        --max-budget-usd "$BUDGET_PER_CALL" \
        --allowedTools "Read,Edit,Glob,Grep,Bash(git diff*)" \
        --append-system-prompt-file "$PLUGIN_DIR/prompts/editor-review.md" \
        --output-format text \
        "Fix the following code review findings. Only fix what was flagged — do not introduce unrelated changes. Findings: $FINDINGS"

    if [ "$epoch" -eq "$MAX_EPOCHS" ]; then
        echo "Reached max epochs ($MAX_EPOCHS). Stopping."
    fi
done

echo ""
echo "=== Code Review Loop Complete ==="
echo "Review changes with: git diff $BASE_BRANCH"
```

### `scripts/review-pipeline.sh`

```bash
#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==============================="
echo "  Review Pipeline"
echo "==============================="
echo ""

# Phase 1: Simplify
"$SCRIPT_DIR/simplify-loop.sh"

echo ""
echo "-------------------------------"
echo ""

# Phase 2: Code Review
"$SCRIPT_DIR/code-review-loop.sh"

echo ""
echo "==============================="
echo "  Pipeline Complete"
echo "==============================="
echo "Review all changes with: git diff ${BASE_BRANCH:-master}"
```

## Adversarial Prompts

### `prompts/editor-simplify.md`

> You are a code simplification agent. Your changes will be reviewed by a strict, adversarial reviewer who is rewarded for catching unnecessary or harmful changes.
>
> Rules:
> - Only make changes that genuinely reduce complexity, remove duplication, or clean up patterns
> - Every change must make the code simpler, not just different
> - Do not add comments, docstrings, or type annotations unless they resolve ambiguity
> - Do not refactor beyond what simplification requires
> - Do not change behavior — simplification is structural, not functional
> - If a file is already clean, do not touch it
>
> Your precision matters more than your volume. Fewer, better changes beat many marginal ones.

### `prompts/reviewer-simplify.md`

> You are an adversarial code review agent evaluating simplification changes. You are evaluated on calibration — your credibility depends on two metrics equally:
>
> 1. **False approvals**: Approving a change that made code worse, more complex, or changed behavior
> 2. **False rejections**: Rejecting a change that was a genuine improvement
>
> Rules:
> - Read the diff carefully. Judge each change on whether it actually simplifies the code.
> - If changes are marginal or purely stylistic with no complexity reduction, mark as CLEAN — do not chase perfection.
> - If a change altered behavior (not just structure), flag it as NEEDS_WORK.
> - If the diff is empty or trivial, mark as CLEAN immediately. Do not invent problems.
> - Be specific in feedback — vague complaints are as bad as false approvals.
>
> You cannot edit files. You can only read code to inform your verdict.

### `prompts/editor-review.md`

> You are a code fix agent. You have been given specific findings from a code reviewer. Your fixes will be re-reviewed by the same adversarial reviewer.
>
> Rules:
> - ONLY fix what was explicitly flagged in the findings. Do not fix adjacent code.
> - Do not introduce unrelated improvements, refactors, or cleanups.
> - If a finding is ambiguous, make the minimal safe change.
> - If you disagree with a finding, skip it — do not argue via code changes.
> - Every fix you make will be scrutinized. Unnecessary changes count against you.

### `prompts/reviewer-review.md`

> You are an adversarial architectural code reviewer. You are evaluated on calibration — your credibility depends equally on:
>
> 1. **Missing real issues**: Letting architectural problems, anti-patterns, or convention violations pass
> 2. **False positives**: Flagging code that follows good practices, or nitpicking style preferences
>
> Review criteria (in priority order):
> 1. Correctness: Does the code do what it's supposed to?
> 2. Architecture: Does it follow established patterns (container-presenter, proper state management)?
> 3. Conventions: TypeScript conventions (I-prefix interfaces, T-prefix types), React patterns, CSS module usage
> 4. Edge cases: Missing error handling at system boundaries, race conditions
>
> Do NOT flag:
> - Style preferences that don't affect readability
> - Missing comments or documentation
> - Hypothetical future problems
> - Anything that was there before the diff (pre-existing issues)
>
> If the code is solid, say CLEAN. Do not manufacture findings to justify your existence.

## Plugin Manifest

### `.claude-plugin/plugin.json`

```json
{
  "name": "review-pipeline",
  "description": "Adversarial code review pipeline with bash-enforced convergence loops. Includes /simplify-loop, /code-review-loop, and /review-pipeline skills.",
  "version": "0.1.0",
  "author": {
    "name": "Derek"
  },
  "keywords": ["code-review", "simplify", "adversarial", "pipeline"]
}
```

## Configuration

Environment variables for customization (all have defaults):

| Variable | Default | Purpose |
|---|---|---|
| `MAX_EPOCHS` | `3` | Maximum loop iterations per phase |
| `BASE_BRANCH` | `master` | Branch to diff against |
| `BUDGET_PER_CALL` | `2.00` | Max USD spend per `claude -p` invocation |
| `MAX_TURNS` | `15` | Max agentic turns per `claude -p` invocation |

## Safety Mechanisms

| Mechanism | What it prevents |
|---|---|
| Bash `for` loop | Agent cannot exceed max epochs |
| `--allowedTools` (no Edit for reviewer) | Reviewer cannot edit files |
| `--max-budget-usd` per call | Runaway token spend |
| `--max-turns` per call | Runaway tool loops within a single pass |
| Reviewer "CLEAN" escape hatch in prompt | Prevents infinite nitpicking |
| Empty diff check | Skips reviewer if editor made no changes |
| File type filter (`grep -E '\.(ts|tsx|...)$'`) | Only reviews relevant source files |
| Final output: "run `git diff`" | Human reviews everything before commit |

## Verification Plan

1. **Unit test the scripts**: Run each script with `MAX_EPOCHS=1` on a branch with known issues to verify the loop mechanics work (editor runs, reviewer parses verdict, loop breaks on CLEAN)
2. **Test adversarial prompts**: Verify the reviewer actually rejects bad changes — introduce an intentionally bad simplification and confirm the reviewer catches it
3. **Test convergence**: Run `/simplify-loop` on a branch with real changes, confirm it converges within 3 epochs
4. **Test tool restrictions**: Confirm the reviewer agent cannot edit files (the `--allowedTools` flag should prevent it)
5. **Test plugin installation**: Install via `claude --plugin-dir ./claude-review-pipeline` and verify skills appear in `/` autocomplete
6. **End-to-end**: Run `/review-pipeline` on the current `dy/je-modal-tags-column` branch and review the final `git diff master`
