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
