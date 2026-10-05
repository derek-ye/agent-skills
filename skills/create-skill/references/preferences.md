# Derek's preferences and context

## Confirmed in the authoring interview

Source: Derek's interview for this skill. These are durable authoring preferences, not a full policy for all engineering work.

| Preference | Reason and application |
| --- | --- |
| Codify recurring technical processes and personal judgment. | Typical skills cover test selection, implementation methods, framework use, and verification. Ask what distinguishes Derek's approach from a generic workflow. |
| Reduce continuous human supervision through evidence. | Derek currently monitors and micromanages agents. Specify proof of completed work so he can assess the result without repeating every step. |
| Use deterministic checks and observed artifacts. | Depending on the task, use tests, lint rules, screenshots, and traversed application flows. Evidence must establish the requested outcome; no single check proves all code is correct. |
| Compose tools and other skills. | Skills may encode a sequence of implementation, testing, browser verification, and review. Define dependencies and what each handoff establishes. |
| Support a team of agents with shared standards. | Delegate useful independent work and review with clear responsibilities, then integrate and verify. Provide a fallback when the runtime cannot delegate. |
| Work in Claude Code and Codex, and elsewhere where possible. | Keep the core portable and make runtime-specific dependencies explicit. Installation alone does not establish runtime compatibility. |
| Learn from Lauren Tan (Poteto) and Matt Pocock. | Adapt useful structure and content to Derek's actual needs; preserve attribution for reused material. |
| Interview deeply before drafting. | Resolve the judgment, rationale, examples, and acceptance expectations before encoding a workflow; use focused rounds of substantive questions. Confirmed in the follow-up interview. |
| Operate independently until blocked or facing a major judgment call. | Derek wants less supervision and is flexible about team structure. Choose useful roles and bounded retries; surface blockers or decisions that materially alter behavior, scope, or acceptance with options and a recommendation. |
| Research and explain defaults when a preference is undecided. | Act as a guide: teach the relevant practice and tradeoff, recommend a suitable default, and resolve material decisions in the interview. |
| Test meaningful happy paths and relevant edge cases. | For an authenticated database write, verify authorization and database effects; avoid checks that merely restate incidental local variable assignments or unchanged values. Whether an internal assertion is useful depends on the contract and defect it detects. |
| Capture specific testing preferences, including filtering tautological tests. | Derek wants this judgment codified. His exact definition, examples, and exceptions are still open; elicit them when authoring that testing skill. |

## Existing repository guidance, scoped to its source

These are explicit in existing skills, but extrapolating them to every skill is a proposed default rather than a newly confirmed universal rule.

- [Intentional UI copy](../../intentional-ui-copy/SKILL.md): retain copy that helps action or explains real state; remove decorative or repetitive copy. Apply to product copy tasks.
- [Work priority summary](../../work-priority-summary/SKILL.md): lead with recommendations, use plain language and source links, distinguish facts from recommendations, and ask materially useful questions. Use this as a proposed reporting default.
- [Weekly todos](../../update-weekly-todos/SKILL.md): preserve user edits and states, reconcile instead of duplicating, and do not invent commitments or completion. Relevant to updates of existing artifacts.
- Repository review workflows favor evidence-based findings and allow a clean review. Useful as a review default; imported skill rhetoric is not automatically Derek's voice.

## Open preferences

- A full taxonomy of tautological tests and acceptable exceptions remains task-specific. Derek's authenticated-write example establishes behavioral outcomes over incidental variable checks; ask for further examples only when the particular testing skill needs them.
- Project-specific commands, evidence destinations, and required toolchains: discover or interview per task.

When Derek clarifies a durable preference, update its rule, rationale, scope, and source together. Replace superseded preferences rather than accumulating contradictions. Do not copy private examples or credentials into this public repository; use sanitized examples.
