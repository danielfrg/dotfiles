local lsp = require("utils.lsp")

return vim.tbl_extend("error", {
	filetypes = {
		"html",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"svelte",
		"astro",
	},
	settings = {
		tailwindCSS = {
			classAttributes = { "class", "className", "ngClass", "class:list" },
			validate = true,
		},
	},
}, lsp.server("tailwindcss", {
	tool = "@tailwindcss/language-server",
	markers = { "package.json" },
	bin = "node_modules/.bin/tailwindcss-language-server",
	args = { "--stdio" },
	-- Only projects that use Tailwind
	wants = function(root)
		return lsp.mentions(root, "package.json", '"tailwindcss"')
	end,
	install = function(_, declared)
		return declared and "pnpm install" or "pnpm add -D @tailwindcss/language-server"
	end,
}))
