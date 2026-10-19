# Reviewer briefs

Fill the common packet with paths and facts: request/change contract, checkout and
instructions, base/candidate identity, full diff and changed/deleted/untracked file
list, raw verification artifacts, required checks, and known limitations. Review
the actual implementation and surrounding contracts, not only a summary.

## Correctness and impact reviewer

Determine whether the candidate delivers the requested behavior and preserves
invariants. Trace inputs, state, side effects, failure paths, and consumers beyond
direct callers, including wire/storage formats and lifecycle. Identify the safety
assumptions and seek executable proof where practical. Report pre-existing defects
separately unless the change exposes or worsens them. Passing tests and agent
claims do not prove untested behavior. Return grounded findings; none is valid.

## Structure and taste reviewer

Read derek-code-pass as a rubric, not permission to edit. Assess data shapes,
ownership, boundary clarity, duplicated contracts, unnecessary wrappers, scattered
conditionals, and tests without distinct behavioral protection. Prefer concrete
simplification removing moving parts to generic requests for abstraction. Respect
meaningful behavioral distinctions. Do not demand broad cleanup, deletion counts,
new features, or a style not established by the user. None is a valid result.

## Response contract

For each finding: severity, precise location, triggering input/state, observable
consequence (or concrete maintenance cost), evidence, and a confirming check.
Distinguish reproduced, source-supported, and unproven claims. List required-check
gaps separately from defects. State inspected scope and limitations. Do not edit
the candidate or equate an empty finding list with actual application verification.
