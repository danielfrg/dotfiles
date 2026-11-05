-- Common typos
local typos = { W = "w", Wq = "wq", WQ = "wq", Q = "q!" }
for typo, cmd in pairs(typos) do
	vim.api.nvim_create_user_command(typo, function()
		vim.cmd(cmd)
	end, { nargs = 0 })
end

-- :LspInfo is now :checkhealth vim.lsp
vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", { nargs = 0 })
