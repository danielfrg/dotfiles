local parsers = {
	-- Python
	"python",
	"ninja",

	-- C/C++
	"c",
	"cpp",

	-- Web
	"astro",
	"html",
	"css",
	"javascript",
	"typescript",
	"tsx",

	-- Neovim
	"vim",
	"vimdoc",
	"lua",
	"query",

	-- General
	"bash",
	"just",
	"markdown",
	"markdown_inline",
	"rst",
	"toml",
	"terraform",
	"yaml",
}

require("nvim-treesitter").install(parsers)

-- Start highlighting and Treesitter indent whenever a parser exists
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
	callback = function(ev)
		if pcall(vim.treesitter.start, ev.buf) then
			vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})
