"""Run from the repository root: python3 tests/rex-palette-open.py."""
import os
from pathlib import Path
import subprocess
import tempfile
import unittest


class PaletteOpenTest(unittest.TestCase):
    def test_reopens_palette_for_exact_client_without_starting_another_picker(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            rex = root / "rex"
            rex.write_text('#!/bin/sh\nprintf "%s\\n" "$@" >> "$REX_TEST_LOG"\n')
            rex.chmod(0o755)
            log = root / "calls"
            env = {**os.environ, "PATH": f"{root}:/usr/bin:/bin", "REX_TEST_LOG": str(log)}
            result = subprocess.run(
                ["/bin/zsh", "home/.local/scripts/project-session-rex.sh",
                 "--reopen-palette", "client:remote-window"],
                env=env, capture_output=True, text=True, timeout=5,
            )
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(log.read_text().splitlines(),
                             ["-C", "client:remote-window", "do", "client.palette.toggle"])


if __name__ == "__main__":
    unittest.main()
