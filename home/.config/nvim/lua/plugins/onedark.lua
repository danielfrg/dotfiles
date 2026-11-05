require("onedark").setup({
	-- Background from colors/one.lua
	colors = { bg0 = "#191D25" },
	-- Editor surfaces from colors/one.lua
	highlights = {
		CursorLine = { bg = "#2d3137" },
		Visual = { bg = "#2d3137" },
		VisualNOS = { bg = "#2d3137" },
		NormalFloat = { bg = "#222630" },
		FloatBorder = { bg = "#222630" },
		StatusLine = { bg = "#222630" },
		StatusLineNC = { bg = "#222630" },
		-- Statusline mode block (utils/statusline.lua)
		StatusModeNormal = { fg = "#222630", bg = "#61AFEF", fmt = "bold" },
		StatusModeInsert = { fg = "#222630", bg = "#98C379", fmt = "bold" },
		StatusModeVisual = { fg = "#222630", bg = "#C678DD", fmt = "bold" },
		StatusModeCommand = { fg = "#222630", bg = "#E5C07B", fmt = "bold" },
	},
})
require("onedark").load()
