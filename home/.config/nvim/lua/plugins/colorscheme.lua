return {

    -- {
    --     "rebelot/kanagawa.nvim",
    --     config = function()
    --         require('kanagawa').setup({
    --             compile = false,
    --             undercurl = true,
    --             commentStyle = { italic = false },
    --             functionStyle = {},
    --             keywordStyle = { italic = false },
    --             statementStyle = { bold = false },
    --             typeStyle = {},
    --             transparent = false,   -- do not set background color
    --             dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
    --             terminalColors = true, -- define vim.g.terminal_color_{0,17}
    --             colors = {             -- add/modify theme and palette colors
    --                 palette = {},
    --                 theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    --             },
    --             overrides = function(colors) -- add/modify highlights
    --                 return {}
    --             end,
    --             theme = "dragon",  -- Load "wave" theme when 'background' option is not set
    --             background = {     -- map the value of 'background' option to a theme
    --                 dark = "wave", -- try "dragon" !
    --                 light = "lotus"
    --             },
    --         })

    --         vim.api.nvim_command("colorscheme kanagawa-dragon")
    --     end,
    -- }

    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    --     config = function()
    --         vim.api.nvim_command("colorscheme tokyonight")
    --     end,
    -- }

    {
        'AlexvZyl/nordic.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require 'nordic'.setup {
                bright_border = false,
                -- Reduce the overall amount of blue in the theme (diverges from base Nord).
                reduced_blue = true,
                cursorline = {
                    bold_number = true,
                    theme = 'light',
                    blend = 1,
                },
            }
            require 'nordic'.load()

            vim.cmd [[highlight CursorLine guibg=#303e4e]]
            vim.cmd [[highlight Visual guibg=#303e4e guifg=None]]

            vim.cmd [[highlight TelescopeSelection guifg=#ffffff guibg=#2C323F gui=bold]]

            vim.cmd [[
                  highlight PmenuSel guibg=#4C566A
                  highlight Pmenu guibg=#1D222B
                ]]

            vim.api.nvim_set_hl(0, "FloatBorder", { link = "TelescopeBorder" })
            vim.api.nvim_set_hl(0, "FloatTitle", { link = "TelescopeTitle" })
        end
    },
}
