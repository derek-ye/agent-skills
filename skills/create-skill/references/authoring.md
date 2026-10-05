# Authoring standard

## Format and loading

- A skill is a directory containing `SKILL.md` with YAML `name` and `description`.
- Name matches the directory: 1–64 lowercase letters/digits/hyphens, no leading, trailing, or consecutive hyphens. Description is 1–1024 characters and describes user intent and appropriate activation.
- Keep the main instructions concise. The official recommendation is under 500 lines; this is guidance, not a validity rule.
- Link supporting resources relatively and say when to read them. Keep the essential workflow in the main file. Avoid deep reference chains and duplicated rules.
- Use client-specific frontmatter only when verified for the target runtime. Standard format compatibility does not prove execution compatibility.

## Questions that expose useful judgment

1. What recurring request should this automate? What goes wrong today?
2. Show one acceptable and one unacceptable outcome. What distinguishes them?
3. Which rules are firm, which are defaults, and when are exceptions justified?
4. Which tools/skills already exist? Which inputs and artifacts do they require?
5. What evidence would you trust? Which failures should stop completion?

Ask only the unresolved questions relevant to the current skill. A vague answer is an opportunity to offer a concrete example, not a reason to repeat the whole interview.

## Evidence contract

For each material criterion, define: behavior or property → check → expected result → artifact → failure handling.

Example for a UI implementation skill:

| Criterion | Evidence |
| --- | --- |
| User can complete the requested flow | Execute named steps in the browser against the changed app; record inputs and expected/observed final state. |
| Relevant visual states are correct | Screenshots of specified viewports/states, inspected against the requirement; retain paths. |
| Regression checks pass | Actual project test/lint/type/build commands, exit results, and relevant failures. |
| Tests detect meaningful regressions | An independent expected outcome and a plausible defect caught by the assertion; use a controlled failure where warranted. |

These checks support bounded claims. A screenshot cannot establish persistence, a mocked flow may not establish integration, and a successful lint run cannot establish feature behavior. Report untested criteria and environment blockers. Avoid forcing UI artifacts on backend-only work.

## Completion and review

Each stage ends with an observable criterion. Retry only when a concrete change can resolve the failure; bound automated loops. Keep substantive failures visible. Independent reviewers inspect the requirement, diff, and evidence rather than merely accepting the implementer's summary.

Start with a few realistic cases. Separate activation checks from execution-quality checks. Prefer cases exposing missed requirements, unavailable dependencies, invented preferences, and unsupported completion claims over tests that simply compare instruction wording.

## Sources

- [Agent Skills specification](https://agentskills.io/specification): portable structure and metadata constraints.
- [Official creation best practices](https://agentskills.io/skill-creation/best-practices): extract real workflow knowledge, use progressive disclosure, and avoid generic content.
- [Official evaluation guide](https://agentskills.io/skill-creation/evaluating-skills): representative tasks and comparison-based evaluation.
- [Matt Pocock: writing for agents](https://github.com/mattpocock/skills/blob/main/skills/productivity/writing-for-agents/SKILL.md): concise instructions and explicit completion criteria. Runtime mechanisms and authoring opinions require separate verification.

This skill is an original synthesis. Record pinned source references for additional external patterns actually incorporated; preserve upstream license notices if copying text or code.

### Poteto inspiration

Reviewed `poteto/plugins` at `74dd2291e8e37b12fd6dc49b2acbd655c6bdaf12`:

- [Authoring a skill](https://github.com/poteto/plugins/blob/74dd2291e8e37b12fd6dc49b2acbd655c6bdaf12/pstack/skills/poteto-mode/playbooks/authoring-a-skill.md): targeted structural checks and pruning instructions that change no decision.
- [Encode lessons in structure](https://github.com/poteto/plugins/blob/74dd2291e8e37b12fd6dc49b2acbd655c6bdaf12/pstack/skills/principle-encode-lessons-in-structure/SKILL.md): use enforceable mechanisms for machine-checkable rules.
- [Build the lever](https://github.com/poteto/plugins/blob/74dd2291e8e37b12fd6dc49b2acbd655c6bdaf12/pstack/skills/principle-build-the-lever/SKILL.md): prove one unit before automating repetitive work.
- [Prove it works](https://github.com/poteto/plugins/blob/74dd2291e8e37b12fd6dc49b2acbd655c6bdaf12/pstack/skills/principle-prove-it-works/SKILL.md): inspect actual feature behavior and delegated artifacts.
- [Verify this](https://github.com/poteto/plugins/blob/74dd2291e8e37b12fd6dc49b2acbd655c6bdaf12/cursor-team-kit/skills/verify-this/SKILL.md): falsifiable conditions, metrics, and comparative evidence.
- [Arena](https://github.com/poteto/plugins/blob/74dd2291e8e37b12fd6dc49b2acbd655c6bdaf12/pstack/skills/arena/SKILL.md): separate outputs and a shared rubric for delegated work.

Pstack is MIT ©2026 Lauren Tan; Cursor team kit is MIT ©2026 Cursor. Concepts are expressed here in original wording.

[Verification skill example](https://github.com/poteto/verification-skill-example/blob/d5abe70d0d8c671672b6cef4069363f26c488feb/.cursor/skills/verify-atlas/SKILL.md), reviewed at `d5abe70d0d8c671672b6cef4069363f26c488feb`, inspires real UI entry points, settled state, and persistence/side-effect checks. Its app and omitted driver are fictional and the repository has no license; this skill neither copies its prose nor assumes that driver is available.
