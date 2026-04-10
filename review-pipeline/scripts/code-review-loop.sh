#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PIPELINE_DIR="$(dirname "$SCRIPT_DIR")"
MAX_EPOCHS=${MAX_EPOCHS:-3}
BASE_BRANCH=${BASE_BRANCH:-master}
MAX_TURNS=${MAX_TURNS:-30}
CACHE_DIR="${REVIEW_CACHE_DIR:-.review-cache}"
CONTEXT_FILE="$CACHE_DIR/context.md"

# Build context if not already cached (standalone runs)
if [ ! -f "$CONTEXT_FILE" ]; then
    "$SCRIPT_DIR/scout.sh"
fi

# Build context flags
CONTEXT_FLAGS=""
if [ -f "$CONTEXT_FILE" ]; then
    CONTEXT_FLAGS="--append-system-prompt-file $CONTEXT_FILE"
fi

MERGE_BASE=$(git merge-base "$BASE_BRANCH" HEAD)
CHANGED_FILES=$(git diff "$MERGE_BASE" --name-only --diff-filter=ACMR || true)

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
    FINDINGS=$(git diff "$MERGE_BASE" | claude -p \
        --effort max \
        --model opus \
        --max-turns 15 \
        --allowedTools "Read,Glob,Grep" \
        --append-system-prompt-file "$PIPELINE_DIR/prompts/reviewer-review.md" \
        $CONTEXT_FLAGS \
        --output-format text \
        "Review this diff for architectural and best-practices issues against the project's conventions.")

    echo "[Reviewer] Findings:"
    echo "$FINDINGS"

    if echo "$FINDINGS" | grep -qi "^CLEAN"; then
        echo ""
        echo "Clean after $epoch epoch(s)."
        break
    fi

    # Editor pass: fix the findings
    echo ""
    echo "[Editor] Fixing findings..."
    claude -p \
        --effort max \
        --model opus \
        --max-turns "$MAX_TURNS" \
        --allowedTools "Read,Edit,Glob,Grep,Bash(git diff*)" \
        --append-system-prompt-file "$PIPELINE_DIR/prompts/editor-review.md" \
        $CONTEXT_FLAGS \
        --output-format text \
        "Fix the following code review findings. Only fix what was flagged — do not introduce unrelated changes.

Findings:
$FINDINGS

Files to check:
$CHANGED_FILES"

    if [ "$epoch" -eq "$MAX_EPOCHS" ]; then
        echo ""
        echo "Reached max epochs ($MAX_EPOCHS). Stopping."
    fi
done

echo ""
echo "=== Code Review Loop Complete ==="
echo "Review changes with: git diff $MERGE_BASE"
