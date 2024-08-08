return {
    -- undo tree
    {
        "mbbill/undotree",
        event = "VeryLazy"
    },

    -- Detect tabstop and shiftwidth automatically
    {
        "tpope/vim-sleuth",
        event = "VeryLazy",
    },

    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
    },

    {
        "tpope/vim-repeat",
        event = "VeryLazy",
    },

    {
        "tpope/vim-surround",
        event = "VeryLazy",
    },


    -- "gc" to comment visual regions/lines
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
    },

    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false }
    },

    {
        "famiu/bufdelete.nvim",
        event = "VeryLazy"
    },

    -- autopairs
    {
        "windwp/nvim-autopairs",
        event = "VeryLazy"
    },

    {
        "andymass/vim-matchup",
        event = "VeryLazy",

        config = function()
            vim.api.nvim_set_hl(0, "OffScreenPopup",
                { fg = "#fe8019", bg = "#3c3836", italic = true })
            vim.g.matchup_matchparen_offscreen = {
                method = "popup",
                highlight = "OffScreenPopup"
            }
        end
    },

    -- adds more targets like [ or ,
    {
        "wellle/targets.vim",
        event = "VeryLazy"
    },

    {
        "christoomey/vim-tmux-navigator",
        event = "VeryLazy"
    },

    {
        "ThePrimeagen/vim-be-good",
        event = "VeryLazy",
    },
}
