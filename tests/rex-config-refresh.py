"""Run from the repository root: python3 tests/rex-config-refresh.py."""
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import time
import unittest


REX = shutil.which("rex") or "/Applications/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS/rex"


@unittest.skipUnless(Path(REX).is_file(), "Rex CLI is not installed")
class ConfigRefreshTest(unittest.TestCase):
    def test_snapshot_changes_invalidate_the_apps_cached_keymap(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            config = root / "config"
            shutil.copytree("home/.config/rex", config)
            cache = root / "cache/rex"
            cache.mkdir(parents=True)
            projects = cache / "project-actions.lua"
            sessions = cache / "session-actions.lua"
            projects.write_text("return {server='', projects={{path='/tmp/alpha', label='alpha'}}}\n")
            sessions.write_text("return {{session_id='session:existing', label='before'}}\n")
            endpoint = "unix://" + str(root / "server.sock")
            home = root / "home"
            (home / ".dotfiles").mkdir(parents=True)
            (home / "code/background-only").mkdir(parents=True)
            env = {**os.environ, "HOME": str(home), "XDG_CACHE_HOME": str(root / "cache")}
            with (root / "server.log").open("w+") as log:
                server = subprocess.Popen(
                    [REX, "server", "run", "--listen", endpoint, "--config", str(config / "init.lua"),
                     "--state-dir", str(root / "state"), "--restore=false"],
                    env=env, stdout=log, stderr=log,
                )
                try:
                    def call(*args):
                        result = subprocess.run(
                            [REX, "--autostart=false", "--timeout", "1s", "-S", endpoint, *args, *(["--json"] if args[0] == "config" else [])],
                            env=env, capture_output=True, text=True, timeout=3,
                        )
                        self.assertEqual(result.returncode, 0, result.stderr)
                        return json.loads(result.stdout)

                    for _ in range(100):
                        if (root / "server.sock").exists() or server.poll() is not None:
                            break
                        time.sleep(0.05)
                    self.assertIsNone(server.poll(), "isolated Rex server did not start")
                    before = call("api", "call", "server.status")["config"]["hash"]
                    for snapshot, content in [
                        (projects, "return {server='remote', projects={{path='/home/remote/beta', label='beta'}}}\n"),
                        (sessions, "return {{session_id='session:new', label='after'}}\n"),
                    ]:
                        snapshot.write_text(content)
                        result = call("config", "reload")
                        self.assertFalse(result["diagnostics"])
                        after = call("api", "call", "server.status")["config"]["hash"]
                        self.assertNotEqual(before, after, f"{snapshot.name} changed but Rex would keep the old palette")
                        before = after
                    request = {"token": str(root / "refresh-stage"), "client_id": "client:app"}
                    (cache / "palette-request").write_text(request["token"])
                    refreshed = subprocess.run(
                        [REX, "--autostart=false", "-S", endpoint, "do", str(config / "refresh-palette.lua"),
                         "--args", json.dumps(request)],
                        env=env, capture_output=True, text=True, timeout=5,
                    )
                    self.assertEqual(refreshed.returncode, 0, refreshed.stderr)
                    keymap = call("api", "call", "client.keymap", '{"server_actions":"configured"}')
                    titles = {action["title"] for action in keymap["actions"]}
                    self.assertIn("Open Project: background-only", titles)
                    self.assertNotIn("Open Project: beta", titles)
                    self.assertFalse(Path(request["token"]).exists(), "worker should remove its staging directory")
                finally:
                    server.terminate()
                    server.wait(timeout=5)


if __name__ == "__main__":
    unittest.main()
