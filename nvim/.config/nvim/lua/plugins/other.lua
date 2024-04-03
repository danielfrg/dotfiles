return {
    -- measure startuptime
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        config = function()
            vim.g.startuptime_tries = 10
        end,
    },

    -- Detect tabstop and shiftwidth automatically
    { "tpope/vim-sleuth" },

    -- "gc" to comment visual regions/lines
    { "numToStr/Comment.nvim", event = "VeryLazy" },

    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
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
