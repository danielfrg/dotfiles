local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		file_ignore_patterns = { "^.git/", "node_modules/*" },
		vimgrep_arguments = {
			"rg",
			"-L", -- follow symlinks
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
		},
		mappings = {
			n = {
				["d"] = actions.delete_buffer,
				["q"] = actions.close,
			},
		},
	},
	pickers = {
		find_files = { hidden = true },
		git_files = { hidden = true },
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
