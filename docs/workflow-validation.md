# Workflow validation, October 18, 2026

## Scope tools

`python3 -m unittest discover -s tests -v`: six tests passed using real temporary
git repositories. Cases cover committed deletion with an empty unstaged diff;
staged/unstaged/untracked fingerprint changes; renamed paths and symlink handling;
a moving target branch; a staged change canceled by the working tree; and missing
target detection. These tests validate scope/evidence mechanics, not bug recall.

`node --check skills/verify-atoms/scripts/smoke.mjs` passed. The seven new/changed
workflow, review, verification and PR skills passed the system skill-creator's
frontmatter/name validation. Local relative links and final whitespace were checked.

## Skill behavior

Independent static walkthroughs covered deletion-only/committed-only changes with
no cleanup, final-round fixes, missing required browser evidence despite reviewer
agreement, a demonstrated finding disputed by another reviewer, and invocation
from scratch versus after implementation. Reviews suggested outcome precedence
and non-Atoms verification discovery; both were added. A separate technical review
ran the fixture tests and inspected the scope helper and browser driver.

A fresh agent then followed code-review-loop against a real deletion-only fixture.
The brief asked to remove an unused helper while preserving a CLI. Base execution
printed `Sample Task` and exited 0. Candidate execution raised ModuleNotFoundError
and exited 1 because the supposedly unused module was still imported. The agent
returned NEEDS_FIX with location, trigger, consequence, actual before/after output,
and a disclosed sequential review. It made no edits. This demonstrates one actual
review case; it is not a measured reviewer recall/noise benchmark or an execution
of every multi-agent branch.

## Atoms recipe

Inspected and ran an isolated copy of Atoms revision
`f12e8119ee9c33b4e8e58f224798726decaa10f8`, using Node 24.13.0 and locked npm
installation. The original Atoms checkout was not changed.

- `npm run check` passed lint, formatting, TypeScript, and 25 tests across 3 files.
- `npm run build` exited 0. Upstream module-level `use client` bundling warnings
  were emitted; they were not treated as evidence of product behavior.
- `npm run dev:mock -- --host 127.0.0.1 --port 4317 --strictPort` reached readiness.
- Playwright smoke passed capture, note editing, Today scheduling with in-session
  navigation, completion/Undo including absence from Logbook after Undo, search
  positive/negative controls and Escape, and expected reset after full reload.
- A separate fresh 390x844 browser context passed Today → Open navigation → Inbox.
  Desktop and mobile screenshots were visually inspected for the exercised states.

Early driver runs failed at hydration readiness and at Playwright's checked-state
confirmation after a completed task left the list. The recipe/driver were corrected
to wait for initial dev-page network idle and assert the resulting removal/Undo
instead. The final flows passed; no application change was made to obtain a pass.
The driver remains a smoke harness, not a full app/browser regression suite.

Local results JSON, screenshots and browser trace were retained in the task's
`evidence/atoms/` directory, not committed into this skill repository. No backend
deployment, login, durable storage, account isolation, or production release was
verified. Those require their own configured environment and checks.
