"""Exercise real credential protocol routing with synthetic mounted tokens."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest

HELPER = Path(__file__).resolve().parents[1] / "bin/git-credential-workspace"


class CredentialTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.mapping = self.root / "map.json"
        self.mapping.write_text(json.dumps([
            {"host": "github.com", "path_prefix": "danielfrg/", "username": "x-access-token", "token_file": "github-danielfrg"},
            {"host": "github.com", "path_prefix": "inmatura/", "username": "x-access-token", "token_file": "github-inmatura"},
            {"host": "forgejo.corp.danielfrg.net", "path_prefix": "danielfrg/", "username": "danielfrg", "token_file": "forgejo-danielfrg"},
        ]))
        for filename, token in [("github-danielfrg", "synthetic-personal"), ("github-inmatura", "synthetic-business"), ("forgejo-danielfrg", "synthetic-forgejo")]:
            (self.root / filename).write_text(token)
        self.env = {**os.environ, "DEV_CREDENTIAL_MAP": str(self.mapping), "DEV_GIT_SECRET_DIR": str(self.root)}

    def get(self, host="github.com", path="danielfrg/repo.git", protocol="https", mode="get"):
        self.assertTrue(HELPER.is_file(), "credential helper is not implemented")
        return subprocess.run(["python3", str(HELPER), mode], input=f"protocol={protocol}\nhost={host}\npath={path}\n\n", env=self.env, capture_output=True, text=True)

    def test_github_owner_mapping(self):
        self.assertEqual(self.get().stdout, "username=x-access-token\npassword=synthetic-personal\n\n")
        self.assertEqual(self.get(path="inmatura/repo.git").stdout, "username=x-access-token\npassword=synthetic-business\n\n")

    def test_forgejo_mapping(self):
        self.assertEqual(self.get(host="forgejo.corp.danielfrg.net").stdout, "username=danielfrg\npassword=synthetic-forgejo\n\n")

    def test_unknown_host_returns_no_secret(self):
        result = self.get(host="github.com.attacker.invalid")
        self.assertEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")

    def test_owner_prefix_boundary(self):
        for path in ["danielfrg-evil/repo", "nvidia/repo", "danielfrg/../evil/repo"]:
            self.assertEqual(self.get(path=path).stdout, "")

    def test_plaintext_protocol_returns_no_secret(self):
        self.assertEqual(self.get(protocol="http").stdout, "")

    def test_missing_token_fails_without_disclosure(self):
        (self.root / "github-danielfrg").unlink()
        result = self.get()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")
        self.assertNotIn("synthetic", result.stderr)

    def test_rotated_file_is_reread(self):
        self.assertIn("synthetic-personal", self.get().stdout)
        replacement = self.root / "replacement"
        replacement.write_text("synthetic-rotated")
        replacement.replace(self.root / "github-danielfrg")
        self.assertEqual(self.get().stdout, "username=x-access-token\npassword=synthetic-rotated\n\n")

    def test_store_and_erase_do_not_write_tokens(self):
        before = {p.name: p.read_bytes() for p in self.root.iterdir()}
        for mode in ["store", "erase"]:
            self.assertEqual(self.get(mode=mode).stdout, "")
        self.assertEqual({p.name: p.read_bytes() for p in self.root.iterdir()}, before)

    def test_multiline_token_is_rejected(self):
        (self.root / "github-danielfrg").write_text("synthetic\npassword=injected")
        result = self.get()
        self.assertNotEqual(result.returncode, 0)
        self.assertEqual(result.stdout, "")


if __name__ == "__main__":
    unittest.main()
