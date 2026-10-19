---
name: dev-workflow
description: Carry an engineering change from behavior and implementation planning through verification, independent review, and a reviewable PR briefing. Use for end-to-end feature, bug-fix, or refactor work; not for a standalone explanation or copy edit.
---

# Development workflow

Own the result through these gates. Reuse current evidence; rerun a completed
stage only for a changed patch, failure, or material gap. Follow repository
instructions and existing authorization. This skill does not authorize merging,
deploying, messaging others, or changing unrelated work.

## 1. Define the change

Read repository instructions, affected implementation, and relevant tests.
Establish the base and full scope with
`python3 <this-skill>/scripts/review_scope.py --repo <checkout> --base <target>`,
or equivalent git inspection. Resolve the target from the PR or repository;
never assume master. Include committed, staged, unstaged, and untracked changes.

Write a brief contract in task notes:
- Problem, intended consumer, and observable before/after.
- Behaviors to preserve and explicit non-goals.
- Important inputs, outputs, data ownership, side effects, and failure cases.
- Acceptance criteria, checks, and unresolved product choices.

For a nontrivial state transition or an unclear behavior change, use
[before-after](../before-after/SKILL.md) to establish the contract above. Reuse
that explanation in verification and the handoff; avoid a duplicate investigation.

Select the route:
- **Bug:** reproduce first; locate the owning cause; add a failing-before,
  passing-after regression where an affordable meaningful test exists.
- **Feature:** read [generation](references/generation.md) before splitting work.
- **Refactor:** define behavior preservation and comparison before edits.
- **Investigation:** answer from evidence and stop before modifying code unless
  implementation is already requested.

Keep small work small. A few lines in task notes can be the whole contract.
Do not create planning documents or agent teams simply to satisfy a template.

## 2. Build verifiable slices

Choose data shapes and caller-facing interfaces before filling in logic. Inspect
existing patterns without treating accidental complexity as a convention. Each
slice ends in an observable result; give shared contracts one owner. Parallelize
only independent work with bounded ownership and integration criteria. Inspect
all delegated diffs and integrate them yourself.

Use [derek-code-pass](../derek-code-pass/SKILL.md) on changed code. For UI choices
also read [derek-design-preferences](../derek-design-preferences/SKILL.md).
Use project formatters and linters for mechanical conventions. Do not additionally
run simplify-loop or review-pipeline; their stages are already composed here.

## 3. Prove the result

Discover required checks from configuration and CI. Use the project's verification
recipe; for Atoms read [verify-atoms](../verify-atoms/SKILL.md). For another project
use [create-project-verification](../create-project-verification/SKILL.md) when a
reusable recipe is needed, otherwise record this change's specific checks.

Exercise the feature through its real entry point. Match baseline and candidate
inputs for comparative claims. Capture commands, exits, UI states, side effects,
and failures. Lint, build, and author summaries do not establish product behavior.
Tie evidence to commit and worktree fingerprint; later edits can invalidate it.

## 4. Review and reverify

Run [code-review-loop](../code-review-loop/SKILL.md) with the contract, base and
candidate identity, full diff, repository context, and verification evidence.
It owns reviewer roles, adjudication, limits, and final outcomes. Reverify accepted
fixes against the final state before resolving their findings.

## 5. Brief and deliver

Use [pr-description-style](../pr-description-style/SKILL.md) for the final diff.
Include the review outcome, material risks/gaps, and relevant recovery steps.
Link detailed logs instead of expanding the PR narrative. Distinguish prepared,
opened, merged, and deployed states. PASS is evidence, not permission to publish.

After recurring corrections or escaped defects, propose a durable fix: types,
lints, tests, or scripts when enforceable; examples or skill rules for judgment.
Do not silently codify an unconfirmed preference or rewrite shared instructions.

## Provenance

Original composition from Derek's existing skills and October 18, 2026 request.
Conceptual inspiration: Lauren Tan's
[pstack](https://github.com/cursor/plugins/tree/main/pstack) and Anthropic's
[review process](https://claude.dev/blog/solving-code-review-at-anthropic/).
No upstream implementation or runtime-specific agent API is required.
