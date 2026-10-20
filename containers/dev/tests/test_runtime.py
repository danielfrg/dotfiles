"""Real bootstrap/backup filesystem tests and authenticated container lifecycle."""
import base64
from contextlib import closing
import json
import os
from pathlib import Path
import sqlite3
import subprocess
import tempfile
import time
import unittest
import urllib.error
import urllib.request
import uuid

ROOT = Path(__file__).resolve().parents[1]
ENTRYPOINT = ROOT / "bin/dev-entrypoint"
IMAGE = os.environ.get("DEV_IMAGE", "daniel-dev:test")


class RuntimeTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name) / "home"
        self.home.mkdir()
        self.env = {**os.environ, "HOME": str(self.home), "DEV_PROFILE_DIR": str(ROOT / "profile")}
        for key in ["OPENCODE_DB", "XDG_CONFIG_HOME", "XDG_STATE_HOME", "XDG_DATA_HOME"]:
            self.env.pop(key, None)

    def launch(self, mode):
        self.assertTrue(ENTRYPOINT.is_file(), "dev-entrypoint is not implemented")
        return subprocess.run(["python3", str(ENTRYPOINT), mode], env=self.env, capture_output=True, text=True)

    def bootstrap(self):
        result = self.launch("bootstrap")
        self.assertEqual(result.returncode, 0, result.stderr)

    def database(self):
        self.bootstrap()
        db = self.home / ".local/share/opencode/opencode.db"
        with closing(sqlite3.connect(db)) as connection:
            connection.execute("PRAGMA journal_mode=WAL")
            connection.execute("CREATE TABLE sentinel(value TEXT)")
            connection.execute("INSERT INTO sentinel VALUES ('uncommitted-work-is-valuable')")
            connection.commit()
        return db

    def test_empty_home_bootstrap(self):
        self.bootstrap()
        for owner in ["danielfrg", "inmatura", "nvidia"]:
            self.assertTrue((self.home / "code" / owner).is_dir())
        self.assertTrue((self.home / ".zshrc").is_file())
        config = json.loads((self.home / ".config/opencode/opencode.json").read_text())
        self.assertEqual(config["shell"], "/bin/zsh")
        self.assertEqual(config["update"], "disable")

    def test_existing_home_preserved(self):
        (self.home / ".zshrc").write_text("# user customization\n")
        self.bootstrap()
        self.assertEqual((self.home / ".zshrc").read_text(), "# user customization\n")

    def test_existing_jsonc_configuration_does_not_get_shadowed(self):
        directory = self.home / ".config/opencode"
        directory.mkdir(parents=True)
        config = directory / "opencode.jsonc"
        content = '// user preferences\n{"shell":"/bin/bash","update":"notify"}\n'
        config.write_text(content)
        self.bootstrap()
        self.assertEqual(config.read_text(), content)
        self.assertFalse((directory / "opencode.json").exists())

    def test_bootstrap_idempotent(self):
        self.bootstrap()
        config = self.home / ".config/opencode/opencode.json"
        original = config.stat().st_mtime_ns
        self.bootstrap()
        self.assertEqual(config.stat().st_mtime_ns, original)

    def test_unusable_home_fails(self):
        self.env["HOME"] = str(self.home / "not-a-directory")
        Path(self.env["HOME"]).write_text("do not delete")
        self.assertNotEqual(self.launch("bootstrap").returncode, 0)
        self.assertEqual(Path(self.env["HOME"]).read_text(), "do not delete")

    def test_database_path_not_relocated(self):
        self.env["OPENCODE_DB"] = str(Path(self.temp.name) / "elsewhere.db")
        self.assertNotEqual(self.launch("bootstrap").returncode, 0)
        self.assertFalse(Path(self.env["OPENCODE_DB"]).exists())

    def test_retained_service_environment_cannot_relocate_persistence(self):
        configdir = self.home / ".config/opencode"
        configdir.mkdir(parents=True)
        file = configdir / "service.json"
        for key, value in [("OPENCODE_DB", "/tmp/disposable.db"), ("XDG_DATA_HOME", "/tmp/disposable-data"), ("HOME", "/tmp/disposable-home")]:
            content = json.dumps({"env": {key:value}})
            file.write_text(content)
            self.assertNotEqual(self.launch("bootstrap").returncode, 0, key + " was accepted")
            self.assertEqual(file.read_text(), content)

    def test_retained_remote_access_is_refused_without_rewriting_config(self):
        configdir = self.home / ".config/opencode"
        configdir.mkdir(parents=True)
        file = configdir / "service.json"
        for remote in [{"route":"synthetic-unused-route"}, True]:
            content = json.dumps({"remote":remote})
            file.write_text(content)
            self.assertNotEqual(self.launch("bootstrap").returncode, 0)
            self.assertEqual(file.read_text(), content)

    def test_health_does_not_start_missing_server(self):
        self.bootstrap()
        result = self.launch("health")
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse((self.home / ".local/state/opencode/service.json").exists())
        self.assertFalse((self.home / ".local/share/opencode/opencode.db").exists())

    def test_existing_git_identity_is_preserved_and_helper_is_added(self):
        gitconfig = self.home / ".gitconfig"
        gitconfig.write_text('[user]\n name = Custom Name\n email = custom@example.invalid\n')
        self.bootstrap()
        def value(key):
            result = subprocess.run(["git", "config", "--file", str(gitconfig), "--get", key], capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, "missing Git setting: " + key)
            return result.stdout.strip()
        self.assertEqual(value("user.name"), "Custom Name")
        self.assertEqual(value("user.email"), "custom@example.invalid")
        self.assertEqual(value("credential.helper"), "/usr/local/bin/git-credential-workspace")
        self.assertEqual(value("credential.useHttpPath"), "true")

    def test_included_git_identity_and_helper_chain_are_preserved(self):
        included = self.home / "identity.gitconfig"
        included.write_text('[user]\n name = Included User\n email = included@example.invalid\n[credential]\n helper = custom-helper\n')
        (self.home / ".gitconfig").write_text('[include]\n path = ~/identity.gitconfig\n')
        self.bootstrap()
        def value(key):
            return subprocess.check_output(["git", "config", "--global", "--includes", "--get-all", key], env=self.env, text=True).strip()
        self.assertEqual(value("user.name"), "Included User")
        self.assertEqual(value("user.email"), "included@example.invalid")
        self.assertEqual(value("credential.helper"), "custom-helper")

    def test_xdg_git_configuration_is_preserved(self):
        directory = self.home / ".config/git"
        directory.mkdir(parents=True)
        (directory / "config").write_text('[user]\n name = XDG User\n email = xdg@example.invalid\n[credential]\n helper = xdg-helper\n')
        self.bootstrap()
        name = subprocess.check_output(["git", "config", "--includes", "--get", "user.name"], env=self.env, text=True).strip()
        self.assertEqual(name, "XDG User")

    def test_conditional_git_identity_is_not_overridden(self):
        repository = self.home / "code/nvidia/example"
        repository.mkdir(parents=True)
        subprocess.run(["git", "init", "--quiet", str(repository)], check=True)
        included = self.home / "work.gitconfig"
        included.write_text('[user]\n name = Work User\n email = work@example.invalid\n[credential]\n helper = work-helper\n')
        (self.home / ".gitconfig").write_text(f'[includeIf "gitdir:{self.home.resolve()}/code/nvidia/"]\n path = ~/work.gitconfig\n')
        self.bootstrap()
        name = subprocess.check_output(["git", "-C", str(repository), "config", "--get", "user.name"], env=self.env, text=True).strip()
        self.assertEqual(name, "Work User")

    def test_backup_restores_integrity(self):
        self.database()
        result = self.launch("backup")
        self.assertEqual(result.returncode, 0, result.stderr)
        artifacts = list((self.home / ".local/share/opencode/backups").glob("backup-*.sqlite3"))
        self.assertEqual(len(artifacts), 1)
        self.assertEqual(artifacts[0].stat().st_mode & 0o777, 0o600)
        with closing(sqlite3.connect(artifacts[0])) as connection:
            self.assertEqual(connection.execute("PRAGMA integrity_check").fetchone(), ("ok",))
            self.assertEqual(connection.execute("SELECT value FROM sentinel").fetchone(), ("uncommitted-work-is-valuable",))

    def test_backup_failure_leaves_database_and_previous_backups(self):
        db = self.database()
        self.assertEqual(self.launch("backup").returncode, 0)
        backups = self.home / ".local/share/opencode/backups"
        previous = {p.name: p.read_bytes() for p in backups.iterdir()}
        db.write_bytes(b"not a valid database")
        self.assertNotEqual(self.launch("backup").returncode, 0)
        self.assertEqual(db.read_bytes(), b"not a valid database")
        self.assertEqual({p.name: p.read_bytes() for p in backups.iterdir()}, previous)

    def test_database_backup_retention(self):
        self.database()
        backups = self.home / ".local/share/opencode/backups"
        backups.mkdir()
        (backups / "notes.txt").write_text("keep unrelated files")
        for _ in range(9):
            result = self.launch("backup")
            self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(len(list(backups.glob("backup-*.sqlite3"))), 7)
        self.assertEqual((backups / "notes.txt").read_text(), "keep unrelated files")


