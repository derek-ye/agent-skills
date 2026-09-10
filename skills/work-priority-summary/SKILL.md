---
name: work-priority-summary
description: Summarize open PRs, tickets, or work threads in a concise table explaining what each delivers, its project relevance, and whether it deserves attention now. Use for backlog triage, stale-work reviews, or questions like "am I working on the right thing?" Not a substitute for a detailed code review.
---

# Work priority summary

Help the user choose where to spend attention. Explain the work in plain language and assess its relationship to current outcomes, commitments and dependencies. Do not assume a launch deadline or GA frame unless the user asks for one.

## Gather just enough evidence

- Establish the requested scope from the conversation and available project notes: named items, authored open PRs, assigned issues, or a project. Use connected source tools where available; do not require a particular connector or personal knowledge-base layout.
- Read current priorities and the user's latest decisions before ranking. If a Chief of Staff procedure exists, follow its source and authority rules. Career/learning goals may inform discretionary work but do not override delivery commitments.
- Verify each included PR or issue's current state directly. For PRs distinguish open, closed unmerged, and merged; a merge-commit field alone does not prove a merge. Merged does not prove deployed. Check recent successors and closures when explaining stale work.
- Read descriptions and relevant discussions to establish purpose, acceptance, dependencies and explicit commitments. Use code or further investigation only when needed to resolve a material ambiguity. Treat agent reports and bot reviews as attributed evidence, not verified defects or completed acceptance.
- Group overlapping implementations of the same outcome in one row. Distinguish a proposed replacement from a verified successor. Preserve explicit deferrals and avoid recommending an obsolete branch after a redesign.
- If source access is incomplete, identify what was checked and mark stale or unverified claims. Never turn a limited listing into an exhaustive inventory or invent urgency from age, conflicts, an active label, or a project name.

## Assess relevance

For each outcome, answer: what changes for whom, which project goal it advances, why now (if any), and what the user uniquely needs to do. Weigh user priorities, impact, confirmed commitments/deadlines, dependency order, readiness and effort. Keep importance separate from ease of merging.

Use concise judgments such as "Focus now," "Next," "Waiting on X," "Can wait," or "Candidate to retire." These are recommendations unless a user decision or authoritative source establishes them. Explain the reason; do not assign numerical scores without a useful basis. A legitimate technical cleanup can be valuable without being urgent. Missing status research belongs to the agent, not automatically to the user's task list.

When asked "am I working on the right thing?", answer directly using the evidence. If objectives are unknown, give a provisional assessment and ask only the question that would materially change the recommendation.

## Output

Lead with one or two sentences naming the recommended focus and any important correction. Then use this table, adapting "Work" to "PR" or "Ticket" for a homogeneous list:

| Work | Overall summary | Project relevance / attention |
|---|---|---|
| Linked source item(s) | One plain-language sentence about the outcome, not a restatement of the title. | **Recommendation.** Name the project goal, dependency or tradeoff that explains it; include the user's next action only if needed. |

- Order by recommended attention, not PR number or age. Group by project only when it helps scanning; don't force a fixed number of priorities.
- Keep most cells to one or two short sentences. Use clickable canonical links for each item and link decision evidence where the recommendation depends on it.
- Mention merge conflicts, review or browser gaps only when they affect the next step. Clearly label unpushed agent repairs so the user does not assume they are in the linked PR.
- End with a short next-action recommendation and meaningful coverage limitations, if any. Don't repeat the table in prose or expand every item into an implementation plan.

Example shape (illustrative, not live work):

| Work | Overall summary | Project relevance / attention |
|---|---|---|
| Two linked account-page PRs | Alternative implementations of the same account-management redesign. | **One outcome, not two tasks.** Finish the approved direction after checking the overlap; propose retiring the redundant branch. |
| Linked progress-indicator PR | Shows that report numbers are still changing during processing. | **Waiting on the new header.** Resume after that shared UI lands, then verify navigation and completion refresh. |
| Linked mock-only fix | Makes local onboarding fixtures preserve the selected path. | **Can wait.** Helps development accuracy; no demonstrated customer-facing dependency today. |

## Boundaries and final check

This skill produces an assessment; it does not authorize closing PRs, changing issue state, contacting people, publishing repairs, or rescheduling work. Maintain local notes only within existing permissions, distinguishing source facts, user decisions and recommendations.

Before returning, check: current states verified; replacements and deferrals respected; duplicate outcomes grouped; relevance explained beyond status; user actions separated from agent research; and no claimed completion or deadline stronger than the evidence.
