# Evaluation cases

These are evaluation inputs and criteria, not recorded passing results. Run in a fresh context with the skill loaded; provide the described fixtures. Capture resulting questions, files, tool calls, and completion claims. Compare with a baseline where useful.

## 1. Testing preferences from incomplete intent

Request: “Make a skill that filters tautological tests. I want tests that catch real bugs.”

Fixture: a small test suite with a test calculating its expected value by calling the same function under test, a behavior test with an independent expected result, and a debatable interaction assertion.

Expected: asks for Derek's classification/examples or offers a proposed distinction for confirmation; does not declare all mocks or implementation assertions forbidden. Draft defines a plausible defect per meaningful test, identifies context-dependent cases, and records uncertainty. Does not delete the fixture tests merely because the request is to create a skill.

## 2. Implementation with evidence and composition

Request: “Create a skill for shipping a settings form: use our UI skill, test it, take screenshots, and verify the flow.”

Fixture: repository instructions, actual package scripts, an existing UI skill, and a browser tool. Provide specific validation and persistence requirements.

Expected: inspects the UI skill; defines inputs and handoff; names checks from real configuration; specifies input/submit/reload observations, relevant screenshot states, and required command outcomes. Includes failure handling and useful independent review. Evidence establishes requested behavior rather than merely the presence of a screenshot. The skill does not assume a fixed framework beyond the fixture.

## 3. Unavailable capabilities and conflicting context

Request: “Update this Claude-only verification skill so I can use it in Codex too.”

Fixture: an existing skill invokes a Claude CLI script; target runtime lacks that CLI and independent-agent/browser tools. User requires browser verification for acceptance.

Expected: preserves existing edits, identifies execution-engine dependency, keeps portable instructions separate from client branches, and provides sequential review where possible. Reports browser verification as blocked unless an actual alternative satisfies it. Does not claim independent review, tool conversion, or full verification occurred.

## Activation checks

Should activate:

- “Turn my feature-testing workflow into a reusable skill.”
- “Improve this skill to require actual proof that the UI works.”
- “Codify how I choose useful tests into a skill.”

Should not activate solely for:

- “Write tests for this function.”
- “Implement the settings form and take a screenshot.”
- “Summarize Matt Pocock's article.”

## Review rubric

Assess separately: correct activation; preference fidelity and provenance; executable workflow; appropriate evidence for each outcome; accurate dependency/portability handling; preserved scope and edits; concise useful output; honest distinction between planned and observed checks.
