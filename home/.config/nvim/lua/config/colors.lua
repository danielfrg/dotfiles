-- Function to set custom highlight groups
local set_hl = vim.api.nvim_set_hl

vim.cmd("colorscheme default")

palette = {
    -- bg = "#16181D",
    bg = "#252738",
    orange = "#ffa07a",
    blue = "#73ADE9",
    yellow = "#fce094",
    green = "#a1c181",
    purple = "#ffcaff",
    red = "#f08080",
    cyan = "#9ff9f8",

    black = "#07080d",
    gray1 = "#5D636F",
    gray2 = "#21252B",
    gray3 = "#2B2D32",

    white = "#eef1f8",
}

set_hl(0, "Normal", { bg = palette.bg, fg = palette.white, blend = 0 })
set_hl(0, "NormalNC", { bg = palette.bg, fg = palette.white, blend = 0 })
set_hl(0, "CursorLine", { bg = "#383d53" })
set_hl(0, "Visual", { bg = "#383d53" })

set_hl(0, "Identifier", { fg = palette.white })
set_hl(0, "Keyword", { fg = palette.orange })
set_hl(0, "Function", { fg = palette.blue })
set_hl(0, "Special", { fg = palette.yellow })
set_hl(0, "Boolean", { fg = palette.yellow })
set_hl(0, "String", { fg = palette.green })
set_hl(0, "Constant", { fg = palette.purple })
set_hl(0, "Type", { fg = palette.cyan })
set_hl(0, "Comment", { fg = palette.gray1 })

-- Tree and Oil
set_hl(0, "Directory", { fg = palette.yellow })

-- Python
set_hl(0, "@operator.python", { fg = palette.blue })
set_hl(0, "@attribute.python", { fg = palette.blue })
set_hl(0, "@number.python", { fg = palette.yellow })

-- JS
set_hl(0, "@number.javascript", { fg = palette.yellow })
set_hl(0, "@tag.tsx", { fg = palette.white })
set_hl(0, "@tag.builtin.tsx", { fg = palette.blue })
set_hl(0, "@tag.delimiter.tsx", { fg = palette.white })
set_hl(0, "@tag.attribute.tsx", { fg = palette.blue })

-- Markdown
set_hl(0, "@markup.heading", { fg = palette.orange })

-- Statusline
set_hl(0, "StatusLine", { bg = "#1E1E2F", fg = palette.gray1 })

-- Telescope
set_hl(0, "TelescopePromptPrefix", { fg = palette.yellow, bg = palette.gray2 })
set_hl(0, "TelescopeTitle", { fg = palette.bg, bg = palette.orange })
set_hl(0, "TelescopeNormal", { bg = palette.gray2 })

-- CMP
set_hl(0, "NormalFloat", { bg = palette.gray3, fg = palette.white })

function set_highlights_table(table)
    for group, config in pairs(table) do
        vim.api.nvim_set_hl(0, group, config)
    end
end

set_highlights_table({
    -- Git
    Added = { fg = palette.green },
    Removed = { fg = palette.red },
    Changed = { fg = palette.blue },
})
