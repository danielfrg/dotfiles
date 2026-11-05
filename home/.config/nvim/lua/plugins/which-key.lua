require("which-key").setup()
require("which-key").add({
	{ "<leader>b", group = "Buffers" },
	{ "<leader>g", group = "Git" },
	{ "<leader>l", group = "LSP" },
	{ "<leader>s", group = "Search" },
})
