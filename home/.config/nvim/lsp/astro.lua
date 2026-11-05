local lsp = require("utils.lsp")

return vim.tbl_extend("error", {
	filetypes = { "astro" },
	-- astro-ls needs the project's TypeScript
	before_init = function(params, config)
		params.initializationOptions = vim.tbl_deep_extend("force", params.initializationOptions or {}, {
			typescript = { tsdk = config.root_dir .. "/node_modules/typescript/lib" },
		})
	end,
}, lsp.server("astro", {
	tool = "@astrojs/language-server",
	markers = { "package.json" },
	bin = "node_modules/.bin/astro-ls",
	args = { "--stdio" },
	wants = function(root)
		return lsp.mentions(root, "package.json", '"astro"')
	end,
	install = function(_, declared)
		return declared and "pnpm install" or "pnpm add -D @astrojs/language-server"
	end,
}))
