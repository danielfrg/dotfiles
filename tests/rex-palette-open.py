"""Run from the repository root: python3 tests/rex-palette-open.py."""
import json
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


class PaletteRefreshHelperTest(unittest.TestCase):
    def test_worker_receives_literal_context_and_does_not_reopen_the_palette(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            rex = root / "rex"
            rex.write_text('#!/bin/sh\nprintf "%s\\n" "$@" >> "$REX_TEST_LOG"\n')
            rex.chmod(0o755)
            log = root / "calls"
            env = {**os.environ, "PATH": f"{root}:/usr/bin:/bin", "REX_TEST_LOG": str(log)}
            context = json.dumps({"server": "srv-nv-01", "client_id": "client:remote-window"})
            result = subprocess.run(
                ["/bin/zsh", "-f", "home/.local/scripts/project-session-rex.sh",
                 "--refresh-palette", context],
                env=env, capture_output=True, text=True, timeout=5,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(log.read_text().splitlines(),
                             ["do", str(Path.home() / ".config/rex/refresh-palette.lua"),
                              "--args", context])

    def test_missing_context_fails_without_running_a_picker_or_a_native_action(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            rex = root / "rex"
            rex.write_text('#!/bin/sh\nprintf "%s\\n" "$@" >> "$REX_TEST_LOG"\n')
            rex.chmod(0o755)
            log = root / "calls"
            env = {**os.environ, "PATH": f"{root}:/usr/bin:/bin", "REX_TEST_LOG": str(log)}
            result = subprocess.run(
                ["/bin/zsh", "-f", "home/.local/scripts/project-session-rex.sh", "--refresh-palette"],
                env=env, capture_output=True, text=True, timeout=5,
            )
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse(log.exists())


if __name__ == "__main__":
    unittest.main()
