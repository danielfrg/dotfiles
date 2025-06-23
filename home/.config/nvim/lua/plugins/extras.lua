return {
    -- undo tree
    {
        "mbbill/undotree",
        event = "VeryLazy",
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Open undotree" },
        }
    },

    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        config = function()
            require('gitsigns').setup()
        end
    },

    {
        "brenoprata10/nvim-highlight-colors",
        event = "VeryLazy",
        config = function()
            require 'nvim-highlight-colors'.setup({
                render = 'virtual',
                enable_tailwind = true
            })
        end
    },

    -- {
    --     "m4xshen/hardtime.nvim",
    --     lazy = false,
    --     dependencies = { "MunifTanjim/nui.nvim" },
    --     opts = {},
    -- },
}
