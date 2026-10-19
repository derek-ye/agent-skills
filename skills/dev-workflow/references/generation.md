# Planning code generation

Read for a feature or substantial change. Turn intent into independently checkable
implementation work before multiplying workers.

## Resolve uncertainty

Separate product choices (what should happen) from empirical questions (what the
current app, dependency, or prototype does). Inspect or run code for the latter.
Ask only about material product choices that cannot be inferred. Continue
independent work while waiting.

For consequential unfamiliar architecture or interactions, compare a small number
of structurally different designs/prototypes. Choose by user behavior, domain fit,
reader load, and migration cost. Routine code does not need a design tournament.

## Shape an implementation brief

Each slice names:
- Observable outcome and non-goals.
- Owned files/modules and dependencies on earlier slices.
- Inputs, outputs, authoritative data shape, state transitions, and boundaries.
- Acceptance checks with expected results independent of the implementation.
- Risks, integration checks, and the artifact handed to the next owner.

Prefer a vertical slice proving one useful path across UI/domain/storage to
horizontal layers that cannot be exercised until everything is done. Give shared
types/schema contracts one owner. Parallel workers need isolated checkouts or
disjoint ownership; never double-drive the same app or generated output.

## Choose the mechanism

- One-off feature: generate candidate code directly against the brief.
- Repeated deterministic change: prove one instance, then use a codemod, template,
  schema generator, or script and compare output with the proven instance.
- Checked-in generated files: identify the source of truth and regeneration
  command. Edit the source, regenerate, inspect output; do not hand-patch derived
  files or require unchanged output when the source legitimately changed.
- Framework-owned output: follow the actual lifecycle. Dev/build/backend tooling
  may require an environment unavailable to the current agent; state that gap.

Apply the same behavior and review gates regardless of who or what wrote the code.

## Improve from actual runs

Retain a few representative briefs, final patches, verification results, finding
lists/dispositions, human corrections, and human attention spent. Sanitize shared
examples. Classify failures: requirement, context, contract, implementation,
verification, review noise, or delivery. Improve the stage responsible.

Compare a changed skill/tool on the same bounded tasks. Do not promote it because
its prose sounds stronger. Use real escaped defects and clean changes to evaluate
reviewers. Measure useful accepted work and human correction cost, not lines of
code or agent count.
