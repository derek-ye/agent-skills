#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==============================="
echo "  Review Pipeline"
echo "==============================="
echo ""

# Phase 0: Scout — build codebase context (once, shared by both loops)
"$SCRIPT_DIR/scout.sh"

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
MERGE_BASE=$(git merge-base "${BASE_BRANCH:-master}" HEAD)
echo "Review all changes with: git diff $MERGE_BASE"
