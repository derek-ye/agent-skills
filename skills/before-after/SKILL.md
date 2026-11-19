---
name: before-after
description: Explain what changes before and after a PR, diff, commit, or proposal, leading with consequential and breaking behaviors and surfacing edge cases and unintended changes. Use for change walkthroughs, behavioral regression analysis, and questions about what users or callers gain, lose, or must do differently; also supports a specifically requested runtime event.
---

# Before / after

Answer: "What was the world before this change, what is it afterward, and what
else might change that we did not intend?" Give the reader a working model of
each side: who can do what, what happens to their data, and what they must do
differently. Explain from the consumer's point of view, then use implementation
details to establish the cause. Organize by consequences, not files or
implementation chronology. This is a read-only analysis unless edits are
separately authorized.

## Establish the comparison

- Identify the baseline and changed state from the actual repository. For a PR,
  resolve its target, merge base, and candidate head, and account for stacked
  dependencies. For local work, state which commits or working-tree changes are
  included; do not assume an empty unstaged diff means no changes. Do not use
  unrelated local edits as evidence of either side. Name the revisions actually
  inspected.
- Read the request or PR intent and repository instructions. Inspect the
  complete diff, including deleted/renamed files, tests, configuration,
  dependencies and generated output.
- Read both implementations and trace the real entry points, callers, owning
  state, persisted state, contracts, relevant tests, and side effects. Trace
  beyond edited lines when shared code, stored formats, permissions, lifecycle
  or external consumers can be affected. Descriptions and comments explain
  intent; check whether the code delivers it, and do not infer intended behavior
  solely from the implementation. Include existing UI or mock behavior when that
  is what users had before a new backend was added.
- Group files into coherent changes in behavior or contracts. Account for every
  material part of the diff, including structural or tooling changes with no
  expected user-visible effect. A list of changed files is not an explanation.
- Compare the same scenario on baseline and candidate under comparable input,
  data, configuration and time where relevant.
- For a proposal, compare current behavior with the proposed outcome and label
  the latter as planned. If a baseline or important path is unavailable, name
  the gap and narrow the claim instead of inventing the before state.

## Find the consequential differences

Lead with supported changes that affect the reader's decision: breaking
contracts, removed capabilities, access changes, data loss or migration,
changed defaults, new failure modes, hard limits, and required user/operator
steps. Then explain the main capabilities gained and routine changes. Choose
what matters for this change; do not force every category into the answer.

For each material difference, establish:

- **Before:** what the same actor could do or observe and the outcome they got,
  including prior limitations.
- **After:** what that actor can do now and the resulting outcome. Separate the
  intended improvement from additional effects found in code.
- **Consequence:** who is affected, under what conditions, why it matters, and
  any action needed.
- **Preserved:** the consequential behavior, data or invariant that should
  remain unchanged; check that it still holds.
- **Edge cases:** concrete inputs/states that could change the result. Select
  relevant boundaries such as empty data, thresholds, ownership, stale clients,
  existing records, failure/cancel/retry and concurrent operations. Explain the
  trigger and consequence rather than dumping a generic checklist.
- **Unwanted changes:** look for lost capabilities, widened permissions, changed
  defaults, hidden data loss, altered side effects, broken consumers or behavior
  outside the stated scope. Distinguish confirmed regression, possible issue
  needing proof, and an intentional tradeoff. If intent is unclear, say so
  rather than declaring every extra change a bug.

Use one concrete example when a rule is surprising. Keep the actor, starting
data, and action the same across both sides so the changed result is clear.
Include a relevant failure or boundary case when the happy path hides the
consequence.

Establish actual wiring: new backend capability does not mean the UI uses it;
deployment, optimistic UI, committed writes and another client's observation
are different boundaries. Distinguish UI access from underlying API support,
temporary state from persisted state, and a prerequisite from something this
change introduces. Do not promise rollback, idempotency or immediate
consistency without evidence. Separate pre-existing issues from problems
introduced or exposed by the candidate.

