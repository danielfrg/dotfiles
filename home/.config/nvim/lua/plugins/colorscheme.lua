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

    -- {
    --     "shaunsingh/nord.nvim",
    --     config = function()
    --         vim.cmd([[colorscheme nord]])
    --     end,
    -- },

    {
        "rmehri01/onenord.nvim",
        config = function()
            vim.cmd([[colorscheme onenord]])

            -- Plugins
            vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#414C5F" })
            vim.api.nvim_set_hl(0, "BufferLineFill", { bg = "#21242a" })
            vim.api.nvim_set_hl(0, "BufferLineIndicatorSelected", { fg = "#2d3441" })
        end,
    },

    -- {
    --     "navarasu/onedark.nvim",
    --     priority = 1000,
    --     lazy = false,
    --     config = function()
    --         require("onedark").setup({
    --             colors = {
    --                 id = "#000000",
    --                 bg0 = "#292c32",
    --                 lightgrey = "#C8CCD4",
    --                 grey = "#5d636f",
    --                 red = "#D07277",
    --                 cyan = "#70b3bd",
    --                 yellow = "#DFC184",
    --                 orange = "#bf956a",
    --                 green = "#A1C181",
    --                 blue = "#73ADE9",
    --                 purple = "#B477CF",
    --             },
    --             highlights = {
    --                 ["@attribute"] = { fg = "$blue" },
    --                 ["@boolean"] = { fg = "$yellow" },
    --                 ["@constant"] = { fg = "$yellow" },
    --                 ["@constructor"] = { fg = "$cyan" },
    --                 ["@constant.builtin"] = { fg = "$yellow" },
    --                 ["@function.builtin"] = { fg = "$blue" },
    --                 ["@property"] = { fg = "$red" },
    --                 ["@type"] = { fg = "$cyan" },
    --                 ["@type.builtin"] = { fg = "$cyan" },
    --                 ["@variable"] = { fg = "$lightgrey" },
    --                 ["@variable.builtin"] = { fg = "$orange" },
    --                 ["@variable.member"] = { fg = "$red" },
    --                 ["@variable.parameter"] = { fg = "$lightgrey" },

    --                 zshDeref = { fg = "$red" },

    --                 TelescopeBorder = { fg = "$blue" },
    --                 TelescopePromptBorder = { fg = "$lightgrey" },
    --                 TelescopeResultsBorder = { fg = "$lightgrey" },
    --                 TelescopePreviewBorder = { fg = "$lightgrey" },
    --             },
    --         })
    --         vim.cmd([[colorscheme onedark]])
    --     end,
    -- },
}
