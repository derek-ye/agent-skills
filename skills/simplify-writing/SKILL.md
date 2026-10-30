---
name: simplify-writing
description: Draft or revise explanations, tickets, summaries, and other prose in Derek's concise, plain-language style. Use for requests to simplify writing, give a high-level explanation, or make text easier to read; this is not a code-simplification workflow.
---

# Simplify writing

Make the point easy to understand in one read, at roughly a high-school reading
level. Keep the meaning and useful context; cut the work the reader must do.

## Choose what matters

- Lead with the answer or outcome. Explain the problem, why it matters, and what
  improves when those points help the reader. Combine them naturally rather than
  forcing a template.
- Apply the 80/20 rule: keep the few facts that explain most of the issue. This is
  a judgment about usefulness, not a word-count quota.
- Start at the level of purpose, behavior, and responsibility. Include technical
  detail only when omitting it would hide an important choice, risk, limitation,
  or next action. Introduce a component's role before its name when needed.
- For a narrow follow-up, answer that question and stop once the missing
  relationship is clear. Do not repeat the whole earlier explanation.

## Write plainly

- Use familiar words, active verbs, and short, connected sentences. Prefer
  "use" to "leverage" and "move shared code" to "decouple shared dependencies."
- Avoid jargon and unexplained acronyms. Keep an exact technical term when it
  carries essential meaning, then explain it briefly in everyday language.
- Prefer short paragraphs. Use bullets for parallel points and headings only
  when they help navigation. Do not turn every answer into a report.
- Remove repetition, filler, agent work history, and inventories of internal
  details. Avoid canned conclusions, invented labels, and unprompted contrasts.
- Be direct without sounding childish or choppy. Use one concrete example when
  it explains more than another paragraph would.
- Do not compress away who does what. Words such as "flow," "ownership," and
  "navigation" can hide the relationship even in a short sentence. Name the
  actor and action when that relationship matters. For example, replace
  "keep saving and navigation in each flow" with "the shared editor edits
  accounts; onboarding saves a template, while replacement asks the user to
  confirm changes to the live chart." High-level writing should omit mechanics,
  not the actions that make the explanation understandable. If the user asks
  what a phrase means, restore the missing relationship instead of merely
  replacing its jargon with other abstract words.

## Preserve the substance

Keep material caveats, source links, scope, and uncertainty. Distinguish current
behavior from proposed behavior, and a future feature from a defect in the
current work. Do not turn "no intended behavior change" into "no possible risk"
or claim an unverified improvement as a measured result.

Respect the requested format and any required disclosures. For tickets and PRs,
keep the reason and intended result understandable without opening the links;
link supporting detail instead of copying it all. This skill changes the writing,
not the underlying decision or permission to publish it.

Before sending, ask: can the reader explain the main point and why it matters?
Remove details that do not help them do that. Return the writing itself unless
the user asks for an explanation of the edits.
