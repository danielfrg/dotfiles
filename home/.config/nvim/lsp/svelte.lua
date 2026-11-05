local lsp = require("utils.lsp")

return vim.tbl_extend("error", {
	filetypes = { "svelte" },
}, lsp.server("svelte", {
	tool = "svelte-language-server",
	markers = { "package.json" },
	bin = "node_modules/.bin/svelteserver",
	args = { "--stdio" },
	wants = function(root)
		return lsp.mentions(root, "package.json", '"svelte"')
	end,
	install = function(_, declared)
		return declared and "pnpm install" or "pnpm add -D svelte-language-server"
	end,
}))
