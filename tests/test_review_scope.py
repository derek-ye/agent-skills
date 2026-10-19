import importlib.util
from pathlib import Path
import subprocess
import tempfile
import unittest

spec = importlib.util.spec_from_file_location(
    "review_scope", Path(__file__).resolve().parents[1] / "skills/dev-workflow/scripts/review_scope.py"
)
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)


class ReviewScopeTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.repo = Path(self.temp.name)
        self.git("init", "-b", "main")
        self.git("config", "user.email", "fixture@example.invalid")
        self.git("config", "user.name", "Fixture")
        (self.repo / "kept.txt").write_text("original\n")
        (self.repo / "obsolete.txt").write_text("old contract\n")
        self.git("add", ".")
        self.git("commit", "-m", "baseline")
        self.git("checkout", "-b", "feature")

    def git(self, *args):
        return subprocess.check_output(["git", "-C", str(self.repo), *args], stderr=subprocess.PIPE)

    def test_committed_deletion_is_reviewed_with_clean_worktree(self):
        (self.repo / "obsolete.txt").unlink()
        self.git("add", "-u")
        self.git("commit", "-m", "remove contract")
        self.assertEqual(self.git("diff"), b"")
        result = module.scope(self.repo, "main")
        self.assertEqual(result["files"], [{"status": "D", "path": "obsolete.txt"}])
        self.assertEqual(result["status_porcelain"], [])

    def test_staged_unstaged_and_untracked_changes_invalidate_evidence(self):
        first = module.scope(self.repo, "main")
        (self.repo / "kept.txt").write_text("staged\n")
        self.git("add", "kept.txt")
        staged = module.scope(self.repo, "main")
        (self.repo / "kept.txt").write_text("working\n")
        working = module.scope(self.repo, "main")
        (self.repo / "new name.bin").write_bytes(b"\0new\xff")
        new = module.scope(self.repo, "main")
        self.assertEqual(len({r["candidate_fingerprint"] for r in [first, staged, working, new]}), 4)
        self.assertIn({"status": "?", "path": "new name.bin"}, new["files"])
        (self.repo / "new name.bin").write_bytes(b"\0changed\xff")
        self.assertNotEqual(module.scope(self.repo, "main")["candidate_fingerprint"], new["candidate_fingerprint"])

    def test_rename_preserves_both_paths_and_untracked_symlink_is_not_followed(self):
        self.git("mv", "obsolete.txt", "renamed.txt")
        outside = self.repo.parent / (self.repo.name + "-outside")
        outside.write_text("do not read external content")
        self.addCleanup(outside.unlink)
        (self.repo / "link").symlink_to(outside)
        before = module.scope(self.repo, "main")
        self.assertIn({"status": "D", "path": "obsolete.txt"}, before["files"])
        self.assertIn({"status": "A", "path": "renamed.txt"}, before["files"])
        outside.write_text("different external content")
        self.assertEqual(module.scope(self.repo, "main")["candidate_fingerprint"], before["candidate_fingerprint"])

    def test_target_advance_does_not_include_unmerged_target_changes(self):
        base = module.scope(self.repo, "main")["base"]
        self.git("checkout", "main")
        (self.repo / "target-only.txt").write_text("unrelated\n")
        self.git("add", ".")
        self.git("commit", "-m", "target advanced")
        self.git("checkout", "feature")
        result = module.scope(self.repo, "main")
        self.assertEqual(result["base"], base)
        self.assertEqual(result["files"], [])
        self.assertNotEqual(result["target"], result["base"])

    def test_index_change_is_not_hidden_by_restored_worktree(self):
        (self.repo / "kept.txt").write_text("staged change\n")
        self.git("add", "kept.txt")
        (self.repo / "kept.txt").write_text("original\n")
        self.assertEqual(self.git("diff", "main"), b"")
        self.assertIn({"status": "M", "path": "kept.txt"}, module.scope(self.repo, "main")["files"])

    def test_missing_target_fails_instead_of_assuming_master(self):
        with self.assertRaises(ValueError):
            module.scope(self.repo)


if __name__ == "__main__":
    unittest.main()
