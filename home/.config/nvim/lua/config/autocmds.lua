local group = vim.api.nvim_create_augroup("config", { clear = true })

-- Yanked text flashes briefly
vim.api.nvim_create_autocmd("TextYankPost", {
	group = group,
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Only the active window shows the cursorline
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
	group = group,
	callback = function()
		vim.wo.cursorline = true
	end,
})
vim.api.nvim_create_autocmd("WinLeave", {
	group = group,
	callback = function()
		vim.wo.cursorline = false
	end,
})
