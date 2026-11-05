local map = vim.keymap.set

-- oil
map("n", "-", require("oil").toggle_float, { desc = "File explorer (oil)" })

-- flash: <CR> jumps, except in quickfix and the command-line window where <CR> opens the entry
map({ "n", "x", "o" }, "<CR>", function()
	if vim.bo.buftype == "quickfix" or vim.fn.getcmdwintype() ~= "" then
		return "<CR>"
	end
	return "<Cmd>lua require('flash').jump()<CR>"
end, { expr = true, desc = "Flash" })

-- telescope
local builtin = require("telescope.builtin")
map("n", "<leader><leader>", builtin.find_files, { desc = "Find files" })
map("n", "<leader>sf", builtin.find_files, { desc = "Find files" })
map("n", "<leader>sg", builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>sw", builtin.grep_string, { desc = "Grep word under cursor" })
map("n", "<leader>sb", function()
	builtin.buffers({ sort_lastused = true })
end, { desc = "Buffers" })
map("n", "<leader>s.", builtin.oldfiles, { desc = "Recent files" })
map("n", "<leader>sr", builtin.resume, { desc = "Resume last picker" })
map("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
map("n", "<leader>sh", builtin.help_tags, { desc = "Help" })
map("n", "<leader>sk", builtin.keymaps, { desc = "Keymaps" })
map("n", "<leader>ss", builtin.builtin, { desc = "Pickers" })
map("n", "<leader>/", function()
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ winblend = 10, previewer = false }))
end, { desc = "Fuzzy search in buffer" })
map("n", "<leader>gc", builtin.git_commits, { desc = "Git commits" })
map("n", "<leader>gs", builtin.git_status, { desc = "Git status" })

-- undotree (built-in)
map("n", "<leader>u", "<Cmd>Undotree<CR>", { desc = "Undo tree" })
