import { readdirSync, existsSync, statSync } from "node:fs";
import { join } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

// Discovers skills from Python packages in a local .venv.
// Scans .venv/lib/pythonX.Y/site-packages/PKG/.agents/skills/NAME/SKILL.md
// and registers every matching directory as a skill path.
export default function (pi: ExtensionAPI) {
	pi.on("resources_discover", (event) => {
		const venvDir = join(event.cwd, ".venv");
		if (!existsSync(venvDir)) return;

		const libDir = join(venvDir, "lib");
		if (!existsSync(libDir)) return;

		const skillPaths: string[] = [];

		// lib/ may contain python3.11, python3.12, etc.
		for (const pythonDir of safeReaddir(libDir)) {
			if (!pythonDir.startsWith("python")) continue;

			const sitePackages = join(libDir, pythonDir, "site-packages");
			if (!existsSync(sitePackages)) continue;

			for (const pkg of safeReaddir(sitePackages)) {
				const agentsSkills = join(sitePackages, pkg, ".agents", "skills");
				if (!existsSync(agentsSkills)) continue;

				for (const skillName of safeReaddir(agentsSkills)) {
					const skillMd = join(agentsSkills, skillName, "SKILL.md");
					if (existsSync(skillMd)) {
						skillPaths.push(join(agentsSkills, skillName));
					}
				}
			}
		}

		if (skillPaths.length > 0) {
			return { skillPaths };
		}
	});
}

function safeReaddir(dir: string): string[] {
	try {
		return readdirSync(dir).filter((entry) => {
			try {
				return statSync(join(dir, entry)).isDirectory();
			} catch {
				return false;
			}
		});
	} catch {
		return [];
	}
}
