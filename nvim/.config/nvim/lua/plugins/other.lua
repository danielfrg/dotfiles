return {
    -- measure startuptime
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        config = function()
            vim.g.startuptime_tries = 10
        end,
    },

    {
        "nvim-tree/nvim-web-devicons",
        lazy = true
    },

    -- Detect tabstop and shiftwidth automatically
    {
        "tpope/vim-sleuth",
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

    {
        "tpope/vim-fugitive",
        event = "VeryLazy",
    },

    {
        "tpope/vim-surround",
        event = "VeryLazy",
    },

    {
        "christoomey/vim-tmux-navigator",
        event = "VeryLazy"
    },

    {
        "mbbill/undotree",
        event = "VeryLazy"
    },

    {
        "ThePrimeagen/vim-be-good",
        event = "VeryLazy",
    },
}
