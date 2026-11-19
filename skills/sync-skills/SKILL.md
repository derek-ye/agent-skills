---
name: sync-skills
description: Bring Derek's local skill repos up to date with origin/main, reconcile skills that diverged locally (keep everything, newest wins on conflict), and make sure every skill is linked into ~/.claude/skills and ~/.agents/skills and callable. Use when asked to sync, update, pull, link, or audit installed skills. Not for writing or changing what a skill does.
---

# Sync skills

Goal: every skill repo matches origin/main, no local work is lost, and every
skill in every repo is linked for Claude Code (`~/.claude/skills`) and Codex
(`~/.agents/skills`).

Clients only find skills one level deep (`<dest>/<name>/SKILL.md`), so each
skill needs its own symlink; linking a whole repo folder does not work.

## 1. Survey

Run `scripts/sync.sh` (read-only). It finds the repos from the existing links
(pass other repo paths as arguments), fetches, and prints per repo: branch,
ahead/behind origin/main, uncommitted or untracked files; per skill: name
mismatches and link state (`MISSING`, `POINTS-ELSEWHERE`, `PLAIN-DIR`); and
broken links.

## 2. Bring each repo up to date

- Behind, clean: `git pull --ff-only`.
- Untracked or modified skill files that also exist on origin: back each one
  up to the scratchpad, then compare with `git show origin/main:<path>`.
  Identical → delete the local copy. Different → reconcile (below).
- Local commits not on origin: rebase onto origin/main and push.
- If a hook blocks edits in the main checkout, edit in a worktree
  (`git worktree add ../<repo>-<branch> -b <branch>`), push that branch to
  `origin main`, fast-forward the main checkout, remove the worktree.

### Reconciling a diverged skill

Keep everything. Merge both versions into one file: keep every rule, section
and example unique to either side; drop only exact duplicates. When the two
contradict, the newer one wins (compare the local file's mtime with the
origin commit date) and the merged file keeps the loser's how-to detail if it
still applies. Keep the result in the style of the repo's other skills.

Commit with the conflicts named in the message, push to `origin main`, and
keep the backup path for the report.

## 3. Link

Run `scripts/sync.sh --link`. It adds only missing links and never replaces
anything. Then handle what it reports:

- `POINTS-ELSEWHERE`: a link to an old path or another repo. Repoint it only if
  the old target is gone or identical; otherwise report it.
- `PLAIN-DIR`: a real folder shadows the repo skill. Don't delete it; diff it
  against the repo and report.
- `BROKEN`: remove the link if its skill was deleted on purpose (check git
  log); otherwise report it.
- `NAME-MISMATCH`: the frontmatter `name` must equal the folder name or the
  skill won't load under that name. Report it; fix only if asked.

## 4. Verify

Run `scripts/sync.sh` again. Done when every repo shows `ahead=0 behind=0` with
no `DIRTY` lines (except work the user owns and asked to keep), and no
`MISSING` or `BROKEN` lines remain. New links appear only in a new session; say
so rather than claiming the skills are callable now.

## Report

One line per repo (commit SHA it now matches), each reconciled skill with what
each side contributed and how conflicts went, backups, links added, and
anything left for the user (`PLAIN-DIR`, `POINTS-ELSEWHERE`, mismatches).
