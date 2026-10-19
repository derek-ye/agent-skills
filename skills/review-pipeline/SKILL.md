---
name: review-pipeline
description: Prepare an existing change for review using Derek's code pass, project checks, and independent review. Use after implementation; use dev-workflow for start-to-finish work.
---

# Review pipeline

This is a skill workflow, not a Claude CLI script. Read repository instructions;
establish intended behavior, target base, full patch, and required checks.

1. Apply [derek-code-pass](../derek-code-pass/SKILL.md) for worthwhile scoped
   improvements. No cleanup edits is valid; continue with review anyway.
2. Run required project checks and its verification recipe. For Atoms use
   [verify-atoms](../verify-atoms/SKILL.md). For other projects discover commands
   from configuration/CI and actual entry points; use
   [create-project-verification](../create-project-verification/SKILL.md) if a
   reusable recipe is needed. Preserve failures and unavailable checks.
3. Run [code-review-loop](../code-review-loop/SKILL.md). It owns reviewer roles,
   triage, bounded fixes/rechecks, and the PASS / NEEDS_FIX / INCONCLUSIVE /
   LIMIT_REACHED outcome. Include deletion-only and committed-only changes.
   Do not start a second nested loop.
4. Prepare or refresh [PR context](../pr-description-style/SKILL.md) from the final
   patch and evidence. Report material risks, gaps, and relevant recovery steps.

Preserve existing authorization for edits and external actions. The outcome applies
only to the reviewed candidate and is never an automatic merge instruction.
