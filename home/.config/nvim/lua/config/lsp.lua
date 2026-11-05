-- Language servers come from each project (see utils/lsp.lua and lsp/<name>.lua)
local servers = { "ruff", "ty", "ts_ls", "svelte", "astro", "tailwindcss", "gopls" }
vim.lsp.enable(servers)

-- On startup, list the servers the project in cwd expects but hasn't installed
vim.api.nvim_create_autocmd("VimEnter", {
	group = vim.api.nvim_create_augroup("lsp-check", { clear = true }),
	callback = function()
		Utils.lsp.check_cwd(servers)
	end,
})

vim.diagnostic.config({
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = { source = true },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
})

-- Keymaps on top of Neovim's defaults (K, grn, gra, grr, gri, grt, gO, <C-s>, [d, ]d)
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(ev)
		-- Accepting an LSP completion (<C-y>) applies its extras: auto-imports, snippets
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf)
		end

		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = "LSP: " .. desc })
		end
		map("gl", vim.diagnostic.open_float, "Diagnostic float")
		map("gD", vim.lsp.buf.definition, "Go to definition")
		map("<leader>lr", vim.lsp.buf.rename, "Rename")
	end,
})
