-- Install every plugin in a single vim.pack.add call, then require one file per plugin.
vim.pack.add({
	"https://github.com/navarasu/onedark.nvim",
})

require("plugins.onedark")

-- Keymaps that use a plugin live here, required last so all plugins are set up first.
require("plugins.keymaps")
