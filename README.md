# Agent skills

Canonical repository: https://github.com/derek-ye/agent-skills

Edit reusable skills in `skills/` here. Local installations should link to this
checkout instead of maintaining independent copies. Pull/push synchronizes Git;
symlinks do not fetch remote changes.

## Development workflow

- **Start-to-finish work:** `dev-workflow` turns intent into a behavior contract,
  implementation slices, verification, independent review, and a PR briefing.
- **Already implemented:** `review-pipeline` applies the code pass, runs project
  verification, and delegates to `code-review-loop`.
- **Review only:** `code-review-loop` uses independent correctness/impact and
  structure/taste reviewers with an orchestrator. It adjudicates evidence rather
  than waiting for unanimity and defaults to three rounds.
- **Atoms:** `verify-atoms` provides real launch/check commands, a feature map,
  and an optional Playwright smoke driver. Mock checks do not prove live auth or
  backend persistence.
- **Another project:** `create-project-verification` creates its grounded recipe.

Outcomes are `PASS`, `NEEDS_FIX`, `INCONCLUSIVE`, or `LIMIT_REACHED`, tied to the
reviewed candidate. None grants permission to merge or deploy. The workflow uses
the current agent runtime; it does not spawn Claude CLI subprocesses. If independent
review is unavailable, it reports that limitation instead of claiming parity.

The old `review-pipeline/scripts/*.sh` and prompts have been removed. Invoke a skill
in your agent rather than running those paths. `simplify-loop` remains a compatibility
skill for a single focused `derek-code-pass`; it no longer runs a shell loop.
See [workflow design](docs/review-pipeline-design.md) for roles and evaluation.

## Installation

For Codex, link each wanted skill directory under `~/.agents/skills`; for Claude
Code use `~/.claude/skills`. From this repo, replacing `skill-name`:

```sh
mkdir -p "$HOME/.agents/skills"
ln -s "$PWD/skills/skill-name" "$HOME/.agents/skills/skill-name"
```

Inspect existing destinations first and preserve independent edits. Keep built-in
and unrelated skills in place. Link the referenced sibling skills too, including
`derek-code-pass`, `derek-design-preferences`, and `pr-description-style`. A linked
skill's relative resources resolve from its real directory. Installed clients may
need a new session to discover new skills. The Claude plugin manifest also exposes
this repository's skill collection to clients supporting that plugin format.

## Other skills

- `before-after`: explain all material changes in a PR through baseline/candidate
  behavior, impact, edge cases and unintended effects; also supports event walkthroughs.

- `create-skill`: interview and codify technical workflows with evidence and review.
- `derek-code-pass`: scoped structure, comment, and behavioral-test preferences.
- `derek-design-preferences`: UI copy and typography preferences.
- `pr-description-style`: concise user context, matched screenshots, and evidence.
- `work-priority-summary`: work inventory, dependencies, and attention recommendations.
- `update-weekly-todos`: maintain concise Obsidian action lists.
- `ponytail`: upstream minimal-code skill; provenance and license in its directory.
- `test-audit`: imported OpenClaw testing workflow; requires its project-specific
  tools/skills and is not a generic prerequisite for every project.
- `principle-test-behavior-not-implementation`: imported pstack testing principle;
  provenance and license in its directory.

## Checks

```sh
python3 -m unittest discover -s tests -v
python3 skills/dev-workflow/scripts/review_scope.py --repo . --base main
```

The tests exercise git scope and evidence identity, including committed deletions,
tracked/untracked changes, renames, and an advancing base. They do not establish
that a language-model reviewer finds every bug. See the design's behavioral cases
and recorded validation for the distinction.
