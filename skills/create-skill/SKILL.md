---
name: create-skill
description: Create or refine reusable agent skills for Derek's technical workflows. Use when asked to codify a recurring process, testing preference, implementation method, verification workflow, or framework into a skill, or to improve an existing skill. Includes focused interviewing, skill composition, evidence requirements, and review for Claude Code and Codex.
---

# Create a skill

Turn a recurring technical process into instructions an agent can execute and Derek can assess through concrete evidence. Capture the judgment behind preferences so the skill remains useful across projects.

Read [preferences](references/preferences.md) on every run. Read [authoring](references/authoring.md) when drafting or reviewing. Read [evaluation cases](evals/cases.md) when evaluating this meta-skill itself.

## 1. Understand the process

Inspect the repository instructions, relevant existing skills, tools, and a real example of the work. Follow the destination repository's conventions; here the canonical destination is `skills/<name>/SKILL.md`. Preserve independent edits and inspect existing installation links before changing them.

Establish:

- The request that should trigger the skill and nearby requests that should not.
- The recurring problem, desired result, and current failure mode.
- Derek's rules, why they matter, examples, and permitted exceptions.
- Required tools, frameworks, other skills, and execution environment.
- What evidence would let Derek accept the result without retracing the work.

Interview deeply before drafting. Explore the workflow, pain points, acceptable/unacceptable examples, rationale, firm rules and exceptions, dependencies, agent roles, acceptance evidence, and failure handling. Use focused rounds and follow-up questions grounded in Derek's answers; reuse answered questions and research facts rather than repeatedly asking for them. Offer concrete choices or ask for a good/bad example rather than asking him to design the instructions. Continue independent research while awaiting answers; do not invent required decisions. Draft once material decisions are resolved or Derek explicitly accepts the remaining assumptions.

Separate user-stated preferences, repository-specific rules, and proposed defaults. Explain conflicts and ask only when the answer is needed. A testing example is evidence of intent, not permission to invent Derek's complete testing philosophy.

When Derek has no preference, research relevant established practice, briefly explain the recommendation and tradeoffs, and guide him toward a decision. Label it as a proposed default until accepted; do not treat popularity as proof of suitability. During execution, proceed independently within agreed scope and acceptance criteria. Bring genuine blockers and major judgment calls to Derek with evidence, feasible options, and a recommendation; continue unrelated work while awaiting a decision. Routine implementation choices and recoverable failures do not require escalation.

Done when the workflow, scope, acceptance criteria, and unresolved assumptions are explicit enough to draft.

## 2. Design execution and evidence

Translate each important outcome into observable checks. Specify the command or tool, expected result, artifact location, and what failure requires. Discover project commands from configuration instead of assuming a package manager or framework.

Choose the strongest suitable mechanism for a recurring rule: types, lint rules, runtime checks, canonical helpers, or scripts for machine-checkable constraints; instructions with examples for judgment. For repetitive deterministic work, prove one unit, automate the recipe, and compare the automated result with the known result. Make reruns safe where applicable.

Choose checks appropriate to the work: meaningful behavior tests, lint/type/build checks, browser interaction, screenshots of relevant states, or other deterministic checks. State the exact flow and expected outcome for browser verification. Screenshots establish visible state; use assertions or observations for behavior they cannot establish. Identify required suites separately from optional broader checks.

Verify the changed build through real user entry points and relevant input-to-output effects. Where applicable, check reload/persistence, cancel, error, and empty states. Prefer observable settled state over arbitrary delays. For comparative claims, define the condition, metric, and threshold and compare baseline and changed behavior under equivalent inputs and environment. Classify unmet claims as failed or inconclusive instead of stretching the evidence.

For a testing skill, establish the source of expected behavior independently of the implementation and identify a plausible defect the test should detect. Ask for examples before encoding Derek's precise definition of a tautological test. For applicable cases, propose a failing-before/fixed-after check or controlled defect; do not require mutation infrastructure for every task.

Use Derek's behavioral example as a starting point: for an authenticated database write, check the authorized happy path, relevant authorization failures, and observable persistence or absence of unwanted writes. Avoid incidental assertions that a local variable was assigned or retained a value unless that value is itself an externally meaningful contract. Discover the relevant edge cases from requirements; this example is not a universal checklist or a prohibition on all internal assertions.

Compose existing skills by documenting when to invoke them, their inputs, expected outputs, and completion/failure handling. Inspect their actual capabilities and platform dependencies. Avoid circular dependencies. If a required tool or skill is unavailable, report the missing capability and any feasible partial result; do not call the substitution equivalent without evidence.

Use multiple agents when independent implementation, review, or verification benefits the task and the client supports it. Define bounded roles, ownership, handoff artifacts, and stop conditions. The orchestrator integrates results and verifies claims against artifacts. Independent review supplements execution evidence. Provide a sequential fallback preserving the same checks; report that independent review was unavailable when it matters.

Done when each acceptance criterion has appropriate evidence and each dependency has an execution path or an explicit blocker.

## 3. Write the smallest useful skill

Use standard `name` and `description` frontmatter. Put the essential workflow, scope, and completion criteria in `SKILL.md`; put detailed examples, rationale, or tool-specific instructions in linked references loaded at stated times. Add scripts only for useful repeatable deterministic work. Avoid generic advice that does not change behavior.

Write concrete actions, defaults, recovery steps, and bounded retries. Keep Claude- or Codex-specific mechanisms in an explicitly named branch or reference. Use capability descriptions rather than assuming a particular sub-agent or skill-invocation tool exists everywhere.

For the new skill, record durable task-specific preferences with their rationale and source. Update this meta-skill's preference reference only when Derek states a durable cross-skill preference; keep contextual preferences scoped to their originating skill. Current user instructions take precedence. Cite inspiration and preserve license/provenance when adapting external text or code.

Done when an unfamiliar agent can follow the skill without relying on this conversation, hidden paths, or unverified tool capabilities.

## 4. Review and exercise

Review independently when useful and available. Check triggering, scope, preference fidelity, tool availability, evidence sufficiency, conflicting instructions, and unnecessary ceremony. A reviewer may return no findings. Fix substantiated issues; avoid speculative additions.

Validate directory/name agreement, frontmatter, relative links, and referenced commands. Exercise 2–3 representative cases, including a failure or ambiguous case and a near-miss that should not trigger. Use a clean-context agent execution when available, and compare behavior against the same task without the skill when useful. Label static walkthroughs as walkthroughs rather than claiming runtime validation. Keep evaluation cases and observed results distinct.

Inspect the final diff and preserve unrelated work. Save a concrete draft in the requested destination; for this repo a review branch and draft PR are suitable unless Derek specifies otherwise. A request to create a skill authorizes preparing it, not automatically merging it or activating unrelated workflows.

Done when structural checks pass, meaningful behavior checks have been assessed, and limitations are stated.

## 5. Report the result

Lead with the artifact or PR link. Briefly state what the skill does, the checks actually performed with evidence, and remaining blockers or assumptions. Explain how to invoke it. Distinguish a finished artifact from demonstrated runtime reliability. Never claim a command, screenshot, manual flow, independent review, or passing test without an observed result.
