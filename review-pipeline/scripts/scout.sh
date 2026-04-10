#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PIPELINE_DIR="$(dirname "$SCRIPT_DIR")"
CACHE_DIR="${REVIEW_CACHE_DIR:-.review-cache}"
CACHE_FILE="$CACHE_DIR/context.md"
CACHE_MAX_AGE_DAYS=${CACHE_MAX_AGE_DAYS:-7}

# Check if cache is still valid (time-based)
NEEDS_REFRESH=true

if [ -f "$CACHE_FILE" ]; then
    CACHE_AGE_DAYS=$(( ($(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE")) / 86400 ))
    if [ "$CACHE_AGE_DAYS" -lt "$CACHE_MAX_AGE_DAYS" ]; then
        NEEDS_REFRESH=false
    fi
fi

if [ "$NEEDS_REFRESH" = true ]; then
    echo "[Scout] Building codebase context..."
    mkdir -p "$CACHE_DIR"

    claude -p \
        --effort max \
        --model opus \
        --max-turns 40 \
        --allowedTools "Read,Glob,Grep" \
        --append-system-prompt-file "$PIPELINE_DIR/prompts/scout.md" \
        --output-format text \
        "Analyze this codebase and produce a structured context document for code reviewers." \
        > "$CACHE_FILE"

    echo "[Scout] Context cached to $CACHE_FILE"
else
    CACHE_AGE_DISPLAY=$(stat -f '%Sm' -t '%Y-%m-%d %H:%M' "$CACHE_FILE" 2>/dev/null || stat -c '%y' "$CACHE_FILE" 2>/dev/null | cut -d. -f1)
    echo "[Scout] Using cached context ($CACHE_AGE_DISPLAY, ${CACHE_AGE_DAYS}d old, refreshes after ${CACHE_MAX_AGE_DAYS}d)"
fi