A deliberate behavior change can still break an existing workflow. Explain that
impact without assuming it is a defect. Separately flag a confirmed defect or
unresolved product decision when the evidence warrants it. Do not turn generic
risks or untested scenarios into findings.

Use available how/why skills when mechanism or historical rationale is unclear;
otherwise inspect directly. They are optional dependencies. Stop when the full
change map and its material consequences are covered, not after explaining only
one interesting function or expanding into an unrelated repository audit.

## Explain it

- Open with the most consequential supported behavior difference and its
  practical effect, in one or two sentences. A one-sentence orientation can
  precede it when needed.
- Prefer a compact change map for several comparable changes, usually:

  | Behavior | Before | After | Consequence | Edge cases / unintended effects |
  | --- | --- | --- | --- | --- |

  Use as many rows as meaningful change groups require, not one per file. For a
  narrow change, a short paragraph is enough. Add a small diagram only when it
  clarifies a flow or state transition.
- Explain implementation only where it accounts for a consequential outcome.
  Ground material claims in source locations and requirements, and put
  representative source links next to those claims; avoid file inventories, API
  catalogs, diff statistics, and a second summary repeating the table.
- Separate observed results, behavior inferred from source, stated intent, and
  proposed behavior; label unverified claims. Running checks is useful when
  needed to resolve a material uncertainty: exercise relevant existing tests or
  small isolated comparisons, using the same input on both versions. A passing
  suite alone does not prove the comparison or the absence of unwanted changes.
  For measured claims, compare equivalent inputs and environments and report
  confounds. Do not mutate shared data merely to obtain evidence.
- Explicitly report confirmed unwanted changes with location, trigger,
  consequence and the cheapest confirming check. If none were found, say so
  within the inspected scope; do not imply exhaustive proof. Keep intentional
  changes, findings and verification gaps distinguishable.
- Finish with material unknowns or decisions, if any. Say when no externally
  observable behavior change was found; do not manufacture a breaking change
  for a refactor. Mention unchanged guarantees only when they prevent a likely
  misunderstanding.
- Reuse a concise version in a PR description when preparing one; retain the
  full explanation in the chat handoff or a linked artifact.

Scale the explanation to the question. Leave the reader able to predict the
important outcomes without reading the diff. This skill explains a change;
fixes, broader audits, publishing, and merging require their own task scope.

## Narrow event mode

If explicitly asked about one runtime event rather than a change, use one
implementation and compare state immediately before its trigger with the
settled result. Name preconditions, affected actors, side effects, invariants
and relevant failure paths. Do not invent a product improvement or expand a
narrow question into a PR review.

## Inspiration

Original wording, informed by sources reviewed at
[`poteto/plugins@74dd229`](https://github.com/poteto/plugins/tree/74dd2291e8e37b12fd6dc49b2acbd655c6bdaf12):

- [how](https://github.com/poteto/plugins/blob/74dd2291e8e37b12fd6dc49b2acbd655c6bdaf12/pstack/skills/how/SKILL.md): trace actual runtime paths and build a useful mental model.
- [PR review canvas](https://github.com/poteto/plugins/blob/74dd2291e8e37b12fd6dc49b2acbd655c6bdaf12/cursor-team-kit/skills/pr-review-canvas/SKILL.md): organize around reviewer value and concrete behavior comparisons.
- [verify-this](https://github.com/poteto/plugins/blob/74dd2291e8e37b12fd6dc49b2acbd655c6bdaf12/cursor-team-kit/skills/verify-this/SKILL.md): ground comparative claims in equivalent conditions and bounded evidence.
- [authoring a skill](https://github.com/poteto/plugins/blob/74dd2291e8e37b12fd6dc49b2acbd655c6bdaf12/pstack/skills/poteto-mode/playbooks/authoring-a-skill.md): keep instructions that change decisions and validate their structure.

Pstack: MIT ©2026 Lauren Tan. Cursor team kit: MIT ©2026 Cursor.
