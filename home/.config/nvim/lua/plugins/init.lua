-- Install every plugin in a single vim.pack.add call, then require one file per plugin.

-- Build steps after a plugin is installed or updated
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local data = ev.data
		if data.kind == "delete" then
			return
		end
		-- :TSUpdate keeps parsers in sync with the nvim-treesitter version
		if data.spec.name == "nvim-treesitter" then
			if not data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end
		-- telescope-fzf-native compiles its C sorter with make
		if data.spec.name == "telescope-fzf-native.nvim" then
			vim.system({ "make" }, { cwd = data.path }):wait()
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
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-fzf-native.nvim",
	"https://github.com/nvim-telescope/telescope-ui-select.nvim",
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
require("plugins.telescope")
require("plugins.undotree")

-- Keymaps that use a plugin live here, required last so all plugins are set up first.
require("plugins.keymaps")
