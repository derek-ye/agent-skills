---
name: before-after
description: Explain all material changes in a PR or diff through before/after behavior and impact, surfacing edge cases and unintended changes. Use for whole-PR walkthroughs and behavioral regression analysis; also supports a specifically requested runtime event.
---

# Before and after

Answer: "What was the world before this PR, what is it afterward, and what else
might change that we did not intend?" Explain from the consumer's point of view,
then use implementation details to establish the cause. This is a read-only
analysis unless edits are separately authorized.

## Establish the whole comparison

Resolve the PR's target, merge base, candidate head and any worktree changes from
the actual repository. Read the request/PR intent and repository instructions.
Inspect the complete diff, including deleted/renamed files, tests, configuration,
dependencies and generated output. Do not infer intended behavior solely from the
implementation or assume an empty unstaged diff means no changes.

Group files into coherent changes in behavior or contracts. Account for every
material part of the diff, including structural or tooling changes with no
expected user-visible effect. A list of changed files is not an explanation.
Compare the same scenario on baseline and candidate under comparable input, data,
configuration and time where relevant. Name the revisions actually inspected.

## Explain each change and challenge its consequences

Read the real entry points, owning state, consumers, contracts and relevant tests
on both sides. Trace beyond edited lines when shared code, stored formats,
permissions, lifecycle or external consumers can be affected.

For each coherent change establish:
- **Before:** what users/callers could do or observe, including prior limitations.
- **After and impact:** what the candidate actually changes, for whom, and why it
  matters. Separate intended improvement from additional effects found in code.
- **Preserved:** the consequential behavior, data or invariant that should remain
  unchanged; check that it still holds.
- **Edge cases:** concrete inputs/states that could change the result. Select
  relevant boundaries such as empty data, thresholds, ownership, stale clients,
  existing records, failure/cancel/retry and concurrent operations. Explain the
  trigger and consequence rather than dumping a generic checklist.
- **Unwanted changes:** look for lost capabilities, widened permissions, changed
  defaults, hidden data loss, altered side effects, broken consumers or behavior
  outside the stated scope. Distinguish confirmed regression, possible issue
  needing proof, and an intentional tradeoff. If intent is unclear, say so rather
  than declaring every extra change a bug.

Establish actual wiring: new backend capability does not mean the UI uses it;
deployment, optimistic UI, committed writes and another client's observation are
different boundaries. Do not promise rollback, idempotency or immediate consistency
without evidence. Separate pre-existing issues from problems introduced or exposed
by the candidate, and distinguish proposed outcomes from implemented behavior.

Ground material claims in source locations and requirements. Exercise relevant
existing tests or small isolated comparisons where practical; use the same input
on both versions for comparative proof. Label source-based inference, reproduced
results and unverified claims. A passing suite alone does not prove the absence
of unwanted changes. Do not mutate shared data merely to obtain evidence.

Use available how/why skills when mechanism or historical rationale is unclear;
otherwise inspect directly. They are optional dependencies. Stop when the full
change map and its material consequences are covered, not after explaining only
one interesting function or expanding into an unrelated repository audit.

## Deliver in chat and PR context

Lead with current behavior, impact and improvement in one or two sentences.
Then provide a compact change map, usually:

| Change | Before | After and impact | Edge cases / unintended effects |
| --- | --- | --- | --- |

Use as many rows as meaningful change groups require, not one per file. Include
source links and relevant evidence. Explicitly report confirmed unwanted changes
with location, trigger, consequence and the cheapest confirming check, plus any
remaining uncertainties. If none were found, say so within the inspected scope;
do not imply exhaustive proof. Keep intentional changes, findings and verification
gaps distinguishable. Reuse a concise version in a PR description when preparing
one; retain the full explanation in the chat handoff or a linked artifact.

## Narrow event mode

If explicitly asked about one runtime event rather than a PR, use one implementation
and compare state immediately before its trigger with the settled result. Name
preconditions, affected actors, side effects, invariants and relevant failure paths.
Do not invent a product improvement or expand a narrow question into a PR review.
