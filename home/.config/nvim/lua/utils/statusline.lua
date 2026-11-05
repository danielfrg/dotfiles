-- Custom statusline, no plugin: mode | file path + flags | LSP clients | line:column
local M = {}

local modes = {
	["n"] = { label = "NOR", hl = "StatusModeNormal" },
	["no"] = { label = "NORMAL·OPERATOR PENDING", hl = "StatusModeNormal" },
	["v"] = { label = "VIS", hl = "StatusModeVisual" },
	["V"] = { label = "VIS", hl = "StatusModeVisual" },
	["\22"] = { label = "VIS", hl = "StatusModeVisual" },
	["s"] = { label = "SELECT", hl = "StatusModeVisual" },
	["S"] = { label = "S·LINE", hl = "StatusModeVisual" },
	["\19"] = { label = "S·BLOCK", hl = "StatusModeVisual" },
	["i"] = { label = "INS", hl = "StatusModeInsert" },
	["R"] = { label = "REPLACE", hl = "StatusModeInsert" },
	["Rv"] = { label = "V·REPLACE", hl = "StatusModeInsert" },
	["c"] = { label = "COM", hl = "StatusModeCommand" },
	["cv"] = { label = "VIM EX", hl = "StatusModeCommand" },
	["ce"] = { label = "EX", hl = "StatusModeCommand" },
	["r"] = { label = "PROMPT", hl = "StatusModeCommand" },
	["rm"] = { label = "MORE", hl = "StatusModeCommand" },
	["r?"] = { label = "CONFIRM", hl = "StatusModeCommand" },
	["!"] = { label = "SHELL", hl = "StatusModeCommand" },
	["t"] = { label = "TER", hl = "StatusModeInsert" },
}

local function mode_info()
	local mode = vim.api.nvim_get_mode().mode
	return modes[mode] or { label = mode, hl = "StatusModeNormal" }
end

-- Attached LSP clients as [name1, name2], empty when none
local function lsp_status()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		return ""
	end
	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end
	return "[" .. table.concat(names, ", ") .. "]"
end

function M.render()
	local mode = mode_info()
	return table.concat({
		"%#" .. mode.hl .. "#",
		"  " .. mode.label .. "  ",
		"%#StatusLine#",
		" %f", -- file path relative to cwd
		"%h%w%m%r", -- help, preview, modified, readonly flags
		"%=",
		lsp_status(),
		" %l:%c%V ", -- line:column
	})
end

return M
