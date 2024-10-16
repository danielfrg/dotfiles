-- Function to set custom highlight groups
local set_hl = vim.api.nvim_set_hl

vim.cmd("colorscheme default")

palette = {
    bg = "#16181D",
    red = "#f08080",
    green = "#a1c181",
    yellow = "#fce094",
    orange = "#ffa07a",
    blue = "#73ADE9",

    black = "#000000",
    gray1 = "#5D636F",
    gray2 = "#21252B",
    white0 = "#eef1f8",
}

set_hl(0, "Normal", { bg = palette.bg, fg = palette.white0 })
set_hl(0, "Identifier", { fg = palette.white0 })
set_hl(0, "Keyword", { fg = palette.orange })
set_hl(0, "Boolean", { fg = palette.yellow })
set_hl(0, "String", { fg = palette.green })
set_hl(0, "Function", { fg = palette.blue })
set_hl(0, "Special", { fg = palette.yellow })
set_hl(0, "Comment", { fg = palette.gray1 })

-- Python
set_hl(0, "@operator.python", { fg = palette.orange })
set_hl(0, "@attribute.python", { fg = palette.orange })

-- JS
set_hl(0, "@tag.tsx", { fg = palette.white0 })
set_hl(0, "@tag.builtin.tsx", { fg = palette.white0 })
set_hl(0, "@tag.delimiter.tsx", { fg = palette.white0 })
set_hl(0, "@tag.attribute.tsx", { fg = palette.white0 })

set_hl(0, "StatusLine",  { fg="#505259", bg=palette.black })

-- Telescope.
set_hl(0, "TelescopePromptPrefix",  { fg=palette.yellow, bg=palette.gray2 })
set_hl(0, "TelescopeTitle",  { fg=palette.bg, bg=palette.orange })
set_hl(0, "TelescopeNormal", { bg = palette.gray2 })

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
