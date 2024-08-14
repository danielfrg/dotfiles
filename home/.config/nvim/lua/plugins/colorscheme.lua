return {
    -- {
    --     "catppuccin/nvim",
    --     name = "catppuccin",
    --     priority = 1000,
    --     lazy = false,
    --     config = function()
    --         vim.cmd([[colorscheme catppuccin-mocha]])
    --     end,
    -- },

    {
        "navarasu/onedark.nvim",
        priority = 1000,
        opts = {
            style = "warmer",
        },
        config = function()
            require("onedark").setup({
                colors = {
                    -- black = "#282c33", -- terminal.background (One Dark)
                    -- bg0 = "#3b414d",         -- status_bar.background (One Dark)
                    -- bg1 = "#2f343e",         -- elevated_surface.background (One Dark)
                    -- bg2 = "#363c46",         -- border.variant (One Dark)
                    -- bg3 = "#3b3f4c",         -- No exact match, using a close one
                    -- bg_d = "#2e343e",        -- element.background (One Dark)
                    -- bg_blue = "#74ade8",     -- text.accent (One Dark)
                    -- bg_yellow = "#dec184",   -- conflict (One Dark)
                    -- fg = "#c8ccd4",          -- text (One Dark)
                    purple = "#b46acc", -- terminal.ansi.magenta (One Dark)
                    green = "#A1C081",  -- terminal.ansi.green (One Dark)
                    orange = "#BF956A", -- terminal.ansi.yellow (One Dark)
                    blue = "#73ADE9",   -- terminal.ansi.blue (One Dark)
                    -- yellow = "#dfc184",      -- Close match to constant (One Dark)
                    -- cyan = "#6eb4bf",        -- terminal.ansi.cyan (One Dark)
                    red = "#D07277", -- terminal.ansi.red (One Dark)
                    -- grey = "#5d636f",        -- Close match to comment (One Dark)
                    -- light_grey = "#838994",  -- text.muted (One Dark)
                    -- dark_cyan = "#3a565b",   -- terminal.ansi.bright_cyan (One Dark)
                    -- dark_red = "#673a3c",    -- terminal.ansi.bright_red (One Dark)
                    -- dark_yellow = "#786441", -- terminal.ansi.dim_yellow (One Dark)
                    -- dark_purple = "#5e2b26", -- terminal.ansi.bright_magenta (One Dark)
                    -- diff_add = "#a1c181",    -- created (One Dark)
                    -- diff_delete = "#d07277", -- deleted (One Dark)
                    -- diff_change = "#dec184", -- conflict (One Dark)
                    -- diff_text = "#74ade8",   -- text.accent (One Dark)        -- redefine an existing color
                },
            })
            vim.cmd([[colorscheme onedark]])
        end,
    },
}
