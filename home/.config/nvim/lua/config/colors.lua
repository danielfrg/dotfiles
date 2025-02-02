-- Function to set custom highlight groups
local set_hl = vim.api.nvim_set_hl

vim.cmd("colorscheme default")

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
    faint_gray = "#222630",
    light_gray = "#5C6370",
    linenr = "#4B5263"
}

set_hl(0, "Normal", { fg = palette.white, bg = palette.black })
set_hl(0, "NormalNC", { fg = palette.white, bg = palette.black })
set_hl(0, "NormalFloat", { bg = palette.light_black, fg = palette.white })
set_hl(0, "Cursor", { bg = palette.white })
set_hl(0, "CursorLine", { bg = palette.faint_gray })
set_hl(0, "CursorLineNr", { bold = false })
set_hl(0, "Visual", { bg = palette.faint_gray })
set_hl(0, "VisualNOS", { bg = palette.faint_gray })

-- Apply changes to the cursor
vim.opt.guicursor = "n-v-c:block-Cursor"
vim.opt.guicursor:append("i:ver100-iCursor")

-- Syntax highlighting
set_hl(0, "Identifier", { fg = palette.white })
set_hl(0, "Keyword", { fg = palette.red })
set_hl(0, "Function", { fg = palette.blue })
set_hl(0, "Special", { fg = palette.yellow })
set_hl(0, "Boolean", { fg = palette.yellow })
set_hl(0, "String", { fg = palette.green })
set_hl(0, "Constant", { fg = palette.purple })
set_hl(0, "Type", { fg = palette.blue })
set_hl(0, "Comment", { fg = palette.light_gray })

-- Tree and Oil
set_hl(0, "Directory", { fg = palette.yellow })

-- Python
set_hl(0, "@operator.python", { fg = palette.blue })
set_hl(0, "@attribute.python", { fg = palette.blue })
set_hl(0, "@attribute.builtin.python", { fg = palette.blue })
set_hl(0, "@number.python", { fg = palette.yellow })

-- JS
set_hl(0, "@number.javascript", { fg = palette.yellow })
set_hl(0, "@tag.tsx", { fg = palette.white })
set_hl(0, "@tag.builtin.tsx", { fg = palette.blue })
set_hl(0, "@tag.delimiter.tsx", { fg = palette.white })
set_hl(0, "@tag.attribute.tsx", { fg = palette.blue })

-- Markdown
set_hl(0, "@markup.heading", { fg = palette.red })

-- TOML
set_hl(0, "@property.toml", { fg = palette.red })

-- Statusline
set_hl(0, "StatusLine", { fg = palette.white, bg = palette.light_black })
set_hl(0, "StatusLineNC", { fg = palette.light_gray, bg = palette.light_black })
set_hl(0, "StatusNormal", { fg = palette.light_black, bg = palette.blue, bold = true })
set_hl(0, "StatusInsert", { fg = palette.light_black, bg = palette.green, bold = true })
set_hl(0, "StatusVisual", { fg = palette.light_black, bg = palette.purple, bold = true })


function set_highlights_table(table)
    for group, config in pairs(table) do
        vim.api.nvim_set_hl(0, group, config)
    end
end

set_highlights_table({
    -- Git
    Added = { fg = palette.green },
    Removed = { fg = palette.red },
    Changed = { fg = palette.yellow },
})
