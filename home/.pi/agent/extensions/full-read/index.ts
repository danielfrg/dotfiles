import type { TextContent } from "@earendil-works/pi-ai";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { constants } from "node:fs";
import { access, readFile } from "node:fs/promises";
import { resolve } from "node:path";

const readSchema = Type.Object({
	path: Type.String({ description: "Path to the file to read (relative or absolute)" }),
});

export default function (pi: ExtensionAPI) {
	pi.registerTool({
		name: "read",
		label: "read",
		description: "Read the full contents of a file. No truncation or line limits.",
		parameters: readSchema,

		async execute(_toolCallId, params, signal, _onUpdate, ctx) {
			const absolutePath = resolve(ctx.cwd, params.path.replace(/^@/, ""));

			if (signal?.aborted) {
				return {
					content: [{ type: "text", text: "Operation aborted" }],
					details: {},
				};
			}

			try {
				await access(absolutePath, constants.R_OK);
				const text = await readFile(absolutePath, "utf-8");

				return {
					content: [{ type: "text", text }] as TextContent[],
					details: {},
				};
			} catch (error: any) {
				return {
					content: [{ type: "text", text: `Error reading file: ${error.message}` }] as TextContent[],
					details: {},
				};
			}
		},
	});
}
