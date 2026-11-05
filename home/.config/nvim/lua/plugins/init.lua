-- Install every plugin in a single vim.pack.add call, then require one file per plugin.

-- Run :TSUpdate when nvim-treesitter is installed or updated, so parsers match the plugin version
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local data = ev.data
		if data.spec.name == "nvim-treesitter" and data.kind ~= "delete" then
			if not data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
	end,
})

vim.pack.add({
	"https://github.com/navarasu/onedark.nvim",
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/nvim-mini/mini.pairs",
	"https://github.com/nvim-mini/mini.surround",
	"https://github.com/stevearc/oil.nvim",
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/folke/flash.nvim",
	"https://github.com/folke/which-key.nvim",
})

require("plugins.onedark")
require("plugins.mini-icons")
require("plugins.mini-pairs")
require("plugins.mini-surround")
require("plugins.oil")
require("plugins.treesitter")
require("plugins.gitsigns")
require("plugins.flash")
require("plugins.which-key")

-- Keymaps that use a plugin live here, required last so all plugins are set up first.
require("plugins.keymaps")
