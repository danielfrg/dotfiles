"""Container boundary tests: missing tools, wrong identity, and hidden runtime PATH."""
import json
import os
import subprocess
import unittest


IMAGE = os.environ.get("DEV_IMAGE", "daniel-dev:test")


def container(*args, timeout=180):
    return subprocess.run(
        ["docker", "run", "--rm", "--platform", "linux/amd64", "--entrypoint", args[0], IMAGE, *args[1:]],
        capture_output=True, text=True, timeout=timeout,
    )


class ImageTests(unittest.TestCase):
    def run_ok(self, *args, timeout=180):
        result = container(*args, timeout=timeout)
        self.assertEqual(result.returncode, 0, (result.stdout + result.stderr)[-3000:])
        return result.stdout.strip()

    def test_runtime_identity(self):
        result = json.loads(self.run_ok("python3", "-c", "import os,pwd,json; p=pwd.getpwuid(os.getuid()); print(json.dumps([os.getuid(),os.getgid(),os.environ['HOME'],p.pw_shell]))"))
        self.assertEqual(result, [1000, 1000, "/home/danielfrg", "/bin/zsh"])

    def test_required_tools_on_noninteractive_path(self):
        tools = "node pnpm go uv uvx opencode git git-lfs gh just bun pre-commit gcc g++ make cmake ninja pkg-config kubectl helm argocd terraform ansible-playbook ssh jq yq rg fd curl wget rsync dig ip sqlite3 psql yamlfmt zsh starship fzf zoxide bat eza tmux nvim ffmpeg".split()
        script = "import shutil,sys; missing=[t for t in sys.argv[1:] if not shutil.which(t)]; print(missing); sys.exit(bool(missing))"
        self.assertEqual(self.run_ok("python3", "-c", script, *tools), "[]")

    def test_language_versions(self):
        self.assertTrue(self.run_ok("node", "--version").startswith("v26."))
        self.assertTrue(self.run_ok("pnpm", "--version").startswith("10."))
        self.assertIn("go1.25.", self.run_ok("go", "version"))
        self.assertRegex(self.run_ok("opencode", "--version"), r"^(?:opencode v)?2\.")

    def test_managed_python_and_user_installs(self):
        script = "uv python install 3.12 3.13 && uv run --python 3.12 --no-project python -c 'import sys; assert sys.version_info[:2] == (3,12)' && uv run --python 3.13 --no-project python -c 'import sys; assert sys.version_info[:2] == (3,13)'"
        self.run_ok("/bin/sh", "-c", script, timeout=600)

    def test_excluded_tools(self):
        script = "import shutil; assert not any(shutil.which(t) for t in ['vp','nvcc','sshd','rex','dockerd']); print('ok')"
        self.assertEqual(self.run_ok("python3", "-c", script), "ok")


if __name__ == "__main__":
    unittest.main()
