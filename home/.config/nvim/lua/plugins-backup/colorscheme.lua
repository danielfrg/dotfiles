return {
    {
        'AlexvZyl/nordic.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require 'nordic'.setup {
                cursorline = {
                    bold_number = true,
                    theme = 'light',
                    blend = 0.85,
                },
            }
            require 'nordic'.load()

            vim.cmd [[highlight TelescopeSelection guifg=#ffffff guibg=#2C323F gui=bold]]

            vim.api.nvim_set_hl(0, "FloatBorder", { link = "TelescopeBorder" })
            vim.api.nvim_set_hl(0, "FloatTitle", { link = "TelescopeTitle" })
        end
    },

    --     {
    --         "folke/tokyonight.nvim",
    --         lazy = false,
    --         priority = 1000,
    --         opts = {},
    --         config = function()
    --             vim.cmd("colorscheme tokyonight")
    --         end,
    --     }
    --

    -- {
    --     "rebelot/kanagawa.nvim",
    --     priority = 1000,
    --     config = function()
    --         require("kanagawa").setup({
    --             -- transparent = true,
    --             theme = "wave",  -- Load "wave" theme when 'background' option is not set
    --             background = {   -- map the value of 'background' option to a theme
    --                 dark = "dragon", -- try "dragon" !
    --             },
    --             compile = false,
    --             colors = {
    --                 theme = {
    --                     all = {
    --                         ui = {
    --                             bg_gutter = "none",
    --                         },
    --                     },
    --                 },
    --             },
    --             overrides = function(colors)
    --                 local theme = colors.theme
    --                 return {
    --                     LineNr = { bg = 'none' },

    --                     NormalFloat = { bg = "none" },
    --                     FloatBorder = { bg = "none" },
    --                     FloatTitle = { bg = "none" },

    --                     CmpDocumentation = { bg = "none" },

    --                     -- telescope
    --                     TelescopeTitle = { fg = theme.ui.special, bold = true },
    --                     TelescopePromptNormal = { bg = theme.ui.bg_p1 },
    --                     TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
    --                     TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
    --                     TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
    --                     TelescopePreviewNormal = { bg = theme.ui.bg_dim },
    --                     TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

    --                     -- popup menus
    --                     Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend }, -- add `blend = vim.o.pumblend` to enable transparency
    --                     PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
    --                     PmenuSbar = { bg = theme.ui.bg_m1 },
    --                     PmenuThumb = { bg = theme.ui.bg_p2 },
    --                 }
    --             end,
    --         })
    --         vim.cmd("colorscheme kanagawa")
    --     end,
    -- }
}
