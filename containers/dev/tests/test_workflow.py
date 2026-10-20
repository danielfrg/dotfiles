"""Publication boundaries: untrusted events cannot publish an untested rebuild."""
from pathlib import Path
import re
import unittest
import yaml

WORKFLOW = Path(__file__).resolve().parents[3] / ".github/workflows/dev-image.yml"


class WorkflowTests(unittest.TestCase):
    def workflow(self):
        self.assertTrue(WORKFLOW.is_file(), "publication workflow is not implemented")
        return yaml.safe_load(WORKFLOW.read_text())

    def test_pr_testing_and_tag_only_publication(self):
        workflow = self.workflow()
        self.assertIn("pull_request", workflow["on"])
        self.assertEqual(workflow["on"]["push"]["tags"], ["dev-v*"])
        publish = workflow["jobs"]["publish"]
        self.assertEqual(publish["needs"], "test")
        self.assertIn("github.event_name == 'push'", publish["if"])
        self.assertIn("startsWith(github.ref, 'refs/tags/dev-v')", publish["if"])

    def test_permissions_and_pinned_actions(self):
        workflow = self.workflow()
        self.assertEqual(workflow["permissions"], {"contents":"read"})
        self.assertNotIn("packages", workflow["jobs"]["test"].get("permissions", {}))
        self.assertEqual(workflow["jobs"]["publish"]["permissions"], {"contents":"read", "packages":"write"})
        for job in workflow["jobs"].values():
            self.assertEqual(job["runs-on"], "ubuntu-24.04")
            for step in job["steps"]:
                if "uses" in step:
                    self.assertRegex(step["uses"], r"@\w{40}$")
                    if step["uses"].startswith("actions/checkout@"):
                        self.assertFalse(step["with"]["persist-credentials"])

    def test_publishes_tested_image_without_rebuilding(self):
        jobs = self.workflow()["jobs"]
        test_steps = jobs["test"]["steps"]
        upload = next(s for s in test_steps if s.get("uses", "").startswith("actions/upload-artifact@"))
        self.assertEqual(upload["with"]["name"], "tested-dev-image")
        self.assertIn("refs/tags/dev-v", upload["if"])
        publish_steps = jobs["publish"]["steps"]
        download = next(s for s in publish_steps if s.get("uses", "").startswith("actions/download-artifact@"))
        self.assertEqual(download["with"]["name"], "tested-dev-image")
        commands = "\n".join(s.get("run", "") for s in publish_steps)
        self.assertIn("docker load", commands)
        self.assertIn("docker push", commands)
        self.assertNotIn("docker build", commands)
        build = "\n".join(s.get("run", "") for s in test_steps)
        self.assertNotIn("--build-arg", build)
        self.assertIn("unittest discover -s containers/dev/tests", build)
        self.assertIn("docker save", build)


if __name__ == "__main__":
    unittest.main()
