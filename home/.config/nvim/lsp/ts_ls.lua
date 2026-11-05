local lsp = require("utils.lsp")

return vim.tbl_extend("error", {
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	init_options = { hostInfo = "neovim" },
}, lsp.server("ts_ls", {
	tool = "typescript-language-server",
	markers = { "package.json", "tsconfig.json" },
	bin = "node_modules/.bin/typescript-language-server",
	args = { "--stdio" },
	-- Only TypeScript projects are expected to have it
	wants = function(root)
		return lsp.mentions(root, "package.json", '"typescript"') or vim.uv.fs_stat(root .. "/tsconfig.json") ~= nil
	end,
	install = function(_, declared)
		return declared and "pnpm install" or "pnpm add -D typescript-language-server"
	end,
}))
