---
name: pr-description-style
description: Write or refresh PR titles, descriptions, and screenshots in Derek’s concise, reviewer-focused style. Use when preparing a PR or updating its description after changes; this is not a code-review workflow.
---

# PR description style

Make the current change easy to understand and review in one read.

- **Content**
	- **Context**
		- Build a small context snippet around these points, in order:
		- **Before:** What did the user encounter before the change? Ground it in their task or the UI they use; name a click or other interaction only when it helps explain the problem.
		- **Why:** Explain the user problem or the improvement we want.
		- **How, when useful:** Explain the approach only when it helps the reviewer understand a meaningful choice. Usually omit implementation details for small PRs.
		- Keep a brief reassurance when it resolves a likely reviewer concern, such as whether existing content remains readable. Include surfaces and input methods only when those distinctions matter to the change.
	- **Links and evidence**
		- Include known Slack discussion and Linear ticket links next to the context they support or on a short line below it. Retain links that explain the product decision or requirement.
		- Do not invent references, business context, or approvals. Links supplement the explanation; they do not replace it.
		- Summarize verification with checks run, outcomes, and material gaps. Distinguish observed results from checks reported by an earlier author.

- **Writing style**
	- **Language and length**
		- Write simply, at roughly a high-school reading level. Prefer familiar words, short sentences, and concrete actions.
		- Keep each context point to about two short sentences at most. This is a ceiling, not a target; combine points naturally when one or two sentences cover the whole change.
		- Do not force separate headings for a small context snippet. The outline in this skill organizes instructions, not the required PR output.
	- **What to cut**
		- State the problem once, then describe the visible improvement without repeating the same restriction or explanation.
		- Include technical details only when they explain a consequential design choice, limitation, or risk the reviewer needs to assess.
		- Omit agent work history, self-congratulation, review-loop counts, abandoned approaches, raw logs, retry chronology, and unnecessary inventories of unchanged behavior.

- **Screenshots**
	- **Choosing and capturing states**
		- Capture and inspect actual rendered UI. A screenshot is evidence only for the state it shows; do not imply it verifies other surfaces.
		- Prefer a before/after table with the same route, data, viewport, scroll position, and interaction state. Explain any material mismatch or reconstructed baseline.
		- Avoid a hover or selection highlight that hides the actual change.
		- Include an additional interaction, narrow-layout, or theme screenshot only when it demonstrates something useful. Put secondary images in a collapsed section when that improves scanning.
	- **Publishing images**
		- Embed durable images readable by the repository’s reviewers. Use the repository’s established attachment workflow when available; keep screenshot files out of the implementation diff.
		- Do not make private material public to obtain an image URL.

- **Workflow and scope**
	- **Requested output**
		- For a full PR description, follow the repository’s PR template and required disclosures.
		- For a context-only writing request, return the requested snippet without unrelated template sections; still honor any repository requirement that applies to that output.
		- Keep author-owned checklist boxes unchecked unless the user explicitly asks otherwise.
		- When asked to update a PR description and images, complete that update within the authorization already given. This skill does not itself authorize publishing, messaging, code changes, or merging.
	- **Refreshing an existing PR**
		- Describe the final diff against its base. Rewrite stale sections when the implementation changes instead of appending a history of revisions.
		- Keep images and captions in sync with the final implementation; replace stale ones when the design changes.
		- After updating, read back the description and verify the image links resolve. Retain an honest testing limitation if a relevant state could not be exercised.

- **Example**
	- Matched transactions cannot be tagged, but their empty Tags cells give no explanation. This PR gives those cells a muted background and a tooltip explaining the tag restriction.
	- Existing tag names remain readable, including their full names in the tooltip.
	- Adapt this level of detail to the actual change; do not copy this feature-specific wording into unrelated PRs.
