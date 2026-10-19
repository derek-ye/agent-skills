---
name: create-project-verification
description: Create or update a project verification recipe from real launch commands, user flows, evidence, and cleanup. Use when a project needs a reusable way to prove application behavior.
---

# Create a project verification recipe

Inspect root/scoped instructions, build configuration, CI, routes, existing
harnesses, state/storage, and auth. Discover commands instead of copying another
project's assumptions. Prefer existing drivers. Missing tools are limitations,
not permission to invent execution results.

Write `verify-<project>/SKILL.md` in the established location (`skills/` here):
- **Identity:** checkout/build and changed-file identification.
- **Launch:** exact install/start commands, working directory, environment variable
  names, ports, readiness, and network/credential requirements.
- **Doctor:** confirm expected app/version, not an unrelated service. Use a private
  instance/profile with isolated data; never drive a shared session or production.
- **Drive:** a small map of key flows with actual routes, accessible controls,
  inputs, expected outcomes, and relevant side effects.
- **Checks:** real required CI commands and focused checks by affected surface.
- **Evidence:** actions/results and artifacts tied to candidate identity; matched
  base/head conditions for comparisons.
- **Cleanup:** stop only owned processes and remove only owned temporary state.

Distinguish mock, local integration, and production verification. A mock cannot
prove durable storage, authorization, or remote integration. Keep credentials,
browser state, and personal screenshots out of this repo.

Execute once from a cold start in an isolated checkout where possible. Fix wrong
instructions. Report each flow as observed, failed, or unverified. Structural
validation does not establish runtime validity. A blocked environment can leave a
grounded recipe explicitly INCONCLUSIVE until required flows can run. Do not
create a fictional ready-to-run recipe.
