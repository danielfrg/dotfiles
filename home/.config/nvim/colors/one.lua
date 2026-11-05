-- Custom One Dark palette on top of Neovim's default colorscheme
-- Currently not used
vim.cmd("highlight clear")
vim.o.background = "dark"
vim.g.colors_name = "one"

local palette = {
	yellow = "#E5C07B",
	blue = "#61AFEF",
	red = "#E06C75",
	purple = "#C678DD",
	green = "#98C379",
	gold = "#D19A66",
	cyan = "#56B6C2",
	white = "#ABB2BF",
	black = "#191D25",
	light_black = "#222630",
	gray = "#3E4452",
	faint_gray = "#2d3137",
	light_gray = "#5C6370",
	linenr = "#4B5263",
}

local highlights = {
	-- Editor
	Normal = { fg = palette.white, bg = palette.black },
	NormalNC = { fg = palette.white, bg = palette.black },
	NormalFloat = { fg = palette.white, bg = palette.light_black },
	Cursor = { bg = palette.white },
	CursorLine = { bg = palette.faint_gray },
	CursorLineNr = { bold = false },
	Visual = { bg = palette.faint_gray },
	VisualNOS = { bg = palette.faint_gray },
	Directory = { fg = palette.yellow },
	StatusLine = { fg = palette.white, bg = palette.light_black },
	StatusLineNC = { fg = palette.light_gray, bg = palette.light_black },

	-- Syntax
	Identifier = { fg = palette.white },
	Keyword = { fg = palette.red },
	Function = { fg = palette.blue },
	Special = { fg = palette.yellow },
	Boolean = { fg = palette.yellow },
	String = { fg = palette.green },
	Constant = { fg = palette.purple },
	Type = { fg = palette.blue },
	Comment = { fg = palette.light_gray },

	-- Python
	["@operator.python"] = { fg = palette.blue },
	["@attribute.python"] = { fg = palette.blue },
	["@attribute.builtin.python"] = { fg = palette.blue },
	["@number.python"] = { fg = palette.yellow },

	-- JS / TSX
	["@number.javascript"] = { fg = palette.yellow },
	["@tag.tsx"] = { fg = palette.white },
	["@tag.builtin.tsx"] = { fg = palette.blue },
	["@tag.delimiter.tsx"] = { fg = palette.white },
	["@tag.attribute.tsx"] = { fg = palette.blue },

	-- Markdown
	["@markup.heading"] = { fg = palette.red },

	-- TOML
	["@property.toml"] = { fg = palette.red },

	-- Git
	Added = { fg = palette.green },
	Removed = { fg = palette.red },
	Changed = { fg = palette.yellow },
}

for group, opts in pairs(highlights) do
	vim.api.nvim_set_hl(0, group, opts)
end
