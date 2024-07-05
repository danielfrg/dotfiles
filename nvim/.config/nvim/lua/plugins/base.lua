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
        "tpope/vim-repeat",
        event = "VeryLazy",
    },

    -- "gc" to comment visual regions/lines
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
    },

    -- fancy TODO comments
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false }
    },

    -- buffer delete event
    {
        "famiu/bufdelete.nvim",
        event = "VeryLazy"
    },

    -- tmux
    {
        "christoomey/vim-tmux-navigator",
        event = "VeryLazy"
    },

    -- learn vim
    {
        "ThePrimeagen/vim-be-good",
        cmd = "VimBeGood",
        lazy = true,
        -- event = "VeryLazy",
    },
}
