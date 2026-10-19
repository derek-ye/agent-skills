import { mkdir, writeFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { pathToFileURL } from "node:url";

const base = new URL(process.argv[2] || "http://127.0.0.1:4317");
if (
  !["http:", "https:"].includes(base.protocol) ||
  !["127.0.0.1", "localhost", "[::1]"].includes(base.hostname)
) {
  console.error("INCONCLUSIVE: use an isolated loopback Atoms instance.");
  process.exit(2);
}
const artifacts = resolve(
  process.argv[3] || `/tmp/atoms-evidence-${Date.now()}`,
);
await mkdir(artifacts, { recursive: true });
let playwright;
let browser;
let expect;
try {
  const modulePath = process.env.PLAYWRIGHT_MODULE;
  playwright = await import(
    modulePath ? pathToFileURL(modulePath).href : "playwright"
  );
  ({ expect } = await import(
    modulePath
      ? pathToFileURL(resolve(dirname(modulePath), "test.mjs")).href
      : "playwright/test"
  ));
  browser = await playwright.chromium.launch({ headless: true });
} catch (error) {
  console.error(
    `INCONCLUSIVE: Playwright/browser unavailable: ${error.message}`,
  );
  process.exit(2);
}
try {
  const context = await browser.newContext({
    viewport: { width: 1280, height: 900 },
  });
  const page = await context.newPage();
  const title = `Verification task ${Date.now()}`;
  const steps = [];
  const errors = [];
  page.on("pageerror", (error) => errors.push(error.message));
  await context.tracing.start({ screenshots: true, snapshots: true });
  let exitCode = 0;
  try {
    await page.goto(new URL("/inbox", base).href);
    await page.waitForLoadState("networkidle");
    await expect(
      page.getByRole("heading", { name: "Inbox", exact: true }),
    ).toBeVisible();
    await page.getByRole("button", { name: "New task", exact: true }).click();
    await page
      .getByRole("textbox", { name: "Task title", exact: true })
      .fill(title);
    await page
      .getByRole("textbox", { name: "Task notes", exact: true })
      .fill("Initial verification note");
    await page
      .getByRole("textbox", { name: "Task title", exact: true })
      .press("Enter");
    const edit = () =>
      page.getByRole("button", { name: `Edit ${title}`, exact: true });
    await expect(edit()).toHaveCount(1);
    steps.push({
      flow: "capture",
      expected: "one submitted task",
      observed: title,
      outcome: "PASS",
    });
    await edit().dblclick();
    await expect(
      page.getByRole("textbox", { name: "Task notes", exact: true }),
    ).toHaveValue("Initial verification note");
    await page
      .getByRole("textbox", { name: "Task notes", exact: true })
      .fill("Edited verification note");
    await page.getByRole("button", { name: "When", exact: true }).click();
    await page.getByRole("button", { name: "Today", exact: true }).click();
    await page.getByRole("button", { name: "Done", exact: true }).click();
    await page
      .getByRole("navigation", { name: "Workspace", exact: true })
      .getByRole("link", { name: "Today", exact: true })
      .click();
    await expect(
      page.getByRole("heading", { name: "Today", exact: true }),
    ).toBeVisible();
    await edit().dblclick();
    await expect(
      page.getByRole("textbox", { name: "Task notes", exact: true }),
    ).toHaveValue("Edited verification note");
    await page.getByRole("button", { name: "Done", exact: true }).click();
    steps.push({
      flow: "edit-and-schedule",
      expected: "Today contains task and retains edited notes",
      outcome: "PASS",
    });
    await page
      .getByRole("checkbox", { name: `Mark ${title} complete`, exact: true })
      .click();
    await expect(edit()).toHaveCount(0);
    await page.getByRole("button", { name: "Undo", exact: true }).click();
    await expect(
      page.getByRole("checkbox", {
        name: `Mark ${title} complete`,
        exact: true,
      }),
    ).not.toBeChecked();
    await page
      .getByRole("navigation", { name: "Workspace", exact: true })
      .getByRole("link", { name: "Logbook", exact: true })
      .click();
    await expect(edit()).toHaveCount(0);
    await page
      .getByRole("navigation", { name: "Workspace", exact: true })
      .getByRole("link", { name: "Today", exact: true })
      .click();
    await expect(edit()).toHaveCount(1);
    steps.push({
      flow: "complete-and-undo",
      expected: "removed on completion, restored by Undo, absent in Logbook",
      outcome: "PASS",
    });
    await page
      .getByRole("button", { name: "Search tasks", exact: true })
      .click();
    const search = page.getByRole("textbox", {
      name: "Search tasks",
      exact: true,
    });
    await search.fill(title);
    await expect(edit()).toHaveCount(1);
    await expect(page.locator("[data-task-id]")).toHaveCount(1);
    await search.fill(`No match ${title}`);
    await expect(page.locator("[data-task-id]")).toHaveCount(0);
    await search.press("Escape");
    await expect(edit()).toHaveCount(1);
    steps.push({
      flow: "search",
      expected: "unique match, empty negative query, Escape restores view",
      outcome: "PASS",
    });
    await page.screenshot({
      path: resolve(artifacts, "before-reload.png"),
      fullPage: true,
    });
    await page.reload();
    await expect(
      page.getByRole("heading", { name: "Today", exact: true }),
    ).toBeVisible();
    await expect(edit()).toHaveCount(0);
    steps.push({
      flow: "demo-reset",
      expected: "new task absent after full reload",
      outcome: "PASS",
    });
    if (errors.length)
      throw new Error(`Browser page errors: ${errors.join("; ")}`);
  } catch (error) {
    exitCode = 1;
    steps.push({ outcome: "FAIL", error: error.message });
    await page
      .screenshot({ path: resolve(artifacts, "failure.png"), fullPage: true })
      .catch(() => {});
  } finally {
    await context.tracing.stop({ path: resolve(artifacts, "trace.zip") });
    await writeFile(
      resolve(artifacts, "results.json"),
      JSON.stringify(
        {
          outcome: exitCode ? "FAIL" : "PASS",
          url: base.href,
          title,
          steps,
          browserErrors: errors,
          limits:
            "Demo smoke only. CI, visual inspection, mobile, auth, backend and other flows are separate.",
        },
        null,
        2,
      ),
    );
  }
  console.log(
    `${exitCode ? "FAIL" : "PASS"}: Atoms demo smoke; evidence ${artifacts}`,
  );
  process.exitCode = exitCode;
} finally {
  await browser.close();
}
