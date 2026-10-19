# Development and review workflow

This replaces the former Claude CLI/bash editor-reviewer loops. The user requested
this redesign on October 18, 2026. Existing code and PR taste remain in their own
skills; this layer connects generation, evidence, review, and delivery.

## Entry points and ownership

`dev-workflow` owns the full change. `review-pipeline` starts after implementation.
Both call one `code-review-loop`; neither nests another review loop. `simplify-loop`
is only a compatibility route to a focused code pass. The removed shell scripts
must not be used as CI gates.

One orchestrator owns intent, candidate identity, integration, finding triage, and
the final report. Two independent reviewers inspect correctness/impact and
structure/taste. An implementer (the parent or one delegate) changes code. Reviewers
never write the target checkout. Agents can be from the same model; independence
means fresh context and evidence, not a claim of statistical independence.

## Generation

Capture observable before/after, invariants, non-goals, boundaries, data ownership,
and acceptance checks. Split substantial work into verifiable vertical slices.
Settle shared contracts before parallelizing consumers. Compare designs only when
uncertainty warrants it. Agent code and deterministic generated code use the same
gates; derived files are changed through their source/generator.

## Evidence and review

Scope includes committed, staged, unstaged, deleted, renamed, binary, and relevant
untracked changes. The deterministic scope helper fingerprints base/head, index,
worktree patch, and untracked contents. Renames are explicit delete/add entries.
Ignored artifacts, submodule internals, dependency versions, environment, and
runtime data still need appropriate inspection; a patch hash is not build proof.
A moving target branch is recorded separately from the merge base and needs
integration validation before landing.

No cleanup edits does not skip review. Deletions have no file-type filter. Run
required project checks and exercise relevant real user paths, with observed
inputs/results and side effects. Atoms' in-memory navigation and reload reset are
separate claims; its demo does not establish backend security or durability.

Each finding has a trigger, consequence, location, evidence, and confirming check.
The parent accepts, dismisses with reason, or leaves unresolved. Accepted findings
remain open until fixed and verified. Agreement alone cannot pass a patch, and a
single demonstrated blocker cannot be voted away. Optional taste suggestions do
not create endless mandatory edits.

Default maximum: three review rounds. Re-review fix deltas and affected contracts;
no repeat findings without new evidence. Last-round fixes without fresh review
return LIMIT_REACHED. Missing tools or undecidable safety claims are explicit.
Outcome precedence: exhausted review/progress budget → LIMIT_REACHED; otherwise
confirmed blockers → NEEDS_FIX; otherwise missing required evidence → INCONCLUSIVE;
otherwise PASS. Required checks, final review, and evidence must cover final code.

## PR and learning

The briefing follows pr-description-style: user behavior, consequential approach,
actual verification, material risks/gaps, and recovery when useful. Logs belong in
linked artifacts. Prepared, published, merged, and deployed are distinct states.
A passing review never expands authorization.

Improve from accepted/rejected findings, escaped bugs, review rounds, and human
attention. Enforce deterministic rules with types/lints/scripts/tests. Use concrete
preferred/rejected examples to refine taste. Do not silently promote one-off
corrections into global instructions.

## Behavioral evaluation cases

These are scenarios to exercise, not declarations of runtime success:

| Case | Required behavior |
| --- | --- |
| Committed deletion only; no cleanup edits | Review deleted base code and consumers; do not skip |
| Two reviewers agree, required browser missing | INCONCLUSIVE, not PASS |
| One reviewer reproduces a serious defect, another says fine | Confirm and block; no majority vote |
| Fix after final review round | LIMIT_REACHED until a new reviewed run covers it |
| Required checks fail despite no findings | Never PASS; distinguish defect from environment gap |
| Repeated dismissed nit with no new evidence | Stop churn; preserve reason |
| Reviewer unavailable | Disclose sequential fallback; INCONCLUSIVE if independence was required |
| Candidate changes after proof | Re-scope and rerun affected checks/review |
| Ordinary prose edit | Proportional checks; no compulsory browser/team ceremony |
| Generated output changed | Inspect source/generation, regenerate with actual owning command |

The Python fixture tests cover actual git mechanics. Independent skill walkthroughs
and the Atoms smoke run are recorded separately in [validation](workflow-validation.md).
