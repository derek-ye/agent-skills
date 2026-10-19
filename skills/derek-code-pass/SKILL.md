---
name: derek-code-pass
description: Refine changed code before review using Derek's preferences for simple structure, direct comments, and focused tests.
---

Review the current task's diff and make worthwhile improvements directly.
No changes is a valid outcome. Don't manufacture cleanup to demonstrate
that the skill ran.

## Structure

- Trace callers, return values, and side effects before editing.
- Reuse existing code; remove duplicate schemas, empty subclasses, and
  thin wrappers when they add no meaningful contract.
- Keep distinctions that represent different behavior.

## Comments

- State what the operation does. Explain why when it helps.
- Remove narration and redundant caveats.
- Prefer clear wording over compressed wording.
- Make ownership explicit where it matters.

## Tests

- Run an explicit 80/20 test-value pass on added or changed tests: find the
  smallest set that protects the important behaviors and failures. Aggressively
  seek redundant cases, setup, and assertions; use 80/20 as a reduction challenge,
  not an automatic deletion or coverage quota.
- Before adding or keeping a test, inspect relevant existing coverage. Remove
  tests that repeat behavior already verified elsewhere without protecting a
  distinct contract, integration, configuration, or failure mode. Keep tests
  that exercise behavior the existing coverage cannot detect breaking.
- Test behavior where it is owned. Caller tests should protect the caller’s
  decisions and integration, not repeat a shared component or dependency’s
  built-in behavior.
- Do not cross PR boundaries to add tests for code that wasn't created in the PR.
  If an existing component needs its own test coverage, tell Derek
  what is missing and why; wait for authorization before expanding the scope.
  Do not implement that component's tests in the current PR.
- Preserve coverage of authorization boundaries, data integrity, and distinct
  loading/error states; shared coverage does not automatically protect how a
  caller uses that behavior.
- Prefer observable results over internal call sequences. Remove redundant
  cases, setup, and machinery; name the remaining coverage that justifies a cut.
- Report keep/cut/consolidate decisions with representative tests, the distinct
  failure each retained test catches, and the remaining proof that justifies a
  cut. If no worthwhile cuts are found, say why; passing tests alone do not prove
  the suite is minimal. Broader audits can inspect existing coverage without
  silently expanding the current PR.
- Use names that make actors, ownership, and expected outcomes clear.

## Behavior

- Preserve authorization, audit handling, and data integrity.
- Surface unresolved behavior changes rather than silently making
  product decisions.
- Stay within the task's scope.

## PR description

- Use [pr-description-style](../pr-description-style/SKILL.md) to prepare or
  refresh the PR description after the code pass, reflecting the final changes
  and verification. Follow existing authorization before publishing updates.

## Verification and delivery

- Run checks appropriate to the edits.
- Don't commit or push unless authorized.
- Briefly report changes and verification, or say no worthwhile
  changes were found.
- Flag material unresolved decisions.
