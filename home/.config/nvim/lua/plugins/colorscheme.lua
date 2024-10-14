return {
    "nvim-lua/plenary.nvim",

    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            vim.api.nvim_command("colorscheme tokyonight")
        end,
    }

    -- {
    --     "nvchad/ui",
    --     -- config = function()
    --     --     require "nvchad"
    --     -- end
    -- },

    -- {
    --     "nvchad/base46",
    --     lazy = true,
    --     build = function()
    --         require("base46").load_all_highlights()
    --     end,
    -- },

    -- {
    --     'AlexvZyl/nordic.nvim',
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         require 'nordic'.setup {
    --             cursorline = {
    --                 bold_number = true,
    --                 theme = 'light',
    --                 blend = 1,
    --             },
    --         }
    --         require 'nordic'.load()

    --         vim.cmd [[highlight CursorLine guibg=#303e4e]]
    --         vim.cmd [[highlight Visual guibg=#303e4e guifg=None]]

    --         vim.cmd [[highlight TelescopeSelection guifg=#ffffff guibg=#2C323F gui=bold]]

    --         vim.cmd [[
    --           highlight PmenuSel guibg=#4C566A
    --           highlight Pmenu guibg=#1D222B
    --         ]]

    --         vim.api.nvim_set_hl(0, "FloatBorder", { link = "TelescopeBorder" })
    --         vim.api.nvim_set_hl(0, "FloatTitle", { link = "TelescopeTitle" })
    --     end
    -- },
}