class ServerTests(unittest.TestCase):
    def test_abrupt_termination_replacement_recovers_existing_home(self):
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp) / "home"
            home.mkdir(mode=0o777)
            home.chmod(0o777)
            secrets = Path(temp) / "secrets"
            secrets.mkdir(mode=0o755)
            password = "synthetic-restart-password"
            (secrets / "server-password").write_text(password)
            names = ["dev-restart-" + uuid.uuid4().hex for _ in range(2)]
            def start_and_wait(name):
                command = ["docker", "run", "-d", "--name", name, "--platform", "linux/amd64", "-p", "127.0.0.1::4096", "-v", f"{home}:/home/danielfrg", "-v", f"{secrets}:/run/secrets/opencode-runtime:ro", IMAGE, "serve"]
                started = subprocess.run(command, capture_output=True, text=True)
                self.assertEqual(started.returncode, 0, started.stderr)
                port = subprocess.check_output(["docker", "port", name, "4096/tcp"], text=True).strip().rsplit(":", 1)[1]
                request = urllib.request.Request(f"http://127.0.0.1:{port}/api/info", headers={"Authorization":"Basic " + base64.b64encode(f"opencode:{password}".encode()).decode()})
                deadline = time.monotonic() + 60
                while time.monotonic() < deadline:
                    try:
                        with urllib.request.urlopen(request, timeout=2) as response:
                            self.assertEqual(response.status, 200)
                        return
                    except OSError as error:
                        if isinstance(error, urllib.error.HTTPError):
                            error.close()
                        state = json.loads(subprocess.check_output(["docker", "inspect", name, "--format", "{{json .State}}"], text=True))
                        self.assertTrue(state["Running"], f"Replacement/startup exited {state['ExitCode']}")
                        time.sleep(0.25)
                self.fail("Replacement did not become healthy")
            try:
                start_and_wait(names[0])
                sentinel = home / "code/danielfrg/uncommitted-sentinel"
                sentinel.write_text("retain this work")
                subprocess.run(["docker", "kill", "--signal", "KILL", names[0]], check=True, capture_output=True)
                self.assertTrue((home / ".local/state/opencode/service.json").exists())
                start_and_wait(names[1])
                self.assertEqual(sentinel.read_text(), "retain this work")
                with closing(sqlite3.connect(home / ".local/share/opencode/opencode.db")) as database:
                    self.assertEqual(database.execute("PRAGMA integrity_check").fetchone(), ("ok",))
            finally:
                subprocess.run(["docker", "rm", "-f", *names], capture_output=True)

    def test_zsh_profile_startup_navigation_and_tools(self):
        script = "dev-entrypoint bootstrap && zsh -ic 'cdc; [[ $PWD == $HOME/code ]] && whence starship kubectl uv node >/dev/null && print profile-ok'"
        result = subprocess.run(["docker", "run", "--rm", "--platform", "linux/amd64", "--entrypoint", "sh", IMAGE, "-c", script], capture_output=True, text=True, timeout=30)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("profile-ok", result.stdout)

    def test_foreground_server_and_auth_and_signal_shutdown(self):
        self.assertTrue(ENTRYPOINT.is_file(), "dev-entrypoint is not implemented")
        with tempfile.TemporaryDirectory() as temp:
            home = Path(temp) / "home"
            home.mkdir(mode=0o777)
            home.chmod(0o777)
            secrets = Path(temp) / "secrets"
            secrets.mkdir(mode=0o755)
            password = "synthetic-test-password-only"
            (secrets / "server-password").write_text(password)
            name = "dev-test-" + uuid.uuid4().hex
            command = ["docker", "run", "-d", "--name", name, "--platform", "linux/amd64", "-p", "127.0.0.1::4096", "-v", f"{home}:/home/danielfrg", "-v", f"{secrets}:/run/secrets/opencode-runtime:ro", IMAGE, "serve"]
            started = subprocess.run(command, capture_output=True, text=True)
            self.assertEqual(started.returncode, 0, started.stderr)
            try:
                port = subprocess.check_output(["docker", "port", name, "4096/tcp"], text=True).strip().rsplit(":", 1)[1]
                url = f"http://127.0.0.1:{port}/api/info"
                header = "Basic " + base64.b64encode(f"opencode:{password}".encode()).decode()
                deadline = time.monotonic() + 90
                while True:
                    try:
                        with urllib.request.urlopen(urllib.request.Request(url, headers={"Authorization": header}), timeout=3) as response:
                            info = json.load(response)
                        break
                    except (OSError, urllib.error.URLError) as error:
                        if isinstance(error, urllib.error.HTTPError):
                            error.close()
                        if time.monotonic() >= deadline:
                            logs = subprocess.check_output(["docker", "logs", name], stderr=subprocess.STDOUT, text=True)
                            self.assertNotIn(password, logs, "server logs leaked its password")
                            self.fail("Server did not become healthy: " + logs[-2500:])
                        time.sleep(0.5)
                self.assertIsInstance(info, dict)
                with self.assertRaises(urllib.error.HTTPError) as error:
                    urllib.request.urlopen(url)
                self.assertEqual(error.exception.code, 401)
                error.exception.close()
                health = subprocess.run(["docker", "exec", name, "dev-entrypoint", "health"], capture_output=True, text=True)
                self.assertEqual(health.returncode, 0, health.stderr)
                pairing = subprocess.run(["docker", "exec", name, "opencode", "pair", "--url", f"http://127.0.0.1:{port}"], capture_output=True, text=True, timeout=30)
                self.assertEqual(pairing.returncode, 0, pairing.stderr)
                self.assertIn("/auth/connect/", pairing.stdout)
                logs = subprocess.check_output(["docker", "logs", name], stderr=subprocess.STDOUT, text=True)
                self.assertNotIn(password, logs)
                self.assertTrue((home / ".local/share/opencode/opencode.db").is_file())
                subprocess.run(["docker", "stop", "--time", "15", name], check=True, capture_output=True)
                state = json.loads(subprocess.check_output(["docker", "inspect", name, "--format", "{{json .State}}"], text=True))
                self.assertFalse(state["Running"])
                self.assertNotEqual(state["ExitCode"], 137, "SIGTERM required forced SIGKILL")
            finally:
                subprocess.run(["docker", "rm", "-f", name], capture_output=True)


if __name__ == "__main__":
    unittest.main()
