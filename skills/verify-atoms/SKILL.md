---
name: verify-atoms
description: Verify Atoms changes with its actual CI commands and isolated browser flows for capture, editing, scheduling, completion, Undo, and search. Distinguishes in-memory demo behavior from backend integration.
---

# Verify Atoms

## Locate and scope

Use the requested Atoms checkout (Derek's current path is
`/home/derek/dev/atoms`), not this skills repo. Read its instructions and current
configuration before applying this recipe. Grounded in Atoms commit
`f12e8119ee9c33b4e8e58f224798726decaa10f8`; behavior can drift.

Record checkout, target/base SHA, candidate HEAD/worktree fingerprint, app URL,
data mode, and selected flows. For before/after claims use isolated base and
candidate checkouts, separate ports, the same browser settings and inputs, and
comparable clock/timezone. Relative dates and seed data depend on current time.

## Launch and doctor

From an isolated Atoms checkout:

```sh
npm ci
npm run dev:mock -- --host 127.0.0.1 --port 4317 --strictPort
```

Use a different explicit port for the baseline. `--strictPort` prevents silently
switching to an unrelated instance. Record the process/session you started. Wait
for Vite's ready message, then check `/inbox` renders the Inbox heading and New
task button without an error overlay. An HTTP response alone is not readiness. For this Vite preview the smoke driver
waits for initial network idle before its first interaction, then asserts the
editor actually opens; SSR controls can appear before hydration attaches events.
Do not use arbitrary sleeps or blindly retry capture clicks (which can duplicate tasks).
Confirm the server's working directory/build matches the candidate. Do not stop
an existing port owner; choose another port instead. Use a fresh browser context.

This workspace is currently `DemoProvider` in `src/lib/DemoStore.tsx`, seeded by
`src/domain/Seed.ts`. Edits survive client navigation but reset on full reload.
The dev:mock command sets VITE_DATA_MODE, but that variable alone does not prove
which provider is active; inspect the current route/provider wiring.

Do not run `convex dev` against an unknown deployment. The repository contains
backend auth code/tests, but the demonstrated demo path cannot prove live auth,
account isolation, backend writes, or durable/offline storage. For backend changes,
inspect the actual integration and use an explicitly isolated configured test
backend. Otherwise report that part INCONCLUSIVE; never invent a login flow.

## Required checks

CI (`.github/workflows/check.yml`) uses Node 24 and runs:

```sh
npm run check
npm run build
```

`check` runs lint, format:check, typecheck, and all tests. Focused diagnosis can
use `npm test -- src/domain/Commands.test.ts`, `src/domain/Ordering.test.ts`, or
`convex/auth.test.ts` as appropriate, without substituting for required CI checks.
Build generates framework artifacts; inspect resulting git changes. Do not hand
edit `src/routeTree.gen.ts` or `convex/_generated/*` to silence errors. Discover the
owning generation command/environment if a change actually requires regeneration.

## Drive and observe

Use an available browser driver, preferably an established project harness.
There is no checked-in browser harness in the inspected Atoms revision. The
[smoke driver](scripts/smoke.mjs) uses Playwright when available; otherwise follow
these same flows with the runtime's browser tool. Never call browser checks passed
because the tool is absent.

| Flow | Actions through the UI | Expected result |
| --- | --- | --- |
| Capture/edit | `/inbox`, New task, fill Task title and Task notes, press Enter in title; double-click Edit <title>, change notes, Done | One task with the submitted title; reopening shows the edited notes |
| Schedule/navigation | Edit that task, When, Today, Done; click Workspace navigation's Today link | Task appears in Today; editing/reopening preserves title/notes within the session |
| Completion/Undo | Mark <title> complete; press toast Undo | Task disappears from Today when completed, then returns unchecked; it is no longer in Logbook after Undo |
| Search | Search tasks button, fill Search tasks textbox with the unique title; use an impossible query, then Escape | Match shown, impossible query has no task rows, Escape restores the view |
| Reset boundary | Reload after creating the unique task | Test-created task disappears because the demo resets; do not call this a persistence regression |
| Mobile/UI | Fresh 390x844 context, `/today`, Open navigation, Inbox | Navigation works; inspect screenshot for clipping/overlap, keyboard focus and affected states as relevant |

Scope rows with `data-task-id` if necessary. Controls have role/accessible names;
avoid coordinate clicks and implementation setters. Compact task editing uses
double-click, keyboard Enter on the edit button, or touch. Click sidebar links
for in-session navigation: `page.goto` reloads and resets demo state.

The driver covers the first five rows; mobile and visual quality require an
additional browser pass when relevant. For project/area, deadline, history,
ordering, auth, or other changes, add focused flows from the affected code rather
than treating this smoke set as exhaustive coverage. Do not run every flow for an
unrelated prose-only change; report selected checks and their limits.

## Evidence and cleanup

With a runtime-provided Playwright module:

```sh
PLAYWRIGHT_MODULE=/absolute/path/to/playwright/index.mjs \
  node <this-skill>/scripts/smoke.mjs http://127.0.0.1:4317 /tmp/atoms-evidence
```

If Playwright resolves normally, omit PLAYWRIGHT_MODULE. A supported browser must
already be installed; discover the runtime/browser dependency rather than assuming
a download happened. The driver only accepts loopback URLs and uses a fresh
context. Run it only against the instance you own. It writes action/results JSON,
a screenshot, and trace; it exits 0 for covered flows passing, 1 for failure, and
2 for unavailable prerequisites. It does not run CI or establish a whole-PR PASS.

Attach scope identity and check exit results to those artifacts. Inspect relevant
screenshots; screenshots alone do not prove state transitions. Keep traces and
screenshots private/local unless publication is authorized. Stop only the owned
server session, close the owned browser context, and remove only your scratch
state. No production deployment is required for this recipe.
