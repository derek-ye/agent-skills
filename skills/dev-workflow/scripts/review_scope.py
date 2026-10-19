#!/usr/bin/env python3
"""Describe the full candidate relative to its target without changing files."""

import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys


def git(repo, *args):
    return subprocess.check_output(["git", "-C", str(repo), *args], stderr=subprocess.PIPE)


def scope(repo, base=None):
    repo = Path(git(repo, "rev-parse", "--show-toplevel").decode().strip())
    if base is None:
        try:
            base = git(repo, "symbolic-ref", "refs/remotes/origin/HEAD").decode().strip()
        except subprocess.CalledProcessError:
            raise ValueError("Pass --base from the PR target; origin/HEAD is unavailable.")
    target = git(repo, "rev-parse", "--verify", f"{base}^{{commit}}").decode().strip()
    merge_base = git(repo, "merge-base", target, "HEAD").decode().strip()
    head = git(repo, "rev-parse", "HEAD").decode().strip()
    # Include index-only changes even when the worktree cancels the staged patch.
    paths = {}
    for options in [[], ["--cached"]]:
        changed = git(repo, "diff", "--no-ext-diff", "--no-textconv", "--no-renames",
                      "--name-status", "-z", *options, merge_base, "--").split(b"\0")
        for i in range(0, len(changed) - 1, 2):
            path = changed[i + 1].decode()
            paths.setdefault(path, set()).add(changed[i].decode())
    files = [{"status": "/".join(sorted(statuses)), "path": path}
             for path, statuses in sorted(paths.items())]
    digest = hashlib.sha256()
    for label, data in [
        ("base", merge_base.encode()),
        ("head", head.encode()),
        ("index", git(repo, "diff", "--no-ext-diff", "--no-textconv", "--binary",
                      "--cached", merge_base, "--")),
        ("worktree", git(repo, "diff", "--no-ext-diff", "--no-textconv", "--binary", "--")),
    ]:
        digest.update(label.encode() + b"\0" + data + b"\0")
    untracked = git(repo, "ls-files", "--others", "--exclude-standard", "-z").split(b"\0")
    for raw in sorted(p for p in untracked if p):
        path = repo / raw.decode()
        data = str(path.readlink()).encode() if path.is_symlink() else path.read_bytes()
        digest.update(b"untracked\0" + raw + b"\0" + hashlib.sha256(data).digest())
        files.append({"status": "?", "path": raw.decode()})
    return {
        "repo": str(repo), "target": target, "base": merge_base, "head": head,
        "candidate_fingerprint": digest.hexdigest(), "files": files,
        "status_porcelain": git(repo, "status", "--porcelain=v1").decode().splitlines(),
        "note": "Renames appear as delete/add. Untracked content is fingerprinted, not printed. "
                "Inspect ignored/generated artifacts and submodule contents separately when relevant.",
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", default=".")
    parser.add_argument("--base", help="PR target branch/ref; defaults only to origin/HEAD")
    args = parser.parse_args()
    try:
        print(json.dumps(scope(args.repo, args.base), indent=2, ensure_ascii=True))
    except (subprocess.CalledProcessError, ValueError, OSError, UnicodeError) as exc:
        detail = exc.stderr.decode(errors="replace").strip() if isinstance(exc, subprocess.CalledProcessError) else str(exc)
        print(f"INCONCLUSIVE: cannot establish review scope: {detail}", file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
