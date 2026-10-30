---
name: guided-pr-review
description: Walk the user through reviewing a PR live, in 15–30 minutes, by sorting files by risk and explaining unfamiliar codebase patterns before they read the diff. Use when the user wants help reviewing a PR themselves ("walk me through this PR", "help me review this fast"), especially in a part of the stack they know less well. For a written report instead of a walkthrough, use pr-review-packet.
---

# Guided PR review

The user reviews; you navigate. Reviews are slow mostly because the reviewer must learn unfamiliar patterns while reading the diff, not because of reading speed. Remove that cost: decide what deserves attention, and explain each unfamiliar pattern before they meet it.

Start read-only. Don't post comments, approve or edit code unless asked.

## 1. Sort by risk (you do this; aim for under 5 minutes)

Fetch the PR description, the file list with line counts, and the diff. Then sort every file into one of three groups:

- **Close read:** code that changes behavior for users on merge. Behind a feature flag, only the flag wiring belongs here. Look hard at shared hooks, shared components and anything that many pages use.
- **Skim for design:** new code behind a flag that is off by default. It can't hurt users until the flag turns on, so check the approach, not every line.
- **Skip:** generated files (verify they match their source, e.g. backend golden types, instead of reading them), stories, CSS, renames and moves, and tests (read test names only, as a map of what's covered).

Verify claims in the PR description against the diff, such as "behind flag X" or "matches backend". Tell the user what you verified so they don't redo it.

Give the user a timed plan: which files, in what order, and what question to ask of each ("could this break today's Tags page?").

## 2. Walk file by file, in the user's order

For each file they open:

- Say what changed in one or two sentences. Point out changes that are mostly whitespace or indentation and suggest GitHub's "Hide whitespace" setting.
- When the file uses a pattern the user may not know (a design-system component, a caching hook, a React API), explain it from first principles before the diff: what problem it solves, then how it works. Read the real source in the repo and cite `path:line`. Don't explain from memory.
- Separate what the PR added from what was already there. Users often mistake old code for new code; "this already existed; the PR only adds X" saves a lot of confusion.
- Say whether something deserves a comment. Defensive code the author already handled is worth understanding but not worth commenting on.
- Offer an ASCII diagram when the question is about how parts connect (who calls whom, data flowing up or down).

Keep every answer short and answer the question asked. The user follows up when they want more.

## 3. Wrap up

- Name the two or three comments worth leaving, usually about behavior that ships to everyone. Offer to draft them; don't post them.
- Note merge dependencies, such as a backend PR that must land first.
- Name what slowed the review (usually unfamiliar patterns) and suggest a 5-minute "how do these pieces fit" pass before the diff next time.
