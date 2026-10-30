---
name: code-review-loop
description: Orchestrate independent correctness and code-quality reviews, adjudicate findings, and reverify fixes with bounded rounds and explicit outcomes. Use to review a patch or PR; replaces the Claude CLI shell loop.
---

# Evidence-based review loop

The parent orchestrates and owns the verdict. For nontrivial changes use two fresh
reviewers when delegation is available and authorized. Give them the same intent,
complete diff, surrounding code, and raw evidence independently. Do not share one
reviewer's findings with the other or treat author reasoning as proof. Reviewers
never edit the target checkout; safe execution can use separate scratch checkouts.
Only the orchestrator or assigned implementer changes the candidate. No specific
model family or task API is required.

For a small change or unavailable delegation, use both lenses sequentially and
disclose the lack of independence. If independence is an explicit acceptance
requirement and unavailable, report BLOCKED.

## Review boundary

Read the request/PR, root and scoped repository instructions, project review rules
when present, and affected code. Establish intent independently of the diff; ask
only if material intent is unresolved. Include additions, deletions, renames,
config, tests, generated output, binaries, and relevant untracked files. Do not
filter file types or execute an untrusted patch just to inspect it.

For a PR or nontrivial diff, use [before-after](../before-after/SKILL.md) to
map all material changes, edge cases, and possible unintended effects. Include
the map and raw evidence in the common reviewer packet; reviewers independently
check it against the code. Reuse an existing current map rather than repeating
the investigation. A narrow event question can use its event mode.

Record base SHA, candidate HEAD, and worktree identity using
`python3 <dev-workflow>/scripts/review_scope.py --repo <checkout> --base <target>`
or equivalent git inspection. Review committed changes even with an empty
unstaged diff. No cleanup edits never means skip review. A truly empty scope is
PASS with "no changes"; a nonempty scope still needs substantive review. Inspect
binary artifacts appropriately or record the inspection gap.

## Independent lenses

Read [reviewer briefs](references/reviewers.md); send each reviewer its matching
brief plus the common boundary. The first pass covers the whole candidate.

1. **Correctness and impact:** before/after, failure paths, authorization, data
   integrity, concurrency, downstream contracts, and safety assumptions.
2. **Structure and taste:** read [derek-code-pass](../derek-code-pass/SKILL.md) as a
   review rubric, without making its edits. Find material complexity or
   maintainability regressions; formatter nits belong in tooling. Explicitly run
   its 80/20 test-value pass for added/changed tests and return keep/cut/consolidate
   decisions with remaining proof, even when no cuts are warranted. For UI work use
   [design preferences](../derek-design-preferences/SKILL.md).

Return substantiated findings or explicitly none. Each finding needs an ID,
location (base location for deleted code), severity, trigger, consequence,
evidence, and a confirming check. Label unverified hypotheses. Agreement is
supporting signal, not proof; one demonstrated serious issue blocks despite votes.

## Adjudicate and converge

Check findings against source/evidence and deduplicate by root cause. Keep a short
ledger: `ID | finding | blocking? | accepted/dismissed/unresolved | evidence/reason`.
Accepted findings stay open until fixed and verified. Dismissals need a concrete
reason. Do not silently drop disagreement or automatically fix suggestions.

Block on demonstrated correctness/security/data-integrity defects, broken explicit
requirements or conventions, and material structural regressions with a concrete
simpler alternative. Subjective preferences and speculative refactors are
nonblocking unless established as a bar by the user or repository. Resolve disputes
with the cheapest decisive check; otherwise keep the material uncertainty visible.

Default to at most **three review rounds**. State a different user-requested limit
before starting. Each round comprises independent reviews, adjudication, any scoped
fixes, and relevant verification. Fixes must receive a fresh review of their delta
and affected contracts, plus checking the existing ledger. After the first full
pass focus on new edits; reopen broad scope only for a concrete reason such as a
changed shared contract. Do not repeat dismissed findings without new evidence or
keep finding unrelated pre-existing bugs.

Use one writer at a time. Inspect delegated changes and run relevant feasible
checks against the final state; disclose checks not run. Last-round fixes are not automatically reviewed:
if no review budget remains, report LIMIT_REACHED. Stop earlier for no meaningful
progress, repeated unchanged findings, missing tools, or a major unresolved choice.
Never keep agents running just to obtain unanimity.

## Outcomes

The outcome assesses the reviewed code, separately from merge or release readiness.
Missing acceptance evidence does not by itself block PASS. Unrun deterministic
checks, manual/browser QA, Chromatic, deployment confirmation, stale required-commit
checks, and merge conflicts are follow-ups unless the user explicitly makes them
conditions of this review. Still run useful feasible checks and report actual
results. A failing check that demonstrates a candidate defect blocks; unavailable
checks or infrastructure failures do not establish a defect. A published-head PASS
does not cover a future rebase or conflict resolution; review that delta separately.

Use exactly one outcome tied to the final candidate identity. If several apply,
choose LIMIT_REACHED for exhausted substantive review/fix budget, otherwise NEEDS_FIX
for confirmed blockers, otherwise BLOCKED when substantive review cannot be
completed, otherwise PASS:
- **PASS:** substantive review completed, no unresolved blocking findings, and final
  edits reviewed. List unperformed checks, acceptance follow-ups, and nonblocking
  notes separately; do not claim unverified behavior works.
- **NEEDS_FIX:** a confirmed blocking defect remains and is not fixed in scope.
- **BLOCKED:** the candidate cannot be inspected, a concrete suspected blocking
  defect cannot be adjudicated with available evidence, or an explicit user-required
  review condition cannot be met. Name the specific obstacle. Do not use this for
  routine acceptance or merge-readiness follow-ups.
- **LIMIT_REACHED:** substantive review/fix work remains when the round or progress
  limit ends automation. Missing routine acceptance checks alone do not exhaust
  the review budget.

Default to a short chat handoff: **outcome → behavior changed → evidence →
unresolved decisions/next action**. Identify the reviewed candidate and disclose
review independence. Keep round counts, the full findings/disposition ledger,
test-value assessment (PR-added versus existing tests), and raw logs in a linked
local review artifact when they would crowd the handoff. A small review can keep
all of its evidence inline without creating a separate document.

Keep material findings and verification gaps visible in chat: briefly explain
current behavior and impact, then the proposed change or check and expected
outcome. Distinguish proposals from applied and verified changes.
PASS never authorizes publishing, merging, or deploys.
