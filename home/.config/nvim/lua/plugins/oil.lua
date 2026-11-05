require("oil").setup({
	default_file_explorer = false,
	columns = { "icon" },
	delete_to_trash = true,
	keymaps = {
		["<C-h>"] = false,
		["<M-h>"] = "actions.select_split",
	},
	view_options = {
		show_hidden = true,
	},
	float = {
		padding = 10,
	},
})
