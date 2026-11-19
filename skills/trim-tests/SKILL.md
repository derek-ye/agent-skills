---
name: trim-tests
description: Cut a test suite, or the tests a branch or PR adds, by about 80% of its lines while keeping about 80% of core coverage, with coverage measured before and after. Use when asked to trim, shrink, prune, or 80/20 tests, or when a PR's tests are too long. Not for writing new tests or for a one-off test review.
---

# Trim tests

Cut about 80% of the test lines and keep about 80% of the core coverage.
Measure both; don't guess. Core coverage beats the line target: if the cut
would drop a core behavior, stop and report instead.

This skill adds a target and a measurement to two others. Use
[test-audit](../test-audit/SKILL.md) for the junk patterns and retention bar
(its Validation and Landing sections are OpenClaw-specific; skip them), and
[principle-test-behavior-not-implementation](../principle-test-behavior-not-implementation/SKILL.md)
for what counts as a behavior test. Don't restate their rules here.

## Scope

Default: only test files changed on the current branch, from
`git diff --name-only $(git merge-base HEAD <base>)`. Leave other tests alone.
Trim the whole suite only when asked. Never edit production code; if a cut
would free a test-only export, name it in the report.

## 1. Measure before

Find the test and coverage commands in the project's config (for example
`vitest run --coverage <files>`). Run only the scoped test files and record:

- test lines (`wc -l`) and test count;
- line and branch coverage of the source files those tests exercise (for a
  PR, the source files the PR changes).

Save the per-file coverage report so you can diff it later. If no coverage
tool is set up, don't install one: read each test, list the code paths it
reaches, and label every number in the report as estimated.

## 2. Group by behavior

List each test under the user-visible behavior it protects: a result, an
error, a permission check, a stored change. Mark each behavior core or minor.
Core means a user or caller would notice it breaking: happy paths,
authorization, data integrity, distinct error and loading states. A test that
maps to no behavior goes in a "none" group.

## 3. Cut

- Keep one strong test per core behavior: the one at the owning boundary that
  asserts a literal observed result.
- Merge near-duplicates into one table-driven test when the cases differ only
  in input and expected output.
- Drop tests in the "none" group, tests that pin implementation details,
  tests that re-test a library or framework, and tests a stronger test
  already covers.
- Cut minor behaviors last, and only as far as the line target needs.
- Trim setup and helpers that only the dropped tests used.

Coverage shows what code ran, not what a test checks. Don't keep a weak test
only because it raises the number, and don't drop the only test that asserts
a core behavior because another test happens to run the same lines.

## 4. Measure after

Rerun the same commands. The kept tests must pass. Diff the coverage reports
and map every newly uncovered line or branch back to a behavior. If one is
core, restore its test and cut elsewhere.

## 5. Stop rule

Stop cutting when the next cut would remove the last test of a core behavior,
even if you are far short of 80%. Report the number you reached and what
blocks the rest. A 50% cut with every core behavior kept is a good result; an
80% cut that loses one is a failed one.

## Report

| | Before | After | Change |
| --- | --- | --- | --- |
| Test lines | | | |
| Test count | | | |
| Line coverage | | | |
| Branch coverage | | | |

Then list: behaviors that lost coverage (core or minor, and which lines),
behaviors kept and the test that owns each, the commands you ran, and whether
the numbers are measured or estimated. Don't commit or push unless asked.
